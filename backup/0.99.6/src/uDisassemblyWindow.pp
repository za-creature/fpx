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

unit uDisassemblyWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  uDebugger;

type

  { TDisassemblyWindow }

  TDisassemblyWindow = class(TForm)
    AsmSource: TListView;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
  private
    dbg:TProgramDebugger;
    procedure SetProgramDebugger(v:TProgramDebugger);
    { private declarations }
  public
    callback:TNotifyEvent;
    procedure RefreshDisassemblyWindow();
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
    { public declarations }
  end; 

var
  DisassemblyWindow: TDisassemblyWindow;

implementation

{ TDisassemblyWindow }

procedure TDisassemblyWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then callback(self);
end;

procedure TDisassemblyWindow.RefreshDisassemblyWindow();
var p:PAsmOut;
    aitem:TListItem;
    i:integer;
begin
     if dbg<>nil then
      begin
       p:=dbg.DisassembleCurrentFrame();
       asmSource.Items.Clear();
       for i:=0 to p^.linecount-1 do
        begin
         aitem:=asmSource.Items.Add();
         aitem.Caption:=p^.lines[i]^.addr;
         aitem.SubItems.Add(p^.lines[i]^.instr);
         aitem.SubItems.Add(p^.lines[i]^.args);
        end;
       ReleaseAssemblerSource(p);
      end;
end;

procedure TDisassemblyWindow.SetProgramDebugger(v:TProgramDebugger);
begin
     dbg:=v;
     RefreshDisassemblyWindow();
end;

initialization
  {$I uDisassemblyWindow.lrs}

end.

