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

unit uWatchListWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs,
  Buttons, ComCtrls, uAddWatchDialog, uDebugger;

type

  { TWatchListWindow }

  TWatchListWindow = class(TForm)
    AddWatchButton: TButton;
    ClearWatchListButton: TButton;
    DeleteWatchButton: TButton;
    WatchList: TListView;
    procedure AddWatchButtonClick(Sender: TObject);
    procedure ClearWatchListButtonClick(Sender: TObject);
    procedure DeleteWatchButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    //procedure AddWatch(wname:string);
    //procedure DeleteWatch(id:integer);
    procedure SetProgramDebugger(v:TProgramDebugger);
    function GetExpressionValue(expression:ansistring):ansistring;
    procedure AddWatch(expression:ansistring);
  private
    { private declarations }
    dbg:TProgramDebugger;
  public
    { public declarations }
    callback:TNotifyEvent;
    procedure RefreshWatchList();
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
  end;

var
  WatchListWindow: TWatchListWindow;

implementation

{ TWatchListWindow }

function TWatchListWindow.GetExpressionValue(expression:ansistring):ansistring;
begin
     if dbg<>nil then result:=dbg.GetExpressionValue(expression)
                 else result:='Program not running';
end;

procedure TWatchListWindow.SetProgramDebugger(v:TProgramDebugger);
begin
     dbg:=v;
     RefreshWatchList();
end;

procedure TWatchListWindow.AddWatchButtonClick(Sender: TObject);
begin
  if AddWatchDialog.Execute() then
   AddWatch(AddWatchDialog.Expression);
end;

procedure TWatchListWindow.ClearWatchListButtonClick(Sender: TObject);
begin
     WatchList.Items.Clear();
end;

procedure TWatchListWindow.AddWatch(expression:ansistring);
var aitem:TListItem;
begin
    aitem:=WatchList.Items.Add();
    aitem.Caption:=expression;
    aitem.SubItems.Add(GetExpressionValue(expression));
end;

procedure TWatchListWindow.DeleteWatchButtonClick(Sender: TObject);
var i:integer;
begin
  i:=0;
  while i<WatchList.Items.Count do
   begin
    if Watchlist.Items.Item[i].Selected then
     begin
      Watchlist.Items.Delete(i);
      dec(i);
     end;
    inc(i);
   end;
end;

procedure TWatchListWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then Callback(self);
end;

procedure TWatchListWindow.RefreshWatchList();
var i:integer;
begin
     for i:=0 to WatchList.Items.Count-1 do
      WatchList.Items.Item[i].SubItems.Strings[0]:=GetExpressionValue(WatchList.Items.Item[i].Caption);
end;

initialization
  {$I uwatchlistwindow.lrs}

end.

