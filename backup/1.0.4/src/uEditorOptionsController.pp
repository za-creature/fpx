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

unit uEditorOptionsController;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Graphics, SyneditTypes, IniFiles, Synedit,
  SynHighlighterPas, LCLType;
  
{$i structures.inc}

type TEditorOptions=class(TObject)
      conf:TInifile;
      highlighter:TSynPasSyn;
      //window
      window_top,window_left,window_width,window_height:integer;
      window_maximized:boolean;
      //breakpoint window
      bpw_top,bpw_left,bpw_width,bpw_height:integer;
      bpw_visible:boolean;
      //callstack window
      csw_top,csw_left,csw_width,csw_height:integer;
      csw_visible:boolean;
      //registers window
      rgw_top,rgw_left,rgw_width,rgw_height:integer;
      rgw_visible:boolean;
      //watchlist window
      wlw_top,wlw_left,wlw_width,wlw_height:integer;
      wlw_visible:boolean;
      //disassembly window
      daw_top,daw_left,daw_width,daw_height:integer;
      daw_visible:boolean;
      //ascii table
      at_top,at_left:integer;
      at_visible:boolean;
      //messages
      ms_height:integer;
      ms_visible:boolean;
      //process list window
      plw_top,plw_left,plw_width,plw_height:integer;
      plw_visible:boolean;
      //evaluator window
      evw_top,evw_left,evw_width,evw_height:integer;
      evw_visible:boolean;
      //bookmarks
      bmw_top,bmw_left,bmw_width,bmw_height:integer;
      bmw_visible:boolean;
      bookmarks:array of TBookmarkDataSet;
      sbooks:TList;
      //env
      //windowState:integer;
      browser_style,code_style,asm_output,target_processor,asm_style:integer;//radio
      call_linker_after,only_link_to_static:boolean;
      primary_file,heap_size,stack_size,lib_type:integer;
      mode:integer;
      bin_directory,unit_output_dir,exe_output_dir,object_dir,library_dir,
      include_dir,unit_dir,compilerdir,exeparams,rundir:string;
      objectpascal_support,c_macros,bp7_compatibility,c_operators,
      delphi_compatibility,stop_after_first_error,static_in_objects,label_goto,
      c_inline:boolean;
      register_variables,uncertain_opt,level1_opt,level2_opt:boolean;
      v_warnings,v_notes,v_hints,v_used,v_general,v_all,v_allproc:boolean;
      range_checking,stack_checking,io_checking,integer_overflow_checking:boolean;
      asm_source,asm_register_alloc,asm_temp_alloc:boolean;
      syntax_highlight:TSynArray;
      //editor_options
      auto_indent,tab_indent,auto_indent_on_paste,drag_and_drop,drop_files,
      enhance_home,no_caret,smart_tabs,tabs_to_spaces,double_click_selects_line,
      right_mouse_moves_cursor,line_numbers,scroll_by_one_less,highlight_brackets,
      insert_mode,view_toolbar:boolean;
      target:integer;
      op:TSynSearchOptions;
      //debug options
      debuginfo,profileinfo:integer;
      //help files
      defaulthelp,numhelpfiles:integer;
      helpfiles:array of string;

      font_name:string;
      font_size:integer;
      constructor Create(filename:string);
      destructor Destroy();override;
      procedure Setup(t:TSynEdit);
      function GetParams():string;
      procedure Updatehighlighter();
     private
      procedure ReadSyntax(id:integer;fg,bg:TColor;fs:TFontStyles);
      procedure WriteSyntax(id:integer);
     end;

implementation

function strval(n:integer):string;inline;
begin
 str(n,strval);
end;

