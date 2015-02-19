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

unit uFindWindow; 

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, Buttons;

type

  { TFindWindow }

  TFindWindow = class(TForm)
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
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure ReplaceAllClick(Sender: TObject);
  private
    { private declarations }
  public
    callback:procedure(swc,a:boolean) of object;
    { public declarations }
  end; 

var
  FindWindow: TFindWindow;

implementation

{ TFindWindow }

//main
procedure TFindWindow.FindReplaceClick(Sender: TObject);
begin
  callback(true,false);
  visible:=false;
end;

//cancel
procedure TFindWindow.CancelClick(Sender: TObject);
begin
  callback(false,false);
  visible:=false;
end;

procedure TFindWindow.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
    canclose:=false;
  CancelClick(sender);
end;

//replace all
procedure TFindWindow.ReplaceAllClick(Sender: TObject);
begin
     callback(true,true);
end;

initialization
  {$I uFindWindow.lrs}

end.

