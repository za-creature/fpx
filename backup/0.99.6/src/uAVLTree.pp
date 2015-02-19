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

unit uAVLTree;

{$mode objfpc}

interface 

uses classes;

type PTree=^TTree; 
     TTree=record 
      l,r:PTree; 
      h:integer; 
      key,filename:ansistring; 
     end; 
     TStringObject=class(TObject)
      public
       value:ansistring;
       constructor Create(v:ansistring);
     end;
     TAVLTree=class(TObject)
      private
       root:PTree; 
       class procedure Balance(var node:PTree);
       class procedure RotLeft(var node:PTree);
       class procedure RotRight(var node:PTree);
       class procedure FixHeight(var node:PTree);
      public 
       procedure Insert(key,filename:ansistring); 
       procedure Delete(key:ansistring); 
       function Search(key:ansistring):ansistring; 
       function FileExists(filename:ansistring):boolean;
       function KeyExists(key:ansistring):boolean;
       procedure Clear(); 
       procedure SaveToFile(filename:ansistring); 
       constructor Create(); 
       destructor Destroy();override; 
     end; 

implementation 
     
const NullTree:TTree=(l:nil;r:nil;h:0;key:'';filename:''); 

constructor TStringObject.Create(v:ansistring);
begin
     value:=v;
end;

constructor TAVLTree.Create();
begin
     root:=@NullTree; 
end; 

procedure TAVLTree.Clear(); 
  procedure freenode(var node:PTree);
  begin
       if node^.l<>@NullTree then freenode(node^.l);
       if node^.r<>@NullTree then freenode(node^.r);
       dispose(node); 
  end; 
begin
     if root<>@NullTree then freenode(root); 
     root:=@NullTree; 
end; 

destructor TAVLTree.Destroy();
begin
     Clear; 
end; 

procedure TAVLTree.Balance(var node:PTree);
begin
     FixHeight(node); 
     if node^.l^.h>node^.r^.h+1 then
      begin
       if node^.l^.r^.h>node^.l^.l^.h then RotLeft(node^.l); 
       RotRight(node); 
      end; 
     if node^.l^.h+1<node^.r^.h then
      begin
       if node^.r^.r^.h<node^.r^.l^.h then RotRight(node^.r); 
       RotLeft(node); 
      end; 
end; 

procedure TAVLTree.FixHeight(var node:PTree);
begin
     if node^.l^.h>node^.r^.h then node^.h:=node^.l^.h+1
                              else node^.h:=node^.r^.h+1; 
end; 

procedure TAVLTree.RotLeft(var node:PTree);
var aux:PTree; 
begin
     aux:=node^.r;
     node^.r:=aux^.l; 
     aux^.l:=node;
     FixHeight(node); 
     FixHeight(aux); 
     node:=aux; 
end;

procedure TAVLTree.RotRight(var node:PTree);
var aux:PTree; 
begin
     aux:=node^.l;
     node^.l:=aux^.r;
     aux^.r:=node;
     FixHeight(node); 
     FixHeight(aux); 
     node:=aux; 
end;

procedure TAVLTree.Insert(key,filename:ansistring);

function NewNode():PTree;
begin
     new(Result);
     Result^.key:=key;
     Result^.filename:=filename;
     Result^.l:=@NullTree; 
     Result^.r:=@NullTree;
     Result^.h:=1; 
end; 

procedure i_insert(var node:PTree);
begin
     if node<>@NullTree then
      begin
       if key<node^.key then i_insert(node^.l)
                        else i_insert(node^.r); 
       Balance(node); 
      end              else node:=NewNode(); 
end; 

begin
     i_insert(root); 
end;

procedure TAVLTree.Delete(key:ansistring);
begin
     //maybe in the next version :)
end; 

function TAVLTree.Search(key:ansistring):ansistring;
var onode,node:PTree; 
begin
     node:=root;
     while node<>@NullTree do 
      begin 
       onode:=node; 
       if key<node^.key then node:=node^.l else
       if key>node^.key then node:=node^.r
                        else exit(node^.filename); 
      end; 
     result:='-1';
end; 

function TAVLTree.FileExists(filename:ansistring):boolean;
var node:PTree; 
begin
     node:=root;
     while node<>@NullTree do 
      if filename<node^.filename then node:=node^.l else
      if filename>node^.filename then node:=node^.r else exit(true);
     result:=false; 
end;                                  

function TAVLTree.KeyExists(key:ansistring):boolean;
var node:PTree; 
begin
     node:=root;
     while node<>@NullTree do 
      if key<node^.key then node:=node^.l else
      if key>node^.key then node:=node^.r else exit(true);
     result:=false; 
end;                                  

procedure TAVLTree.SaveToFile(filename:ansistring);
var f:text; 

procedure WriteTree(node:PTree);
begin
     if node=@NullTree then exit;
     WriteTree(node^.l);
     writeln(f,node^.key);
     writeln(f,node^.filename); 
     WriteTree(node^.r);
end; 

begin
     assign(f,filename);
     rewrite(f); 
     writeln(f,'This is an automatically generated index file for your documentation. DO NOT REMOVE!'); 
     WriteTree(root); 
     close(f);     
end; 

end.
