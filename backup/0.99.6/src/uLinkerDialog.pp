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

unit uLinkerDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Buttons, uEditorOptionsController;

type

  { TLinkerDialog }

  TLinkerDialog = class(TForm)
    CancelButton: TButton;
    OkButton: TButton;
    CallLinkerAfter: TCheckBox;
    OnlyLinkToStatic: TCheckBox;
    CheckGroup1: TCheckGroup;
    LibraryType: TRadioGroup;
    procedure CancelClick(Sender: TObject);
    procedure OkClick(Sender: TObject);
  private
    mr:integer;
    { private declarations }
  public
    function Execute(EditorOptions:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  LinkerDialog: TLinkerDialog;

implementation

{ TLinkerDialog }

procedure TLinkerDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

procedure TLinkerDialog.OkClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

function TLinkerDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     CallLinkerAfter.Checked:=EditorOptions.call_linker_after;
     OnlyLinkToStatic.Checked:=EditorOptions.only_link_to_static;
     LibraryType.ItemIndex:=EditorOptions.lib_type;
     mr:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      begin
       EditorOptions.call_linker_after:=CallLinkerAfter.Checked;
       EditorOptions.only_link_to_static:=OnlyLinkToStatic.Checked;
       EditorOptions.lib_type:=LibraryType.ItemIndex;
      end;
end;

initialization
  {$I uLinkerDialog.lrs}

end.

