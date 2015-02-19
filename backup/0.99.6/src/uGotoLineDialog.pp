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

unit uGotoLineDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Spin, Buttons;
  
{I keycodes.inc}

type

  { TGotoLineDialog }

  TGotoLineDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    GotoLineLabel: TLabel;
    Line: TSpinEdit;
    procedure OkButtonClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    mr:integer;
    { private declarations }
  public
    function Execute(var linenumber:integer):boolean;
    { public declarations }
  end; 

var
  GotoLineDialog: TGotoLineDialog;

implementation

{ TGotoLineDialog }

procedure TGotoLineDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

procedure TGotoLineDialog.OkButtonClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

function TGotoLineDialog.Execute(var linenumber:integer):boolean;
begin
     mr:=0;
     ShowModal();
     Result:=mr=1;
     if Result then linenumber:=Line.Value;
end;

initialization
  {$I uGotoLineDialog.lrs}

end.

