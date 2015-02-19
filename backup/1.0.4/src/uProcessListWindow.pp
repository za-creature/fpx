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
  {$ifdef win32}Windows, {$endif} Classes, SysUtils, LResources, Forms,
  Controls, Graphics, Dialogs, Buttons, StdCtrls, Process, ExtCtrls, ComCtrls;

type
  TDataContainer=record
   cmdline,args,StartStamp:string;
   proc:TProcess;
   hwnd:PtrInt;
  end;
  PDataContainer=^TDataContainer;

  { TProcessListWindow }

  TProcessListWindow = class(TForm)
    FocusButton: TButton;
    KillButton: TButton;
    DoneButton: TButton;
    GenericGroup: TGroupBox;
    IdleTimer: TTimer;
    ProcessList: TListView;
    procedure DoneButtonClick(Sender: TObject);
    procedure FocusButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure IdleTimerTimer(Sender: TObject);
    procedure KillButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    mylist:TList;
    callback:TNotifyEvent;
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
       ProcessListWindow.Close();
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
     try
      {$ifdef win32}
      p:=PDataContainer(mylist.Items[ProcessList.Selected.Index])^.proc.ProcessID;
      EnumWindows(@EnumWindowsCallback,p);
      {$else}
      ShowMessage('Currently not implemented');
      {$endif}
     except
     end;
end;

procedure TProcessListWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(callback) then Callback(self);
end;

procedure TProcessListWindow.DoneButtonClick(Sender: TObject);
begin
     Close();
end;

procedure TProcessListWindow.IdleTimerTimer(Sender: TObject);
var i:integer;
    ref:boolean;
begin
     ref:=false;
     i:=0;
     while i<mylist.Count do
      begin
       if not PDataContainer(mylist.Items[i])^.proc.Running then
        begin
         //discard the object
         PDataContainer(mylist.Items[i])^.proc.Destroy();
         //release the entire structure
         dispose(PDataContainer(mylist.Items[i]));
         //remove the structure pointer from the list
         mylist.Delete(i);
         dec(i);//we've deleted an item so we gotta check the next one in the list
         ref:=true;
        end;
       inc(i);
      end;
     if ref then Refresh();
end;

procedure TProcessListWindow.KillButtonClick(Sender: TObject);
begin
     try
      //kill the process & discard the object
      PDataContainer(mylist.Items[ProcessList.Selected.Index])^.proc.Terminate(255);//code 255: killed by master
      PDataContainer(mylist.Items[ProcessList.Selected.Index])^.proc.Destroy();
      //release the entire structure
      dispose(PDataContainer(mylist.Items[ProcessList.Selected.Index]));
      //remove the structure pointer from the list
      mylist.Delete(ProcessList.Selected.Index);
      //delete the row from the process list
      ProcessList.Items.Delete(ProcessList.Selected.Index);
      {MoveColRow(false,ProcessList.Selected.Index,ProcessList.Items.Count-1);
      ProcessList.RowCount:=ProcessList.Items.Count-1;}
     except
     end;
end;

procedure TProcessListWindow.Refresh();
var aitem:TListItem;
    i:integer;
begin
     //live... liiive... LIIIIIIIVE!
     {ProcessList.RowCount:=myList.Count+1;}
     ProcessList.Items.Clear;
     for i:=0 to mylist.Count-1 do
      begin
       {ProcessList.Cells[0,i+1]:=ExtractFileName(PDataContainer(mylist.Items[i])^.cmdline);
       ProcessList.Cells[1,i+1]:=PDataContainer(mylist.Items[i])^.cmdline;
       ProcessList.Cells[2,i+1]:=PDataContainer(mylist.Items[i])^.args;
       ProcessList.Cells[3,i+1]:=PDataContainer(mylist.Items[i])^.StartStamp;}
       aitem:=ProcessList.Items.Add();
       aitem.Caption:=ExtractFileName(PDataContainer(mylist.Items[i])^.cmdline);
       aitem.SubItems.Add(PDataContainer(mylist.Items[i])^.cmdline);
       aitem.SubItems.Add(PDataContainer(mylist.Items[i])^.args);
       aitem.SubItems.Add(PDataContainer(mylist.Items[i])^.StartStamp);
      end;
end;


initialization
  {$I uProcessListWindow.lrs}

end.

