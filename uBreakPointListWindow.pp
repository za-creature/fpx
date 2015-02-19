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
  ComCtrls, uAddBreakPointDialog, uDebugger, Synedit;
  
{$i structures.inc}

type

  TBreakpointSynEditMark = class(TSynEditMark)
  protected
    procedure SetLine(const Value: Integer);override;
  public
    onLineChange:TNotifyEvent;
  end;

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
  protected
    _debugging:boolean;
    dbg:TProgramDebugger;
    procedure SetProgramDebugger(v:TProgramDebugger);
    procedure SetDebugging(v:boolean);
    procedure StartDebug();
    procedure StopDebug();
  public
    callback:TNotifyEvent;
    l:TList;
    GetCurrentEditor:function():TCustomEditor of object;
    CurrentEditorId:Integer;
    GetEditor:TGetEditorCallback;
    procedure RefreshBreakpointList();
    procedure RefreshInternalBreakpointList();
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
    property Debugging:boolean read _debugging write setDebugging;
    procedure PostRefresh(Sender:TObject);
  end;

var
  BreakPointListWindow: TBreakPointListWindow;

implementation

procedure TBreakpointSynEditMark.SetLine(const Value:integer);
begin
     fLine:=Value;
     if Assigned(onLineChange) then onLineChange(self);
end;

{ TBreakPointListWindow }

procedure TBreakPointListWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then callback(self);
end;

procedure TBreakPointListWindow.AddButtonClick(Sender: TObject);
var i:integer;
    p:TBreakpointSynEditMark;
begin
     if AddBreakPointDialog.Execute(GetEditor,l.Count,CurrentEditorID) then
      begin
       with GetEditor(AddBreakPointDialog.Filename) do
        begin
         for i:=0 to Marks.Count-1 do
          if (Marks[i].Line=AddBreakPointDialog.Line)and(Marks[i] is TBreakpointSynEditMark) then exit;//exists; fuck off
         p:=TBreakpointSynEditMark.Create(GetEditor(AddBreakPointDialog.Filename));
         p.Line:=AddBreakPointDialog.Line;
         p.onLineChange:=@PostRefresh;
         Marks.Add(p);
        end;
       RefreshBreakpointList();
      end;
end;

procedure TBreakPointListWindow.RefreshBreakPointList();
var aitem:TListItem;
var i,j:integer;
begin
     BreakpointList.Items.Clear();
     for i:=0 to l.Count-1 do
      for j:=0 to GetEditor(i).Marks.Count-1 do
       if GetEditor(i).Marks[j] is TBreakpointSynEditMark then
        begin
         aitem:=BreakpointList.Items.Add();
         aitem.Caption:=GetEditor(i).tname;
         aitem.SubItems.Add(IntToStr(GetEditor(i).Marks[j].Line));
        end;
     if Debugging then RefreshInternalBreakpointList();
     try
      GetCurrentEditor().Repaint();
     except
     end;
end;

procedure TBreakPointListWindow.ClearButtonClick(Sender: TObject);
var i,j:integer;
begin
     for i:=0 to l.Count-1 do
      with GetEditor(i) do
       begin
        for j:=0 to Marks.Count-1 do
         if Marks[j] is TBreakpointSynEditMark then
          begin
           Marks[j].Destroy();
           Marks.Delete(j);
          end;
       end;
     RefreshBreakpointList();
end;

procedure TBreakPointListWindow.DeleteButtonClick(Sender: TObject);
var i,j,id:integer;
begin
     id:=0;
     for i:=0 to l.Count-1 do
      with GetEditor(i) do
       begin
        j:=0;
        while j<Marks.Count do
         begin
          if Marks[j] is TBreakpointSynEditMark then //we only care about breakpoints
           begin
            if BreakpointList.Items[id].Selected then
             begin
              Marks[j].Destroy();
              Marks.Delete(j);
              BreakpointList.Items.Delete(id);
              dec(id);
              dec(j);
             end;
            inc(id);
           end;
          inc(j);
         end;
       end;
     RefreshBreakpointList();
end;

procedure TBreakPointListWindow.SetProgramDebugger(v:TProgramDebugger);
begin
     dbg:=v;
end;

procedure TBreakPointListWindow.SetDebugging(v:boolean);
begin
     if not _debugging and v then StartDebug();
     if _debugging and not v then StopDebug();
     _debugging:=v;
end;

procedure TBreakPointListWindow.StopDebug();
begin
end;

procedure TBreakpointListWindow.RefreshInternalBreakpointList();
var i,j:integer;
begin
     if dbg<>nil then
      begin
       dbg.ClearBreakpointList();
       for i:=0 to l.Count-1 do
        for j:=0 to GetEditor(i).Marks.Count-1 do
         if GetEditor(i).Marks[j] is TBreakpointSynEditMark then
          dbg.AddBreakpoint(GetEditor(i).activefilename,GetEditor(i).Marks[j].Line);
      end;
end;

procedure TBreakPointListWindow.StartDebug();
begin
     RefreshInternalBreakpointList();
end;

procedure TBreakPointListWindow.PostRefresh(Sender:TObject);
begin
     RefreshBreakpointList();
end;

initialization
  {$I uBreakPointListWindow.lrs}

end.

