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
  {$ifdef win32}Windows,{$endif}Interfaces, Forms, Classes, Sysutils, Process;


type //pointers
     PRegister=^TRegister;
     PPRegister=^PRegister;
     PFloatingRegister=^TFloatingRegister;
     PPFloatingREgister=^PFloatingRegister;
     PMMXRegister=^TMMXRegister;
     PPMMXRegister=^PMMXRegister;
     PSSERegister=^TSSERegister;
     PPSSERegister=^PSSERegister;
     
     PRegisterList=^TRegisterList;
     PFloatingRegisterList=^TFloatingRegisterList;
     PMMXRegisterList=^TMMXRegisterList;
     PSSERegisterList=^TSSERegisterList;
     
     PWatch=^TWatch;
     PBreakPoint=^TBreakPoint;
     
     PFrame=^TFrame;
     PPFrame=^PFrame;
     PStackTrace=^TStackTrace;
     
     PAsmOut=^TAsmOut;
     
     PPAsmLine=^PAsmLine;
     PAsmLine=^TAsmLine;
     
     //generic datastructures
     TWatch=record
      name,value:ansistring;
      watchtype:byte;//reserved for future-usage
     end;
     
     TRegister=record
      name,dec,hex:ansistring;
     end;
     TFloatingRegister=record
      name,flt,raw:ansistring;
     end;
     TMMXRegister=record
      name,int8,int16,int32,int64:ansistring;
     end;
     TSSERegister=record
      name,float32,float64,int8,int16,int32,int64,int128:ansistring;
     end;

     
     TRegisterList=record
      numregisters:integer;
      registers:PPRegister;
     end;
     TFloatingRegisterList=record
      numregisters:integer;
      registers:PPFloatingRegister;
     end;
     TMMXRegisterList=record
      numregisters:integer;
      registers:PPMMXRegister;
     end;
     TSSERegisterList=record
      numregisters:integer;
      registers:PPSSERegister;
     end;
     
     TBreakPoint=record
      filename:ansistring;
      linenumber:integer;
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
     
     TAsmLine=record
      addr,instr,args:ansistring;
     end;
     TAsmOut=record
      linecount:integer;
      lines:PPAsmLine;
     end;
     
     //GDB Handler
     TGdbHandler=class(TObject)
     protected
      function WaitForQueryOutput():ansistring;
      procedure UnconfirmedQuery(qry:ansistring);
     public
      gdb:TProcess;
      constructor Create(gdbpath:ansistring);
      destructor Destroy();override;
      function Query(qry:ansistring):ansistring;
      function Ready():boolean;
      onProgramTermination:TNotifyEvent;
     end;
     //Program Debugger
     TProgramDebugger=class(TObject)
      protected
       //internals
       ec,ln:integer;
       cf:ansistring;
       rn:boolean;
       breakpointlist{,watchlist}:TList;
       hwnd:dword;
       //internal functions
       procedure AnalizeLocationData(s:ansistring);
       function BreakpointAtCurrentPosition():boolean;
//       procedure RefreshWatchList();
//       function Bypass():integer;
       function Bypass2():integer;
       procedure SetProgramTerminationEvent(value:TNotifyEvent);
       FonProgramTermination:TNotifyEvent;
      public
       gdb:TGdbHandler;
       onProgramTerminate:procedure(exitcode:integer) of object;
       //constructor/destructor
       constructor Create(cygdir,filename,workdir,params:ansistring);
       destructor Destroy();override;
       //code flow
       procedure TraceInto();
       procedure StepOver();
       procedure UntilNextLine();
       procedure Continue();
       //watches
