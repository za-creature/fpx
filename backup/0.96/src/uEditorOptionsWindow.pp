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

unit uEditorOptionsWindow; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TEditorOptionsWindow }

  TEditorOptionsWindow = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    AutoIndent: TCheckBox;
    DoubleClickSelectsLine: TCheckBox;
    RightMouseMovesCursor: TCheckBox;
    ShowLineNumbers: TCheckBox;
    ScrollByOneLess: TCheckBox;
    HighlightBrackets: TCheckBox;
    PreferInsertMode: TCheckBox;
    TabIndent: TCheckBox;
    AutoIndentOnPaste: TCheckBox;
    DragAndDropEditing: TCheckBox;
    DropFiles: TCheckBox;
    EnhanceHomeKey: TCheckBox;
    NoCaret: TCheckBox;
    SmartTabs: TCheckBox;
    TabsToSpaces: TCheckBox;
    EditingGroup: TCheckGroup;
    MiscelaneousGroup: TCheckGroup;
    IndentingOptionsGroup: TGroupBox;
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
  EditorOptionsWindow: TEditorOptionsWindow;

implementation

{ TEditorOptionsWindow }

procedure TEditorOptionsWindow.OkClick(Sender: TObject);
begin
  callback(true);
  visible:=false;
end;

procedure TEditorOptionsWindow.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
    canclose:=false;
  CancelClick(sender);
end;

procedure TEditorOptionsWindow.CancelClick(Sender: TObject);
begin
  callback(false);
  visible:=false;
end;

initialization
  {$I uEditorOptionsWindow.lrs}

end.

