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

unit uEditorStyleDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, SynEdit,
  SynHighlighterPas, StdCtrls, Buttons, ExtCtrls, Spin,
  uEditorOptionsController;

type
  { TEditorStyleDialog }

  TEditorStyleDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    FontStyleBold: TCheckBox;
    FontStyleItalic: TCheckBox;
    FontStyleUnderline: TCheckBox;
    FontStyleGroup: TCheckGroup;
    FontColorDialog: TColorDialog;
    SyntaxHighlightLabel: TLabel;
    InteractivePreviewLabel: TLabel;
    Foreground: TLabel;
    Background: TLabel;
    FontSizeLabel: TLabel;
    FGColorLabel: TLabel;
    BGColorLabel: TLabel;
    SyntaxTypeSelector: TListBox;
    FontFaceRadioGroup: TRadioGroup;
    FontSize: TSpinEdit;
    Preview: TSynEdit;
    Highlighter: TSynPasSyn;
    procedure FGColorClick(Sender: TObject);
    procedure BGColorClick(Sender: TObject);
    procedure FontSizeChange(Sender: TObject);
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure Boldchange(Sender: TObject);
    procedure ItalicChange(Sender: TObject);
    procedure UnderlineChange(Sender: TObject);
    procedure FontFaceChange(Sender: TObject);
    procedure SyntaxTypeChange(Sender: TObject; User: boolean);
    procedure SpinEdit1Change(Sender: TObject);
  private
    { private declarations }
  public
    function execute(EditorOptions:TEditorOptions):boolean;
    a:TSynArray;
    mr,p:integer;
    { public declarations }
  end; 

procedure SetHighlighterOptions(t:TSynPasSyn;a:Tsynarray);

var
  EditorStyleDialog: TEditorStyleDialog;

implementation

{ TEditorStyleDialog }

procedure SetHighlighterOptions(t:TSynPasSyn;a:Tsynarray);
begin
 t.AsmAttri.Background:=a[0].bg;
 t.AsmAttri.Foreground:=a[0].fg;
 t.AsmAttri.Style:=a[0].style;
 
 t.CommentAttri.Background:=a[1].bg;
 t.CommentAttri.Foreground:=a[1].fg;
 t.CommentAttri.Style:=a[1].Style;
 
 t.DirectiveAttri.Background:=a[2].bg;
 t.DirectiveAttri.Foreground:=a[2].fg;
 t.DirectiveAttri.Style:=a[2].style;
 
 t.IdentifierAttri.Background:=a[3].bg;
 t.IdentifierAttri.Foreground:=a[3].fg;
 t.IdentifierAttri.Style:=a[3].style;
 
 t.KeyAttri.Background:=a[4].bg;
 t.KeyAttri.Foreground:=a[4].fg;
 t.KeyAttri.Style:=a[4].style;
 
 t.NumberAttri.Background:=a[5].bg;
 t.NumberAttri.Foreground:=a[5].fg;
 t.NumberAttri.Style:=a[5].style;
 
 t.SpaceAttri.Background:=a[6].bg;
 t.SpaceAttri.Foreground:=a[6].fg;
 t.SpaceAttri.Style:=a[6].style;
 
 t.StringAttri.Background:=a[7].bg;
 t.StringAttri.Foreground:=a[7].fg;
 t.StringAttri.Style:=a[7].style;
 
 t.SymbolAttri.Background:=a[8].bg;
 t.SymbolAttri.Foreground:=a[8].fg;
 t.SymbolAttri.Style:=a[8].style;
end;

procedure TEditorStyleDialog.FontFaceChange(Sender: TObject);
begin
  Preview.Font.Name:=FontFaceRadioGroup.Items.Strings[FontFaceRadioGroup.ItemIndex];
  Preview.Refresh;
end;

procedure TEditorStyleDialog.SyntaxTypeChange(Sender: TObject; User: boolean);
begin
  p:=SyntaxTypeSelector.ItemIndex;
  Foreground.color:=a[p].fg;
  Background.color:=a[p].bg;
  FontStyleBold.checked:=fsBold in a[p].Style;
  FontStyleItalic.checked:=fsItalic in a[p].Style;
  FontStyleUnderline.checked:=fsUnderline in a[p].Style;
end;

procedure TEditorStyleDialog.OkClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

procedure TEditorStyleDialog.FGColorClick(Sender: TObject);
begin
  FontColorDialog.Color:=Foreground.Color;
  FontColorDialog.Title:='Please Select a Foreground Color';
  FontColorDialog.Execute();
  Foreground.Color:=FontColorDialog.color;
  a[p].fg:=FontColorDialog.color;
  SetHighlighterOptions(Highlighter,a);
  Preview.refresh;
end;

procedure TEditorStyleDialog.BGColorClick(Sender: TObject);
begin
  FontColorDialog.Color:=Background.Color;
  FontColorDialog.Title:='Please Select a Background Color';
  FontColorDialog.Execute();
  Background.Color:=FontColorDialog.color;
  a[p].bg:=FontColorDialog.color;
  SetHighlighterOptions(Highlighter,a);
  Preview.refresh;
end;

procedure TEditorStyleDialog.FontSizeChange(Sender: TObject);
begin
  Preview.Font.Size:=FontSize.Value;
end;

procedure TEditorStyleDialog.CancelClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

procedure TEditorStyleDialog.Boldchange(Sender: TObject);
begin
  if FontStyleBold.checked then a[p].style+=[fsBold]
                           else a[p].style-=[fsBold];
  SetHighlighterOptions(Highlighter,a);
  Preview.Refresh;
end;

procedure TEditorStyleDialog.ItalicChange(Sender: TObject);
begin
  if FontStyleItalic.checked then a[p].style+=[fsItalic]
                             else a[p].style-=[fsItalic];
  SetHighlighterOptions(Highlighter,a);
  Preview.Refresh;
end;

procedure TEditorStyleDialog.UnderlineChange(Sender: TObject);
begin
  if FontStyleUnderline.checked then a[p].style+=[fsUnderline]
                                else a[p].style-=[fsUnderline];
  SetHighlighterOptions(Highlighter,a);
  Preview.Refresh;
end;

procedure TEditorStyleDialog.SpinEdit1Change(Sender: TObject);
begin
  Preview.Font.Size:=FontSize.Value;
  Preview.Refresh;
end;

function TEditorStyleDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     a:=EditorOptions.syntax_highlight;
     FontSize.Value:=EditorOptions.font_size;
     

     mr:=0;
     SyntaxTypeSelector.ItemIndex:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      begin
       EditorOptions.syntax_highlight:=a;
       EditorOptions.font_name:=Preview.Font.Name;
       EditorOptions.font_size:=FontSize.Value;
       EditorOptions.UpdateHighlighter();
      end;
end;

initialization
  {$I uEditorStyleDialog.lrs}

end.