//       procedure AddWatch(name:ansistring);
//       procedure DeleteWatch(name:ansistring);
//       procedure ClearWatchList();
//       function GetWatch(name:ansistring):PWatch;
//       function GetWatch(id:integer):PWatch;
       function GetExpressionValue(name:ansistring):ansistring;
       //breakpoints
       procedure AddBreakPoint(filename:ansistring;linenumber:integer);
       procedure RemoveBreakPoint(filename:ansistring;linenumber:integer);
       procedure ClearBreakPointList();
       function GetBreakPoint(filename:ansistring;linenumber:integer):PBreakPoint;
       //call stack
       function GetStackTrace():PStackTrace;
       //properties to give read-only access to certain private fields
       property Running:boolean read rn write rn;
       property CurrentLineNumber:integer read ln;
       property CurrentFileName:ansistring read cf;
       property ExitCode:integer read ec;
       //property WatchCount:integer read Bypass;
       property BreakPointCount:integer read Bypass2;
       property Handle:dword read hwnd;
       property onProgramTermination:TNotifyEvent read FonProgramTermination write SetProgramTerminationEvent;
       //register examination
       function GetRegisters():PRegisterList;
       function GetFloatingPointRegisters():PFloatingRegisterList;
       function GetMMXRegisters():PMMXRegisterList;
       function GetSSERegisters():PSSERegisterList;
       //disassembly
       function DisassembleCurrentFrame():PAsmOut;
     end;     
     
procedure ReleaseStackTrace(s:PStackTrace);
procedure ReleaseRegisterList(s:PRegisterList);
procedure ReleaseRegisterList(s:PFloatingRegisterList);
procedure ReleaseRegisterList(s:PMMXRegisterList);
procedure ReleaseRegisterList(S:PSSERegisterList);
procedure ReleaseAssemblerSource(s:PAsmOut);

     
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
        result+=LowerCase(s[1]);
        for i:=2 to length(s) do
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

procedure ReleaseRegisterList(s:PRegisterList);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.numregisters-1 do
           if s^.registers[i]<>nil then dispose(s^.registers[i]);
          if s^.registers<>nil then freemem(s^.registers);
          dispose(s);
         end;
end;

procedure ReleaseRegisterList(s:PFloatingRegisterList);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.numregisters-1 do
           if s^.registers[i]<>nil then dispose(s^.registers[i]);
          if s^.registers<>nil then freemem(s^.registers);
          dispose(s);
         end;
end;

procedure ReleaseRegisterList(S:PSSERegisterList);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.numregisters-1 do
           if s^.registers[i]<>nil then dispose(s^.registers[i]);
          if s^.registers<>nil then freemem(s^.registers);
          dispose(s);
         end;
end;

procedure ReleaseRegisterList(s:PMMXRegisterList);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.numregisters-1 do
           if s^.registers[i]<>nil then dispose(s^.registers[i]);
          if s^.registers<>nil then freemem(s^.registers);
          dispose(s);
         end;
end;

procedure ReleaseAssemblerSource(s:PAsmOut);
var i:integer;
begin
        if s<>nil then
         begin
          for i:=0 to s^.linecount-1 do
           if s^.lines[i]<>nil then dispose(s^.lines[i]);
          if s^.lines<>nil then freemem(s^.lines);
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
        if gdb.Running then gdb.Terminate(255);
        gdb.Destroy();
end;

function TGdbHandler.WaitForQueryOutput():ansistring;
const bsize=512;
var eof:boolean;
    buffer:array[0..bsize-1] of char;
    br,i:integer;
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
          Application.ProcessMessages();
         end;
        if (not gdb.Running)and(onProgramTermination<>nil)then OnProgramTermination(self);
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
begin
        UnconfirmedQuery(qry);
        result:=WaitForQueryOutput();
end;

//----------
//Program Debugger
//----------

//constructor/destructor

constructor TProgramDebugger.Create(cygdir,filename,workdir,params:ansistring);
begin
        inherited Create();
        gdb:=TGdbHandler.Create(cygdir);
//        watchlist:=TList.Create();
        breakpointlist:=TList.Create();
        gdb.Query('set annotate 1');
        gdb.Query('cd '+CygFormat(workdir));
        gdb.Query('file '+CygFormat(filename));
        gdb.Query('set args '+params);
        rn:=true;
        AnalizeLocationData(gdb.Query('start '+CygFormat(filename)));