procedure TEditorOptions.UpdateHighlighter();
begin
 highlighter.AsmAttri.Background:=syntax_highlight[0].bg;
 highlighter.AsmAttri.Foreground:=syntax_highlight[0].fg;
 highlighter.AsmAttri.Style:=syntax_highlight[0].style;

 highlighter.CommentAttri.Background:=syntax_highlight[1].bg;
 highlighter.CommentAttri.Foreground:=syntax_highlight[1].fg;
 highlighter.CommentAttri.Style:=syntax_highlight[1].Style;

 highlighter.DirectiveAttri.Background:=syntax_highlight[2].bg;
 highlighter.DirectiveAttri.Foreground:=syntax_highlight[2].fg;
 highlighter.DirectiveAttri.Style:=syntax_highlight[2].style;

 highlighter.IdentifierAttri.Background:=syntax_highlight[3].bg;
 highlighter.IdentifierAttri.Foreground:=syntax_highlight[3].fg;
 highlighter.IdentifierAttri.Style:=syntax_highlight[3].style;

 highlighter.KeyAttri.Background:=syntax_highlight[4].bg;
 highlighter.KeyAttri.Foreground:=syntax_highlight[4].fg;
 highlighter.KeyAttri.Style:=syntax_highlight[4].style;

 highlighter.NumberAttri.Background:=syntax_highlight[5].bg;
 highlighter.NumberAttri.Foreground:=syntax_highlight[5].fg;
 highlighter.NumberAttri.Style:=syntax_highlight[5].style;

 highlighter.SpaceAttri.Background:=syntax_highlight[6].bg;
 highlighter.SpaceAttri.Foreground:=syntax_highlight[6].fg;
 highlighter.SpaceAttri.Style:=syntax_highlight[6].style;

 highlighter.StringAttri.Background:=syntax_highlight[7].bg;
 highlighter.StringAttri.Foreground:=syntax_highlight[7].fg;
 highlighter.StringAttri.Style:=syntax_highlight[7].style;

 highlighter.SymbolAttri.Background:=syntax_highlight[8].bg;
 highlighter.SymbolAttri.Foreground:=syntax_highlight[8].fg;
 highlighter.SymbolAttri.Style:=syntax_highlight[8].style;
end;

procedure TEditorOptions.ReadSyntax(id:integer;fg,bg:TColor;fs:TFontStyles);
var b,i,u:boolean;
    t:TFontStyles;
begin
 syntax_highlight[id].fg:=conf.ReadInteger('syntax-highlighting','fg-'+strval(id),fg);
 syntax_highlight[id].bg:=conf.ReadInteger('syntax-highlighting','bg-'+strval(id),bg);
 b:=conf.ReadBool('syntax-highlighting','b-'+strval(id),fsBold in fs);
 i:=conf.ReadBool('syntax-highlighting','i-'+strval(id),fsItalic in fs);
 u:=conf.ReadBool('syntax-highlighting','u-'+strval(id),fsUnderline in fs);
 t:=[];
 if b then t:=[fsBold];
 if u then t+=[fsUnderline];
 if i then t+=[fsItalic];
 syntax_highlight[id].style:=t;
end;

procedure TEditorOptions.WriteSyntax(id:integer);
begin
 conf.WriteInteger('syntax-highlighting','fg-'+strval(id),syntax_highlight[id].fg);
 conf.WriteInteger('syntax-highlighting','bg-'+strval(id),syntax_highlight[id].bg);
 conf.WriteBool('syntax-highlighting','b-'+strval(id),fsBold in syntax_highlight[id].style);
 conf.WriteBool('syntax-highlighting','i-'+strval(id),fsItalic in syntax_highlight[id].style);
 conf.WriteBool('syntax-highlighting','u-'+strval(id),fsUnderline in syntax_highlight[id].style);
end;

constructor TEditorOptions.Create(filename:string);
var b:boolean;
    bl,i:integer;
