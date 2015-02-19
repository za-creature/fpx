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

unit uAboutWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls;

type

  { TAboutWindow }

  TAboutWindow = class(TForm)
    CloseButton: TButton;
    TitleGroup: TGroupBox;
    CreatedByGroup: TGroupBox;
    ContactGroup: TGroupBox;
    LazarusLogo: TImage;
    Title: TLabel;
    Email: TLabel;
    Suggestions: TLabel;
    Version: TLabel;
    CreatedBy: TLabel;
    Localhost: TLabel;
    OriginalConcept: TLabel;
    Dude1: TLabel;
    Dude2: TLabel;
    Dude3: TLabel;
    Contact: TLabel;

    procedure CloseButtonClick(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
  private
    { private declarations }
  public
    callback:procedure() of object;
    { public declarations }
  end; 

var
  AboutWindow: TAboutWindow;

implementation

{ TAboutWindow }

procedure TAboutWindow.CloseButtonClick(Sender: TObject);
begin
  callback();
  visible:=false;
end;

procedure TAboutWindow.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
  canclose:=false;
end;


initialization
  {$I uAboutWindow.lrs}

end.

