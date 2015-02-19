unit uEvaluatorWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  EditBtn, Buttons, Spin, uInternalEvaluatorDialog;

type

  { TEvaluatorWindow }

  TEvaluatorWindow = class(TForm)
    CancelButton: TButton;
    EvaluateButton: TButton;
    InputFileName: TEdit;
    InputFileLabel: TLabel;
    Label1: TLabel;
    OpenDialog: TOpenDialog;
    OutputFileName: TEdit;
    OutputFileLabel: TLabel;
    SettingsBox: TGroupBox;
    InputAdd: TButton;
    InputDelete: TButton;
    InputClear: TButton;
    OutputClear: TButton;
    OutputDelete: TButton;
    OutputAdd: TButton;
    TimeLimit: TSpinEdit;
    UseVerifier: TCheckBox;
    Verifier: TFileNameEdit;
    Executable: TFileNameEdit;
    VerifierBox: TGroupBox;
    InputFilesLabel: TLabel;
    OutputFilesLabel: TLabel;
    InputFiles: TListBox;
    OutputFiles: TListBox;
    ExecutableBox: TGroupBox;
    procedure CancelButtonClick(Sender: TObject);
    procedure EvaluateButtonClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormResize(Sender: TObject);
    procedure InputAddClick(Sender: TObject);
    procedure InputClearClick(Sender: TObject);
    procedure InputDeleteClick(Sender: TObject);
    procedure OutputAddClick(Sender: TObject);
    procedure OutputClearClick(Sender: TObject);
    procedure OutputDeleteClick(Sender: TObject);
    procedure UseVerifierChange(Sender: TObject);
  private
    { private declarations }
  public
    callback:TNotifyEvent;
    { public declarations }
  end; 

var
  EvaluatorWindow: TEvaluatorWindow;

implementation

{ TEvaluatorWindow }

procedure TEvaluatorWindow.FormResize(Sender: TObject);
begin
     InputFiles.Width:=(Width-32) div 2;
     OutputFiles.Width:=(Width-32) div 2;
     OutputFiles.Left:=InputFiles.Width+8+16;
     Verifierbox.Width:=InputFiles.Width;
     OutputFilesLabel.Left:=OutputFiles.Left;
     ExecutableBox.Width:=InputFiles.Width;
     SettingsBox.Width:=OutputFiles.Width;
     SettingsBox.Left:=OutputFiles.Left;
end;

procedure TEvaluatorWindow.CancelButtonClick(Sender: TObject);
begin
  Close();
end;

procedure TEvaluatorWindow.EvaluateButtonClick(Sender: TObject);
begin
     if not UseVerifier.Checked then InternalEvaluatorDialog.Execute(InputFiles.Items,OutputFiles.Items,InputFileName.Text,OutputFileName.Text,Executable.Text,TimeLimit.Value,'')
                                else InternalEvaluatorDialog.Execute(InputFiles.Items,nil,InputFileName.Text,OutputFileName.Text,Executable.Text,TimeLimit.Value,Verifier.Text);
end;

procedure TEvaluatorWindow.FormClose(Sender: TObject;
  var CloseAction: TCloseAction);
begin
  if Assigned(callback) then Callback(self);
end;

procedure TEvaluatorWindow.InputAddClick(Sender: TObject);
var i:integer;
begin
  OpenDialog.FilterIndex:=2;
  if OpenDialog.Execute() then
   for i:=0 to OpenDialog.Files.Count-1 do
    InputFiles.Items.Add(OpenDialog.Files[i]);
end;

procedure TEvaluatorWindow.InputClearClick(Sender: TObject);
begin
  InputFiles.Items.Clear();
end;

procedure TEvaluatorWindow.InputDeleteClick(Sender: TObject);
var i:integer;
begin
     i:=0;
     while i<InputFiles.Items.Count do
      begin
       if InputFiles.Selected[i] then
        begin
         InputFiles.Items.Delete(i);
         dec(i);
        end;
       inc(i);
      end;
end;

procedure TEvaluatorWindow.OutputAddClick(Sender: TObject);
var i:integer;
begin
  OpenDialog.FilterIndex:=3;
  if OpenDialog.Execute() then
   for i:=0 to OpenDialog.Files.Count-1 do
    OutputFiles.Items.Add(OpenDialog.Files[i]);
end;

procedure TEvaluatorWindow.OutputClearClick(Sender: TObject);
begin
  OutputFiles.Items.Clear();
end;

procedure TEvaluatorWindow.OutputDeleteClick(Sender: TObject);
var i:integer;
begin
     i:=0;
     while i<OutputFiles.Items.Count do
      begin
       if OutputFiles.Selected[i] then
        begin
         OutputFiles.Items.Delete(i);
         dec(i);
        end;
       inc(i);
      end;
end;

procedure TEvaluatorWindow.UseVerifierChange(Sender: TObject);
var v:boolean;
begin
  v:=not(UseVerifier.Checked);
  OutputFiles.Enabled:=v;
  OutputAdd.Enabled:=v;
  OutputDelete.Enabled:=v;
  OutputClear.Enabled:=v;
  Verifier.Enabled:=not(v);
end;

initialization
  {$I uEvaluatorWindow.lrs}

end.

