unit uShowResultsDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  Buttons;

type

  { TShowResultsDialog }

  TShowResultsDialog = class(TForm)
    CloseButton: TButton;
    ResultsBox: TListBox;
    procedure CloseButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    procedure Execute(t:TStrings);
  end; 

var
  ShowResultsDialog: TShowResultsDialog;

implementation

{ TShowResultsDialog }

procedure TShowResultsDialog.Execute(t:TStrings);
begin
     ResultsBox.Items.Assign(t);
     ShowModal();
end;

procedure TShowResultsDialog.CloseButtonClick(Sender: TObject);
begin
  Close();
end;

initialization
  {$I uShowResultsDialog.lrs}

end.

