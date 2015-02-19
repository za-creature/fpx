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

{$mode objfpc} 

unit uTagReader; 

interface 

uses sysutils, uAVLTree;

type TTag=record
      name:ansistring;
      params:array of ansistring; 
      paramnames:array of ansistring;      
     end;
     TLocationData=record
      s,e:integer; 
     end; 
     THTMLNodeGraphBuilder=class(TOBject) 
      private
       class function nextTag(s:ansistring;var o:integer;l:integer):TLocationData;
       class function nextTag(s:ansistring;var o:integer;l:integer;var nontagchars:ansistring):TLocationData;
       class function Analyze(s:string):TTag;
       class function FileOpenAndReadEveryFuckingThingAsOneFuckingLine(name:ansistring):ansistring;
       class function getSubTagValue(tag:TTag;subname:ansistring):ansistring;
       class function ParseFileName(filename:ansistring):ansistring;
       procedure doThisFile(filename:ansistring);
       myAVL:TAVLTree; 
       CheckedFilesAVL:TAVLTree;
       basedir:ansistring; 
      public
       onFileChange:procedure(newname:ansistring) of object; 
       procedure BuildNodeGraph(filename:ansistring);
     end; 
     
implementation 
     
     
function THTMLNodeGraphBuilder.nextTag(s:ansistring;var o:integer;l:integer):TLocationData; 
var done:boolean; 
    qo,dqo:boolean; 
