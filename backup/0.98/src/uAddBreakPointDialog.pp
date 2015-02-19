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

unit uAddBreakPointDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons;

type

  { TAddBreakpointDialog }

  TAddBreakpointDialog = class(TForm)
    BreakPointType: TRadioGroup;
    CancelButton: TButton;
    BreakPoint: TEdit;
    OkButton: TButton;
    Label1: TLabel;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    bt,mr:integer;
    exp:string;
    { private declarations }
  public
    function Execute():boolean;
    property BreakText:string read exp;
    property BreakType:integer read bt;
    { public declarations }
  end; 

var
  AddBreakpointDialog: TAddBreakpointDialog;

implementation

procedure TAddBreakpointDialog.OkButtonClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

procedure TAddBreakpointDialog.CancelButtonClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

function TAddBreakPointDialog.Execute():boolean;
begin
     mr:=0;
     ShowModal();
     Result:=mr=1;
     exp:=BreakPoint.Text;
     bt:=BreakPointType.ItemIndex;
end;

initialization
  {$I uAddBreakPointDialog.lrs}

end.

