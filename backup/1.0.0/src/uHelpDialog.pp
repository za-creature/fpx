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
  {$ifdef win32}Windows, {$endif}Classes, SysUtils, LResources, Forms, Controls,
  Graphics, Dialogs, IpHtml, ComCtrls, Buttons, StdCtrls, ExtCtrls, uAVLTree;
  
{$ifndef win32}
{$i keycodes.inc}
{$endif}

const TimerTicks=20;

type
  TSimpleIpHtml = class(TIpHtml)
  public
    property OnGetImageX;
  end;
  TMatchTable=array of integer;
  PMatchTable=^TMatchTable;

  { THelpDialog }

  THelpDialog = class(TForm)
    DisplayButton: TButton;
    EditBox: TEdit;
    EditGroupBox: TGroupBox;
    HomeSpeedButton: TSpeedButton;
    IdleTimer: TIdleTimer;
    SearchPanel: TPanel;
    SearchSpeedButton: TSpeedButton;
    HtmlPanel: TIpHtmlPanel;
    ForwardSpeedButton: TSpeedButton;
    BackSpeedButton: TSpeedButton;
    StatusBar: TStatusBar;
    ToolBar: TToolBar;
    TopicList: TListBox;
    TopicListGroupBox: TGroupBox;
    procedure BackSpeedButtonClick(Sender: TObject);
    procedure ForwardSpeedButtonClick(Sender: TObject);
    procedure HomeSpeedButtonClick(Sender: TObject);
    procedure HotClick(Sender: TObject);
    procedure HtmlPanelHotChange(Sender: TObject);
    procedure SearchSpeedButtonClick(Sender: TObject);
    procedure DisplayButtonClick(Sender: TObject);
    procedure EditBoxChange(Sender: TObject);
    procedure EditBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure IdleTimerStartTimer(Sender: TObject);
    procedure IdleTimerStopTimer(Sender: TObject);
    procedure IdleTimerTimer(Sender: TObject);
    procedure TopicListKeyDown(Sender: TObject; var Key: Word;Shift: TShiftState);

  private
    { private declarations }
    mr:integer;
    sf:string;
    //for searching
    SearchQuery:string;
    h:PChar;
    i:integer;
    table:PMatchTable;
    History:array of string;
    HistoryPointer:integer;
    procedure Search(t:string);
    procedure InlineSearch(t:string);
    procedure OpenHTMLFile(const Filename: string;saveinhistory:boolean);
    procedure HTMLGetImageX(Sender: TIpHtmlNode; const URL: string;var Picture: TPicture);
  public
    { public declarations }
    function Execute(filename:ansistring):boolean;
    function ExecuteIndex(s:string):boolean;
    property SelectedFile:string read sf;
    function TopicSearch(s:string):string;
    HelpIndex:TStringList;
    ContentHome:string;
  end;
  
var
  HelpDialog: THelpDialog;

implementation

{ THelpDialog }

function THelpDialog.Execute(filename:ansistring):boolean;
var odir:string;
begin
     HtmlPanel.visible:=true;
     SearchPanel.visible:=false;
     if fileexists(filename) then
      begin
       odir:=GetCurrentDir();
       HistoryPointer:=-1;
       OpenHTMLFile(filename,true);
       ShowModal();
       SetCurrentDir(odir);
       Result:=true;
      end                    else Result:=false;
end;

procedure THelpDialog.OpenHTMLFile(const Filename: string;saveinhistory:boolean);
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
    if saveinhistory then
     begin
      inc(HistoryPointer);
      SetLength(History,HistoryPointer+1);
      History[HistoryPointer]:=GetCurrentDir+{$ifdef win32}'\'{$else}'/'{$endif}+ExtractFileName(filename);
     end;
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
     OpenHTMLFile(NewFilename,true);
    end                      else
    begin
     bar:=foo(NodeA.HRef);
     if fileexists(bar) then
      begin
       NewFilename:=bar;
       OpenHTMLFile(NewFilename,true);
      end;
    end;
  end;
end;

procedure THelpDialog.HtmlPanelHotChange(Sender: TObject);
begin
     StatusBar.SimpleText:=HtmlPanel.HotURL;
