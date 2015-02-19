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

unit uCompilerModeDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, uEditorOptionsController;

type

  { TCompilerModeDialog }

  TCompilerModeDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    CompilerMode: TRadioGroup;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { private declarations }
    mr:integer;
  public
    function Execute(eo:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  CompilerModeDialog: TCompilerModeDialog;

implementation

{ TCompilerModeDialog }

procedure TCompilerModeDialog.OkButtonClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

procedure TCompilerModeDialog.CancelButtonClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

function TCompilerModeDialog.Execute(eo:TEditorOptions):boolean;
begin
     mr:=0;
     CompilerMode.ItemIndex:=eo.mode;
     ShowModal();
     result:=mr=1;
     if result then
      eo.mode:=CompilerMode.ItemIndex;
end;

initialization
  {$I uCompilerModeDialog.lrs}

end.

