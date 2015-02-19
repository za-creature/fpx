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

unit uDebugger;

{$mode objfpc}{$H+}
{$inline on}
{$coperators on}
interface

uses
  Classes, Sysutils, Process;


type //pointers
     PWatch=^TWatch;
     PBreakPoint=^TBreakPoint;
     PFrame=^TFrame;
     PPFrame=^PFrame;
     PStackTrace=^TStackTrace;
     //generic datastructures
     TWatch=record
      name,value:ansistring;
      watchtype:byte;//reserved for future-usage
     end;
     TBreakPoint=record
      name:ansistring;
      breaktype:byte;//0 for line; 1 for function; 2 (maybe) for address
     end;
     TFrame=record
      id:integer;//frame depth
      address:ansistring;//addr
      fname:ansistring;//function name
      fargs:ansistring;//function arguments
      filename:ansistring;//file containing the function
      linenumber:integer;//line number within the function
     end;
     TStackTrace=record
      framecount:integer;
      frames:PPFrame;
     end;
     //GDB Handler
     TGdbHandler=class(TObject)
     protected
      gdb:TProcess;
      function WaitForQueryOutput():ansistring;
      procedure UnconfirmedQuery(qry:ansistring);
     public
      constructor Create(gdbpath:ansistring);
      destructor Destroy();override;
      function Query(qry:ansistring):ansistring;
      function Ready():boolean;
     end;
     //Program Debugger
     TProgramDebugger=class(TObject)
      protected
       //internals
       gdb:TGdbHandler;
       ec,ln:integer;
       cf:ansistring;
       rn:boolean;
       breakpointlist,watchlist:TList;
       //internal functions
       procedure AnalizeLocationData(s:ansistring);
       procedure RefreshWatchList();
       procedure AddBreakPoint(fname:ansistring;btype:byte);
       function Bypass():integer;
       function Bypass2():integer;
      public
       //constructor/destructor
       constructor Create(cygdir,filename,workdir:ansistring);
       destructor Destroy();
       //code flow
       procedure TraceInto();
       procedure StepOver();
       procedure UntilNextLine();
       procedure Continue();
       //watches
       procedure AddWatch(name:ansistring);
       procedure DeleteWatch(name:ansistring);
       procedure ClearWatchList();
       function GetWatch(name:ansistring):PWatch;
       function GetWatch(id:integer):PWatch;
       //breakpoints
       procedure AddBreakPoint(fname:ansistring);
       procedure AddBreakPoint(linenumber:integer);
       procedure RemoveBreakPoint(fname:ansistring);
       procedure RemoveBreakPoint(linenumber:integer);
       procedure ClearBreakPointList();
       function GetBreakPoint(id:integer):PBreakPoint;
       function GetBreakPoint(name:ansistring):PBreakPoint;
       //call stack
       function GetStackTrace():PStackTrace;
       //properties to give read-only access to certain private fields
       property Running:boolean read rn;
       property CurrentLineNumber:integer read ln;
       property CurrentFileName:ansistring read cf;
       property ExitCode:integer read ec;
       property WatchCount:integer read Bypass;
       property BreakPointCount:integer read Bypass2;
     end;     
     
procedure ReleaseStackTrace(s:PStackTrace);
     
implementation

//----------     
//Generic Functions
//----------

function min(a,b:int64):int64;inline;
begin
        if a>b then exit(b);
        result:=a;
end;

function CygFormat(s:ansistring):ansistring;
var i:integer;
begin
        {$ifdef win32}
        result:='/cygdrive/';
        for i:=1 to length(s) do
         if s[i]<>'\' then
          begin
           if s[i]<>':' then result:=result+s[i]
          end
                      else result:=result+'/';
        {$else}
        result:=s;
        {$endif}
end;

function GetLastLine(s:ansistring):ansistring;inline;
var ep:integer;

