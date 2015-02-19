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

unit uRegistersWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  uDebugger, StdCtrls, ExtCtrls;

type

  { TRegistersWindow }

  TRegistersWindow = class(TForm)
    GeneralRegisters: TListView;
    FloatingPointRegisters: TListView;
    SSERegisters: TListView;
    MMXRegisters: TListView;
    PageController: TPageControl;
    GeneralPurposeSheet: TTabSheet;
    FloatingPointSheet: TTabSheet;
    MMXSheet: TTabSheet;
    MMXSizeSelector: TRadioGroup;
    SSESizeSelector: TRadioGroup;
    SSESheet: TTabSheet;
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure MMXSizeSelectorClick(Sender: TObject);
    procedure SSESizeSelectorClick(Sender: TObject);
  private
    OSSESize,OMMXSize:integer;
    dbg:TProgramDebugger;
    procedure SetProgramDebugger(v:TProgramDebugger);
  public
    callback:TNotifyEvent;
    procedure RefreshRegisters();
    property Debugger:TProgramDebugger read dbg write SetProgramDebugger;
  end; 

var
  RegistersWindow: TRegistersWindow;

implementation

procedure TRegistersWindow.RefreshRegisters();
var p:PRegisterList;
    pp:PFloatingRegisterList;
    ppp:PMMXRegisterList;
    pppp:PSSERegisterList;
    i:integer;
    aitem:TListItem;
begin
     if dbg<>nil then
      begin
       p:=dbg.GetRegisters();
       GeneralRegisters.Items.Clear();
       for i:=0 to p^.numregisters-1 do
        begin
         aitem:=GeneralRegisters.Items.Add();
         aitem.Caption:=p^.registers[i]^.name;
         aitem.SubItems.Add(p^.registers[i]^.hex);
         aitem.SubItems.Add(p^.registers[i]^.dec);
        end;
       ReleaseRegisterList(p);
       
       pp:=dbg.GetFloatingPointRegisters();
       FloatingPointRegisters.Items.Clear();
       for i:=0 to pp^.numregisters-1 do
        begin
         aitem:=FloatingPointRegisters.Items.Add();
         aitem.Caption:=pp^.registers[i]^.name;
         aitem.SubItems.Add(pp^.registers[i]^.flt);
         aitem.SubItems.Add(pp^.registers[i]^.raw);
        end;
       ReleaseRegisterList(pp);
       
       ppp:=dbg.GetMMXRegisters();
       MMXRegisters.Items.Clear();
       for i:=0 to ppp^.numregisters-1 do
        begin
         aitem:=MMXRegisters.Items.Add();
         aitem.Caption:=ppp^.registers[i]^.name;
         if MMXSizeSelector.ItemIndex=0 then aitem.SubItems.Add(ppp^.registers[i]^.int8) else
         if MMXSizeSelector.ItemIndex=1 then aitem.SubItems.Add(ppp^.registers[i]^.int16)else
         if MMXSizeSelector.ItemIndex=2 then aitem.SubItems.Add(ppp^.registers[i]^.int32)
                                        else aitem.SubItems.Add(ppp^.registers[i]^.int64);
        end;
       ReleaseRegisterList(ppp);

       pppp:=dbg.GetSSERegisters();
       SSERegisters.Items.Clear();
       for i:=0 to pppp^.numregisters-1 do
        begin
         aitem:=SSERegisters.Items.Add();
         aitem.Caption:=pppp^.registers[i]^.name;
         if SSESizeSelector.ItemIndex=0 then aitem.SubItems.Add(pppp^.registers[i]^.int8) else
         if SSESizeSelector.ItemIndex=1 then aitem.SubItems.Add(pppp^.registers[i]^.int16)else
         if SSESizeSelector.ItemIndex=2 then aitem.SubItems.Add(pppp^.registers[i]^.int32)else
         if SSESizeSelector.ItemIndex=3 then aitem.SubItems.Add(pppp^.registers[i]^.int64)else
         if SSESizeSelector.ItemIndex=4 then aitem.SubItems.Add(pppp^.registers[i]^.float32)else
         if SSESizeSelector.ItemIndex=5 then aitem.SubItems.Add(pppp^.registers[i]^.float64)else
                                             aitem.SubItems.Add(pppp^.registers[i]^.int128);
         
        end;
       ReleaseRegisterList(pppp);

      end;
end;

procedure TRegistersWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if callback<>nil then Callback(self);
end;

procedure TRegistersWindow.FormCreate(Sender: TObject);
begin
  OMMXSize:=0;
  OSSESize:=0;
end;

procedure TRegistersWindow.MMXSizeSelectorClick(Sender: TObject);
var i:integer;
    ppp:PMMXRegisterList;
    aitem:TListItem;
begin
     if (MMXSizeSelector.ItemIndex<>OMMXSize)and(dbg<>nil) then
      begin
       ppp:=dbg.GetMMXRegisters();
       
       MMXRegisters.Items.Clear();
       for i:=0 to ppp^.numregisters-1 do
        begin
         aitem:=MMXRegisters.Items.Add();
         aitem.Caption:=ppp^.registers[i]^.name;
         if MMXSizeSelector.ItemIndex=0 then aitem.SubItems.Add(ppp^.registers[i]^.int8) else
         if MMXSizeSelector.ItemIndex=1 then aitem.SubItems.Add(ppp^.registers[i]^.int16)else
         if MMXSizeSelector.ItemIndex=2 then aitem.SubItems.Add(ppp^.registers[i]^.int32)
                                        else aitem.SubItems.Add(ppp^.registers[i]^.int64);
        end;
       OMMXSize:=MMXSizeSelector.ItemIndex;
       ReleaseRegisterList(ppp);
      end;
end;

procedure TRegistersWindow.SSESizeSelectorClick(Sender: TObject);
var pppp:PSSERegisterList;
    i:integer;
    aitem:TListItem;
begin
     if (SSESizeSelector.ItemIndex<>OSSESize)and(dbg<>nil) then
      begin
       pppp:=dbg.GetSSERegisters();
       SSERegisters.Items.Clear();
       for i:=0 to pppp^.numregisters-1 do
        begin
         aitem:=SSERegisters.Items.Add();
         aitem.Caption:=pppp^.registers[i]^.name;
         if SSESizeSelector.ItemIndex=0 then aitem.SubItems.Add(pppp^.registers[i]^.int8) else
         if SSESizeSelector.ItemIndex=1 then aitem.SubItems.Add(pppp^.registers[i]^.int16)else
         if SSESizeSelector.ItemIndex=2 then aitem.SubItems.Add(pppp^.registers[i]^.int32)else
         if SSESizeSelector.ItemIndex=3 then aitem.SubItems.Add(pppp^.registers[i]^.int64)else
         if SSESizeSelector.ItemIndex=4 then aitem.SubItems.Add(pppp^.registers[i]^.float32)else
         if SSESizeSelector.ItemIndex=5 then aitem.SubItems.Add(pppp^.registers[i]^.float64)else
                                             aitem.SubItems.Add(pppp^.registers[i]^.int128);

        end;
       OSSESize:=SSESizeSelector.ItemIndex;
       ReleaseRegisterList(pppp);
      end;
end;

procedure TRegistersWindow.SetProgramDebugger(v:TProgramDebugger);
begin
     dbg:=v;
     RefreshRegisters();
end;

initialization
  {$I uRegistersWindow.lrs}

end.


