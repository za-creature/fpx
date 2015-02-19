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

unit uCompilerOptionsDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons, uEditorOptionsController;

type

  { TCompilerOptionsDialog }

  TCompilerOptionsDialog = class(TForm)
    AssemblerInfo: TCheckGroup;
    All: TCheckBox;
    StopAfterFirstError: TCheckBox;
    ObjectPascal: TCheckBox;
    COperators: TCheckBox;
    AllowLabel: TCheckBox;
    CInline: TCheckBox;
    GlobalCMacros: TCheckBox;
    TPCompatible: TCheckBox;
    DelphiCompatible: TCheckBox;
    StaticInObjects: TCheckBox;
    SyntaxSwitches: TGroupBox;
    L2Optimizations: TCheckBox;
    L1Optimizations: TCheckBox;
    UncertainOptimizations: TCheckBox;
    RegisterVariables: TCheckBox;
    Optimizations: TGroupBox;
    GenerateFasterCode: TRadioButton;
    GenerateSmallerCode: TRadioButton;
    TargetProcessor: TRadioGroup;
    RangeChecking: TCheckBox;
    StackChecking: TCheckBox;
    IOChecking: TCheckBox;
    OverflowChecking: TCheckBox;
    RuntimeChecks: TCheckGroup;
    ShowAllProc: TCheckBox;
    UTInfo: TCheckBox;
    GeneralInfo: TCheckBox;
    Hints: TCheckBox;
    Notes: TCheckBox;
    Warnings: TCheckBox;
    Verbose: TCheckGroup;
    ListSource: TCheckBox;
    ListRegisters: TCheckBox;
    ListTemp: TCheckBox;
    OkButton: TButton;
    CancelButton: TButton;
    PageController: TPageControl;
    AssemblerOutput: TRadioGroup;
    AssemblerReader: TRadioGroup;
    Browser: TRadioGroup;
    SyntaxSheet: TTabSheet;
    CodeGenerationSheet: TTabSheet;
    BrowserSheet: TTabSheet;
    AssemblerSheet: TTabSheet;
    VerboseSheet: TTabSheet;
    
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
  CompilerOptionsDialog: TCompilerOptionsDialog;

implementation

{ TCompilerOptionsDialog }

procedure TCompilerOptionsDialog.CancelClick(Sender: TObject);
begin
     mr:=0;
     Close();
end;

procedure TCompilerOptionsDialog.OkClick(Sender: TObject);
begin
     mr:=1;
     Close();
end;

function TCompilerOptionsDialog.Execute(EditorOptions:TEditorOptions):boolean;
begin
     //load settings
     if EditorOptions.code_style=0 then GenerateFasterCode.checked:=true
                                   else GenerateFasterCode.checked:=false;
     GenerateSmallerCode.checked:=not(GenerateFasterCode.checked);
     Browser.itemindex:=EditorOptions.browser_style;
     TargetProcessor.ItemIndex:=EditorOptions.target_processor;
     AssemblerReader.ItemIndex:=EditorOptions.asm_style;
     AssemblerOutput.ItemIndex:=EditorOptions.asm_output;
     ObjectPascal.checked:=EditorOptions.objectpascal_support;
     GlobalCMacros.checked:=EditorOptions.c_macros;
     TPCompatible.checked:=EditorOptions.bp7_compatibility;
     COperators.checked:=EditorOptions.c_operators;
     DelphiCompatible.checked:=EditorOptions.delphi_compatibility;
     StopAfterFirstError.checked:=EditorOptions.stop_after_first_error;
     StaticInObjects.checked:=EditorOptions.static_in_objects;
     AllowLabel.checked:=EditorOptions.label_goto;
     CInline.checked:=EditorOptions.c_inline;
     RegisterVariables.checked:=EditorOptions.register_variables;
     UncertainOptimizations.checked:=EditorOptions.uncertain_opt;
     L1Optimizations.checked:=EditorOptions.level1_opt;
     L2Optimizations.checked:=EditorOptions.level2_opt;
     Warnings.checked:=EditorOptions.v_warnings;
     Notes.checked:=EditorOptions.v_notes;
     Hints.checked:=EditorOptions.v_hints;
     UTInfo.checked:=EditorOptions.v_used;
     GeneralInfo.checked:=EditorOptions.v_general;
     All.checked:=EditorOptions.v_all;
     ShowAllProc.checked:=EditorOptions.v_allproc;
     RangeChecking.checked:=EditorOptions.range_checking;
     StackChecking.checked:=EditorOptions.stack_checking;
     IOChecking.checked:=EditorOptions.io_checking;
     Overflowchecking.checked:=EditorOptions.integer_overflow_checking;
     ListSource.checked:=EditorOptions.asm_source;
     ListRegisters.checked:=EditorOptions.asm_register_alloc;
     ListTemp.checked:=EditorOptions.asm_temp_alloc;

     mr:=0;
     PageController.PageIndex:=0;
     ShowModal();
     
     Result:=mr=1;

     //save settings
     if Result then
      with EditorOptions do
       begin
        objectpascal_support:=ObjectPascal.Checked;
        c_macros:=GlobalCMacros.Checked;
        bp7_compatibility:=TPCompatible.Checked;
        c_operators:=COperators.Checked;
        delphi_compatibility:=DelphiCompatible.Checked;
        stop_after_first_error:=StopAfterFirstError.Checked;
        static_in_objects:=StaticInObjects.Checked;
        label_goto:=AllowLabel.Checked;
        c_inline:=CInline.Checked;
        register_variables:=RegisterVariables.Checked;
        uncertain_opt:=UncertainOptimizations.Checked;
        level1_opt:=L1Optimizations.Checked;
        level2_opt:=L2Optimizations.Checked;
        v_warnings:=Warnings.Checked;
        v_notes:=Notes.Checked;
        v_hints:=Hints.Checked;
        v_used:=UTInfo.Checked;
        v_general:=GeneralInfo.Checked;
        v_all:=All.Checked;
        v_allproc:=ShowAllProc.Checked;
        range_checking:=RangeChecking.Checked;
        stack_checking:=StackChecking.Checked;
        io_checking:=IOChecking.Checked;
        integer_overflow_checking:=OverflowChecking.Checked;
        asm_source:=ListSource.Checked;
        asm_register_alloc:=ListRegisters.Checked;
        asm_temp_alloc:=ListTemp.Checked;
        browser_style:=Browser.ItemIndex;
        if GenerateFasterCode.Checked then code_style:=0
                                      else code_style:=1;
        asm_output:=AssemblerOutput.ItemIndex;
        target_processor:=TargetProcessor.ItemIndex;
        asm_style:=AssemblerReader.ItemIndex;
       end;
end;

initialization
  {$I uCompilerOptionsDialog.lrs}

end.