begin
  highlighter:=TSynPasSyn.Create(nil);
  conf:=TInifile.Create(filename);
  
  window_top:=               conf.ReadInteger('window','top',0);
  window_left:=              conf.ReadInteger('window','left',0);
  window_width:=             conf.ReadInteger('window','width',800);
  window_height:=            conf.ReadInteger('window','height',600);
  window_maximized:=         conf.ReadBool   ('window','maximized',false);
  //breakpoint window
  bpw_top:=                  conf.ReadInteger('window','breakpoint-top',265);
  bpw_left:=                 conf.ReadInteger('window','breakpoint-left',0);
  bpw_width:=                conf.ReadInteger('window','breakpoint-width',400);
  bpw_height:=               conf.ReadInteger('window','breakpoint-height',150);
  bpw_visible:=              conf.ReadBool   ('window','breakpoint-visible',false);
  //callstack window
  csw_top:=                  conf.ReadInteger('window','callstack-top',80);
  csw_left:=                 conf.ReadInteger('window','callstack-left',400);
  csw_width:=                conf.ReadInteger('window','callstack-width',400);
  csw_height:=               conf.ReadInteger('window','callstack-height',150);
  csw_visible:=              conf.ReadBool   ('window','callstack-visible',false);
  //registers window
  rgw_top:=                  conf.ReadInteger('window','registers-top',500);
  rgw_left:=                 conf.ReadInteger('window','registers-left',400);
  rgw_width:=                conf.ReadInteger('window','registers-width',300);
  rgw_height:=               conf.ReadInteger('window','registers-height',200);
  rgw_visible:=              conf.ReadBool   ('window','registers-visible',false);
  //watchlist window
  wlw_top:=                  conf.ReadInteger('window','watchlist-top',450);
  wlw_left:=                 conf.ReadInteger('window','watchlist-left',0);
  wlw_width:=                conf.ReadInteger('window','watchlist-width',400);
  wlw_height:=               conf.ReadInteger('window','watchlist-height',150);
  wlw_visible:=              conf.ReadBool   ('window','watchlist-visible',false);
  //disassembly window
  daw_top:=                  conf.ReadInteger('window','disassembly-top',80);
  daw_left:=                 conf.ReadInteger('window','disassembly-left',0);
  daw_width:=                conf.ReadInteger('window','disassembly-width',400);
  daw_height:=               conf.ReadInteger('window','disassembly-height',150);
  daw_visible:=              conf.ReadBool   ('window','disassembly-visible',false);
  //process list window
  plw_top:=                  conf.ReadInteger('window','processlist-top',0);
  plw_left:=                 conf.ReadInteger('window','processlist-left',0);
  plw_width:=                conf.ReadInteger('window','processlist-width',0);
  plw_height:=               conf.ReadInteger('window','processlist-height',0);
  plw_visible:=              conf.ReadBool   ('window','processlist-visible',false);
  //evaluator window
  evw_top:=                  conf.ReadInteger('window','evaluator-top',0);
  evw_left:=                 conf.ReadInteger('window','evaluator-left',0);
  evw_width:=                conf.ReadInteger('window','evaluator-width',0);
  evw_height:=               conf.ReadInteger('window','evaluator-height',0);
  evw_visible:=              conf.ReadBool   ('window','evaluator-visible',false);
  //bookmarks window
  bmw_top:=                  conf.ReadInteger('window','bookmarks-top',100);
  bmw_left:=                 conf.ReadInteger('window','bookmarks-left',272);
  bmw_width:=                conf.ReadInteger('window','bookmarks-width',400);
  bmw_height:=               conf.ReadInteger('window','bookmarks-height',150);
  bmw_visible:=              conf.ReadBool   ('window','bookmarks-visible',false);

  font_name:=                conf.ReadString ('editor','font-face',{$IFDEF WIN32}'courier new'{$ELSE}'courier'{$ENDIF});
  font_size:=                conf.ReadInteger('editor','font-size',10);
  insert_mode:=              conf.ReadBool   ('editor','insert',true);
  auto_indent:=              conf.readBool   ('editor','auto-indent',true);
  tab_indent:=               conf.readBool   ('editor','tab-indent',true);
  auto_indent_on_paste:=     conf.readBool   ('editor','auto-indent-on-paste',true);
  drag_and_drop:=            conf.readBool   ('editor','drag-and-drop',false);
  drop_files:=               conf.readBool   ('editor','drop-files',false);
  enhance_home:=             conf.readBool   ('editor','enhance-home-key',true);
  no_caret:=                 conf.readBool   ('editor','no-caret',false);
  smart_tabs:=               conf.readBool   ('editor','smart-tabs',true);
  tabs_to_spaces:=           conf.readBool   ('editor','tabs-to-spaces',true);
  double_click_selects_line:=conf.readBool   ('editor','d-click-selects-line',true);
  right_mouse_moves_cursor:= conf.readBool   ('editor','r-mouse-moves-cursor',false);;
  line_numbers:=             conf.readBool   ('editor','show-line-numbers',true);
  view_toolbar:=             conf.readBool   ('editor','show-toolbar',true);
  scroll_by_one_less:=       conf.readBool   ('editor','scroll-by-one-less',true);
  highlight_brackets:=       conf.readBool   ('editor','bracket-highlight',true);
  ms_visible:=               conf.Readbool   ('editor','show-messages',false);
  ms_height:=                conf.ReadInteger('editor','messages-height',116);

  bin_directory:=            conf.ReadString ('compiler','bin-directory','');
  target:=                   conf.ReadInteger('compiler','target',{$IFDEF WIN32}3{$ELSE}1{$ENDIF});
  
  objectpascal_support:=     conf.ReadBool   ('syntax','object-pascal-support',true);
  c_macros:=                 conf.ReadBool   ('syntax','global-C-macros',true);
  bp7_compatibility:=        conf.ReadBool   ('syntax','borland-pascal-compatibility',false);
  c_operators:=              conf.ReadBool   ('syntax','C-operators',true);
  delphi_compatibility:=     conf.ReadBool   ('syntax','delphi-compatibility',false);
  stop_after_first_error:=   conf.ReadBool   ('syntax','Stop-after-error',false);
  static_in_objects:=        conf.ReadBool   ('syntax','allow-static-in-objects',true);
  label_goto:=               conf.ReadBool   ('syntax','allow-label-goto',true);
  c_inline:=                 conf.ReadBool   ('syntax','allow-C++-style-inline',true);
  
  register_variables:=       conf.ReadBool   ('optimizations','register-variables',true);
  uncertain_opt:=            conf.ReadBool   ('optimizations','uncertain-optimizations',false);
  level1_opt:=               conf.ReadBool   ('optimizations','fast-optimizations',true);
  level2_opt:=               conf.ReadBool   ('optimizations','slower-optimizations',true);
  code_style:=               conf.ReadInteger('optimizations','code-generation-style',1);//faster or smaller code
  target_processor:=         conf.ReadInteger('optimizations','target-processor',0);
  
  v_warnings:=               conf.ReadBool   ('verbose','warnings',true);
  v_notes:=                  conf.ReadBool   ('verbose','notes',false);
  v_hints:=                  conf.ReadBool   ('verbose','hints',false);
  v_used:=                   conf.ReadBool   ('verbose','usedinfo',false);
  v_general:=                conf.ReadBool   ('verbose','general-info',false);
  v_all:=                    conf.ReadBool   ('verbose','all',false);
  v_allproc:=                conf.ReadBool   ('verbose','show-all-proc',false);
  
  range_checking:=           conf.ReadBool   ('runtime-checks','range',true);
  stack_checking:=           conf.ReadBool   ('runtime-checks','stack',true);
  io_checking:=              conf.ReadBool   ('runtime-checks','io',true);
  integer_overflow_checking:=conf.ReadBool   ('runtime-checks','integer-overflow',true);
  
  asm_source:=               conf.ReadBool   ('assembler','list-source',false);
  asm_register_alloc:=       conf.ReadBool   ('assembler','list-register-alloc',false);
  asm_temp_alloc:=           conf.ReadBool   ('assembler','list-temp-alloc',false);
  browser_style:=            conf.ReadInteger('browser','style',0);
  asm_output:=               conf.ReadInteger('assembler','output',0);
  asm_style:=                conf.ReadInteger('assembler','style',0);

  unit_output_dir:=          conf.ReadString ('directories','unit-output','');
  exe_output_dir:=           conf.ReadString ('directories','exe-output','');
  object_dir:=               conf.ReadString ('directories','object','');
  library_dir:=              conf.ReadString ('directories','library','');
  include_dir:=              conf.ReadString ('directories','include','');
  library_dir:=              conf.ReadString ('directories','unit','');
  
  debuginfo:=                conf.ReadInteger('debugger','debuginfo',0);
  profileinfo:=              conf.ReadInteger('debugger','profileinfo',0);
  
  //bookmarks
  
  bl:=                       conf.ReadInteger('bookmarks','count',0);
  setLength(bookmarks,bl);
  for i:=0 to bl-1 do
   begin
    bookmarks[i].filename:=  conf.ReadString ('bookmarks','file'+IntToStr(i),'');
    bookmarks[i].line:=      conf.ReadInteger('bookmarks','line'+IntToStr(i),0);
    bookmarks[i].column:=    conf.ReadInteger('bookmarks','column'+IntToStr(i),0);
    bookmarks[i].caption:=   conf.ReadString ('bookmarks','caption'+IntToStr(i),'');
   end;

  //help files

  numhelpfiles:=             conf.ReadInteger('help','numfiles',0);
  defaulthelp:=              conf.readInteger('help','defaultfile',-1);
  setlength(helpfiles,numhelpfiles);
  for i:=0 to numhelpfiles-1 do
   helpfiles[i]:=            conf.readString('help','file-'+IntToStr(i),'');

  //syntax highlighting (aka colors-menu)
  ReadSyntax(0,clPurple,clWhite,[fsBold]); //asm
  ReadSyntax(1,clGreen,clWhite,[fsItalic]);//comment
  ReadSyntax(2,clTeal,clWhite,[fsBold]);   //directive
  ReadSyntax(3,clBlack,clWhite,[]);        //identifier
  ReadSyntax(4,clBlue,clWhite,[fsBold]);   //keywords
  ReadSyntax(5,$00FF8000,clWhite,[]);      //numbers
  ReadSyntax(6,clBlack,clWhite,[]);        //spaces
  ReadSyntax(7,clRed,clWhite,[]);          //strings
  ReadSyntax(8,clRed,clWhite,[]);          //symbols

  

  UpdateHighlighter;

  inherited Create();
