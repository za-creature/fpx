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

unit uHelpDialog;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, IpHtml,
  ComCtrls;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;

  { THelpDialog }

  THelpDialog = class(TForm)
    HtmlPanel: TIpHtmlPanel;
    procedure FormCreate(Sender: TObject);
    procedure HotClick(Sender: TObject);
  private
    { private declarations }
    procedure OpenHTMLFile(const Filename: string);
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;
      var Picture: TPicture);
  public
    function Execute(filename:ansistring):boolean;
    { public declarations }
  end; 

var
  HelpDialog: THelpDialog;

implementation

{ THelpDialog }

function THelpDialog.Execute(filename:ansistring):boolean;
var odir:string;
begin
     HtmlPanel.
     if fileexists(filename) then
      begin
       odir:=GetCurrentDir();
       OpenHTMLFile(filename);
       ShowModal();
       SetCurrentDir(odir);
       Result:=true;
      end                    else Result:=false;
end;

procedure THelpDialog.OpenHTMLFile(const Filename: string);
var
  fs: TFileStream;
  NewHTML: TSimpleIpHtml;
begin
   try
    fs:=TFileStream.Create(Filename,fmOpenRead);
    NewHTML:=TSimpleIpHtml.Create; 
    NewHTML.OnGetImageX:=@HTMLGetImageX;
    NewHTML.LoadFromStream(fs);
    SetCurrentDir(ExtractFileDir(Filename));
    //get rid of an useless scrollbar
    HtmlPanel.Visible:=false;
    HtmlPanel.Width:=HtmlPanel.Width-20;
    HtmlPanel.SetHtml(NewHTML);
    HtmlPanel.Width:=HtmlPanel.Width+20;
    HtmlPanel.Visible:=true;
   finally
    if fs<>nil then fs.Free;
   end;
end;

function foo(s:string):string;
var i:integer;
begin
     i:=length(s);
     while (i>0)and(s[i]<>'#')do dec(i);
     result:=copy(s,1,i-1);
end;

procedure THelpDialog.HotClick(Sender: TObject);
var
  NodeA: TIpHtmlNodeA;
  NewFilename: String;
  bar:string;
begin
 if HtmlPanel.HotNode is TIpHtmlNodeA then
  begin
   NodeA:=TIpHtmlNodeA(HtmlPanel.HotNode);
   if FileExists(NodeA.HRef) then
    begin
     NewFilename:=NodeA.HRef;
     OpenHTMLFile(NewFilename);
    end                      else
    begin
     bar:=foo(NodeA.HRef);
     if fileexists(bar) then
      begin
       NewFilename:=bar;
       OpenHTMLFile(NewFilename);
      end;
    end;
  end;
end;

procedure THelpDialog.FormCreate(Sender: TObject);
begin
end;

procedure THelpDialog.HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;
  var Picture: TPicture);
var
  PicCreated: boolean;
begin
  try
   if FileExists(URL) then
    begin
     PicCreated := False;
     if Picture=nil then
      begin
       Picture:=TPicture.Create;
       PicCreated := True;
      end;
     Picture.LoadFromFile(URL);
    end;
  except
   if PicCreated then
    Picture.Free;
   Picture := nil;
  end;
end;

initialization
  {$I uHelpDialog.lrs}

end.