end;

procedure THelpDialog.SearchSpeedButtonClick(Sender: TObject);
begin
  HtmlPanel.Visible:=false;
  SearchPanel.Visible:=true;
  EditBox.Text:='';
  ActiveControl:=EditBox;
end;

procedure THelpDialog.ForwardSpeedButtonClick(Sender: TObject);
begin
  if HistoryPointer<Length(History)-1 then
   begin
    inc(HistoryPointer);
    OpenHTMLFile(History[HistoryPointer],false);
   end;
end;

procedure THelpDialog.HomeSpeedButtonClick(Sender: TObject);
begin
  if FileExists(ContentHome) then
   begin
    HistoryPointer:=-1;
    SearchPanel.Visible:=false;
    HtmlPanel.Visible:=true;
    OpenHTMLFile(ContentHome,true);
    ActiveControl:=HtmlPanel;
   end;
end;

procedure THelpDialog.BackSpeedButtonClick(Sender: TObject);
begin
  if HistoryPointer>0 then
   begin
    dec(HistoryPointer);
    OpenHTMLFile(History[HistoryPointer],false);
   end;
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

function BuildMatchTable(s:pchar):PMatchTable;

var i,j,n:integer;

begin
      New(Result);
      SetLength(Result^,Length(s));

      if length(s)<2 then Result^[0]:=-1
                     else
       begin
        i:=2;
        j:=0;
        Result^[0]:=-1;
        Result^[1]:=0;
        n:=length(s);
        while i<n do
         begin
          if s[i-1]=s[j] then
           begin
            Result^[i]:=j+1;
            inc(i);
            inc(j);
           end           else
            if j>0 then j:=Result^[j]
                   else
             begin
              Result^[i]:=0;
              inc(i);
              j:=0;
             end;
         end;
       end;
end;

procedure FreeMatchTable(var p:PMatchTable);
begin
     SetLength(p^,0);
     Dispose(p);
     p:=nil;
end;

function Match(key:pchar;data:pchar;var table:PMatchTable):integer;
var k,n,m,i:integer;
begin
     if table=nil then table:=BuildMatchTable(key);

     m:=0;
     i:=0;
     n:=length(data);
     k:=length(key);
     while i+m<n do
      begin
       if key[i]=data[i+m] then inc(i)
                           else
        begin
         m:=m+i-table^[i];
         if table^[i]>0 then i:=table^[i]
                        else i:=0;
        end;
       if i=k then exit(m);//match @ m
      end;

     result:=-1;
end;

{ TIndexDialog }

procedure THelpDialog.EditBoxChange(Sender: TObject);
begin
  Search(EditBox.Text);
end;

procedure THelpDialog.EditBoxKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
  
function min(a,b:integer):integer;inline;
begin
     if a<b then exit(a);
     result:=b;
end;

function max(a,b:integer):integer;inline;
begin
     if a>b then exit(a);
     result:=b;
end;

begin
  if key=VK_UP then
   begin
    ActiveControl:=TopicList;
    TopicList.ItemIndex:=max(0,TopicList.ItemIndex-1);
   end;
  if key=VK_DOWN then
   begin
    ActiveControl:=TopicList;
    TopicList.ItemIndex:=min(TopicList.Items.Count-1,TopicList.ItemIndex+1);
   end;
  if key=VK_NEXT then
   begin
    ActiveControl:=TopicList;
    TopicList.ItemIndex:=min(TopicList.Items.Count-1,TopicList.ItemIndex+10);
   end;
  if key=VK_PRIOR then
   begin
    ActiveControl:=TopicList;
    TopicList.ItemIndex:=max(0,TopicList.ItemIndex-10);
   end;

  if key=VK_ESCAPE then Close();
end;

procedure THelpDialog.IdleTimerStartTimer(Sender: TObject);
var j:integer;
begin
     table:=nil;
     h:=nil;
     SearchQuery:=Trim(SearchQuery);
     if SearchQuery<>'' then
      begin
       getmem(h,length(SearchQuery)+1);
       //strcopy
       for j:=0 to length(SearchQuery)-1 do h[j]:=UpCase(SearchQuery[j+1]);
       h[j+1]:=#0;
       table:=BuildMatchTable(h);
      end;
     TopicList.Items.Clear();
     i:=0;
