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

unit uHelpFilesDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Buttons, uEditorOptionsController, uTagReader, uAVLTree,
  uMessageBoxController;

type

  { THelpFilesDialog }

  THelpFilesDialog = class(TForm)
    AddFileButton: TButton;
    BuildIndexButton: TButton;
    MakeDefaultButton: TButton;
    CancelButton: TButton;
    OkButton: TButton;
    ClearButton: TButton;
    DeleteButton: TButton;
    HelpFiles: TListView;
    OpenFileDialog: TOpenDialog;
    CurrentFileStatusBar: TStatusBar;
    procedure AddFileButtonClick(Sender: TObject);
    procedure BuildIndexButtonClick(Sender: TObject);
    procedure CancelButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure DeleteButtonClick(Sender: TObject);
    procedure MakeDefaultButtonClick(Sender: TObject);
    procedure OkButtonClick(Sender: TObject);
  private
    { private declarations }
    mr:integer;
  public
    HelpIndex:TStringList;
    procedure BuildNodeGraph(filename:ansistring);
    function Execute(EditorOptions:TEditorOptions):boolean;
    procedure onFileChange(newname:ansistring);
    { public declarations }
  end; 

var
  HelpFilesDialog: THelpFilesDialog;

implementation

{ THelpFilesDialog }

procedure THelpFilesDialog.CancelButtonClick(Sender: TObject);
begin
  mr:=0;
  Close();
end;

procedure THelpFilesDialog.ClearButtonClick(Sender: TObject);
begin
  HelpFiles.Items.Clear();
end;

procedure THelpFilesDialog.DeleteButtonClick(Sender: TObject);
var i:integer;
begin
     i:=0;
     while i<HelpFiles.Items.Count do
      begin
       if HelpFiles.Items[i].Selected then
        begin
         //delete current item
         HelpFiles.Items.Delete(i);;
         dec(i);
        end;
       inc(i);
      end;
end;

procedure THelpFilesDialog.MakeDefaultButtonClick(Sender: TObject);
var i:integer;
    gotselectedelem:boolean;
begin
  gotselectedelem:=false;
  for i:=0 to HelpFiles.Items.Count-1 do
   if HelpFiles.Items[i].Selected then
    begin
     gotselectedelem:=true;
     break;
    end;
 if gotselectedelem then
  begin
   for i:=0 to HelpFiles.Items.Count-1 do
    HelpFiles.Items[i].SubItems.Strings[0]:='';//remove *
   for i:=0 to HelpFiles.Items.Count-1 do
    if HelpFiles.Items[i].Selected then
     begin
      HelpFiles.Items[i].SubItems.Strings[0]:='*';//add *
      break;
     end;
  end;
end;

procedure THelpFilesDialog.AddFileButtonClick(Sender: TObject);
var mr0,i:integer;
begin
  if OpenFileDialog.Execute() then
   for i:=0 to OpenFileDialog.Files.Count-1 do
    begin
     //build node graph
     if not FileExists(OpenFileDialog.Files[i]+'.index') then
      begin
       mr0:=MessageBox('The file "'+OpenFileDialog.Files[i]+'" doesn''t have '+
       'an accompanying index file. Would you like to build one? (this might '+
       'take some time).','Confirm build index',MB_YESNOCANCEL or MB_ICONQUESTION);
       if mr0=MR_YES then BuildNodeGraph(OpenFileDialog.Files[i]);
       if mr0=MR_CANCEL then break;//skip loading further
     end;
     HelpFiles.Items.Add().Caption:=OpenFileDialog.Files[i];
     if HelpFiles.Items.Count=1 then HelpFiles.Items[HelpFiles.Items.Count-1].SubItems.Add('*')//make default if it's just one file
                                else HelpFiles.Items[HelpFiles.Items.Count-1].SubItems.Add('');//do not make default otherwise
    end;
end;

procedure THelpFilesDialog.BuildIndexButtonClick(Sender: TObject);
var i:integer;
begin
     for i:=0 to HelpFiles.Items.Count-1 do
      if HelpFiles.Items[i].Selected then
       BuildNodeGraph(HelpFiles.Items[i].Caption);
end;

procedure THelpFilesDialog.OkButtonClick(Sender: TObject);
begin
  mr:=1;
  Close();
end;

procedure AddFileContent(filename:string;target:TStringList);
var f:text;
    prefix,key,data:string;
begin
     assign(f,filename);
     prefix:=ExtractFileDir(filename);
     reset(f);
     readln(f);//skip header
     while not eof(f) do
      begin
       readln(f,key);
       readln(f,data);
       target.AddObject(key,TStringObject.Create(prefix+{$ifdef win32}'\'{$else}'/s'{$endif}+data));
      end;
     close(f);
end;

function THelpFilesDialog.Execute(EditorOptions:TEditorOptions):boolean;
var i:integer;

begin
     //load settings
     HelpFiles.Clear();
     for i:=0 to length(EditorOptions.helpfiles)-1 do
      begin
       HelpFiles.Items.Add().Caption:=EditorOptions.helpfiles[i];
       if i=EditorOptions.defaulthelp then HelpFiles.Items[i].SubItems.Add('*')
                                      else HelpFiles.Items[i].SubItems.Add('');
      end;
     mr:=0;
     ShowModal();
     Result:=mr=1;
     //save settings
     if Result then
      begin
       setlength(EditorOptions.helpfiles,HelpFiles.Items.Count);
       EditorOptions.numhelpfiles:=length(EditorOptions.helpfiles);
       for i:=0 to HelpFiles.Items.Count-1 do
        EditorOptions.helpfiles[i]:=HelpFiles.Items[i].Caption;
       EditorOptions.defaulthelp:=-1;//assume there is no default help file
       for i:=0 to HelpFiles.Items.Count-1 do
        if HelpFiles.Items[i].SubItems.Strings[0]='*' then
         begin
          EditorOptions.defaulthelp:=i;//or is there? :)
          break;
         end;
       //rebuild node index
       for i:=0 to HelpIndex.Count-1 do HelpIndex.Objects[i].Destroy;
       HelpIndex.Clear();
       for i:=0 to length(EditorOptions.helpfiles)-1 do
        if FileExists(EditorOptions.helpfiles[i]+'.index')then
         AddFileContent(EditorOptions.helpfiles[i]+'.index',HelpIndex);
      end;
end;

procedure THelpFilesDialog.BuildNodeGraph(filename:ansistring);
var myNodeGraphBuilder:THTMLNodeGraphBuilder;
begin
     Enabled:=false;
     myNodeGraphBuilder:=THTMLNodeGraphBuilder.Create();
     myNodeGraphBuilder.onFileChange:=@onFileChange;
     myNodeGraphBuilder.BuildNodeGraph(filename);
     myNodeGraphBuilder.Destroy();
     CurrentFileStatusBar.SimpleText:='';
     Enabled:=true;
end;

procedure THelpFilesDialog.onFileChange(newname:ansistring);
begin
     CurrentFileStatusBar.SimpleText:='Processing: '+newname;
     Application.ProcessMessages();
end;

initialization
  {$I uHelpFilesDialog.lrs}

end.

