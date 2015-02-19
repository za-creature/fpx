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

unit uMessageBoxController;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, ComCtrls, Buttons;

const MB_ICONQUESTION=1;
      MB_ICONINFO=2;
      MB_ICONERROR=3;
      MR_NONE=0;
      MR_YES=1;
      MR_NO=2;
      MR_CANCEL=3;

type
  //TProci=procedure(ModalResult:integer) of object;

  { TMessageBoxController }

  TMessageBoxController = class(TForm)
    Content: TMemo;
    TypeIcon: TImage;
    YesButton: TSpeedButton;
    NoButton: TSpeedButton;
    CancelButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure NoButtonClick(Sender: TObject);
    procedure YesButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
  end; 

var
  MessageBoxController: TMessageBoxController;

function MessageBox(content,title:string;image:integer):integer;

implementation

function MessageBox(content,title:string;image:integer):integer;
begin
     MessageBoxController.Caption:=title;
     MessageBoxController.Content.Lines.Clear();
     MessageBoxController.Content.Lines.Append(content);
     result:=MessageBoxController.ShowModal();
end;


{ TMessageBoxController }

procedure TMessageBoxController.YesButtonClick(Sender: TObject);
begin
  ModalResult:=MR_YES;
  Close();
end;

procedure TMessageBoxController.NoButtonClick(Sender: TObject);
begin
  ModalResult:=MR_NO;
  Close();
end;


procedure TMessageBoxController.CancelButtonClick(Sender: TObject);
begin
  ModalResult:=MR_CANCEL;
  Close();
end;

procedure TMessageBoxController.FormCreate(Sender: TObject);
begin
end;

initialization
  {$I uMessageBoxController.lrs}

end.

