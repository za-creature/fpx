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

unit uPrimaryFileDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  EditBtn, ComCtrls, StdCtrls, Buttons, uEditorOptionsController;

type

  { TPrimaryFileDialog }

  TPrimaryFileDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    PrimaryFileLabel: TLabel;
    FileList: TListBox;
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    mr:integer;
    { private declarations }
  public
    function Execute(PageController:TNoteBook;EditorOptions:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  PrimaryFileDialog: TPrimaryFileDialog;

implementation

{ TPrimaryFileDialog }

procedure TPrimaryFileDialog.OkClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

procedure TPrimaryFileDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

function TPrimaryFileDialog.Execute(PageController:TNoteBook;EditorOptions:TEditorOptions):boolean;
var i:integer;
begin
     //load settings
     FileList.Clear();
     for i:=0 to PageController.Pages.Count-1 do
      FileList.Items.Add(PageController.Pages.Strings[i]);
     FileList.ItemIndex:=EditorOptions.primary_file;
     OkButton.Enabled:=FileList.Items.Count<>0;
     mr:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      EditorOptions.primary_file:=FileList.ItemIndex;
end;

initialization
  {$I uPrimaryFileDialog.lrs}

end.

