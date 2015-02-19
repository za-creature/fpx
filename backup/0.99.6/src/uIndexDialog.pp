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

unit uIndexDialog;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef win32}Windows, {$endif}Classes, SysUtils, LResources, Forms, Controls,
  Graphics, Dialogs, StdCtrls, Buttons, uAVLTree;
  
{$ifndef win32}
{$i keycodes.inc}
{$endif}

type
  TMatchTable=array of integer;
  PMatchTable=^TMatchTable;
  
  { TIndexDialog }

  TIndexDialog = class(TForm)
    DisplayButton: TButton;
    EditBox: TEdit;
    EditGroupBox: TGroupBox;
    TopicListGroupBox: TGroupBox;
    TopicList: TListBox;
    procedure DisplayButtonClick(Sender: TObject);
    procedure EditBoxChange(Sender: TObject);
    procedure EditBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure TopicListKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
    mr:integer;
    sf:string;
    procedure Search(t:string);
  public
    HelpIndex:TStringList;
    function Execute(s:string):boolean;
    property SelectedFile:string read sf;
    function TopicSearch(s:string):string;
    { public declarations }
  end; 

var
  IndexDialog: TIndexDialog;

implementation

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
     SetLength(p^,0);
     Dispose(p);
     p:=nil;
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

{ TIndexDialog }

procedure TIndexDialog.EditBoxChange(Sender: TObject);
begin
  Search(EditBox.Text);
end;

procedure TIndexDialog.EditBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_UP then
   begin
    ActiveControl:=TopicList;
    if TopicList.ItemIndex>0 then TopicList.ItemIndex:=TopicList.ItemIndex-1;
   end;
  if key=VK_DOWN then
   begin
    ActiveControl:=TopicList;
    if TopicList.ItemIndex<TopicList.Items.Count-1 then TopicList.ItemIndex:=TopicList.ItemIndex+1;
   end;
  if key=VK_ESCAPE then Close();
end;

procedure TIndexDialog.TopicListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
var S:string;
begin
     if key in [VK_A..VK_Z] then
      begin
       if ssShift in Shift then EditBox.Text:=EditBox.Text+char(byte('A')+key-VK_A)
                           else EditBox.Text:=EditBox.Text+char(byte('a')+key-VK_A);
      end                     else
     if key=VK_BACK then ActiveControl:=EditBox;
     if key=VK_ESCAPE then Close();
end;

procedure TIndexDialog.DisplayButtonClick(Sender: TObject);
begin
  if TopicList.ItemIndex<>-1 then
   begin
    mr:=1;
    sf:=TStringObject(TopicList.Items.Objects[TopicList.ItemIndex]).value;
    Close();
   end;
end;

procedure TIndexDialog.Search(t:string);
var p,h:PChar;
    i,j:integer;
    table:PMatchTable;
    aitem:string;
begin
     t:=Trim(t);
     getmem(h,length(t)+1);
     //strcopy
     for i:=0 to length(t)-1 do h[i]:=UpCase(t[i+1]);
     h[i+1]:=#0;
     table:=BuildMatchTable(h);
     TopicList.Items.Clear();
     if t='' then TopicList.Items.Assign(HelpIndex)
             else
      begin
       for i:=0 to HelpIndex.Count-1 do
        begin
         aitem:=HelpIndex[i];
         getmem(p,length(aitem)+1);
         //strcopy
         for j:=0 to length(aitem)-1 do p[j]:=UpCase(aitem[j+1]);
         p[j+1]:=#0;
         if Match(h,p,table)<>-1 then
          TopicList.Items.AddObject(HelpIndex[i],HelpIndex.Objects[i]);
         freemem(p);
        end;
      end;
     freemem(h);
     if TopicList.Items.Count<>0 then TopicList.ItemIndex:=0;
end;

function TIndexDialog.TopicSearch(s:string):string;
var i:integer;
    us:string;
begin
     Search(s);
     us:=UpCase(s);
     for i:=0 to TopicList.Items.Count-1 do
      if UpCase(TopicList.Items[i])=us then exit(TStringObject(TopicList.Items.Objects[i]).value);
     result:='/\';
end;

function TIndexDialog.Execute(s:string):boolean;
begin
     EditBox.Text:=s;
     mr:=0;
     showModal();
     Result:=mr<>0;
end;

initialization
  {$I uIndexDialog.lrs}

end.

