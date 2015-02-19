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

unit uDebugOptionsDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  Buttons, uEditorOptionsController;

type

  { TDebugOptionsDialog }

  TDebugOptionsDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    DebugInformation: TRadioGroup;
    ProfilingSwitches: TRadioGroup;
    procedure CancelButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { private declarations }
    mr:integer;
  public
    { public declarations }
    function Execute(eo:TEditorOptions):boolean;
  end; 

var
  DebugOptionsDialog: TDebugOptionsDialog;

implementation

{ TDebugOptionsDialog }

procedure TDebugOptionsDialog.CancelButtonClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

procedure TDebugOptionsDialog.OkButtonClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

function TDebugOptionsDialog.Execute(eo:TEditorOptions):boolean;
begin
  //load settings
  DebugInformation.ItemIndex:=eo.debuginfo;
  ProfilingSwitches.ItemIndex:=eo.profileinfo;
  mr:=0;
  ShowModal();
  result:=mr=1;
  //save settings
  if result then
   begin
    eo.debuginfo:=DebugInformation.ItemIndex;
    eo.profileinfo:=ProfilingSwitches.ItemIndex;
   end;
end;

initialization
  {$I uDebugOptionsDialog.lrs}

end.

