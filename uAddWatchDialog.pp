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

unit uAddWatchDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, StdCtrls,
  LCLType, Buttons;


type

  { TAddWatchDialog }

  TAddWatchDialog = class(TForm)
    OkButton: TButton;
    CancelButton: TButton;
    Watch: TEdit;
    ExpLabel: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { private declarations }
  public
    { public declarations }
    function Execute():boolean;
    mr:integer;
    Expression:string;
  end;

var
  AddWatchDialog: TAddWatchDialog;

implementation

{ TAddWatchDialog }

procedure TAddWatchDialog.Button2Click(Sender: TObject);
begin
  mr:=-1;
  Close();
end;

procedure TAddWatchDialog.Button1Click(Sender: TObject);
begin
  mr:=1;
  Expression:=Watch.Text;
  Close();
end;

function TAddWatchDialog.Execute():boolean;
begin
     mr:=-1;
     showModal();
     result:=mr=1;
end;

initialization
  {$I uAddWatchDialog.lrs}

end.

