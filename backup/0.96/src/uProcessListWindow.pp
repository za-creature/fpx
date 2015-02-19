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

unit uProcessListWindow;

{$mode objfpc}{$H+}

interface

uses
  {$ifdef win32}Windows, {$endif}Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  StdCtrls, Grids, Process, ExtCtrls;

type
  TDataContainer=record
   cmdline,args,StartStamp:string;
   proc:TProcess;
   {$ifdef win32}hwnd:hwnd;{$endif}
  end;
  PDataContainer=^TDataContainer;

  { TProcessListWindow }

  TProcessListWindow = class(TForm)
    FocusButton: TButton;
    KillButton: TButton;
    DoneButton: TButton;
    GenericGroup: TGroupBox;
    ProcessList: TStringGrid;
    IdleTimer: TTimer;
    procedure DoneButtonClick(Sender: TObject);
    procedure FocusButtonClick(Sender: TObject);
    procedure IdleTimerTimer(Sender: TObject);
    procedure KillButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    mylist:TList;
    procedure Refresh();
  end;

var
  ProcessListWindow: TProcessListWindow;

implementation

{$ifdef win32}
function EnumWindowsCallback(hwnd:hwnd;lparam:lparam):longbool;stdcall;
var pid:integer;
begin
     GetWindowThreadProcessId(hwnd,@pid);
     if pid=lparam then
      begin
       BringWindowToTop(hwnd);
       SetForegroundWindow(hwnd);
       result:=false;
      end          else result:=true;
end;
{$endif}

{ TProcessListWindow }

procedure TProcessListWindow.FocusButtonClick(Sender: TObject);
var p:integer;
begin
     if(ProcessList.Row>0)and(ProcessList.Row<ProcessList.RowCount) then
      begin
       {$ifdef win32}
       p:=PDataContainer(mylist.Items[ProcessList.Row-1])^.proc.ProcessID;
       EnumWindows(@EnumWindowsCallback,p);
       {$else}
       ShowMessage('Currently not implemented');
       {$endif}
      end;
end;

procedure TProcessListWindow.DoneButtonClick(Sender: TObject);
begin
     Close();
end;

procedure TProcessListWindow.IdleTimerTimer(Sender: TObject);
var i:integer;
begin
     i:=0;
     while i<mylist.Count do
      begin
       if not PDataContainer(mylist.Items[i])^.proc.Running then
        begin
         //discard the object
         PDataContainer(mylist.Items[ProcessList.Row-1])^.proc.Destroy();
         //release the entire structure
         dispose(PDataContainer(mylist.Items[ProcessList.Row-1]));
         //remove the structure pointer from the list
         mylist.Delete(i);
         
         //delete the row from the process list
         ProcessList.MoveColRow(false,i+1,ProcessList.RowCount-1);
         ProcessList.RowCount:=ProcessList.RowCount-1;
         dec(i);//we've deleted an item so we gotta check the next one in the list
        end;
       inc(i);
      end;
end;

procedure TProcessListWindow.KillButtonClick(Sender: TObject);
begin
     if (ProcessList.Row>0)and(ProcessList.Row<ProcessList.RowCount) then
      begin
       //kill the process & discard the object
       PDataContainer(mylist.Items[ProcessList.Row-1])^.proc.Terminate(255);//code 255: killed by master
       PDataContainer(mylist.Items[ProcessList.Row-1])^.proc.Destroy();
       //release the entire structure
       dispose(PDataContainer(mylist.Items[ProcessList.Row-1]));
       //remove the structure pointer from the list
       mylist.Delete(ProcessList.Row-1);

       //delete the row from the process list
       ProcessList.MoveColRow(false,ProcessList.Row,ProcessList.RowCount-1);
       ProcessList.RowCount:=ProcessList.RowCount-1;
      end;
end;

procedure TProcessListWindow.Refresh();
var i:integer;
begin
     //live... liiive... LIIIIIIIVE!
     ProcessList.RowCount:=myList.Count+1;
     for i:=0 to mylist.Count-1 do
      begin
       ProcessList.Cells[0,i+1]:=ExtractFileName(PDataContainer(mylist.Items[i])^.cmdline);
       ProcessList.Cells[1,i+1]:=PDataContainer(mylist.Items[i])^.cmdline;
       ProcessList.Cells[2,i+1]:=PDataContainer(mylist.Items[i])^.args;
       ProcessList.Cells[3,i+1]:=PDataContainer(mylist.Items[i])^.StartStamp;
      end;
end;


initialization
  {$I uProcessListWindow.lrs}

end.