//        RefreshWatchList();
        {$ifdef win32}
        hwnd:=GetForeGroundWindow();
        {$endif}
end;

destructor TProgramDebugger.Destroy();
begin
//        ClearWatchList();
        ClearBreakPointList();
        breakpointlist.Destroy();
        gdb.Destroy();
//        watchlist.Destroy();
     inherited Destroy();
end;

//internal functions

procedure TProgramDebugger.AnalizeLocationData(s:ansistring);
var i:integer;
    tmp:ansistring;
begin
     if not Running then exit;
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
            if FonProgramTermination<>nil then FonProgramTermination(self);
           end;
          if (copy(tmp,1,25)='Program exited with code ') then
           begin
            ec:=StrToInt(Copy(tmp,26,length(tmp)-26));//remove the ending period
            rn:=false;
            if FonProgramTermination<>nil then FonProgramTermination(self);
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

function TProgramDebugger.BreakpointAtCurrentPosition():boolean;
var i:integer;
begin
     for i:=0 to BreakpointList.Count-1 do
      if (CygFormat(TBreakPoint(BreakpointList[i]^).filename)=CurrentFileName)and
         (TBreakPoint(BreakpointList[i]^).linenumber=CurrentLineNumber)then exit(true);
     result:=false;
end;

{function TProgramDebugger.Bypass():integer;
begin
        //the WatchCount read attribute cannot be set to another property so we must use this bypass function
        result:=watchlist.Count;
end;}

function TProgramDebugger.Bypass2():integer;
begin
        //the BreakPointCount read attribute cannot be set to another property so we must use this bypass function
        result:=breakpointlist.Count;
end;

procedure TProgramDebugger.AddBreakPoint(filename:ansistring;linenumber:integer);
var i:integer;
    mybreakpoint:PBreakPoint;
begin
        for i:=0 to breakpointlist.Count-1 do
         if (PBreakPoint(breakpointlist[i])^.filename=filename)and
            (PBreakPoint(breakpointlist[i])^.linenumber=linenumber) then exit;//we already have this breakpoint; no need to add it again
        new(mybreakpoint);
        mybreakpoint^.filename:=filename;
        mybreakpoint^.linenumber:=linenumber;
        breakpointlist.Add(mybreakpoint);
end;

//flow control functions

procedure TProgramDebugger.TraceInto();
begin
        AnalizeLocationData(gdb.Query('step'));
end;

procedure TProgramDebugger.StepOver();
begin
        AnalizeLocationData(gdb.Query('next'));
end;

procedure TProgramDebugger.UntilNextLine();
var myline:integer;
begin
        MyLine:=self.ln;
        //emulate until
        while (Running)and(CurrentLineNumber<=MyLine) do
         begin
          AnalizeLocationData(gdb.Query('step'));
          if Running and BreakpointAtCurrentPosition() then break;
         end;
end;

procedure TProgramDebugger.Continue();
begin
        //emulate continue
        while Running do
         begin
          AnalizeLocationData(gdb.Query('step'));
          if Running and BreakpointAtCurrentPosition() then break;
         end;
end;

//watch functions

{procedure TProgramDebugger.AddWatch(name:ansistring);
var mywatch:PWatch;
    i:integer;
begin
        for i:=0 to watchlist.Count-1 do
         if TWatch(watchlist.Items[i]^).name=name then exit;//if the watch is already in the list, do nothing
        
        new(mywatch);
        mywatch^.name:=name;
        watchlist.Add(mywatch);
end;}

{procedure TProgramDebugger.DeleteWatch(name:ansistring);
var i:integer;
begin
        for i:=0 to watchlist.Count-1 do
         if TWatch(watchlist.Items[i]^).name=name then
          begin
           dispose(PWatch(watchlist.Items[i]));
           watchlist.Delete(i);
           exit;
          end;
end;}

{procedure TProgramDebugger.ClearWatchList();
var i:integer;
begin
        for i:=0 to watchlist.Count-1 do dispose(PWatch(watchlist.Items[i]));
        watchlist.Clear();
end;}

