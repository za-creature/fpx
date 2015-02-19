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

unit uAddBreakPointDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, Spin, Buttons, Synedit;

{$i structures.inc}

type
     TCustomEditor=class(TSynEdit)
      private
       _tname:string;
       _activefilename:string;
       procedure setTname(v:string);
       procedure setAFN(v:string);
      public
       property tname:string read _tname write setTname;
       property activefilename:string read _activefilename write setAFN;
       onFileChange:TNotifyEvent;
       onNameChange:TNotifyEvent;
       breakpoints:TList;
       constructor Create(aowner:TComponent);
       destructor Destroy();
     end;
     TGetEditorCallback=function(id:integer):TCustomEditor of object;
  { TAddBreakpointDialog }

  TAddBreakpointDialog = class(TForm)
    CancelButton: TButton;
    FilenameComboBox: TComboBox;
    Label2: TLabel;
    OkButton: TButton;
    Label1: TLabel;
    LineNumber: TSpinEdit;
    procedure CancelButtonClick(Sender: TObject);
    procedure FilenameSelect(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    fn,ln,mr:integer;
    GetEditor:TGetEditorCallback;
    { private declarations }
  public
    function Execute(gec:TGetEditorCallback;editorCount:integer):boolean;
    property Line:integer read ln;
    property Filename:integer read fn;
    { public declarations }
  end; 

var
  AddBreakpointDialog: TAddBreakpointDialog;

implementation

procedure TAddBreakpointDialog.OkButtonClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

procedure TAddBreakpointDialog.CancelButtonClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

procedure TAddBreakpointDialog.FilenameSelect(Sender: TObject);
begin
     LineNumber.MaxValue:=GetEditor(FilenameComboBox.ItemIndex).Lines.Count;
end;

function TAddBreakPointDialog.Execute(gec:TGetEditorCallback;editorCount:integer):boolean;
var i:integer;
begin
     GetEditor:=gec;
     FileNameComboBox.Items.Clear();
     for i:=0 to editorCount-1 do
      FileNameComboBox.Items.Add(GetEditor(i).tname);
     if editorCount<>0 then FileNameComboBox.ItemIndex:=0;
     mr:=0;
     ShowModal();
     Result:=mr=1;
     ln:=LineNumber.Value;
     fn:=FileNameComboBox.ItemIndex;
end;

procedure TCustomEditor.setTname(v:string);
begin
     _tname:=v;
     if onNameChange<>nil then onNameChange(self);
end;

procedure TCustomEditor.setAFN(v:string);
begin
     _activefilename:=v;
     if onFileChange<>nil then onFileChange(self);
end;

constructor TCustomEditor.Create(aowner:TComponent);
begin
     inherited Create(aowner);
     breakpoints:=TList.Create();
end;

destructor TCustomEditor.Destroy();
begin
     breakpoints.Destroy();
     inherited Destroy();
end;

initialization
  {$I uAddBreakPointDialog.lrs}

end.

