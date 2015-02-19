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
  ExtCtrls, ComCtrls, Buttons, LCLType;

const MB_ICONQUESTION=1;
      MB_ICONINFO=2;
      MB_ICONERROR=4;
      MB_CONFIRM=8;
      MB_YESNOCANCEL=16;
      MR_NONE=0;
      MR_YES=1;
      MR_NO=2;
      MR_CANCEL=3;
      MR_OK=4;

type
  //TProci=procedure(ModalResult:integer) of object;

  { TMessageBoxController }

  TMessageBoxController = class(TForm)
    Content: TMemo;
    IconQuestion: TImage;
    IconInfo: TImage;
    OkButton: TSpeedButton;
    YesButton: TSpeedButton;
    NoButton: TSpeedButton;
    CancelButton: TSpeedButton;
    procedure CancelButtonClick(Sender: TObject);
    procedure ContentKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState
      );
    procedure NoButtonClick(Sender: TObject);
    procedure YesButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { private declarations }
  public
    mr:integer;
    { public declarations }
  end; 

var
  MessageBoxController: TMessageBoxController;

function MessageBox(content,title:string;dat:integer):integer;

implementation

function MessageBox(content,title:string;dat:integer):integer;
begin
     if(dat and MB_ICONINFO)<>0 then
      begin
       MessageBoxController.IconQuestion.visible:=false;
       MessageBoxController.IconInfo.visible:=true;
      end                        else
      begin
       MessageBoxController.IconQuestion.visible:=true;
       MessageBoxController.IconInfo.visible:=false;
      end;
     if(dat and MB_CONFIRM)<>0 then
      begin
       MessageBoxController.YesButton.visible:=false;
       MessageBoxController.NoButton.visible:=false;
       MessageBoxController.CancelButton.visible:=false;
       MessageBoxController.OkButton.visible:=true;
      end                          else
      begin
       MessageBoxController.YesButton.visible:=true;
       MessageBoxController.NoButton.visible:=true;
       MessageBoxController.CancelButton.visible:=true;
       MessageBoxController.OkButton.visible:=false;
      end;
      
     MessageBoxController.mr:=MR_CANCEL;
     MessageBoxController.Caption:=title;
     MessageBoxController.Content.Lines.Clear();
     MessageBoxController.Content.Lines.Append(content);
     MessageBoxController.ShowModal();
     
     result:=MessageBoxController.mr;
end;


{ TMessageBoxController }

procedure TMessageBoxController.YesButtonClick(Sender: TObject);
begin
  mr:=MR_YES;
  Close();
end;

procedure TMessageBoxController.NoButtonClick(Sender: TObject);
begin
  mr:=MR_NO;
  Close();
end;

procedure TMessageBoxController.CancelButtonClick(Sender: TObject);
begin
  mr:=MR_CANCEL;
  Close();
end;

procedure TMessageBoxController.ContentKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if key=VK_RETURN then
   begin
    if OkButton.visible then OkButtonClick(Sender)
                        else YesButtonClick(Sender);
   end;
end;

procedure TMessageBoxController.OkButtonClick(Sender: TObject);
begin
  mr:=MR_OK;
  Close();
end;

initialization
  {$I uMessageBoxController.lrs}

end.