{procedure TProgramDebugger.RefreshWatchList();
var i:integer;
    tmp:string;
begin
        for i:=0 to watchlist.Count-1 do
         begin
          tmp:=GetLine(gdb.Query('print '+TWatch(watchlist.Items[i]^).name));
          if tmp[1]<>'$' then TWatch(watchlist.Items[i]^).value:=tmp //no symbol in context
                         else TWatch(watchlist.Items[i]^).value:=GetSecondPart(tmp);
         end;
end;}

//the watchlist in a single function :)
function TProgramDebugger.GetExpressionValue(name:ansistring):ansistring;
var tmp:string;
begin
     tmp:=GetLine(gdb.Query('print '+name));
     if tmp[1]<>'$' then result:=tmp //no symbol in context
                    else result:=GetSecondPart(tmp);
end;

{function TProgramDebugger.GetWatch(id:integer):PWatch;
begin
        if(id>=0)and(id<watchlist.Count)then exit(PWatch(watchlist.Items[id]));
        result:=nil;
end;}

//breakpoint functions

procedure TProgramDebugger.RemoveBreakPoint(filename:ansistring;linenumber:integer);
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do
         if (TBreakPoint(breakpointlist.Items[i]^).filename=filename)and
            (TBreakPoint(breakpointlist.Items[i]^).linenumber=linenumber) then
          begin
           dispose(PBreakPoint(breakpointlist.Items[i]));
           breakpointlist.Delete(i);
           exit;
          end;
end;


procedure TProgramDebugger.ClearBreakPointList();
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do dispose(PBreakPoint(breakpointlist.Items[i]));
        breakpointlist.Clear();
end;

function TProgramDebugger.GetBreakPoint(filename:ansistring;linenumber:integer):PBreakPoint;
var i:integer;
begin
        for i:=0 to breakpointlist.Count-1 do
         if (PBreakPoint(breakpointlist.Items[i])^.filename=filename)and
         (PBreakPoint(breakpointlist.Items[i])^.linenumber=linenumber) then exit(breakpointlist.Items[i]);
        result:=nil;
end;

//call stack

function TProgramDebugger.GetStackTrace():PStackTrace;
var filenm,lnm,prms,adr,fnm,fid,s:ansistring;
    charstoskip,l,i:integer;
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

procedure TProgramDebugger.SetProgramTerminationEvent(value:TNotifyEvent);
begin
     FonProgramTermination:=value;
     gdb.onProgramTermination:=value;
end;

//register examination

function TProgramDebugger.GetRegisters():PRegisterList;
var tmp:ansistring;
    i,l:integer;
begin
     new(Result);
     Result^.NumRegisters:=0;
     tmp:=gdb.Query('info registers');
     i:=1;
     l:=length(tmp);
     while i<=l do
      begin
       inc(Result^.NumRegisters);
       ReAllocMem(Result^.registers,Result^.NumRegisters*sizeof(pointer));
       new(Result^.registers[Result^.numRegisters-1]);
       Result^.registers[Result^.numRegisters-1]^.name:='';
       //get register name
       while tmp[i]<>#32 do
        begin
         Result^.registers[Result^.numRegisters-1]^.name+=tmp[i];
         inc(i);
        end;
       while tmp[i]=#32 do inc(i);//skip whitespaces

       //get register hex value
       Result^.registers[Result^.numRegisters-1]^.hex:='';
       while tmp[i]<>#9 do
        begin
         Result^.registers[Result^.numRegisters-1]^.hex+=tmp[i];
         inc(i);
        end;
        
       while tmp[i]=#9 do inc(i);//skip whitespaces
       
       Result^.registers[Result^.numRegisters-1]^.dec:='';
       while tmp[i]<>#10 do
        begin
         Result^.registers[Result^.numRegisters-1]^.dec+=tmp[i];
         inc(i);
        end;
       inc(i);//skip the line feed
      end;
end;

function TProgramDebugger.GetFloatingPointRegisters():PFloatingRegisterList;
var tmp:ansistring;
    i,l:integer;
