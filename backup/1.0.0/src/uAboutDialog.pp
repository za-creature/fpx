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

unit uAboutDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, Buttons,
  ExtCtrls, StdCtrls;

type

  { TAboutDialog }

  TAboutDialog = class(TForm)
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
  private
    { private declarations }
  public
    procedure SetV(v:string);
    { public declarations }
  end; 

var
  AboutDialog: TAboutDialog;

implementation

{ TAboutDialog }

procedure TAboutDialog.CloseButtonClick(Sender: TObject);
begin
     Close();
end;

procedure TAboutDialog.SetV(v:string);
const targetcpu={$i %fpctargetcpu%};
      targetos={$i %fpctargetos};
begin
  Version.Caption:='Version '+v+'-'+targetcpu+'-'+targetos;
end;

initialization
  {$I uAboutDialog.lrs}

end.

