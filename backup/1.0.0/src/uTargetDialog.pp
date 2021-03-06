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

unit uTargetDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, uEditorOptionsController;

type

  { TTargetDialog }

  TTargetDialog = class(TForm)
    CancelButton: TButton;
    OkButton: TButton;
    Target: TRadioGroup;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    mr:integer;
    { private declarations }
  public
    function Execute(EditorOptions:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  TargetDialog: TTargetDialog;

implementation

{ TTargetDialog }

procedure TTargetDialog.OkButtonClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

procedure TTargetDialog.CancelButtonClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

function TTargetDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     Target.ItemIndex:=EditorOptions.target;
     
     mr:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      begin

      end;
end;

initialization
  {$I uTargetDialog.lrs}

end.

