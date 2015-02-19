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

unit uEditorOptionsDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, uEditorOptionsController;

type

  { TEditorOptionsDialog }

  TEditorOptionsDialog = class(TForm)
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
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    mr:integer;
    { private declarations }
  public
    function Execute(EditorOptions:TEditorOptions):boolean;
    { public declarations }
  end; 

var
  EditorOptionsDialog: TEditorOptionsDialog;

implementation

{ TEditorOptionsDialog }

procedure TEditorOptionsDialog.OkClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

procedure TEditorOptionsDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

function TEditorOptionsDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     AutoIndent.checked:=EditorOptions.auto_indent;
     TabIndent.Checked:=EditorOptions.tab_indent;
     AutoIndentOnPaste.checked:=EditorOptions.auto_indent_on_paste;
     DragAndDropEditing.Checked:=EditorOptions.drag_and_drop;
     DropFiles.checked:=EditorOptions.drop_files;
     EnhanceHomeKey.checked:=EditorOptions.enhance_home;
     NoCaret.checked:=EditorOptions.no_caret;
     SmartTabs.checked:=EditorOptions.smart_tabs;
     TabsToSpaces.checked:=EditorOptions.tabs_to_spaces;
     DoubleClickSelectsLine.checked:=EditorOptions.double_click_selects_line;
     rightMouseMovesCursor.checked:=EditorOptions.right_mouse_moves_cursor;
     ShowLineNumbers.checked:=EditorOptions.line_numbers;
     ScrollByOneLess.checked:=EditorOptions.scroll_by_one_less;
     HighlightBrackets.checked:=EditorOptions.Highlight_brackets;
     PreferInsertMode.checked:=EditorOptions.insert_mode;

     mr:=0;
     ShowModal();
     Result:=mr=0;
     //save settings
     if Result then
      with EditorOptions do
       begin
        auto_indent:=AutoIndent.Checked;
        tab_indent:=tabindent.Checked;
        auto_indent_on_paste:=autoindentonpaste.checked;
        drag_and_drop:=DragAndDropEditing.checked;
        drop_files:=DropFiles.checked;
        enhance_home:=EnhanceHomeKey.checked;
        no_caret:=nocaret.checked;
        smart_tabs:=smarttabs.checked;
        tabs_to_spaces:=tabstospaces.checked;
        double_click_selects_line:=doubleclickselectsline.checked;
        right_mouse_moves_cursor:=RightMouseMovesCursor.checked;
        line_numbers:=ShowLineNumbers.checked;
        scroll_by_one_less:=scrollbyoneless.checked;
        highlight_brackets:=highlightbrackets.checked;
        insert_mode:=preferinsertmode.checked;
       end;
end;

initialization
  {$I uEditorOptionsDialog.lrs}

end.

