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

unit uCompilerOptionsWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  ExtCtrls, StdCtrls, Buttons;

type

  { TCompilerOptionsWindow }

  TCompilerOptionsWindow = class(TForm)
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
{    
    
    DelphiCompatible: TCheckBox;



    StaticInObjects: TCheckBox;

    TPCompatible: TCheckBox;

}
    
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure OkClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
  private
    { private declarations }
  public
    callback:procedure(swc:boolean) of object;
    o:integer;
    { public declarations }
  end;

var
  CompilerOptionsWindow: TCompilerOptionsWindow;

implementation

{ TCompilerOptionsWindow }

procedure TCompilerOptionsWindow.CancelClick(Sender: TObject);
begin
  callback(false);
  visible:=false;
end;

procedure TCompilerOptionsWindow.OkClick(Sender: TObject);
var p:integer;
begin
  callback(true);
  visible:=false;
end;

procedure TCompilerOptionsWindow.FormCloseQuery(Sender: TObject;
  var CanClose: boolean);
begin
  canclose:=false;
  CancelClick(sender);
end;

initialization
  {$I uCompilerOptionsWindow.lrs}

end.

