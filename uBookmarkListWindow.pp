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

unit uBookmarkListWindow;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, LResources, Forms, Controls, Graphics, Dialogs, ComCtrls,
  Synedit, LCLType, uAddBreakPointDialog, ExtCtrls;
  
type

  TBookmarkSynEditMark = class(TSynEditMark)
  protected
    procedure SetLine(const Value: Integer);override;
  public
    ParentPointer:pointer;
    onLineChange:TNotifyEvent;
  end;

  { TBookmarkListWindow }

  TBookmarkListWindow = class(TForm)
    BookmarkList: TListView;
    IdleTimer: TIdleTimer;
    procedure BookmarkListDblClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure IdleTimerTimer(Sender: TObject);
    
  private
    { private declarations }
  public
    { public declarations }
    Callback:procedure(i:integer) of object;
    l:TList;
    procedure RefreshList(Sender:TObject);//parameter is for compatibility with TNotifyEvent
  end; 

var
  BookmarkListWindow: TBookmarkListWindow;

implementation

procedure TBookmarkSynEditMark.SetLine(const Value:integer);
begin
     fLine:=Value;
     if Assigned(onLineChange) then onLineChange(self);
end;

{ TBookmarkListWindow }

procedure TBookmarkListWindow.BookmarkListDblClick(Sender: TObject);
begin
   try
    Callback(BookmarkList.Selected.Index);
    BookmarkList.Selected.Selected:=false;
    Application.MainForm.SetFocus();
   except
   end;
end;

procedure TBookmarkListWindow.FormActivate(Sender: TObject);
begin
  IdleTimer.Enabled:=true;
end;

procedure TBookmarkListWindow.FormDeactivate(Sender: TObject);
begin
  IdleTimer.Enabled:=false;
end;

procedure TBookmarkListWindow.IdleTimerTimer(Sender: TObject);
begin
  if Active then
   begin
    //some focus magic
    Application.MainForm.onActivate(self);
    Application.MainForm.SetFocus();
    IdleTimer.Enabled:=false;
   end;
end;

procedure TBookMarkListWindow.RefreshList(Sender:TObject);
var i:integer;
    p:TCustomBookmark;
    aitem:TListItem;
begin
     Bookmarklist.Items.Clear();
     for i:=0 to l.Count-1 do
      begin
       p:=TCustomBookmark(l[i]);
       aitem:=BookmarkList.Items.Add();
       aitem.Caption:=p.Caption;
       aitem.SubItems.Add(p.FileName);
       aitem.SubItems.Add(IntToStr(p.LineNumber));
      end;
end;

initialization
  {$I uBookmarkListWindow.lrs}

end.