end;

procedure THelpDialog.IdleTimerStopTimer(Sender: TObject);
begin
     if h<>nil then freemem(h);
     if table<>nil then FreeMatchTable(table);
     if (TopicList.Items.Count>0)and(TopicList.ItemIndex=-1) then TopicList.ItemIndex:=0;
end;

procedure THelpDialog.IdleTimerTimer(Sender: TObject);
var j,k:integer;
    p:pchar;
    aitem:ansistring;
begin
     k:=0;
     while i<HelpIndex.Count do
      begin
       aitem:=HelpIndex[i];
       getmem(p,length(aitem)+1);
       //strcopy
       for j:=0 to length(aitem)-1 do p[j]:=UpCase(aitem[j+1]);
       p[j+1]:=#0;
       if (SearchQuery='')or(Match(h,p,table)<>-1) then
        begin
         TopicList.Items.AddObject(HelpIndex[i],HelpIndex.Objects[i]);
         inc(k);
         if k=TimerTicks then exit;
        end;
       freemem(p);
       inc(i);
      end;
     IdleTimer.Enabled:=false;
end;

procedure THelpDialog.TopicListKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
     if key in [VK_A..VK_Z] then
      begin
       if ssShift in Shift then EditBox.Text:=EditBox.Text+char(byte('A')+key-VK_A)
                           else EditBox.Text:=EditBox.Text+char(byte('a')+key-VK_A);
      end                     else
     if key=VK_BACK then ActiveControl:=EditBox;
     if key=VK_ESCAPE then Close();
end;

procedure THelpDialog.DisplayButtonClick(Sender: TObject);
begin
  if TopicList.ItemIndex<>-1 then
   begin
    mr:=1;
    sf:=TStringObject(TopicList.Items.Objects[TopicList.ItemIndex]).value;
    SearchPanel.Visible:=false;
    HtmlPanel.Visible:=true;
    HistoryPointer:=-1;
    OpenHTMLFile(sf,true);
    ActiveControl:=HtmlPanel;
   end;
end;

procedure THelpDialog.Search(t:string);
begin
     if IdleTimer.Enabled then IdleTimer.Enabled:=false;//disable
     SearchQuery:=t;
     IdleTimer.Enabled:=true;//enable
end;

procedure THelpDialog.InlineSearch(t:string);
var j,k:integer;
    p:pchar;
    aitem:string;
begin
     t:=Trim(t);
     if t<>'' then
      begin
       getmem(h,length(t)+1);
       //strcopy
       for j:=0 to length(t)-1 do h[j]:=UpCase(t[j+1]);
       h[j+1]:=#0;
       table:=BuildMatchTable(h);
      end;
     TopicList.Items.Clear();
     for k:=0 to HelpIndex.Count-1 do
      begin
       aitem:=HelpIndex[k];
       getmem(p,length(aitem)+1);
       //strcopy
       for j:=0 to length(aitem)-1 do p[j]:=UpCase(aitem[j+1]);
       p[j+1]:=#0;
       if (t='')or(Match(h,p,table)<>-1) then
        TopicList.Items.AddObject(HelpIndex[k],HelpIndex.Objects[k]);
       freemem(p);
      end;
     freemem(h);
     if TopicList.Items.Count<>0 then TopicList.ItemIndex:=0;
end;

function THelpDialog.TopicSearch(s:string):string;
var j:integer;
    us:string;
begin
     InlineSearch(s);
     us:=UpCase(s);
     for j:=0 to TopicList.Items.Count-1 do
      if UpCase(TopicList.Items[j])=us then exit(TStringObject(TopicList.Items.Objects[j]).value);
     result:='/\';
end;

function THelpDialog.ExecuteIndex(s:string):boolean;
begin
     HtmlPanel.visible:=false;
     SearchPanel.visible:=true;
     EditBox.Text:=s;
     mr:=0;
     ActiveControl:=EditBox;
     showModal();
     Result:=mr<>0;
end;

initialization
  {$I uHelpDialog.lrs}

end.
