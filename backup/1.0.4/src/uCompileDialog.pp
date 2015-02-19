{ Copyright (C) 2005-2006 GameLabs Interactive

  This program is free software; you can redistribute it and/or modify it
  under the terms of the GNU General Public License as published by the Free
  Software Foundation; either version 2 of the License, or (at your option)
  any later version.

  This program is distributed in the hope that it will be useful, but WITHOUT
  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
  FITNESS FOR A PARTICULAR PURPOSE. See the GNU Library General Public License
  for more details.

  You should have received a copy of the GNU General Public License along with
  this program; if not, write to the Free Software Foundation, Inc., 59 Temple
  Place - Suite 330, Boston, MA 02111-1307, USA.
}

unit uCompileDialog;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef win32}Windows {$endif}, Classes, SysUtils, LResources, Forms, LCLType,
  Controls, Graphics, Dialogs, uEditorOptionsController, StdCtrls, Process;
  
type
  TMatchTable=array of integer;
  PMatchTable=^TMatchTable;

  { TCompileDialog }

  TCompileDialog = class(TForm)
    ActiveCaption: TLabel;
    HintsLabel: TLabel;
    WarningsLabel: TLabel;
    TotalLinesLabel: TLabel;
    ErrorsLabel: TLabel;
    LineNumberLabel: TLabel;
    TargetLabel: TLabel;
    StatusLabel: TLabel;
    MainFileLabel: TLabel;
    NotesLabel: TLabel;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { private declarations }
    procedure Compile(filename:ansistring;EditorOptions:TEditorOptions);
    wc,nc,hc,ec,mr:integer;
    compiling:boolean;
  public
    { public declarations }
    function Execute(filename:ansistring;EditorOptions:TEditorOptions;suppress:boolean):boolean;
    OutputLines:TStringList;
  end;

var
  CompileDialog: TCompileDialog;

implementation

//KMP

function BuildMatchTable(s:pchar):PMatchTable;

var i,j,n:integer;

begin
      New(Result);
      SetLength(Result^,Length(s));

      if length(s)<2 then Result^[0]:=-1
                     else
       begin
        i:=2;
        j:=0;
        Result^[0]:=-1;
        Result^[1]:=0;
        n:=length(s);
        while i<n do
         begin
          if s[i-1]=s[j] then
           begin
            Result^[i]:=j+1;
            inc(i);
            inc(j);
           end           else
            if j>0 then j:=Result^[j]
                   else
             begin
              Result^[i]:=0;
              inc(i);
              j:=0;
             end;
         end;
       end;
end;

procedure FreeMatchTable(var p:PMatchTable);
begin
     if p<>nil then
      begin
       SetLength(p^,0);
       Dispose(p);
       p:=nil;
      end;
end;

function Match(key:pchar;data:pchar;var table:PMatchTable):integer;
var k,n,m,i:integer;
begin
     if table=nil then table:=BuildMatchTable(key);

     m:=0;
     i:=0;
     n:=length(data);
     k:=length(key);
     while i+m<n do
      begin
       if key[i]=data[i+m] then inc(i)
                           else
        begin
         m:=m+i-table^[i];
         if table^[i]>0 then i:=table^[i]
                        else i:=0;
        end;
       if i=k then exit(m);//match @ m
      end;

     result:=-1;
end;

//other internals

function retrace(s:string):string;
begin
     if s='' then result:='.'
             else result:=s;
end;

function parsefilename(s:ansistring):ansistring;
var p:array[0..1023] of char;
    i:integer;
    {$ifdef win32}
    path,fname:string;
    {$endif}
begin
 {$IFNDEF WIN32}
 parsefilename:='';
 for i:=1 to length(s) do
  begin
   if s[i]=' ' then parsefilename+='\';
   parsefilename+=s[i];
  end;
 {$ELSE}
 for i:=length(s) downto 1 do
  if s[i]='\' then break;
 path:=Copy(s,1,i);
 fname:=Copy(s,i+1,length(s)-i);
 GetShortPathName(pchar(path),p,sizeof(p)-1);
 exit(ansistring(p+fname));
 {$ENDIF}
end;


procedure TCompileDialog.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if compiling then compiling:=false;
end;

procedure TCompileDialog.FormCreate(Sender: TObject);
begin
  OutputLines:=TStringList.Create();
end;

procedure TCompileDialog.FormDestroy(Sender: TObject);
begin
  OutputLines.Destroy();
end;

procedure TCompileDialog.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if compiling then
   begin
    if key=VK_ESCAPE then compiling:=false;
   end         else Close();
end;

procedure TCompileDialog.Compile(filename:ansistring;EditorOptions:TEditorOptions);

function min(a,b:integer):integer;inline;
begin
     if a<b then exit(a);
     result:=b;
end;

const ds={$IFDEF UNIX}'/'{$ELSE}'\'{$ENDIF};
      BufferSize=2048;
var p:Tprocess;
    cl,bd:string;
    o:array[0..BufferSize-1] of char;
    i,br,bl:integer;
