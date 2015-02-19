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

unit uDirectoriesWindow; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, EditBtn,
  Buttons, StdCtrls;

type

  { TDirectoriesWindow }

  TDirectoriesWindow = class(TForm)
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { private declarations }
  public
    callback:procedure(swc:boolean) of object;
    { public declarations }
  end; 

var
  DirectoriesWindow: TDirectoriesWindow;

implementation

{ TDirectoriesWindow }

procedure TDirectoriesWindow.OkClick(Sender: TObject);
begin
  callback(true);
  visible:=false;
end;

procedure TDirectoriesWindow.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
    canclose:=false;
  CancelClick(sender);
end;

procedure TDirectoriesWindow.CancelClick(Sender: TObject);
begin
  callback(false);
  visible:=false;
end;

initialization
  {$I uDirectoriesWindow.lrs}

end.

