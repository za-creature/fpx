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

unit uBreakPointListWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ComCtrls, uAddBreakPointDialog, uDebugger;

type

  { TBreakPointListWindow }

  TBreakPointListWindow = class(TForm)
    AddButton: TButton;
    DeleteButton: TButton;
    ClearButton: TButton;
    BreakPointList: TListView;
    procedure AddButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    dbg:TProgramDebugger;
    procedure SetProgramDebugger(v:TProgramDebugger);
  public
    callback:TNotifyEvent;
    procedure AddBreakPoint(expression:ansistring;isline:boolean);
    function GetBreakPointId(exp:ansistring):integer;
    procedure DeleteBreakPoint(id:integer);
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
  end;

var
  BreakPointListWindow: TBreakPointListWindow;

implementation

{ TBreakPointListWindow }

procedure TBreakPointListWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then callback(self);
end;

procedure TBreakPointListWindow.AddButtonClick(Sender: TObject);
begin
     if AddBreakPointDialog.Execute() then AddBreakPoint(AddBreakPointDialog.BreakText,AddBreakPointDialog.BreakType=0);
end;

procedure TBreakPointListWindow.AddBreakPoint(expression:ansistring;isline:boolean);
const s:array[boolean] of string=('Function','Line');
var aitem:TListItem;
begin
    aitem:=BreakPointList.Items.Add();
    aitem.Caption:=s[isline];
    aitem.SubItems.Add(expression);
    if dbg<>nil then dbg.AddBreakPoint(expression);
end;

procedure TBreakPointListWindow.ClearButtonClick(Sender: TObject);
begin
    BreakPointList.Clear;
end;

procedure TBreakPointListWindow.DeleteButtonClick(Sender: TObject);
var i:integer;
begin
  i:=0;
  while i<BreakPointList.Items.Count do
   begin
    if BreakPointList.Items.Item[i].Selected then
     begin
      DeleteBreakPoint(i);
      dec(i);
     end;
    inc(i);
   end;
end;

function TBreakPointListWindow.GetBreakPointId(exp:ansistring):integer;
var i:integer;
begin
     for i:=0 to BreakPointList.Items.Count-1 do
      if BreakPointList.Items[i].SubItems.Strings[0]=exp then exit(i);
     result:=-1;
end;

procedure TBreakPointListWindow.DeleteBreakPoint(id:integer);
begin
     if dbg<>nil then dbg.RemoveBreakPoint(BreakPointList.Items[id].SubItems.Strings[0]);
     BreakPointList.Items.Delete(id);
end;

procedure TBreakPointListWindow.SetProgramDebugger(v:TProgramDebugger);
var i:integer;
begin
     dbg:=v;
     if dbg<>nil then
      for i:=0 to BreakPointList.Items.Count-1 do
       dbg.AddBreakPoint(BreakPointList.Items[i].SubItems.Strings[0]);
end;


initialization
  {$I uBreakPointListWindow.lrs}

end.