begin
    OutputLines.Clear();
    p:=TProcess.Create(self);
    p.Options:=[poUsePipes,poStdErrToOutput];
    bd:=EditorOptions.bin_directory;
    if bd='' then bd:='.';
    p.commandline:=Retrace(bd)+ds+'fpc'+{$IFDEF WIN32}'.exe'{$ELSE}''{$ENDIF}+' '+EditorOptions.GetParams()+parsefilename(filename);
    {$IFDEF WIN32}
    p.showWindow:=swoHide;
    {$ENDIF}
    if fileexists(bd+ds+'fpc'{$IFDEF WIN32}+'.exe'{$ENDIF}) then
     begin
      p.Execute();
      cl:='';
      while p.Running do
       begin
        //flush stream
        bl:=p.Output.Size;
        while bl>0 do
         begin
          br:=p.Output.Read(o,BufferSize);
          for i:=0 to br-1 do
           if o[i]<>#10 then
            begin
             if o[i]<>#13 then cl+=o[i];
            end
                        else
            begin
             OutputLines.Add(cl);
             cl:='';
            end;
           bl-=br;
         end;
        //kill the program if canceled
        if not compiling then
         begin
          p.Terminate(255);
          p.Destroy();
          OutputLines.Add('Fatal: Compilation Aborted');
          exit;
         end;
        sleep(10);
        Application.ProcessMessages();
       end;
      //final flush stream
      bl:=p.Output.Size;
      while bl>0 do
       begin
        br:=p.Output.Read(o,BufferSize);
        for i:=0 to br-1 do
         if o[i]<>#10 then
          begin
           if o[i]<>#13 then cl+=o[i];
          end
                      else
          begin
           OutputLines.Add(cl);
           cl:='';
          end;
         bl-=br;
       end;
      if cl<>'' then OutputLines.Add(cl);
      p.Destroy();
     end else
    OutputLines.Add('Fatal: Could not execute "'+bd+ds+'fpc'+{$IFDEF WIN32}'.exe'{$ELSE}''{$ENDIF}+'". Make sure your compiler path is set correctly');
end;

function TCompileDialog.Execute(filename:ansistring;EditorOptions:TEditorOptions;suppress:boolean):boolean;
const foo:array[0..2] of string=('Normal','Debug','Release');
      bar:array[0..13] of string=('Go32v2 extender','Linux for i386','OS/2',
      'Win32 for i386','FreeBSD/ELF for i386','Solaris for i386',
      'NetBSD for i386','Netware for i386 (clib)','WDOSX DOS extender',
      'OpenBSD for i386','OS/2 via EMX','Watcom Compatible DOS extenders',
      'Netware for i386 (libc)','Linux for AMD64 (x86-64))');
const er:pchar='ERROR: ';
      hi:pchar='HINT: ';
      no:pchar='NOTE: ';
      wa:pchar='WARNING: ';
      fa:pchar='FATAL: ';
var i:integer;
    fap,erp,hip,nop,wap:PMatchTable;
begin
     try
       Application.MainForm.Enabled:=false;
       erp:=nil;
       fap:=nil;
       hip:=nil;
       nop:=nil;
       wap:=nil;

       mr:=0;
       StatusLabel.Caption:='Status: Compiling';
       Caption:='Compiling ('+foo[EditorOptions.Mode]+' mode)';
       ActiveCaption.Caption:='Press ESC to cancel';
       ActiveCaption.Color:=clBlue;
       TargetLabel.Caption:='Target: '+bar[EditorOptions.Target];
       MainFileLabel.Caption:='Main file: '+filename;
       WarningsLabel.Caption:='Warnings: 0';
       ErrorsLabel.Caption:='Errors: 0';
       NotesLabel.Caption:='Notes: 0';
       HintsLabel.Caption:='Hints: 0';
       compiling:=true;
       Application.ProcessMessages();
       Show();
       Compile(filename,EditorOptions);
       compiling:=false;
       hc:=0;
       ec:=0;
       nc:=0;
       wc:=0;
       i:=0;
       while i<OutputLines.Count do
        begin
         if (Match(fa,pchar(UpCase(OutputLines[i])),fap)<>-1)or(Match(er,pchar(UpCase(OutputLines[i])),erp)<>-1) then inc(ec)
                                                                                                                 else
         if (Match(wa,pchar(UpCase(OutputLines[i])),wap)<>-1) then inc(wc)
                                                              else
         if (Match(no,pchar(UpCase(OutputLines[i])),nop)<>-1) then inc(nc)
                                                              else
         if (Match(hi,pchar(UpCase(OutputLines[i])),hip)<>-1) then inc(hc)
                                                              else
          begin
           OutputLines.Delete(i);
           dec(i);
          end;
         inc(i);
        end;
       WarningsLabel.Caption:='Warnings: '+IntToStr(wc);
       ErrorsLabel.Caption:='Errors: '+IntToStr(ec);
       NotesLabel.Caption:='Notes: '+IntToStr(nc);
       HintsLabel.Caption:='Hints: '+IntToStr(hc);
       if ec=0 then
        begin
         StatusLabel.Caption:='Status: Done.';
         ActiveCaption.Caption:='Compilation ok. Press any key';
         Result:=true;
         ActiveCaption.Color:=clGreen;
        end    else
        begin
         StatusLabel.Caption:='Status: Failed to compile...';
         ActiveCaption.Caption:='Compilation failed. Press any key';
         Result:=false;
         ActiveCaption.Color:=clRed;
        end;

       FreeMatchTable(erp);
       FreeMatchTable(hip);
       FreeMatchTable(nop);
       FreeMatchTable(wap);
       FreeMatchTable(fap);

     finally
      Application.MainForm.Enabled:=true;
      if (Result)and(suppress) then Close();
     end;
end;

initialization
  {$I uCompileDialog.lrs}

end.