begin
     new(Result);
     Result^.NumRegisters:=0;
     tmp:=gdb.Query('info registers st0 st1 st2 st3 st4 st5 st6 st7');
     i:=1;
     l:=length(tmp);
     while i<=l do
      begin
       inc(Result^.NumRegisters);
       ReAllocMem(Result^.registers,Result^.NumRegisters*sizeof(pointer));
       new(Result^.registers[Result^.numRegisters-1]);
       Result^.registers[Result^.numRegisters-1]^.name:='';
       //get register name
       while tmp[i]<>#32 do
        begin
         Result^.registers[Result^.numRegisters-1]^.name+=tmp[i];
         inc(i);
        end;
       while tmp[i]=#32 do inc(i);//skip whitespaces

       //get register floating point value
       Result^.registers[Result^.numRegisters-1]^.flt:='';
       while tmp[i]<>#9 do
        begin
         Result^.registers[Result^.numRegisters-1]^.flt+=tmp[i];
         inc(i);
        end;

       while tmp[i]=#9 do inc(i);//skip whitespaces
       inc(i,5);//skip "(raw "

       //get register raw value
       Result^.registers[Result^.numRegisters-1]^.raw:='';
       while tmp[i]<>')' do
        begin
         Result^.registers[Result^.numRegisters-1]^.raw+=tmp[i];
         inc(i);
        end;
       inc(i,2);//skip the line feed and bracket
      end;
end;

function TProgramDebugger.GetMMXRegisters():PMMXRegisterList;
var tmp:ansistring;
    i,l:integer;
begin
     new(Result);
     Result^.NumRegisters:=0;
     tmp:=GetLine(gdb.Query('info registers mm0 mm1 mm2 mm3 mm4 mm5 mm6 mm7'));//get everything as one line
     i:=1;
     l:=length(tmp);
     while i<=l do
      begin
       inc(Result^.NumRegisters);
       ReAllocMem(Result^.registers,Result^.NumRegisters*sizeof(pointer));
       new(Result^.registers[Result^.numRegisters-1]);
       Result^.registers[Result^.numRegisters-1]^.name:='';
       //get register name
       while tmp[i]<>#32 do
        begin
         Result^.registers[Result^.numRegisters-1]^.name+=tmp[i];
         inc(i);
        end;
       while tmp[i]<>'$' do inc(i);//skip whitespaces, {, int64 id and equal sign
       //get int64 value
       Result^.registers[Result^.numRegisters-1]^.int64:='';
       while tmp[i]<>',' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int64+=tmp[i];
         inc(i);
        end;
       while tmp[i]<>'{' do inc(i);//colon, whitespace, int32 id and equal sign
       //get int32 value
       Result^.registers[Result^.numRegisters-1]^.int32:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int32+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int32+='}';//add finishing bracket
       inc(i);//skip bracket
       while tmp[i]<>'{' do inc(i);//colon, whitespace, int16 id and equal sign
       //get int16 value
       Result^.registers[Result^.numRegisters-1]^.int16:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int16+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int16+='}';//add finishing bracket
       inc(i);//skip bracket
       while tmp[i]<>'{' do inc(i);//colon, whitespace, int8 id and equal sign
       //get int8 value
       Result^.registers[Result^.numRegisters-1]^.int8:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int8+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int8+='}';//add finishing bracket
       inc(i,2);//skip the two remaining brackets
      end;
end;

function TProgramDebugger.GetSSERegisters():PSSERegisterList;
var tmp:ansistring;
    i,l:integer;