end;

destructor TEditorOptions.Destroy();
var i:integer;
begin
 conf.WriteInteger('window','top',window_top);
 conf.WriteInteger('window','left',window_left);
 conf.WriteInteger('window','width',window_width);
 conf.WriteInteger('window','height',window_height);
 conf.WriteBool   ('window','maximized',window_maximized);
 //breakpoint window
 conf.WriteInteger('window','breakpoint-top',bpw_top);
 conf.WriteInteger('window','breakpoint-left',bpw_left);
 conf.WriteInteger('window','breakpoint-width',bpw_width);
 conf.WriteInteger('window','breakpoint-height',bpw_height);
 conf.WriteBool   ('window','breakpoint-visible',bpw_visible);
 //callstack window
 conf.WriteInteger('window','callstack-top',csw_top);
 conf.WriteInteger('window','callstack-left',csw_left);
 conf.WriteInteger('window','callstack-width',csw_width);
 conf.WriteInteger('window','callstack-height',csw_height);
 conf.WriteBool   ('window','callstack-visible',csw_visible);
 //registers window
 conf.WriteInteger('window','registers-top',rgw_top);
 conf.WriteInteger('window','registers-left',rgw_left);
 conf.WriteInteger('window','registers-width',rgw_width);
 conf.WriteInteger('window','registers-height',rgw_height);
 conf.WriteBool   ('window','registers-visible',rgw_visible);
 //watchlist window
 conf.WriteInteger('window','watchlist-top',wlw_top);
 conf.WriteInteger('window','watchlist-left',wlw_left);
 conf.WriteInteger('window','watchlist-width',wlw_width);
 conf.WriteInteger('window','watchlist-height',wlw_height);
 conf.WriteBool   ('window','watchlist-visible',wlw_visible);
 //disassembly window
 conf.WriteInteger('window','disassembly-top',daw_top);
 conf.WriteInteger('window','disassembly-left',daw_left);
 conf.WriteInteger('window','disassembly-width',daw_width);
 conf.WriteInteger('window','disassembly-height',daw_height);
 conf.WriteBool   ('window','disassembly-visible',daw_visible);
 //process list window
 conf.WriteInteger('window','processlist-top',plw_top);
 conf.WriteInteger('window','processlist-left',plw_left);
 conf.WriteInteger('window','processlist-width',plw_width);
 conf.WriteInteger('window','processlist-height',plw_height);
 conf.WriteBool   ('window','processlist-visible',plw_visible);
 //evaluator window
 conf.WriteInteger('window','evaluator-top',evw_top);
 conf.WriteInteger('window','evaluator-left',evw_left);
 conf.WriteInteger('window','evaluator-width',evw_width);
 conf.WriteInteger('window','evaluator-height',evw_height);
 conf.WriteBool   ('window','evaluator-visible',evw_visible);
 //bookmarks window
 conf.WriteInteger('window','bookmarks-top',bmw_top);
 conf.WriteInteger('window','bookmarks-left',bmw_left);
 conf.WriteInteger('window','bookmarks-width',bmw_width);
 conf.WriteInteger('window','bookmarks-height',bmw_height);
 conf.WriteBool   ('window','bookmarks-visible',bmw_visible);
 
 //bookmarks

 conf.WriteInteger('bookmarks','count',sbooks.Count);
 for i:=0 to sbooks.Count-1 do
  with TCustomBookmark(sbooks[i]) do
   begin
    conf.WriteString('bookmarks','file'+IntToStr(i),filename);
    conf.WriteInteger('bookmarks','line'+IntToStr(i),linenumber);
    conf.WriteInteger('bookmarks','column'+IntToStr(i),columnnumber);
    conf.WriteString('bookmarks','caption'+IntToStr(i),caption);
   end;

 
 conf.WriteString ('editor','font-face',font_name);
 conf.WriteInteger('editor','font-size',font_size);
 conf.WriteBool   ('editor','insert',insert_mode);
 conf.WriteBool   ('editor','auto-indent', auto_indent);
 conf.WriteBool   ('editor','tab-indent',tab_indent);
 conf.WriteBool   ('editor','auto-indent-on-paste',auto_indent_on_paste);
 conf.WriteBool   ('editor','drag-and-drop',drag_and_drop);
 conf.WriteBool   ('editor','drop-files',drop_files);
 conf.WriteBool   ('editor','enhance-home-key',enhance_home);
 conf.WriteBool   ('editor','no-caret',no_caret);
 conf.WriteBool   ('editor','smart-tabs',smart_tabs);
 conf.WriteBool   ('editor','tabs-to-spaces',tabs_to_spaces);
 conf.WriteBool   ('editor','d-click-selects-line',double_click_selects_line);
 conf.WriteBool   ('editor','r-mouse-moves-cursor',right_mouse_moves_cursor);
 conf.WriteBool   ('editor','show-line-numbers',line_numbers);
 conf.WriteBool   ('editor','scroll-by-one-less',scroll_by_one_less);
 conf.WriteBool   ('editor','bracket-highlight',highlight_brackets);
 conf.WriteBool   ('editor','show-toolbar',view_toolbar);
 
 conf.WriteBool   ('editor','show-messages',ms_visible);
 conf.WriteInteger('editor','messages-height',ms_height);

 conf.WriteString ('compiler','bin-directory',bin_directory);
 conf.WriteInteger('compiler','target',target);
 
 conf.WriteBool   ('syntax','object-pascal-support',objectpascal_support);
 conf.WriteBool   ('syntax','global-C-macros',c_macros);
 conf.WriteBool   ('syntax','borland-pascal-compatibility',bp7_compatibility);
 conf.WriteBool   ('syntax','C-operators',c_operators);
 conf.WriteBool   ('syntax','delphi-compatibility',delphi_compatibility);
 conf.WriteBool   ('syntax','Stop-after-error',stop_after_first_error);
 conf.WriteBool   ('syntax','allow-static-in-objects',static_in_objects);
 conf.WriteBool   ('syntax','allow-label-goto',label_goto);
 conf.WriteBool   ('syntax','allow-C++-style-inline',c_inline);
 
 conf.WriteBool   ('optimizations','register-variables',register_variables);
 conf.WriteBool   ('optimizations','uncertain-optimizations',uncertain_opt);
 conf.WriteBool   ('optimizations','fast-optimizations',level1_opt);
 conf.WriteBool   ('optimizations','slower-optimizations',level2_opt);
 conf.WriteInteger('optimizations','code-generation-style',code_style);//faster or smaller code
 conf.WriteInteger('optimizations','target-processor',target_processor);

 conf.WriteBool   ('verbose','warnings',v_warnings);
 conf.WriteBool   ('verbose','notes',v_notes);
 conf.WriteBool   ('verbose','hints',v_hints);
 conf.WriteBool   ('verbose','usedinfo',v_used);
 conf.WriteBool   ('verbose','general-info',v_general);
 conf.WriteBool   ('verbose','all',v_all);
 conf.WriteBool   ('verbose','show-all-proc',v_allproc);
 
 conf.WriteBool   ('runtime-checks','range',range_checking);
 conf.WriteBool   ('runtime-checks','stack',stack_checking);
 conf.WriteBool   ('runtime-checks','io',io_checking);
 conf.WriteBool   ('runtime-checks','integer-overflow',integer_overflow_checking);
 
 conf.WriteBool   ('assembler','list-source',asm_source);
 conf.WriteBool   ('assembler','list-register-alloc',asm_register_alloc);
 conf.WriteBool   ('assembler','list-temp-alloc',asm_temp_alloc);
 conf.WriteInteger('assembler','output',asm_output);
 conf.WriteInteger('assembler','style',asm_style);
 
 conf.WriteInteger('browser','style',browser_style);

 conf.WriteString ('directories','unit-output',unit_output_dir);
 conf.WriteString ('directories','exe-output',exe_output_dir);
 conf.WriteString ('directories','object',object_dir);
 conf.WriteString ('directories','library',library_dir);
 conf.WriteString ('directories','include',include_dir);
 conf.WriteString ('directories','unit',library_dir);
 
 conf.WriteInteger('debugger','debuginfo',debuginfo);
 conf.WriteInteger('debugger','profileinfo',profileinfo);
 
 conf.WriteInteger('help','numfiles',numhelpfiles);
 conf.WriteInteger('help','defaultfile',defaulthelp);
 for i:=0 to numhelpfiles-1 do
  conf.WriteString('help','file-'+IntToStr(i),helpfiles[i]);


 for i:=0 to 8 do WriteSyntax(i);

 highlighter.Destroy();
 conf.UpdateFile();
 conf.Destroy();
