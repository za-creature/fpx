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

unit uCallStackWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  uDebugger;

type

  { TCallStackWindow }

  TCallStackWindow = class(TForm)
    CallStack: TListView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    dbg:TProgramDebugger;
    procedure SetProgramDebugger(v:TProgramDebugger);
  public
    callback:TNotifyEvent;
    procedure RefreshCallStack();
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
  end;

var
  CallStackWindow: TCallStackWindow;

implementation

procedure TCallStackWindow.RefreshCallStack();
var p:PStackTrace;
    i:integer;
    aitem:TListItem;
begin
     CallStack.Items.Clear();
     if dbg<>nil then
      begin
       p:=dbg.GetStackTrace();
       for i:=0 to p^.framecount-1 do
        begin
         aitem:=CallStack.Items.Add();
         aitem.Caption:=IntToStr(p^.frames[i]^.id);
         aitem.SubItems.Add(p^.frames[i]^.address);
         aitem.SubItems.Add(p^.frames[i]^.fname);
         aitem.SubItems.Add(p^.frames[i]^.fargs);
         aitem.SubItems.Add(p^.frames[i]^.filename);
         aitem.SubItems.Add(IntToStr(p^.frames[i]^.linenumber));
        end;
       ReleaseStackTrace(p);
      end;
end;

procedure TCallStackWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then Callback(self);
end;

procedure TCallStackWindow.SetProgramDebugger(v:TProgramDebugger);
begin
     dbg:=v;
     RefreshCallStack();
end;


initialization
  {$I uCallStackWindow.lrs}

end.


