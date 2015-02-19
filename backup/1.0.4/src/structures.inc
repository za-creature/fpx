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

type Syn=record
      bg,fg:Tcolor;
      style:TFontStyles;
     end;
     TSynArray=array[0..8] of Syn;
     TBookmarkDataset=record
      caption,filename:ansistring;
      line:integer;
      column:integer;
     end;
     TCustomBookmark=class(TObject)
      protected
       fFilename:ansistring;
       fLineNumber:integer;
       fColumnNumber:integer;
       fCaption:ansistring;
       fTag:integer;
       procedure setFileName(v:ansistring);virtual;abstract;
       procedure setLineNumber(v:integer);virtual;abstract;
       procedure setCaption(v:ansistring);virtual;abstract;
      public
       onChange:TNotifyEvent;
       ChildPointer:pointer;
       property Filename:ansistring read fFilename write SetFileName;
       property LineNumber:integer read fLineNumber write SetLineNumber;
       property ColumnNumber:integer read fColumnNumber write fColumnNumber;
       property Caption:ansistring read fCaption write SetCaption;
     end;