begin
        ep:=length(s)-1;
        while (ep>0)and(s[ep]<>#10) do dec(ep);
        result:=copy(s,ep+1,length(s)-ep-1);
end;

function GetLine(s:ansistring):ansistring;inline;
var i:integer;
begin
        result:='';
        for i:=1 to length(s) do
         if s[i]<>#10 then result+=s[i];
end;

function GetSecondPart(s:ansistring):ansistring;inline;
var i:integer;
begin
        for i:=1 to length(s) do if s[i]='=' then break;
        inc(i);        
        if i<=length(s) then
         result:=Copy(s,i,length(s)-i+1);
end;

procedure ReleaseStackTrace(s:PStackTrace);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.framecount-1 do
           if s^.frames[i]<>nil then dispose(s^.frames[i]);
          if s^.frames<>nil then freemem(s^.frames);
          dispose(s);
         end;
end;

//----------     
//GDB Handler
//----------

constructor TGdbHandler.Create(gdbpath:ansistring);
const ds={$ifdef unix}'/'{$else}'\'{$endif};
begin
        gdb:=TProcess.Create(nil);
        gdb.Options:=[poNoConsole,poUsePipes,poStdErrToOutPut];
        gdb.ShowWindow:=swoHide;
        gdb.CommandLine:=gdbpath+ds+'gdb'{$ifdef win32}+'.exe'{$endif};
        gdb.Execute();
        WaitForQueryOutput();
end;

destructor TGdbHandler.Destroy();
begin
        if gdb.Running then gdb.Terminate(0);
        gdb.Destroy();
end;

function TGdbHandler.WaitForQueryOutput():ansistring;
const bsize=512;
var eof:boolean;
    buffer:array[0..bsize-1] of char;
    i,br:integer;
    tmp:ansistring;
begin
        eof:=false;
        result:='';
        while(gdb.Running)and(not eof)do
         begin
          if Gdb.Output.Size<>0 then
           begin
            br:=gdb.Output.Read(buffer,min(gdb.Output.Size,bsize));
            tmp:='';
            for i:=0 to br-1 do tmp+=buffer[i];
            result+=tmp;
            eof:=copy(result,length(result)-5,5)='(gdb)';
           end                  else sleep(1);
         end;
        Result:=copy(result,1,length(result)-6); //remove the #10
end;

function TGdbHandler.Ready():boolean;
begin
        result:=gdb.Running;//the interface is no longer asynchronous
end;

procedure TGdbHandler.UnconfirmedQuery(qry:ansistring);
var i:integer;
begin
        for i:=1 to length(qry) do gdb.Input.Write(qry[i],1);
        gdb.Input.Write(#10,1);
end;

function TGdbHandler.Query(qry:ansistring):ansistring;
var i:integer;
begin
        UnconfirmedQuery(qry);
        result:=WaitForQueryOutput();
end;

//----------
//Program Debugger
//----------

//constructor/destructor

constructor TProgramDebugger.Create(cygdir,filename,workdir:ansistring);
begin
        inherited Create();
        gdb:=TGdbHandler.Create(cygdir);
        watchlist:=TList.Create();
        breakpointlist:=TList.Create();
        gdb.Query('set annotate 1');
        gdb.Query('cd '+CygFormat(workdir));
        gdb.Query('file '+CygFormat(filename));
        rn:=true;
        AnalizeLocationData(gdb.Query('start '+CygFormat(filename)));
        RefreshWatchList();
end;

destructor TProgramDebugger.Destroy();
begin
        gdb.Destroy();
        watchlist.Destroy();
end;

//internal functions

procedure TProgramDebugger.AnalizeLocationData(s:ansistring);
var i:integer;
    tmp:ansistring;
begin
        i:=1;
        while(i<length(s))and((s[i]<>#26)or(s[i+1]<>#26))do inc(i);
        if i=length(s) then
         begin
          //check wether the program is terminated
          tmp:=GetLastLine(s);
          if (tmp='Program exited normally.') then
           begin
            ec:=0;
            rn:=false;
           end;
          if (copy(tmp,1,25)='Program exited with code ') then
           begin
            ec:=StrToInt(Copy(tmp,26,length(tmp)-26));//remove the ending period
            rn:=false;
           end;
          exit;//no usable data located
         end;
        inc(i,2);//get over the two #26 
        cf:='';
        while s[i]<>':' do
         begin
          cf+=s[i];//get the file name
          inc(i);
         end;
        inc(i);
        
        tmp:='';
        while s[i]<>':' do
         begin
          tmp+=s[i];
          inc(i);
         end;        
        ln:=StrToInt(tmp);//get the line number
        //we don't care about anything else... just yet
end;

function TProgramDebugger.Bypass():integer;
begin
        //the WatchCount read attribute cannot be set to another property so we must use this bypass function
        result:=watchlist.Count;
end;

function TProgramDebugger.Bypass2():integer;
begin
        //the BreakPointCount read attribute cannot be set to another property so we must use this bypass function
        result:=breakpointlist.Count;
end;

procedure TProgramDebugger.AddBreakPoint(fname:ansistring;btype:byte);
var i:integer;
    mybreakpoint:PBreakPoint;
begin
        for i:=0 to breakpointlist.Count-1 do 
         if PBreakPoint(breakpointlist.Items[i])^.name=fname then exit;//we already have this breakpoint; no need to add it again
        new(mybreakpoint);
        mybreakpoint^.breaktype:=btype;
        mybreakpoint^.name:=fname;
        breakpointlist.Add(mybreakpoint);
        gdb.Query('break '+UpperCase(fname));
end;

//flow control functions

procedure TProgramDebugger.TraceInto();
begin
        AnalizeLocationData(gdb.Query('step'));
        RefreshWatchList();
end;

procedure TProgramDebugger.StepOver();
begin
        AnalizeLocationData(gdb.Query('next'));
        RefreshWatchList();
end;

procedure TProgramDebugger.UntilNextLine();
begin
        AnalizeLocationData(gdb.Query('until'));
        RefreshWatchList();
end;

procedure TProgramDebugger.Continue();
begin
        AnalizeLocationData(gdb.Query('continue'));
        RefreshWatchList();
end;

//watch functions

procedure TProgramDebugger.AddWatch(name:ansistring);
var mywatch:PWatch;
    i:integer;
begin
        for i:=0 to watchlist.Count-1 do
         if TWatch(watchlist.Items[i]^).name=name then exit;//if the watch is already in the list, do nothing
        
        new(mywatch);
        mywatch^.name:=name;
        watchlist.Add(mywatch);
end;

procedure TProgramDebugger.DeleteWatch(name:ansistring);
var i:integer;
begin
        for i:=0 to watchlist.Count-1 do
         if TWatch(watchlist.Items[i]^).name=name then
          begin
           dispose(PWatch(watchlist.Items[i]));
           watchlist.Delete(i);
           exit;
          end;
end;

procedure TProgramDebugger.ClearWatchList();
var i:integer;
begin
        for i:=0 to watchlist.Count-1 do dispose(PWatch(watchlist.Items[i]));
        watchlist.Clear();
end;

procedure TProgramDebugger.RefreshWatchList();
var i:integer;
    tmp:string;
begin
        for i:=0 to watchlist.Count-1 do
         begin
          tmp:=GetLine(gdb.Query('print '+TWatch(watchlist.Items[i]^).name));
          if tmp[1]<>'$' then TWatch(watchlist.Items[i]^).value:=tmp //no symbol in context
                         else TWatch(watchlist.Items[i]^).value:=GetSecondPart(tmp);
         end;
end;

function TProgramDebugger.GetWatch(name:ansistring):PWatch;
var i:integer;
begin
        for i:=0 to watchlist.Count-1 do
         if PWatch(watchlist.Items[i])^.name=name then exit(PWatch(watchlist.Items[i]));
        result:=nil;
end;
function TProgramDebugger.GetWatch(id:integer):PWatch;
begin
        if(id>=0)and(id<watchlist.Count)then exit(PWatch(watchlist.Items[id]));
        result:=nil;
end;

//breakpoint functions

procedure TProgramDebugger.AddBreakPoint(fname:ansistring);
begin
        AddBreakPoint(fname,1);
end;

procedure TProgramDebugger.AddBreakPoint(linenumber:integer);
begin
        AddBreakPoint(IntToStr(linenumber),0);
end;

procedure TProgramDebugger.RemoveBreakPoint(fname:ansistring);
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do
         if TBreakPoint(breakpointlist.Items[i]^).name=fname then
          begin
           gdb.Query('clear '+fname);
           dispose(PBreakPoint(breakpointlist.Items[i]));
           breakpointlist.Delete(i);
           exit;
          end;
end;

procedure TProgramDebugger.RemoveBreakPoint(linenumber:integer);
begin
        RemoveBreakPoint(IntToStr(linenumber));
end;

procedure TProgramDebugger.ClearBreakPointList();
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do dispose(PBreakPoint(breakpointlist.Items[i]));
        breakpointlist.Clear();
end;

function TProgramDebugger.GetBreakPoint(id:integer):PBreakPoint;
begin
        if(id>=0)and(id<breakpointlist.Count)then exit(breakpointlist.Items[id]);
        result:=nil;
end;

function TProgramDebugger.GetBreakPoint(name:ansistring):PBreakPoint;
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do
         if PBreakPoint(breakpointlist.Items[i])^.name=name then exit(breakpointlist.Items[i]);
        result:=nil;
end;

//call stack

function TProgramDebugger.GetStackTrace():PStackTrace;
var filenm,lnm,prms,adr,fnm,fid,s:ansistring;
    charstoskip,asi,bs,l,i:integer;
    instring:boolean;
    myframe:PFrame;
begin
        new(result);
        result^.framecount:=0;
        s:=gdb.Query('backtrace');
        i:=0;
        l:=length(s);
        while i<l do
         begin
          inc(i);
          fid:='';
          //read frame id
          inc(i);//jump over the #
          while s[i]<>' ' do
           begin
            if s[i]<>#10 then fid+=s[i];
            inc(i);
           end;
          //read name and address
          while (s[i]=' ')or(s[i]=#10) do inc(i);
          if s[i]='$' then 
           begin
            //read address
            adr:='';
            while s[i]<>' ' do
             begin
              if s[i]<>#10 then adr+=s[i];
              inc(i);
             end;
            //skip the 'in'
            
            charstoskip:=2;
            while (s[i]=' ')or(s[i]=#10)or(charstoskip>0)do
             begin
              if (s[i]<>' ')and(s[i]<>#10) then dec(charstoskip);
              inc(i);
             end;

            //read function name
            fnm:='';
            while s[i]<>' ' do
             begin
              if s[i]<>#10 then fnm+=s[i];
              inc(i);
             end;
           end        else
           begin
            adr:='(fstart)';
            //read function name
            fnm:='';
            while s[i]<>' ' do
             begin
              if s[i]<>#10 then fnm+=s[i];
              inc(i);
             end;
           end;
          inc(i,2);
          prms:='';
          instring:=false;
          //read parameters
          while (s[i]<>')')or(instring) do
           begin
            if s[i]='''' then instring:=not(instring);
            if s[i]<>#10 then prms+=s[i];
            inc(i);
           end;
          inc(i);//get over )
           
          //skip the 'at'
          charstoskip:=2;
          while (s[i]=' ')or(s[i]=#10)or(charstoskip>0)do
           begin
            if (s[i]<>' ')and(s[i]<>#10) then dec(charstoskip);
            inc(i);
           end;
          //get filename
          filenm:='';
          while s[i]<>':' do
           begin
            filenm+=s[i];
            inc(i);
           end;
          inc(i);//get over :
          lnm:='';
          //get linenumber
          while (i<=l)and(s[i] in ['0'..'9']) do
           begin
            lnm+=s[i];
            inc(i);
           end;
          //skip until #10
          while (i<=l)and(s[i]<>#10) do inc(i);
          inc(result^.framecount);
          ReAllocMem(result^.frames,result^.framecount*sizeof(pointer));
          
          new(result^.frames[result^.framecount-1]);
          myframe:=result^.frames[result^.framecount-1];
          
          myframe^.id:=StrToInt(fid);
          myframe^.address:=adr;
          myframe^.fname:=LowerCase(fnm);
          myframe^.fargs:=prms;
          myframe^.filename:=filenm;
          myframe^.linenumber:=StrToInt(lnm);
         end;
end;

end.