begin
     new(Result);
     Result^.NumRegisters:=0;
     tmp:=GetLine(gdb.Query('info registers xmm0 xmm1 xmm2 xmm3 xmm4 xmm5 xmm6 xmm7'));//get everything as one line
     i:=1;
     l:=length(tmp);
     while i<=l do
      begin
       inc(Result^.NumRegisters);
       ReAllocMem(Result^.registers,Result^.NumRegisters*sizeof(pointer));
       new(Result^.registers[Result^.numRegisters-1]);
       Result^.registers[Result^.numRegisters-1]^.name:='';
       //get register name
       while tmp[i]<>#32 do
        begin
         Result^.registers[Result^.numRegisters-1]^.name+=tmp[i];
         inc(i);
        end;
       while tmp[i]<>'{' do inc(i);//skip whitespaces
       inc(i);//skip bracket;
       while tmp[i]<>'{' do inc(i);//v4_float id, whitespaces and equal sign
       //get float32 value
       Result^.registers[Result^.numRegisters-1]^.float32:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.float32+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.float32+='}';//add finishing bracket
       while tmp[i]<>'{' do inc(i);//skip bracket, v2_double id, whitespaces and equal sign
       //get float64 value
       Result^.registers[Result^.numRegisters-1]^.float64:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.float64+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.float64+='}';//add finishing bracket
       while tmp[i]<>'{' do inc(i);//skip bracket, v16_int8 id, whitespaces and equal sign
       //get int8 value
       Result^.registers[Result^.numRegisters-1]^.int8:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int8+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int8+='}';//add finishing bracket
       while tmp[i]<>'{' do inc(i);//skip bracket, v8_int16 id, whitespaces and equal sign
       //get int16 value
       Result^.registers[Result^.numRegisters-1]^.int16:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int16+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int16+='}';//add finishing bracket
       while tmp[i]<>'{' do inc(i);//skip bracket, v4_int32 id, whitespaces and equal sign
       //get int32 value
       Result^.registers[Result^.numRegisters-1]^.int32:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int32+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int32+='}';//add finishing bracket
       while tmp[i]<>'{' do inc(i);//skip bracket, v2_int64 id, whitespaces and equal sign
       //get int64 value
       Result^.registers[Result^.numRegisters-1]^.int64:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int64+=tmp[i];
         inc(i);
        end;
       Result^.registers[Result^.numRegisters-1]^.int64+='}';//add finishing bracket
       while tmp[i]<>'$' do inc(i);//skip bracket, uint128 id, whitespaces and equal sign
       //get int128 value
       Result^.registers[Result^.numRegisters-1]^.int128:='';
       while tmp[i]<>'}' do
        begin
         if tmp[i]<>' ' then Result^.registers[Result^.numRegisters-1]^.int128+=tmp[i];
         inc(i);
        end;
       inc(i);//skip the remaining bracket
      end;
end;

function TProgramDebugger.DisassembleCurrentFrame():PAsmOut;
var tmp:ansistring;
    i,l:integer;
begin
     new(result);
     result^.linecount:=0;
     tmp:=gdb.Query('disassemble');
     l:=length(tmp)-1;
     i:=1;
     while (i<l)and(tmp[i]<>'$') do inc(i);//skip header
     while tmp[l]<>#10 do dec(l);//skip footer
     while i<l do
      begin
       inc(result^.linecount);
       ReAllocMem(result^.lines,result^.linecount*sizeof(pointer));
       //read addr
       new(result^.lines[result^.linecount-1]);
       result^.lines[result^.linecount-1]^.addr:='';
       while tmp[i]<>':' do
        begin
         result^.lines[result^.linecount-1]^.addr+=tmp[i];
         inc(i);
        end;
       inc(i,2);//skip : and tab char
       //while (tmp[i]=#10)or(tmp[i]=' ')do inc(i);//skip whitespaces
       //read instr
       result^.lines[result^.linecount-1]^.instr:='';
       while tmp[i]<>' ' do
        begin
         result^.lines[result^.linecount-1]^.instr+=tmp[i];
         inc(i);
        end;
       while (tmp[i]=#10)or(tmp[i]=' ')do inc(i);//skip whitespaces
       //read args
       result^.lines[result^.linecount-1]^.args:='';
       while tmp[i]<>#10 do
        begin
         result^.lines[result^.linecount-1]^.args+=tmp[i];
         inc(i);
        end;
       inc(i);//skip linefeed
      end;
end;

end.