begin
     while (o<=l)and(s[o]<>'<') do inc(o); 
     Result.s:=o; 
     done:=false; 
     qo:=false;
     dqo:=false; 
     while not done do
      begin
       if ((qo)or(dqo))and(s[o]='\') then inc(o,2);//skip me a river 
       if o>l then break;//force break 
       if (s[o]='"')and(not qo)then dqo:=not(dqo);
       if (s[o]='''')and(not dqo)then qo:=not(qo);
       if (o=l)or(not(qo or dqo)and(s[o]='>')) then done:=true; 
       inc(o); 
      end; 
     Result.e:=o-1; 
end; 

function THTMLNodeGraphBuilder.nextTag(s:ansistring;var o:integer;l:integer;var nontagchars:ansistring):TLocationData; 
var done:boolean; 
    qo,dqo:boolean; 
begin
     while s[o]<>'<' do
      begin
       nontagchars+=s[o]; 
       inc(o); 
      end; 
     Result.s:=o; 
     done:=false; 
     qo:=false;
     dqo:=false; 
     while not done do
      begin
       if ((qo)or(dqo))and(s[o]='\') then inc(o,2);//skip me a river 
       if (s[o]='"')and(not qo)then dqo:=not(dqo);
       if (s[o]='''')and(not dqo)then qo:=not(qo);
       if (o=l)or(not(qo or dqo)and(s[o]='>')) then done:=true; 
       inc(o); 
      end; 
     Result.e:=o-1; 
end;                

function THTMLNodeGraphBuilder.Analyze(s:string):TTag;
var oi,i,l,l2:integer; 
    qo,dqo,done:boolean;                                        
begin
     l:=length(s);
     i:=1;
     //read tag name
     Result.Name:=''; 
     SetLength(Result.Params,0);
     SetLength(Result.ParamNames,0);
     while (i<=l)and(s[i]<>' ')and(s[i]<>#9) do 
      begin
       Result.Name+=s[i]; 
       inc(i); 
      end; 
     //read parameters 
     while i<=l do 
      begin
       l2:=Length(Result.Params); 
       SetLength(Result.Params,l2+1); 
       SetLength(Result.ParamNames,l2+1); 
       while (i<=l)and(s[i]=' ') do inc(i);//skip spaces 
       Result.ParamNames[l2]:='';//init to null 
       while (i<=l)and(s[i]<>'=')and(s[i]<>' ') do    
        begin
         Result.ParamNames[l2]+=s[i]; 
         inc(i); 
        end; 
       while (i<=l)and(s[i]=' ') do inc(i);//skip spaces 
       inc(i);//skip equal sign 
       while (i<=l)and(s[i]=' ') do inc(i);//skip spaces 
       done:=false; 
       qo:=false;
       dqo:=false; 
       oi:=i; 
       //skip until you get a non-string '>" or " " caracter 
       while not done do
        begin
         if ((qo)or(dqo))and(s[i]='\') then inc(i,2);//skip me a river 
         if (s[i]='"')and(not qo)then dqo:=not(dqo);
         if (s[i]='''')and(not dqo)then qo:=not(qo);
         if (i=l)or(not(qo or dqo)and((s[i]='>')or(s[i]=' '))) then done:=true; 
         inc(i); 
        end; 
       Result.Params[l2]:=Trim(Copy(s,oi,i-oi)); 
      end; 
end; 

//a scanner would've been great, but in the absence of one, this will have to do 
function THTMLNodeGraphBuilder.FileOpenAndReadEveryFuckingThingAsOneFuckingLine(name:ansistring):ansistring;
var f:text; 
    c:ansistring; 
begin
     assign(f,name);
     reset(f);
     Result:='';
     while not eof(f) do 
      begin
       readln(f,c);//skip ALL eoln markers; we don't need them, thanks 
       Result+=c; 
      end; 
     close(f); 
end; 

function THTMLNodeGraphBuilder.getSubTagValue(tag:TTag;subname:ansistring):ansistring;
var p:ansistring; 
    i:integer; 
begin
     p:=UpCase(subname);
     for i:=0 to length(tag.params)-1 do 
      if UpCase(tag.paramnames[i])=p then
       begin
        if (tag.params[i][1]='''')or(tag.params[i][1]='"' ) then exit(Copy(tag.params[i],2,length(tag.params[i])-2)) 
                                                            else exit(tag.params[i]); 
       end; 
     result:='-1'; 
end; 

function THTMLNodeGraphBuilder.ParseFileName(filename:ansistring):ansistring;
var i:integer; 
begin
     for i:=1 to length(filename) do 
      if filename[i]='#' then Exit(Copy(filename,1,i-1));
     result:=filename; 
end; 

procedure THTMLNodeGraphBuilder.doThisFile(filename:ansistring); 
var astr,odata,Key,NewFileDir,tmp,data,href,mytagv,myendingtagv,s:ansistring;
    idp,i,l,o:integer;
    ld,ld2:TLocationData;
    myendingtag,mytag:TTag; 
    exists:boolean;
begin
     if onFileChange<> nil then onFileChange(filename);
     s:=FileOpenAndReadEveryFuckingThingAsOneFuckingLine(filename); 
     o:=1;
     l:=length(s); 
     while o<l do
      begin
       ld:=nextTag(s,o,l); 
       mytagv:=Copy(s,ld.s+1,ld.e-ld.s-1); 
       //writeln(mytagv); 
       mytag:=Analyze(mytagv); 
       //we only care about anchors  
       href:=getSubTagValue(mytag,'href'); 
       if (upCase(mytag.name)='A')and(href<>'-1') then
        begin
         data:='';
         repeat
          ld2:=nextTag(s,o,l,data); 
          myendingtagv:=Copy(s,ld2.s+1,ld2.e-ld2.s-1); 
          myendingtag:=Analyze(myendingtagv) 
         until (o>=l)or(UpCase(myendingtag.name)='/A'); 
         tmp:=GetCurrentDir();
         NewFileDir:=ExtractFileDir(ExpandFileName(href));
         SetCurrentDir(NewFileDir); 
         Key:=ExtractRelativePath(BaseDir,GetCurrentDir())+'/'+ParseFileName(ExtractFileName(href));
         DoDirSeparators(Key);
         if FileExists(ParseFileName(ExtractFileName(href))) then
          begin
           //add the reference
           odata:=data;
           idp:=2;
           exists:=false;
           repeat
            astr:=MyAVL.Search(data);
            if astr=key then
             begin
              exists:=true;
              break;
             end        else
             begin
              if astr='-1' then break;
              data:=odata+' ('+IntToStr(idp)+')';
              inc(idp);
             end;
           until false;
           if not exists then MyAVL.Insert(data,key);
           //check wether to process the file
           if not CheckedFilesAVL.KeyExists(key)  then
            begin
             CheckedFilesAVL.Insert(key,'');
             doThisFile(ParseFileName(ExtractFileName(href)));
            end;
          end;
         SetCurrentdir(tmp);           
        end;
      end; 
end; 

procedure THTMLNodeGraphBuilder.BuildNodeGraph(filename:ansistring);
var odir:ansistring; 
begin
     MyAVL:=TAVLTree.Create();
     CheckedFilesAVL:=TAVLTree.Create();
     odir:=GetCurrentDir();//save state 
     basedir:=ExtractFileDir(filename)+'\'; 
     DoDirSeparators(basedir); 
     SetCurrentDir(basedir); 
     CheckedFilesAVL.Insert(ExtractFileName(filename),'');
     doThisFile(ExtractFileName(filename));
     SetCurrentDir(odir);//restore state 
     MyAVL.SaveToFile(filename+'.index');
     MyAVL.Destroy();
     CheckedFilesAVL.Destroy();
end;

end. 

     


