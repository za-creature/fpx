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

unit uFindDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons, uEditorOptionsController, SynEdit, SynEditTypes, LCLType;
  
type

  { TFindDialog }

  TFindDialog = class(TForm)
    FindReplaceButton: TButton;
    CancelButton: TButton;
    ReplaceAllButton: TButton;
    CaseSensitive: TCheckBox;
    WholeWordsOnly: TCheckBox;
    PromptOnReplace: TCheckBox;
    RegularExp: TCheckBox;
    MultiLine: TCheckBox;
    CheckGroup1: TCheckGroup;
    TextInput: TEdit;
    ReplaceInput: TEdit;
    TextToFindLabel: TLabel;
    ReplaceWithLabel: TLabel;
    Direction: TRadioGroup;
    Scope: TRadioGroup;
    Origin: TRadioGroup;
    procedure FindReplaceClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ReplaceAllClick(Sender: TObject);
    procedure TextInputKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { private declarations }
    mr:integer;
  public
    function Execute(EditorOptions:TEditorOptions):boolean;
  end;

var
  FindDialog: TFindDialog;

implementation

{ TFindDialog }

procedure TFindDialog.FindReplaceClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

procedure TFindDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

procedure TFindDialog.ReplaceAllClick(Sender: TObject);
begin
     mr:=2;
     Close();
end;

procedure TFindDialog.TextInputKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then FindReplaceClick(Sender);
  if key=VK_ESCAPE then Close();
end;

function TFindDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     mr:=0;
     ShowModal();
     Result:=mr<>0;
     if Result then
      begin
       EditorOptions.op:=[];
       if mr=2 then EditorOptions.op+=[ssoReplaceAll] else
       if FindReplaceButton.caption='Replace' then EditorOptions.op+=[ssoReplace];

       if CaseSensitive.checked then EditorOptions.op+=[ssoMatchCase];
       if WholeWordsOnly.checked then EditorOptions.op+=[ssoWholeWord];
       if PromptOnReplace.checked then EditorOptions.op+=[ssoPrompt];
       if RegularExp.checked then EditorOptions.op+=[ssoRegExpr];
       if Direction.itemIndex=1 then EditorOptions.op+=[ssoBackwards];
       if Scope.itemIndex=1 then EditorOptions.op+=[ssoSelectedOnly];
       if Origin.itemIndex=1 then EditorOptions.op+=[ssoEntireScope];
      end;
end;

initialization
  {$I uFindDialog.lrs}

end.