end;

procedure TEditorOptions.Setup(t:TSynEdit);
var eop:TSynEditorOptions;
begin
     eop:=[eoAutoSizeMaxScrollWidth];
     if auto_indent then eop+=[eoAutoIndent];
     if drag_and_drop then eop+=[eoDragDropEditing];
     if drop_files then eop+=[eoDropFiles];
     if tab_indent then eop+=[eoTabIndent];
     if auto_indent_on_paste then eop+=[eoAutoIndentOnPaste];
     if enhance_home then eop+=[eoEnhanceHomeKey];
     if no_caret then eop+=[eoNoCaret];
     if smart_tabs then
      begin
       eop+=[eoSmartTabs];
       eop+=[eoSmartTabDelete];
      end;
     if tabs_to_spaces then eop+=[eoTabsToSpaces];
     if double_click_selects_line then eop+=[eoDoubleClickSelectsLine];
     if right_mouse_moves_cursor then eop+=[eoRightMouseMovesCursor];
     if line_numbers then
      begin
       t.Gutter.Width:=30;
       t.gutter.ShowLineNumbers:=true;
      end
                     else
      begin
       t.Gutter.Width:=10;
       t.gutter.ShowLineNumbers:=false;
      end;
     if scroll_by_one_less then eop+=[eoScrollByOneLess];
     if highlight_brackets then eop+=[eoBracketHighlight];
     t.Options:=eop;
     t.InsertMode:=insert_mode;
     t.highlighter:=highlighter;
     t.Font.Name:=font_name;
     t.font.size:=font_size;
     t.Refresh;
