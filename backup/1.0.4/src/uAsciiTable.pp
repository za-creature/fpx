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

unit uAsciiTable;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons;

type

  { TASCIITable }

  TASCIITable = class(TForm)
    ASCII: TImage;
    ExitButton: TButton;
    InsertButton: TButton;
    CharLabel: TLabel;
    DecimalLabel: TLabel;
    HexLabel: TLabel;
    Preview: TImage;
    procedure ASCIIMouseDown(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure ExitButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure InsertButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    callback:procedure(c:byte) of object;
    closeCallback:TNotifyEvent;
    lci:byte;
    { public declarations }
  end; 

var
  ASCIITable: TASCIITable;

implementation

{ TASCIITable }



procedure TASCIITable.ExitButtonClick(Sender: TObject);
begin
  visible:=false;
end;

procedure TASCIITable.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  if Assigned(CloseCallback) then CloseCallback(self);
end;

procedure TASCIITable.ASCIIMouseDown(Sender: TOBject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var cx,cy:integer;
    i,j:integer;
begin
     cx:=x-x mod 8;
     cy:=y-y mod 12;

     {$IFDEF WIN32}
     for i:=0 to 7 do
      for j:=0 to 11 do
       Preview.Canvas.Pixels[i,j]:=ASCII.Canvas.Pixels[cx+i,cy+j];
     {$ELSE}
     Preview.Canvas.Brush.Color:=clWhite;
     Preview.Canvas.FillRect(0,0,8,12);
     Preview.Canvas.Pixels[1,1]:=clBlack;
     {$ENDIF}
     Preview.Refresh;

     i:=(cy div 12)*32+(cx shr 3);
     lci:=i;
     DecimalLabel.Caption:='Decimal: '+IntToStr(i);
     HexLabel.Caption:='Hex: $'+IntToHex(i,2);
     
     DecimalLabel.width:=70;
     HexLabel.width:=70;
     
     DecimalLabel.Refresh;
     HexLabel.Refresh;
end;


procedure TASCIITable.InsertButtonClick(Sender: TObject);
begin
     callback(lci);
end;

initialization
  {$I uAsciiTable.lrs}

end.

