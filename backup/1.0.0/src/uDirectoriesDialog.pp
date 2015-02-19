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

unit uDirectoriesDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, EditBtn,
  Buttons, StdCtrls, uEditorOptionsController;

type

  { TDirectoriesDialog }

  TDirectoriesDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    PathToCompiler: TDirectoryEdit;
    UnitOutputDirectory: TDirectoryEdit;
    ExeOutputDirectory: TDirectoryEdit;
    ObjectDirectories: TDirectoryEdit;
    LibraryDirectories: TDirectoryEdit;
    IncludeDirectories: TDirectoryEdit;
    UnitDirectories: TDirectoryEdit;
    PTBDLabel: TLabel;
    UODLabel: TLabel;
    EODLabel: TLabel;
    ODLabel: TLabel;
    LDLabel: TLabel;
    IDLabel: TLabel;
    UDLabel: TLabel;
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { private declarations }
    mr:integer;
  public
    function Execute(EditorOptions:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  DirectoriesDialog: TDirectoriesDialog;

implementation

{ TDirectoriesDialog }

procedure TDirectoriesDialog.OkClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

procedure TDirectoriesDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

function TDirectoriesDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     PathToCompiler.Text:=EditorOptions.bin_directory;
     UnitOutputDirectory.Text:=EditorOptions.unit_output_dir;
     ExeOutputDirectory.Text:=EditorOptions.exe_output_dir;
     ObjectDirectories.Text:=EditorOptions.object_dir;
     LibraryDirectories.Text:=EditorOptions.library_dir;
     IncludeDirectories.Text:=EditorOptions.include_dir;
     UnitDirectories.Text:=EditorOptions.unit_dir;

     mr:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      begin
       EditorOptions.bin_directory:=PathToCompiler.Text;
       EditorOptions.unit_output_dir:=UnitOutputDirectory.Text;
       EditorOptions.exe_output_dir:=ExeOutputDirectory.Text;
       EditorOptions.object_dir:=ObjectDirectories.Text;
       EditorOptions.library_dir:=LibraryDirectories.Text;
       EditorOptions.include_dir:=IncludeDirectories.Text;
       EditorOptions.unit_dir:=UnitDirectories.Text;
      end;
end;

initialization
  {$I uDirectoriesDialog.lrs}

end.