end;

function TEditorOptions.getparams():string;
const asmout:array[0..8] of string=('',' -Aas',' -Anasmcoff',' -Anasmelf',' -Anasmwin32',' -Amasm',' -Atasm',' -Acoff',' -Apecoff');
      asmsyntax:array[0..2] of string=(' -Rdefault',' -Ratt',' -Rintel');
      targets:Array[0..12] of string=(' -Tgo32v2',' -Tlinux',' -Tos2',' -Twin32',' -Tfreebsd',' -Tsunos',' -Tnetbsd',' -Tnetware',' -Twdosx',' -Topenbsd',' -Temx',' -TWatcom',' -Tnetwlibc');
      debug:array[0..3] of string=('',' -gg',' -gl',' -gv');
      ds={$IFDEF WIN32}'\'{$ELSE}'/'{$ENDIF};
begin
 getparams:='';
 if mode=0 then
  begin
    //normal mode
    //browser
    if browser_style=1 then getparams+=' -bl'else
    if browser_style=2 then getparams+=' -b';
    //assembler
    getparams+=asmout[asm_output];
    getparams+=' -Op'+strval(target_processor+1);
    getparams+=asmsyntax[asm_style];
    //memory sizes
    if heap_size>0 then getparams+=' -Ch'+strval(heap_size);
    if stack_size>0 then getparams+=' -Cs'+strval(stack_size);
    //linker
    if only_link_to_static then getparams+=' -Xt';
    if lib_type=2 then getparams+=' -XD' else
    if lib_type=3 then getparams+=' -XX' else
                       getparams+=' -XS';
    //directories
    if exe_output_dir<>'' then getparams+=' -FE"'+exe_output_dir+'"';
    if unit_output_dir<>'' then getparams+=' -FU"'+unit_output_dir+'"';
    if include_dir<>'' then getparams+=' -Fi"'+include_dir+'"';
    if unit_dir<>'' then getparams+=' -Fu"'+unit_dir+'"';
    if library_dir<>'' then getparams+=' -Fl"'+library_dir+'"';
    if object_dir<>'' then getparams+=' -Fo"'+object_dir+'"';
    //syntax
    if objectpascal_support then getparams+=' -S2';
    if c_macros then getparams+=' -Sm';
    if bp7_compatibility then getparams+=' -Mtp';
    if c_operators then getparams+=' -Sc';
    if delphi_compatibility then getparams+=' -Sd';
    if stop_after_first_error then getparams+=' -Se1'
                   else getparams+=' -Se50';
    if static_in_objects then getparams+=' -St';
    if c_inline then getparams+=' -Si';
    if label_goto then getparams+=' -Sg';
    //optimizations
    if code_style=0 then getparams+=' -Og'
         else getparams+=' -OG';
    if register_variables then getparams+=' -Or';
    if uncertain_opt then getparams+=' -Ou';
    if level1_opt then getparams+=' -O1';
    if level2_opt then getparams+=' -O2';
    //verbose
    getparams+=' -v0';
    if v_warnings then getparams+=' -vw';
    if v_notes then getparams+=' -vn';
    if v_hints then getparams+=' -vh';
    if v_used then getparams+=' -vt';
    if v_general then getparams+=' -vi';
    if v_all then getparams+=' -va';
    if v_allproc then getparams+=' -vd';//I think
    //runtime checks
    if range_checking then getparams+=' -Cr';
    if stack_checking then getparams+=' -Ct';
    if io_checking then getparams+=' -Ci';
    if integer_overflow_checking then getparams+=' -Co';
    //asm info
    if asm_source then getparams+=' -al';
    if asm_register_alloc then getparams+=' -ar';
    if asm_temp_alloc then getparams+=' -at';
    //debugger
    getparams+=debug[debuginfo];
    //target
    getparams+=targets[target]+' ';
  end                            else
 if mode=1 then
  begin
    //debug mode
    //browser
    if browser_style=1 then getparams+=' -bl'else
    if browser_style=2 then getparams+=' -b';
    //assembler
    getparams+=asmout[asm_output];
    getparams+=' -Op'+strval(target_processor+1);
    getparams+=asmsyntax[asm_style];
    //memory sizes
    if heap_size>0 then getparams+=' -Ch'+strval(heap_size);
    if stack_size>0 then getparams+=' -Cs'+strval(stack_size);
    //linker
    if only_link_to_static then getparams+=' -Xt';
    if lib_type=2 then getparams+=' -XD' else
    if lib_type=3 then getparams+=' -XX' else
                       getparams+=' -XS';
    //directories
    if exe_output_dir<>'' then getparams+=' -FE"'+exe_output_dir+'"';
    if unit_output_dir<>'' then getparams+=' -FU"'+unit_output_dir+'"';
    if include_dir<>'' then getparams+=' -Fi"'+include_dir+'"';
    if unit_dir<>'' then getparams+=' -Fu"'+unit_dir+'"';
    if library_dir<>'' then getparams+=' -Fl"'+library_dir+'"';
    if object_dir<>'' then getparams+=' -Fo"'+object_dir+'"';
    //syntax
    if objectpascal_support then getparams+=' -S2';
    if c_macros then getparams+=' -Sm';
    if bp7_compatibility then getparams+=' -Mtp';
    if c_operators then getparams+=' -Sc';
    if delphi_compatibility then getparams+=' -Sd';
    if stop_after_first_error then getparams+=' -Se1'
                              else getparams+=' -Se50';
    if static_in_objects then getparams+=' -St';
    if c_inline then getparams+=' -Si';
    if label_goto then getparams+=' -Sg';
    //optimizations
    
    //No optimizations since we're debugging
    
    //if code_style=0 then getparams+=' -Og'
    //                else getparams+=' -OG';
    //if register_variables then getparams+=' -Or';
    //if uncertain_opt then getparams+=' -Ou';
    //if level1_opt then getparams+=' -O1';
    //if level2_opt then getparams+=' -O2';
    
    //verbose
    getparams+=' -v0';
    if v_warnings then getparams+=' -vw';
    if v_notes then getparams+=' -vn';
    if v_hints then getparams+=' -vh';
    if v_used then getparams+=' -vt';
    if v_general then getparams+=' -vi';
    if v_all then getparams+=' -va';
    if v_allproc then getparams+=' -vd';//I think
    //runtime checks
    if range_checking then getparams+=' -Cr';
    if stack_checking then getparams+=' -Ct';
    if io_checking then getparams+=' -Ci';
    if integer_overflow_checking then getparams+=' -Co';
    //asm info
    if asm_source then getparams+=' -al';
    if asm_register_alloc then getparams+=' -ar';
    if asm_temp_alloc then getparams+=' -at';
    //debugger
    getparams+=' -gl';
    //target
    getparams+=targets[target]+' ';
  end;

end;


end.

