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

unit uMain;

{$mode objfpc}{$H+}

interface

uses
  {$IFDEF WIN32}Windows,{$ENDIF} Classes, SysUtils, LResources, Forms, Controls,
  Graphics, Dialogs, SynEdit, SynHighlighterPas, Menus, ComCtrls, Process,
  ExtCtrls, EditBtn, ExtDlgs, StdCtrls, Buttons, SynEdittypes,
  uPrimaryFileWindow, uFindWindow, uAboutWindow, uEditorOptionsWindow,
  uEditorStyleWindow, uRuntimeParametersWindow, uGotoLineWindow, uLinkerWindow,
  uCompilerModeWindow, uDirectoriesWindow, uMemorySizesWindow,
  uCompilerOptionsWindow, uEditorOptionsController, uMessageBoxController,
  uASCIITable, uTargetWindow, uProcessListWindow, uDebugger;
  
{$IFNDEF WINDOWS}
const VK_INSERT=45;
      VK_F3 = 114;
{$ENDIF}


type
  { TMainForm }

  TMyCustomEditor=class(TSynEdit)
   public
    tname,activefilename:string;
    canreload,isunsaved:boolean;
    procedure Save();
    procedure Reload();
    procedure SaveAs();
    function RetTabName():string;
    function RetName():string;
    property reloadable:boolean read canreload;
    property unsaved:boolean read isunsaved;
    constructor Create(rldb:boolean);
  end;
  TMainForm = class(TForm)
    CloseAllMI: TMenuItem;
    CompilerOutputCloseButton: TButton;
    Calculator: TCalculatorDialog;
    CompilerOutputTitle: TLabel;
    CompilerOutput: TListBox;

    MainMenu: TMainMenu;
    
    FileMI: TMenuItem;
    CutMI: TMenuItem;
    CopyMI: TMenuItem;
    ClosePMI: TMenuItem;
    BTFPMI: TMenuItem;
    EditorPopupMenu: TPopupMenu;
    EditorCutMenu: TMenuItem;
    EditorCopyMenu: TMenuItem;
    EditorPasteMenu: TMenuItem;
    EditorSeparator: TMenuItem;
    EditorGotoMenu: TMenuItem;
    EditorPropertiesMenu: TMenuItem;
    StopDebugMI: TMenuItem;
    ProcessListMI: TMenuItem;
    PageController: TNotebook;
    SaveAsPMI: TMenuItem;
    SavePMI: TMenuItem;
    ReloadPMI: TMenuItem;
    PasteMI: TMenuItem;
    PageControllerPopupMenu: TPopupMenu;
    RunMMI: TMenuItem;
    RunMI: TMenuItem;
    StepOverMI: TMenuItem;
    MenuItem16: TMenuItem;
    MenuItem17: TMenuItem;
    OutputMI: TMenuItem;
    MessagesMI: TMenuItem;
    NewMI: TMenuItem;
    DebugMI: TMenuItem;
    NewFromTemplateMI: TMenuItem;
    ReloadMI: TMenuItem;
    SaveAllMI: TMenuItem;
    CommandShellMI: TMenuItem;
    CompileMMI: TMenuItem;
    CompileMI: TMenuItem;
    MakeMI: TMenuItem;
    OpenMI: TMenuItem;
    BuildMI: TMenuItem;
    TargetMI: TMenuItem;
    PrimaryFileMI: TMenuItem;
    ClearPrimaryFileMI: TMenuItem;
    DebugMMI: TMenuItem;
    AddWatchMI: TMenuItem;
    WatchesMI: TMenuItem;
    AddBreakpointMI: TMenuItem;
    BreakpointListMI: TMenuItem;
    CallStackMI: TMenuItem;
    SaveMI: TMenuItem;
    ToolsMI: TMenuItem;
    CalculatorMI: TMenuItem;
    ASCIITableMI: TMenuItem;
    OptionsMI: TMenuItem;
    ModeMI: TMenuItem;
    CompilerMI: TMenuItem;
    MemorySizesMI: TMenuItem;
    LinkerMI: TMenuItem;
    DebuggerMI: TMenuItem;
    DirectoriesMI: TMenuItem;
    SaveAsMI: TMenuItem;
    EnvironmentMI: TMenuItem;
    PreferencesMI: TMenuItem;
    EditorMI: TMenuItem;
    ColorsMI: TMenuItem;
    CloseMI: TMenuItem;
    TraceIntoMI: TMenuItem;
    RunDirectoryMI: TMenuItem;
    ParametersMI: TMenuItem;
    ExitMI: TMenuItem;
    MenuItem60: TMenuItem;
    SearchMI: TMenuItem;
    FindMI: TMenuItem;
    FindNextMI: TMenuItem;
    FindPreviousMI: TMenuItem;
    ReplaceMI: TMenuItem;
    GotoLineNumberMI: TMenuItem;
    HelpMI: TMenuItem;
    AboutMI: TMenuItem;
    EditMI: TMenuItem;
    UndoMI: TMenuItem;
    RedoMI: TMenuItem;
    
    OpenDialog: TOpenDialog;
    CompilerOutputPanel: TPanel;
    SaveDialog: TSaveDialog;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    
    FindPreviousSpeedButton: TSpeedButton;
    FindSpeedButton: TSpeedButton;
    FindNextSpeedButton: TSpeedButton;
    GotoLineNumberSpeedButton: TSpeedButton;
    Separator: TSpeedButton;
    Separator1: TSpeedButton;
    Separator2: TSpeedButton;
    Separator3: TSpeedButton;
    RunSpeedButton: TSpeedButton;
    CompileSpeedButton: TSpeedButton;
    NewSpeedButton: TSpeedButton;
    PasteSpeedButton: TSpeedButton;
    ReloadSpeedButton: TSpeedButton;
    OpenSpeedButton: TSpeedButton;
    CloseSpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    CutSpeedButton: TSpeedButton;
    RedoSpeedButton: TSpeedButton;
    UndoSpeedButton: TSpeedButton;
    SaveAsSpeedButton: TSpeedButton;
    CopySpeedButton: TSpeedButton;
    
    StatusBar: TStatusBar;
    
    procedure ASCIITableMIClick(Sender: TObject);
    procedure BTFPMIClick(Sender: TObject);
    procedure CloseAllMIClick(Sender: TObject);
    procedure ClosePClick(Sender: TObject);
    procedure CompileSpeedButtonClick(Sender: TObject);
    procedure CompilerOutputClick(Sender: TObject);
    procedure CompilerOutputCloseButtonClick(Sender: TObject);
    procedure FindNextSpeedButtonClick(Sender: TObject);
    procedure FindPreviousSpeedButtonClick(Sender: TObject);
    procedure FindSpeedButtonClick(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure MainFormDestroy(Sender: TObject);
    procedure GotoLineNumberSpeedButtonClick(Sender: TObject);
    procedure MainFormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure MainFormCreate(Sender: TObject);
    procedure MainFormResize(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure PageControllerMouseUp(Sender: TOBject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControllerPageChanged(Sender: TObject);
    procedure PageControllerResize(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure ProcessListMIClick(Sender: TObject);
    procedure ReloadPMIClick(Sender: TObject);
    procedure RunClick(Sender: TObject);
    procedure MessagesClick(Sender: TObject);
    procedure DebugClick(Sender: TObject);
    procedure NewFromTemplateClick(Sender: TObject);
    procedure ReloadClick(Sender: TObject);
    procedure RunSpeedButtonClick(Sender: TObject);
    procedure SaveAllCLick(Sender: TObject);
    procedure CommandShellClick(Sender: TObject);
    procedure CompileClick(Sender: TObject);
    procedure MakeClick(Sender: TObject);
    procedure NewClick(Sender: TObject);
    procedure BuildClick(Sender: TObject);
    procedure SaveAsPMIClick(Sender: TObject);
    procedure SavePMIClick(Sender: TObject);
    procedure StopDebugMIClick(Sender: TObject);
    procedure TargetClick(Sender: TObject);
    procedure PrimaryFileClick(Sender: TObject);
    procedure ClearPrimaryFileClick(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure CalculatorClick(Sender: TObject);
    procedure ModeClick(Sender: TObject);
    procedure CompilerClick(Sender: TObject);
    procedure MemorySizesClick(Sender: TObject);
    procedure LinkerClick(Sender: TObject);
    procedure DebuggerClick(Sender: TObject);
    procedure DirectoriesClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure editorstyle(Sender: TObject);
    procedure EditorClick(Sender: TObject);
    procedure ColorsClick(Sender: TObject);
    procedure CloseClick(Sender: TObject);
    procedure RunDirectoryClick(Sender: TObject);
    procedure ParametersClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure FindNextClick(Sender: TObject);
    procedure FindPreviousClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure GotoLineNumberClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure ExitClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure RedoClick(Sender: TObject);
    procedure PasteSpeedButtonClick(Sender: TObject);
    procedure ReloadSpeedButtonClick(Sender: TObject);
    procedure NewSpeedButtonClick(Sender: TObject);
    procedure OpenSpeedButtonClick(Sender: TObject);
    procedure CloseSpeedButtonClick(Sender: TObject);
    procedure SaveSpeedButtonClick(Sender: TObject);
    procedure CutSpeedButtonClick(Sender: TObject);
    procedure RedoSpeedButtonClick(Sender: TObject);
    procedure UndoSpeedButtonClick(Sender: TObject);
    procedure SaveAsSpeedButtonClick(Sender: TObject);
    procedure CopySpeedButtonClick(Sender: TObject);
    procedure EditorChange(Sender: TObject);
    procedure EditorKeydown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CutClick(Sender:Tobject);
    procedure EditorSpecialLineColors(Sender: TObject; Line: integer;var Special: boolean; var FG, BG: TColor);
    procedure Compile(filename:string);
    procedure ValidateMenus(value:boolean);

    procedure PrimaryFileWindowCallback(swc:boolean);
    procedure FindWindowCallback(swc,a:boolean);
    procedure EditorOptionsWindowCallback(swc:boolean);
    procedure EditorStyleWindowCallback(swc:boolean);
    procedure RuntimeParametersWindowCallback(swc:boolean);
    procedure GotoLineWindowCallback(swc:boolean);
    procedure LinkerWindowCallback(swc:boolean);
    procedure CompilerModeWindowCallback(swc:boolean);
    procedure DirectoriesWindowCallback(swc:boolean);
    procedure MemorySizesWindowCallback(swc:boolean);
    procedure CompilerOptionsWindowCallback(swc:boolean);
    procedure TargetWindowCallback(swc:boolean);
    procedure ASCIITableCallback(b:byte);
    procedure AboutWindowCallback();
    procedure RegisterCallbacks();
    
    procedure EditorMouseClick(Sender: TObject);
    function CloseAllEditors():boolean;
    function GetActiveEditor():TMyCustomEditor;
    function GetEditor(id:integer):TMyCustomEditor;
    procedure AddEditor();
    procedure AddEditor(filename:string);
    procedure CloseEditor(id:integer);
    function EditorsAvailable():boolean;
    
    procedure CreateProcess(filename,args,rundir:string;options:TProcessOptions);
    procedure KillProcess(id:integer);
  private
    imode:boolean;
    EditorOptions:TEditorOptions;
    um_top,um_left,um_width,um_height:integer;
    popupAMI:integer;
    Editors:TList;
    Processes:TList;
    debugger:TProgramDebugger;
    { private declarations }
  public
    { public declarations }
  end; 
var
  MainForm: TMainForm;

implementation

constructor TMyCustomEditor.Create(rldb:boolean);
begin
     inherited Create(MainForm);
     isunsaved:=false;
     canreload:=rldb;
     activefilename:='';
end;

procedure TMyCustomEditor.Save();
begin
     if activefilename='' then
      begin
       MainForm.SaveDialog.Filename:=ExtractFileDir(MainForm.SaveDialog.Filename)+ExtractFileName(activefilename);
       if MainForm.SaveDialog.Execute() then
        begin
         activefilename:=MainForm.SaveDialog.Filename;
         tname:=ExtractFileName(activefilename);
        end;
      end;
     if activefilename<>'' then
      begin
       Lines.SaveToFile(activefilename);
       isunsaved:=false;
       canreload:=true;
       MainForm.PageController.Pages.Strings[MainForm.Editors.IndexOf(self)]:=RetTabName();
       
       MainForm.ReloadMI.Enabled:=true;
       MainForm.ReloadSpeedButton.Enabled:=true;
       MainForm.ReloadPMI.Enabled:=true;
      end;
end;

procedure TMyCustomEditor.SaveAs();
begin
       MainForm.SaveDialog.Filename:=ExtractFileDir(MainForm.SaveDialog.Filename)+ExtractFileName(activefilename);
       if MainForm.SaveDialog.Execute() then
        begin
         activefilename:=MainForm.SaveDialog.Filename;
         tname:=ExtractFileName(activefilename);
         Lines.SaveToFile(activefilename);
         
         isunsaved:=false;
         canreload:=true;
         
         MainForm.PageController.Pages.Strings[MainForm.Editors.IndexOf(self)]:=RetTabName();

         MainForm.ReloadMI.Enabled:=true;
         MainForm.ReloadSpeedButton.Enabled:=true;
         MainForm.ReloadPMI.Enabled:=true;
        end;
end;

function TMyCustomEditor.RetTabName():string;
begin
     if unsaved then RetTabName:=tname+'*'
                else RetTabName:=tname;
end;

function TMyCustomEditor.RetName():string;
begin
     result:=tname;
end;

procedure TMyCustomEditor.Reload();
begin
  if unsaved then
   if MessageBox('You are about to reload this file from disc. Any unsaved changes will be lost. Are you sure?','Warning',0)=MR_YES then
    begin
     Lines.LoadFromFile(activefilename);
     isunsaved:=false;
     MainForm.PageController.Pages.Strings[MainForm.Editors.IndexOf(self)]:=RetTabName();
    end      else
    begin
     Lines.LoadFromFile(activefilename);
     isunsaved:=false;
     MainForm.PageController.Pages.Strings[MainForm.Editors.IndexOf(self)]:=RetTabName();
    end;
end;

function TMainForm.GetActiveEditor():TMyCustomEditor;
begin
     result:=getEditor(PageController.PageIndex);
end;

function TMainForm.getEditor(id:integer):TMyCustomEditor;
begin
     try
      result:=TMyCustomEditor(Editors.Items[id]);
     except
      result:=nil;
     end;
end;

function Exists(t:TStrings;name:string):boolean;inline;
var i:integer;
    usname:string;
begin
     usname:=name+'*';
     for i:=0 to t.count-1 do
      if (t.strings[i]=name)or(t.strings[i]=usname) then exit(true);
     exit(false);
end;

function GetUntitledName():string;
var i:integer;
begin
     i:=0;
     while exists(MainForm.PageController.Pages  ,'untitled'+IntToStr(i)+'.pp') do inc(i);
     exit('untitled'+IntToStr(i)+'.pp');
end;

function GetName(s:string):String;
var i:integer;
begin
 if not exists(MainForm.PageController.Pages,s) then exit(s);
 i:=2;
 while exists(MainForm.PageController.Pages,s+' ('+IntToStr(i)+')') do inc(i);
 exit(s+' ('+IntToStr(i)+')');
end;

function parsefilename(s:string):string;
var p:array[0..1023] of char;
{$IFNDEF WIN32}i:integer;{$ENDIF}
begin
 {$IFNDEF WIN32}
 parsefilename:='';
 for i:=1 to length(s) do
  begin
   if s[i]=' ' then parsefilename+='\';
   parsefilename+=s[i];
  end;
 {$ELSE}
 GetShortPathName(pchar(s),p,sizeof(p)-1);
 exit(String(p));
 {$ENDIF}
end;

{ TMainForm }

procedure TMainForm.CreateProcess(filename,args,rundir:string;options:TPRocessOptions);
var p:PDataContainer;
begin
     new(p);
     p^.cmdline:=filename;
     p^.args:=args;
     p^.StartStamp:=FormatDateTime('h:nn:ss',Now());
     p^.hwnd:=0;
     p^.proc:=TProcess.Create(self);
     p^.proc.CommandLine:=filename+' '+args;
     p^.proc.CurrentDirectory:=rundir;
     p^.proc.Options:=options;
     p^.proc.Execute();
     Processes.Add(p);
end;

procedure TMainForm.KillProcess(id:integer);
var p:PDataContainer;
begin
     p:=PDataContainer(Processes.Items[id]);
     if p^.proc.Running then p^.proc.Terminate(255);//killed by master
     p^.proc.Destroy();
     dispose(p);
end;

procedure TMainForm.MainFormCreate(Sender: TObject);
begin
  Processes:=TList.Create();
  Editors:=TList.Create();
  EditorOptions:=TEditorOptions.Create('editor.ini');
  
  top:=EditorOptions.window_top;
  left:=EditorOptions.window_left;
  width:=EditorOptions.window_width;
  height:=EditorOptions.window_height;

  if EditorOptions.window_maximized then WindowState:=wsMaximized
                                    else WindowState:=wsNormal;
                                    
  statusbar.panels[0].Width:=statusbar.width-224;
  
  {$IFDEF WIN32}


  if Odd(GetKeyState(vk_NumLock)) then StatusBar.Panels[4].Text := 'NUM'
                                  else StatusBar.Panels[4].Text := '';
  if Odd(GetKeyState(vk_Capital)) then StatusBar.Panels[3].Text := 'CAP'
                                  else StatusBar.Panels[3].Text := '';
  {$ENDIF}

  statusbar.panels[1].text:='Ln 0 Col 0';

  EditorOptions.primary_file:=-1;
  //Execute:=Tprocess.Create(self);

  ActiveControl:=PageController;
  
  //the parameters are handled within the RegisterCallbacks method since the components are not created here yet.
end;

function TMainForm.EditorsAvailable():boolean;
begin
     result:=PageController.PageCount>0;
end;

procedure TMainForm.RegisterCallbacks();
var i:integer;
begin
  PrimaryFileWindow.callback:=@PrimaryFileWindowCallback;
  FindWindow.callback:=@FindWindowCallback;
  AboutWindow.callback:=@AboutWindowCallback;
  EditorOptionsWindow.callback:=@EditorOptionsWindowCallback;
  EditorStyleWindow.callback:=@EditorStyleWindowCallback;
  RuntimeParametersWindow.callback:=@RuntimeParametersWindowCallback;
  GotoLineWindow.callback:=@GotoLineWindowCallback;
  LinkerWindow.Callback:=@LinkerWindowCallback;
  CompilerModeWindow.Callback:=@CompilerModeWindowCallback;
  DirectoriesWindow.Callback:=@DirectoriesWindowCallback;
  MemorySizeswindow.Callback:=@MemorySizesWindowCallback;
  CompilerOptionsWindow.Callback:=@CompilerOptionsWindowCallback;
  TargetWindow.Callback:=@TargetWindowCallback;
  ASCIITable.Callback:=@ASCIITableCallback;
  ProcessListWindow.mylist:=Processes;
  for i:=1 to paramcount do AddEditor(paramstr(i));
end;


function TMainForm.CloseAllEditors():boolean;
var mr,i:integer;
begin
     result:=true;
     //perform initial check for unsaved files
     for i:=0 to PageController.Pages.Count-1 do
      if GetEditor(i).unsaved then
       begin
        mr:=MessageBox('You have unsaved files. All changes made since last save will be lost. Save now?','Warning',MB_ICONQUESTION);
        if mr=MR_YES then SaveAllClick(nil);
        if mr=MR_CANCEL then exit(false);//could not perform close all operation
        break;
       end;
     //if we got here, we can close all open files
     for i:=PageController.Pages.Count-1 downto 0 do
      begin
       PageController.Pages.Delete(i);
       TObject(Editors.Items[i]).Destroy();
       Editors.Delete(i);
      end;
end;

procedure TMainForm.MainFormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
 CanClose:=CloseAllEditors();
end;

procedure TMainForm.CompilerOutputCloseButtonClick(Sender: TObject);
begin
 MessagesClick(sender);
end;

procedure TMainForm.CompileSpeedButtonClick(Sender: TObject);
begin
  CompileClick(sender);
end;

procedure TMainForm.ASCIITableMIClick(Sender: TObject);
begin
  ASCIITable.Visible:=true;
end;

procedure TMainForm.BTFPMIClick(Sender: TObject);
begin
  PageController.PageIndex:=popupAMI;
end;

procedure TMainForm.CloseAllMIClick(Sender: TObject);
begin
     CloseAllEditors();
end;

procedure TMainForm.ClosePClick(Sender: TObject);
//var cf:integer;
begin
     try
      CloseEditor(popupAMI);
     finally
     end;
end;
procedure TMainForm.CompilerOutputClick(Sender: TObject);
var code,i:integer;
    l1,l2,p:string;
begin
    if CompilerOutput.Items.Count>0 then
      begin
      if CompilerOutput.ItemIndex<0 then exit;
      if CompilerOutput.ItemIndex=CompilerOutput.Items.Count then CompilerOutput.ItemIndex:=CompilerOutput.Items.Count-1;
       p:=CompilerOutput.Items.Strings[CompilerOutput.ItemIndex];
       for i:=1 to length(p) do
        if p[i]='(' then break;
       inc(i);
       l1:='';
       while (i<=length(p))and(p[i]<>',')and(p[i]<>')') do
        begin
         l1+=p[i];
         inc(i);
        end;
       inc(i);
       l2:='';
       while (i<=length(p))and(p[i]<>')') do
        begin
         l2+=p[i];
         inc(i);
        end;
       if PageController.PageCount>0 then
        begin
         code:=0;//crappy hint removal
         val(l1,i,code);
         if i>GetActiveEditor().Lines.Count then i:=GetActiveEditor().Lines.Count;
         GetActiveEditor().CaretY:=i;
         EditorOptions.redirect_line:=i;
         val(l2,i,code);
         if code=0 then GetActiveEditor().CaretX:=i
                   else GetActiveEditor().CaretX:=1;
                   
         MainForm.ActiveControl:=GetActiveEditor();
         MainForm.Refresh();
         GetActiveEditor.Paint();
        end;
      end;
end;


procedure TMainForm.FindNextSpeedButtonClick(Sender: TObject);
begin
  FindNextClick(Sender);
end;

procedure TMainForm.FindPreviousSpeedButtonClick(Sender: TObject);
begin
  FindPreviousClick(sender);
end;

procedure TMainForm.FindSpeedButtonClick(Sender: TObject);
begin
  FindClick(sender);
end;

procedure TMainForm.FormChangeBounds(Sender: TObject);
begin
  if WindowState<>wsMaximized then
   begin
    um_top:=top;
    um_left:=left;
   end;
end;

procedure TMainForm.MainFormDestroy(Sender: TObject);
//var i:integer;
begin
 Processes.Destroy();
 Editors.Destroy();
// Execute.Destroy();
 
 if WindowState<>wsMaximized then
  begin
   EditorOptions.window_width:=width;
   EditorOptions.window_height:=height;
   EditorOptions.window_top:=top;
   EditorOptions.window_left:=left;
  end                        else
  begin
   EditorOptions.window_height:=um_height;
   EditorOptions.window_width:=um_width;
   EditorOptions.window_top:=um_top;
   EditorOptions.window_left:=um_left;
  end;
 if WindowState=wsMaximized then EditorOptions.window_maximized:=true
                            else EditorOptions.Window_maximized:=false;
 
 EditorOptions.Destroy();
end;

procedure TMainForm.GotoLineNumberSpeedButtonClick(Sender: TObject);
begin
  GotoLineNumberClick(sender);
end;

procedure TMainForm.MainFormResize(Sender: TObject);
begin
 if WindowState<>wsMaximized then
  begin
   um_width:=width;
   um_height:=height;
  end;

 //statusbar
 statusbar.panels[0].Width:=statusbar.width-224;
 //panel
 CompilerOutputPanel.Top:=Statusbar.Top-CompilerOutputPanel.Height;
 CompilerOutputPanel.Width:=Width-CompilerOutputPanel.Left;
 CompilerOutput.Width:=CompilerOutputPanel.Width;
 CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
 CompilerOutputCloseButton.Left:=CompilerOutputPanel.Width-CompilerOutputCloseButton.Width-4;
 //tabcontrol
 PageController.Width:=Width-PageController.Left;
 if CompilerOutputPanel.visible then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                else PageController.Height:=Statusbar.Top-PageController.Top;
 if EditorsAvailable() then GetActiveEditor().Refresh();
 Statusbar.Refresh();
 CompilerOutputPanel.Refresh();
 PageController.Refresh();
end;

procedure TMainForm.CutClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().CutToClipboard;
end;

procedure TMainForm.CopyClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().CopyToClipboard;
end;

procedure TMainForm.PageControllerMouseUp(Sender: TOBject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
var c:tpoint;
begin
  c.x:=x;
  c.y:=10;
  popupAMI:=PageController.TabIndexAtClientPos(c);
  if popupAMI<>-1 then
   begin
    if button=MBRight then
     begin
      PageControllerPopupMenu.Popup(pagecontroller.left+left+x,pagecontroller.top+top+y-20);
     end;
    if button=MBMiddle then ClosePClick(Sender);
   end            else if ssDouble in shift then NewClick(sender);
end;

procedure TMainForm.PasteClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().PasteFromClipboard;
end;

procedure TMainForm.ProcessListMIClick(Sender: TObject);
begin
     ProcessListWindow.Refresh();
     ProcessListWindow.ShowModal();
end;

procedure TMainForm.ReloadPMIClick(Sender: TObject);
begin
     GetEditor(popupAMI).Reload();
end;

procedure TMainForm.RunClick(Sender: TObject);
var rdir,s,exefile:string;
    b:integer;
begin
 if EditorOptions.primary_file<>-1 then b:=EditorOptions.primary_file
                                   else b:=PageController.PageIndex;
 s:=GetEditor(b).activefilename;
 exefile:=copy(s,1,length(s)-length(ExtractFileExt(s))){$IFDEF WIN32}+'.exe'{$ENDIF};
 //attempt to compile
 if (GetEditor(b).unsaved)or(not fileexists(exefile)) then CompileClick(Sender);

 if fileexists(exefile) then
  begin
   if EditorOptions.rundir<>'' then rdir:=EditorOptions.rundir
                               else rdir:=ExtractFileDir(exefile);
                               
   CreateProcess(exefile,EditorOptions.exeparams,rdir,[poNewConsole]);
  end;
end;

procedure TMainForm.MessagesClick(Sender: TObject);
begin
  if CompilerOutputPanel.visible=false then
   begin
    CompilerOutputPanel.visible:=true;
    CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
    CompilerOutput.Width:=CompilerOutputPanel.Width;
   end
                          else
   begin
    CompilerOutputPanel.visible:=false;
    CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
    CompilerOutput.Width:=CompilerOutputPanel.Width;
   end;
  CompilerOutputPanel.Refresh;
 //tabcontrol
 PageController.Width:=Width-PageController.Left;
 if CompilerOutputPanel.visible then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                else PageController.Height:=Statusbar.Top-PageController.Top;
 PageController.Refresh;
 //editor
 if EditorsAvailable() then GetActiveEditor().Refresh();
end;

//debug
procedure TMainForm.DebugClick(Sender: TObject);
var b:integer;
    exefile,s:string;
begin
     //attempt to compile
     BuildClick(Sender);
     if EditorOptions.Primary_File=-1 then b:=PageController.PageIndex
                                      else b:=EditorOptions.Primary_File;
     s:=GetEditor(b).activefilename;
     exefile:=copy(s,1,length(s)-length(ExtractFileExt(s))){$IFDEF WIN32}+'.exe'{$ENDIF};
     if fileexists(exefile) then
      begin
       //debugger:=TProgramDebugger.Create();
      end;
end;

procedure TMainForm.CloseEditor(id:integer);
var proceed:boolean;
    mr:integer;
begin
     proceed:=true;
     if GetEditor(id).unsaved then
      begin
       mr:=MessageBox(GetEditor(id).RetName()+' is not saved. All unsaved changes will be lost. Do you wish to save before closing?','Confirm file close',0);
       if mr=MR_YES then GetEditor(id).Save();
       if mr=MR_CANCEL then proceed:=false;
      end;
     if proceed then
      begin
       PageController.Pages.Delete(id);
       TObject(Editors.Items[id]).Destroy();
       Editors.Delete(id);
       //PageControl.onChange doesn't get called when the active page is -1 so we need to negate stuff here
       
       if PageController.PageCount=0 then
        begin
         ValidateMenus(false);

         ReloadMI.Enabled:=false;
         ReloadSpeedButton.Enabled:=false;
         ReloadPMI.Enabled:=false;
        end;
      end;
end;

procedure TMainForm.AddEditor();
var aeditor:TMyCustomEditor;
begin
     aeditor:=TMyCustomEditor.Create(false);

     aeditor.visible:=false;
     aeditor.left:=0;
     aeditor.top:=0;
     aeditor.PopupMenu:=EditorPopupMenu;

     aeditor.onClick:=@EditorMouseClick;
     aeditor.onKeyDown:=@EditorKeyDown;
     aeditor.onChange:=@EditorChange;
     aeditor.onSpecialLineColors:=@EditorSpecialLineColors;
     aeditor.Lines.Clear();
     aeditor.tname:=GetUntitledName();

     EditorOptions.Setup(aeditor);

     Editors.Add(aeditor);
     PageController.PageIndex:=PageController.Pages.Add(aeditor.RetTabName());
     aeditor.visible:=true;
     aeditor.parent:=PageController.Page[PageController.PageIndex];
     aeditor.Width:=aeditor.parent.width;
     aeditor.height:=aeditor.parent.height;

     ValidateMenus(true);
     ActiveControl:=aeditor;
     
     if PageController.PageCount=1 then
      begin
       //fix some retarded thing a retard did in a retarded build of a retarded component
       PageController.Width:=Width-PageController.Left;
       if not(CompilerOutputPanel.visible) then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                           else PageController.Height:=Statusbar.Top-PageController.Top;
       if CompilerOutputPanel.visible then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                      else PageController.Height:=Statusbar.Top-PageController.Top;
      end;

end;

procedure TMainForm.AddEditor(filename:string);
var aeditor:TMyCustomEditor;
begin
     aeditor:=TMyCustomEditor.Create(true);

     aeditor.visible:=false;
     aeditor.left:=0;
     aeditor.top:=0;
     aeditor.PopupMenu:=EditorPopupMenu;

     aeditor.onClick:=@EditorMouseClick;
     aeditor.onKeyDown:=@EditorKeyDown;
     aeditor.onChange:=@EditorChange;
     aeditor.onSpecialLineColors:=@EditorSpecialLineColors;
     aeditor.Lines.LoadFromFile(filename);
     aeditor.activefilename:=filename;
     aeditor.tname:=ExtractFileName(aeditor.activefilename);

     EditorOptions.Setup(aeditor);

     Editors.Add(aeditor);
     PageController.PageIndex:=PageController.Pages.Add(aeditor.RetTabName());
     aeditor.visible:=true;
     aeditor.parent:=PageController.Page[PageController.PageIndex];
     aeditor.Width:=aeditor.parent.width;
     aeditor.height:=aeditor.parent.height;

     ValidateMenus(true);
     ActiveControl:=aeditor;
     
     if PageController.PageCount=1 then
      begin
       //fix some retarded thing a retard did in a retarded build of a retarded component
       PageController.Width:=Width-PageController.Left;
       if not(CompilerOutputPanel.visible) then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                           else PageController.Height:=Statusbar.Top-PageController.Top;
       if CompilerOutputPanel.visible then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                      else PageController.Height:=Statusbar.Top-PageController.Top;
      end;
      
end;

procedure TMainForm.NewClick(Sender: TObject);
begin
     AddEditor();
end;

procedure TMainForm.TargetClick(Sender: TObject);
begin
     Enabled:=false;
     TargetWindow.Target.ItemIndex:=EditorOptions.target;
     TargetWindow.visible:=true;
end;

procedure TMainForm.PrimaryFileClick(Sender: TObject);
var i:integer;
begin
  Enabled:=false;
  for i:=0 to PageController.Pages.Count-1 do
   PrimaryFileWindow.FileList.Items.Add(PageController.Pages.Strings[i]);
  PrimaryFileWindow.FileList.ItemIndex:=EditorOptions.primary_file;
  if PrimaryFileWindow.FileList.Items.Count=0 then PrimaryFileWindow.OkButton.Enabled:=false
                                              else PrimaryFileWindow.OkButton.Enabled:=true;
  PrimaryFileWIndow.visible:=true;
  PrimaryFileWindow.refresh;
end;

procedure TMainForm.ClearPrimaryFileClick(Sender: TObject);
begin
  EditorOptions.primary_file:=-1;
end;


procedure TMainForm.OpenClick(Sender: TObject);
var i:integer;
    found:boolean;
begin
     OpenDialog.InitialDir:=GetCurrentDir();
     if OpenDialog.Execute then
      begin
       found:=false;
       for i:=0 to PageController.PageCount-1 do
        if OpenDialog.Filename=GetEditor(i).activefilename then
         begin
          PageController.PageIndex:=i;
          found:=true;
          break;
         end;
       if not found then AddEditor(OpenDialog.Filename);
      end;
end;

procedure TMainForm.SaveClick(Sender: TObject);
begin
     GetActiveEditor().Save();
end;

procedure TMainForm.editorstyle(Sender: TObject);
begin
//     EditorOptionsWindow.
end;
procedure TMainForm.EditorClick(Sender: TObject);
begin
  Enabled:=false;
  with EditorOptionsWindow do
   begin
    AutoIndent.checked:=EditorOptions.auto_indent;
    TabIndent.Checked:=EditorOptions.tab_indent;
    AutoIndentOnPaste.checked:=EditorOptions.auto_indent_on_paste;
    DragAndDropEditing.Checked:=EditorOptions.drag_and_drop;
    DropFiles.checked:=EditorOptions.drop_files;
    EnhanceHomeKey.checked:=EditorOptions.enhance_home;
    NoCaret.checked:=EditorOptions.no_caret;
    SmartTabs.checked:=EditorOptions.smart_tabs;
    TabsToSpaces.checked:=EditorOptions.tabs_to_spaces;
    DoubleClickSelectsLine.checked:=EditorOptions.double_click_selects_line;
    rightMouseMovesCursor.checked:=EditorOptions.right_mouse_moves_cursor;
    ShowLineNumbers.checked:=EditorOptions.line_numbers;
    ScrollByOneLess.checked:=EditorOptions.scroll_by_one_less;
    HighlightBrackets.checked:=EditorOptions.Highlight_brackets;
    PreferInsertMode.checked:=EditorOptions.insert_mode;
    visible:=true;
   end;
end;

procedure TMainForm.ColorsClick(Sender: TObject);
begin
  Enabled:=false;
  EditorStyleWindow.a:=EditorOptions.syntax_highlight;
  EditorStyleWindow.visible:=true;
end;

procedure TMainForm.ExitClick(Sender: TObject);
var canclose:boolean;
begin
  canclose:=false;
  MainFormCloseQuery(sender,canclose);
  Application.Terminate();
end;

procedure TMainForm.UndoClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().Undo();
end;

procedure TMainForm.RedoClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().Redo();
end;

procedure TMainForm.PasteSpeedButtonClick(Sender: TObject);
begin
  PasteClick(sender);
end;

procedure TMainForm.ReloadSpeedButtonClick(Sender: TObject);
begin
  ReloadClick(sender);
end;

procedure TMainForm.NewSpeedButtonClick(Sender: TObject);
begin
  NewClick(sender);
end;

procedure TMainForm.OpenSpeedButtonClick(Sender: TObject);
begin
  OpenClick(sender);
end;

procedure TMainForm.CloseSpeedButtonClick(Sender: TObject);
begin
  CloseClick(sender);
end;

procedure TMainForm.SaveSpeedButtonClick(Sender: TObject);
begin
  SaveClick(sender);
end;

procedure TMainForm.CutSpeedButtonClick(Sender: TObject);
begin
  CutClick(sender);
end;

procedure TMainForm.RedoSpeedButtonClick(Sender: TObject);
begin
  RedoClick(sender);
end;

procedure TMainForm.UndoSpeedButtonClick(Sender: TObject);
begin
  UndoClick(sender);
end;

procedure TMainForm.SaveAsSpeedButtonClick(Sender: TObject);
begin
  SaveAsClick(sender);
end;

procedure TMainForm.CopySpeedButtonClick(Sender: TObject);
begin
  CopyClick(sender);
end;

procedure TMainForm.NewFromTemplateClick(Sender: TObject);
begin
end;

procedure TMainForm.ReloadClick(Sender: TObject);
begin
  GetActiveEditor().Reload();
end;

procedure TMainForm.RunSpeedButtonClick(Sender: TObject);
begin
  RunClick(Sender);
end;

procedure TMainForm.SaveAllClick(Sender: TObject);
var i:integer;
begin
 for i:=0 to PageController.PageCount-1 do GetEditor(i).Save();
end;

function s2p(s:string):pchar;
var i:integer;
begin
 s2p:=StrAlloc(length(s));
 for i:=1 to length(s) do s2p[i-1]:=s[i];
end;

procedure TMainForm.CommandShellClick(Sender: TObject);
begin
    CreateProcess({$IFDEF UNIX}'/bin/bash'{$ELSE}GetEnvironmentVariable('comspec'){$ENDIF},'','',[poNewConsole]);
end;

function retrace(s:string):string;
begin
     if s='' then result:='.'
             else result:=s;
end;


function check(s:string):boolean;
var i:integer;
begin
 //check for copyright
 if copy(s,1,9)='Copyright' then exit(false);
 //check for final error
 if copy(s,1,5)='Error' then exit(false);
 for i:=length(s) downto 1 do
  if s[i]='(' then exit(true);
 exit(false);
end;

procedure TMainForm.compile(filename:string);
const ds={$IFDEF UNIX}'/'{$ELSE}'\'{$ENDIF};
var p:Tprocess;
    i:integer;
    os:int64;
    b:TStringList;
begin
    CompilerOutput.Items.Clear();
    b:=TStringList.Create();
    CompilerOutputTitle.Caption:='Messages (Compiling)';
    CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
    CompilerOutputTitle.Refresh();
    p:=TProcess.Create(nil);
    p.Options:=[poUsePipes,poStdErrToOutput];
    p.commandline:=Retrace(EditorOptions.bin_directory)+ds+'fpc'+{$IFDEF WIN32}'.exe'{$ELSE}''{$ENDIF}+' '+EditorOptions.GetParams()+parsefilename(filename);
    {$IFDEF WIN32}
    p.showWindow:=swoHide;
    {$ENDIF}
    if fileexists(EditorOptions.bin_directory+ds+'fpc'{$IFDEF WIN32}+'.exe'{$ENDIF}) then
     begin
      p.Execute();
      os:=0;
      repeat
       sleep(50);
       if p.output.size<>os then
        begin
         b.LoadFromStream(p.output);
         for i:=0 to b.Count-1 do
          CompilerOutput.Items.Add(b.Strings[i]);
         CompilerOutput.Refresh();
         os:=p.output.size;
        end;
      until not(p.running);
      b.LoadFromStream(p.output);
      for i:=0 to b.Count-1 do
      CompilerOutput.Items.Add(b.Strings[i]);
      CompilerOutput.Refresh();
      p.Destroy();
     end else
    CompilerOutput.Items.add('Could not execute "'+EditorOptions.bin_directory+ds+'fpc'+{$IFDEF WIN32}'.exe'{$ELSE}''{$ENDIF}+'". Make sure your compiler path is set correctly');
    CompilerOutputTitle.Caption:='Messages';
    CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
    CompilerOutputTitle.Refresh;
    b.Destroy;
end;

procedure TMainForm.CompileClick(Sender: TObject);
var b:integer;
begin
  if EditorOptions.primary_file<>-1 then b:=EditorOptions.Primary_File
                                    else b:=PageController.PageIndex;
  GetEditor(b).Save();
  if GetEditor(b).ActiveFileName<>'' then
   begin
    if CompilerOutputPanel.visible=false then MessagesClick(sender);
    compile(GetEditor(b).ActiveFileName)
   end;
end;

procedure TMainForm.BuildClick(Sender: TObject);
var b:integer;
begin
  if EditorOptions.primary_file<>-1 then b:=EditorOptions.Primary_File
                                    else b:=PageController.PageIndex;
  GetEditor(b).Save();
  if GetEditor(b).ActiveFileName<>'' then
   begin
    if CompilerOutputPanel.visible=false then MessagesClick(sender);
    compile(GetEditor(b).ActiveFileName+' -B');
   end;
end;

procedure TMainForm.SaveAsPMIClick(Sender: TObject);
begin
     GetEditor(popupAMI).SaveAs();
end;

procedure TMainForm.SavePMIClick(Sender: TObject);
begin
     GetEditor(popupAMI).Save();
end;

procedure TMainForm.StopDebugMIClick(Sender: TObject);
begin
     debugger.Destroy(); //whoops
end;

procedure TMainForm.MakeClick(Sender: TObject);
begin
     CompileClick(sender);
end;

procedure TMainForm.CalculatorClick(Sender: TObject);
begin
 Calculator.Execute();
end;

procedure TMainForm.ModeClick(Sender: TObject);
begin
  Enabled:=false;
  CompilerModeWindow.visible:=true;
end;

procedure TMainForm.CompilerClick(Sender: TObject);
begin
  Enabled:=false;
  with CompilerOptionsWindow do
   begin
    if EditorOptions.code_style=0 then GenerateFasterCode.checked:=true
                                  else GenerateFasterCode.checked:=false;
    GenerateSmallerCode.checked:=not(GenerateFasterCode.checked);
    Browser.itemindex:=EditorOptions.browser_style;
    TargetProcessor.ItemIndex:=EditorOptions.target_processor;
    AssemblerReader.ItemIndex:=EditorOptions.asm_style;
    AssemblerOutput.ItemIndex:=EditorOptions.asm_output;
    ObjectPascal.checked:=EditorOptions.objectpascal_support;
    GlobalCMacros.checked:=EditorOptions.c_macros;
    TPCompatible.checked:=EditorOptions.bp7_compatibility;
    COperators.checked:=EditorOptions.c_operators;
    DelphiCompatible.checked:=EditorOptions.delphi_compatibility;
    StopAfterFirstError.checked:=EditorOptions.stop_after_first_error;
    StaticInObjects.checked:=EditorOptions.static_in_objects;
    AllowLabel.checked:=EditorOptions.label_goto;
    CInline.checked:=EditorOptions.c_inline;
    RegisterVariables.checked:=EditorOptions.register_variables;
    UncertainOptimizations.checked:=EditorOptions.uncertain_opt;
    L1Optimizations.checked:=EditorOptions.level1_opt;
    L2Optimizations.checked:=EditorOptions.level2_opt;
    Warnings.checked:=EditorOptions.v_warnings;
    Notes.checked:=EditorOptions.v_notes;
    Hints.checked:=EditorOptions.v_hints;
    UTInfo.checked:=EditorOptions.v_used;
    GeneralInfo.checked:=EditorOptions.v_general;
    All.checked:=EditorOptions.v_all;
    ShowAllProc.checked:=EditorOptions.v_allproc;
    RangeChecking.checked:=EditorOptions.range_checking;
    StackChecking.checked:=EditorOptions.stack_checking;
    IOChecking.checked:=EditorOptions.io_checking;
    Overflowchecking.checked:=EditorOptions.integer_overflow_checking;
    ListSource.checked:=EditorOptions.asm_source;
    ListRegisters.checked:=EditorOptions.asm_register_alloc;
    ListTemp.checked:=EditorOptions.asm_temp_alloc;
    Visible:=true;
   end;
   PageController.PageIndex:=0;
end;

procedure TMainForm.MemorySizesClick(Sender: TObject);
begin
     Enabled:=false;
     MemorySizesWindow.Visible:=true;
end;

procedure TMainForm.LinkerClick(Sender: TObject);
begin
     Enabled:=false;
     LinkerWindow.Visible:=true;
end;

procedure TMainForm.DebuggerClick(Sender: TObject);
begin

end;

procedure TMainForm.DirectoriesClick(Sender: TObject);
begin
     Enabled:=false;
     DirectoriesWindow.PathToCompiler.Text:=EditorOptions.bin_directory;
     DirectoriesWindow.UnitOutputDirectory.Text:=EditorOptions.unit_output_dir;
     DirectoriesWindow.ExeOutputDirectory.Text:=EditorOptions.exe_output_dir;
     DirectoriesWindow.ObjectDirectories.Text:=EditorOptions.object_dir;
     DirectoriesWindow.LibraryDirectories.Text:=EditorOptions.library_dir;
     DirectoriesWindow.IncludeDirectories.Text:=EditorOptions.include_dir;
     DirectoriesWindow.UnitDirectories.Text:=EditorOptions.unit_dir;
     DirectoriesWindow.Visible:=true;
end;

procedure TMainForm.CloseClick(Sender: TObject);
begin
     CloseEditor(PageController.PageIndex);
end;

procedure TMainForm.RunDirectoryClick(Sender: TObject);
begin
  if EditorsAvailable then SelectDirectoryDialog.InitialDir:=ExtractFilePath(GetActiveEditor().ActiveFileName)
                      else SelectDirectoryDialog.InitialDir:=EditorOptions.rundir;
  if SelectDirectoryDialog.Execute then EditorOptions.rundir:=SelectDirectoryDialog.FileName;
end;

procedure TMainForm.ParametersClick(Sender: TObject);
begin
     Enabled:=false;
     RuntimeParametersWindow.Visible:=true;
end;

procedure TMainForm.SaveAsClick(Sender: TObject);
begin
     GetActiveEditor().SaveAs();
end;

//find
procedure TMainForm.FindClick(Sender: TObject);
begin
  Enabled:=false;
  FindWindow.Caption:='Find';
  FindWindow.FindReplaceButton.Caption:='Find';
  FindWindow.ReplaceAllButton.enabled:=false;
  FindWindow.PromptOnReplace.enabled:=false;
  FindWindow.ReplaceInput.Enabled:=false;
  FindWindow.ReplaceWithLabel.Font.color:=clGray;
  FindWindow.Visible:=true;
end;

procedure TMainForm.FindNextClick(Sender: TObject);
begin
    GetActiveEditor().SearchReplace(FindWindow.TextInput.Text,FindWindow.ReplaceInput.Text,EditorOptions.op);
end;

procedure TMainForm.FindPreviousClick(Sender: TObject);
begin
  if ssoBackwards in EditorOptions.op then
   begin
    EditorOptions.op-=[ssoBackwards];
    GetActiveEditor().SearchReplace(FindWindow.TextInput.Text,FindWindow.TextInput.Text,EditorOptions.op);
    EditorOptions.op+=[ssoBackwards];
   end                  else
   begin
    EditorOptions.op+=[ssoBackwards];
    GetActiveEditor().SearchReplace(FindWindow.TextInput.Text,FindWindow.TextInput.Text,EditorOptions.op);
    EditorOptions.op-=[ssoBackwards];
   end;
end;

procedure TMainForm.ReplaceClick(Sender: TObject);
begin
  Enabled:=false;
  FindWindow.Caption:='Replace';
  FindWindow.FindReplaceButton.caption:='Replace';
  FindWindow.ReplaceAllButton.enabled:=true;
  FindWindow.PromptOnReplace.enabled:=true;
  FindWindow.ReplaceInput.enabled:=true;
  FindWindow.ReplaceWithLabel.font.color:=clWindowText;
  FindWindow.Visible:=true;
end;

procedure TMainForm.GotoLineNumberClick(Sender: TObject);
begin
  Enabled:=false;
  GotoLineWindow.Line.maxvalue:=GetActiveEditor().Lines.count;
  GotoLineWindow.Visible:=true;
end;

procedure TMainForm.AboutClick(Sender: TObject);
begin
  Enabled:=false;
  AboutWindow.Visible:=true;
end;

procedure TMainForm.EditorChange(Sender: TObject);
begin
     if(Sender as TMyCustomEditor).unsaved=false then
      begin
       (Sender as TMyCustomEditor).isunsaved:=true;
       MainForm.PageController.Pages.Strings[MainForm.Editors.IndexOf(sender)]:=(Sender as TMyCustomEditor).RetTabName();
      end;
end;

procedure TMainForm.EditorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if EditorOptions.redirect_line<>-1 then
   begin
    EditorOptions.redirect_line:=-1;
    GetActiveEditor().Paint;
   end;
  StatusBar.Panels[1].text:='Ln '+IntToStr(GetActiveEditor().caretY)+', Col '+IntToStr(GetActiveEditor().caretX);
  {$IFDEF WIN32}
  if Odd(GetKeyState(vk_NumLock)) then StatusBar.Panels[4].Text := 'NUM'
                                  else StatusBar.Panels[4].Text := '';
  if Odd(GetKeyState(vk_Capital)) then StatusBar.Panels[3].Text := 'CAP'
                                  else StatusBar.Panels[3].Text := '';
  {$ENDIF}
  if key=VK_INSERT then imode:=not(GetActiveEditor().InsertMode);
  if imode then StatusBar.Panels[2].Text := 'INS'
           else StatusBar.Panels[2].Text := 'OVR';
  //shortcuts
  //file menu
  if (key=VK_N) and (ssCtrl in Shift) then NewClick(sender);
  if (key=VK_O) and (ssCtrl in Shift) then OpenClick(sender);
//  if (key=VK_Q) and (ssCtrl in Shift) then CloseClick(sender);
  if (key=VK_R) and (ssCtrl in Shift) and (ReloadMI.Enabled) then ReloadClick(sender);
  if (key=VK_S) and (ssCtrl in Shift) then
   begin
    if ssAlt in Shift then SaveAsClick(sender)
                      else SaveClick(sender);
   end;
  //search menu
  if (key=VK_F) and (ssCtrl in Shift) then FindClick(sender);
  if (key=VK_F3) then
   begin
    if ssShift in Shift then FindPreviousClick(sender)
                        else FindNextClick(sender);
   end;
  if (key=VK_H) and (ssCtrl in Shift) then ReplaceClick(sender);
  if (key=VK_G) and (ssCtrl in Shift) then GotoLineNumberClick(sender);
  //menu activators
end;

procedure TMainForm.EditorSpecialLineColors(Sender: TObject; Line: integer;
  var Special: boolean; var FG, BG: TColor);
begin
  Special:=false;
  if line=EditorOptions.redirect_line then
   begin
    Special:=true;
    FG:=ClBlack;
    BG:=$00CCCCFF;
   end;
  if line=EditorOptions.debug_line then
   begin
    Special:=true;
    FG:=ClBlack;
    BG:=$00FFCCCC;
   end;
end;

procedure TMainForm.ValidateMenus(value:boolean);
begin
    //file menu

    CloseMI.Enabled:=value;
    CloseAllMI.Enabled:=value;
    SaveMI.Enabled:=value;
    SaveAsMI.Enabled:=value;
    SaveAllMI.Enabled:=value;

    //edit menu
    UndoMI.Enabled:=value;
    RedoMI.Enabled:=value;
    CutMI.Enabled:=value;
    CopyMI.Enabled:=value;
    PasteMI.Enabled:=value;

    //search menu
    FindMI.Enabled:=value;
    FindNextMI.Enabled:=value;
    FindPreviousMI.Enabled:=value;
    ReplaceMI.Enabled:=value;
    GotoLineNumberMI.Enabled:=value;

    //run menu

    RunMI.Enabled:=value;
    DebugMI.Enabled:=value;
    RunDirectoryMI.Enabled:=value;
    ParametersMI.Enabled:=value;

    //compile menu

    CompileMI.Enabled:=value;
    MakeMI.Enabled:=value;
    BuildMI.Enabled:=value;

    //debug menu

    //MessagesMI.Enabled:=value;
    
    //speed buttons

    CloseSpeedButton.Enabled:=value;
    SaveSpeedButton.Enabled:=value;
    SaveAsSpeedButton.Enabled:=value;
    
    UndoSpeedButton.Enabled:=value;
    RedoSpeedButton.Enabled:=value;

    CutSpeedButton.Enabled:=value;
    CopySpeedButton.Enabled:=value;
    PasteSpeedButton.Enabled:=value;
    
    FindSpeedButton.Enabled:=value;
    FindNextSpeedButton.Enabled:=value;
    FindPreviousSpeedButton.Enabled:=value;
    GotoLineNumberSpeedButton.Enabled:=value;
    
    CompileSpeedButton.Enabled:=value;
    RunSpeedButton.Enabled:=value;
end;

procedure TMainForm.PageControllerPageChanged(Sender: TObject);
//var i:integer;
begin
 if EditorsAvailable() then
  begin
   ValidateMenus(true);//we have a document opened
   //check wether we can or cannot reload the file
   ReloadMI.Enabled:=GetActiveEditor().reloadable;
   ReloadSpeedButton.Enabled:=GetActiveEditor().reloadable;
   ReloadPMI.Enabled:=GetActiveEditor().reloadable;
  end                            else
  begin
   ValidateMenus(false); //no document opened
   
   ReloadMI.Enabled:=false;
   ReloadSpeedButton.Enabled:=false;
   ReloadPMI.Enabled:=false;
  end;
end;

procedure TMainForm.PageControllerResize(Sender: TObject);
var i:integer;
begin
     for i:=0 to PageController.PageCount-1 do
      begin
       GetEditor(i).Width:=GetEditor(i).parent.width;
       GetEditor(i).height:=GetEditor(i).parent.height;
      end;
end;

procedure TMainForm.RuntimeParametersWindowCallback(swc:boolean);
begin
     Enabled:=true;
     if swc then EditorOptions.exeparams:=RuntimeParametersWindow.Parameters.Text;
end;

procedure TMainForm.GotoLineWindowCallback(swc:boolean);
begin
     Enabled:=true;
     if swc then
      begin
       GetActiveEditor().CaretY:=GotoLineWindow.Line.Value;
       GetActiveEditor().CaretX:=1;
       GetActiveEditor().Refresh;
      end;
end;
procedure TMainForm.LinkerWindowCallback(swc:boolean);
begin
     Enabled:=true;
     if swc then
      begin
       EditorOptions.call_linker_after:=LinkerWindow.CallLinkerAfter.Checked;
       EditorOptions.only_link_to_static:=LinkerWindow.OnlyLinkToStatic.Checked;
       EditorOptions.lib_type:=LinkerWindow.LibraryType.ItemIndex;
      end;
end;
procedure TMainForm.MemorySizesWindowCallback(swc:boolean);
begin
     Enabled:=true;
     if swc then
      begin
       EditorOptions.heap_size:=StrToInt(MemorySizesWindow.HeapSize.Text);
       EditorOptions.stack_size:=StrToInt(MemorySizesWindow.StackSize.Text);
      end;
end;
procedure TMainForm.CompilerModeWindowCallback(swc:boolean);
begin
 Enabled:=true;
 if swc then EditorOptions.mode:=CompilerModeWindow.CompilerMode.ItemIndex;
end;
procedure TMainForm.DirectoriesWindowCallback(swc:boolean);
begin
 Enabled:=true;
 if swc then
  begin
   EditorOptions.bin_directory:=DirectoriesWindow.PathToCompiler.Text;
   EditorOptions.unit_output_dir:=DirectoriesWindow.UnitOutputDirectory.Text;
   EditorOptions.exe_output_dir:=DirectoriesWindow.ExeOutputDirectory.Text;
   EditorOptions.object_dir:=DirectoriesWindow.ObjectDirectories.Text;
   EditorOptions.library_dir:=DirectoriesWindow.LibraryDirectories.Text;
   EditorOptions.include_dir:=DirectoriesWindow.IncludeDirectories.Text;
   EditorOptions.unit_dir:=DirectoriesWindow.UnitDirectories.Text;
  end;
end;

procedure TMainForm.FindWindowCallback(swc,a:boolean);
begin
 Enabled:=true;
 if swc then
  begin
   EditorOptions.op:=[];
   if a then EditorOptions.op+=[ssoReplaceAll]
        else
    if FindWindow.FindReplaceButton.caption='Replace' then EditorOptions.op+=[ssoReplace];

   if FindWindow.CaseSensitive.checked then EditorOptions.op+=[ssoMatchCase];
   if FindWindow.WholeWordsOnly.checked then EditorOptions.op+=[ssoWholeWord];
   if FindWindow.PromptOnReplace.checked then EditorOptions.op+=[ssoPrompt];
   if FindWindow.RegularExp.checked then EditorOptions.op+=[ssoRegExpr];
   if FindWindow.Direction.itemIndex=1 then EditorOptions.op+=[ssoBackwards];
   if FindWindow.Scope.itemIndex=1 then EditorOptions.op+=[ssoSelectedOnly];
   if FindWindow.Origin.itemIndex=1 then EditorOptions.op+=[ssoEntireScope];
   GetActiveEditor().SearchReplace(FindWindow.TextInput.Text,FindWindow.ReplaceInput.Text,EditorOptions.op);
  end;
end;

procedure TMainForm.CompilerOptionsWindowCallback(swc:boolean);
begin
  Enabled:=true;
  if swc then
   begin
    with EditorOptions do
     begin
      objectpascal_support:=CompilerOptionsWindow.ObjectPascal.Checked;
      c_macros:=CompilerOptionsWindow.GlobalCMacros.Checked;
      bp7_compatibility:=CompilerOptionsWindow.TPCompatible.Checked;
      c_operators:=CompilerOptionsWindow.COperators.Checked;
      delphi_compatibility:=CompilerOptionsWindow.DelphiCompatible.Checked;
      stop_after_first_error:=CompilerOptionsWindow.StopAfterFirstError.Checked;
      static_in_objects:=CompilerOptionsWindow.StaticInObjects.Checked;
      label_goto:=CompilerOptionsWindow.AllowLabel.Checked;
      c_inline:=CompilerOptionsWindow.CInline.Checked;
      register_variables:=CompilerOptionsWindow.RegisterVariables.Checked;
      uncertain_opt:=CompilerOptionsWindow.UncertainOptimizations.Checked;
      level1_opt:=CompilerOptionsWindow.L1Optimizations.Checked;
      level2_opt:=CompilerOptionsWindow.L2Optimizations.Checked;
      v_warnings:=CompilerOptionsWindow.Warnings.Checked;
      v_notes:=CompilerOptionsWindow.Notes.Checked;
      v_hints:=CompilerOptionsWindow.Hints.Checked;
      v_used:=CompilerOptionsWindow.UTInfo.Checked;
      v_general:=CompilerOptionsWindow.GeneralInfo.Checked;
      v_all:=CompilerOptionsWindow.All.Checked;
      v_allproc:=CompilerOptionsWindow.ShowAllProc.Checked;
      range_checking:=CompilerOptionsWindow.RangeChecking.Checked;
      stack_checking:=CompilerOptionsWindow.StackChecking.Checked;
      io_checking:=CompilerOptionsWindow.IOChecking.Checked;
      integer_overflow_checking:=CompilerOptionsWindow.OverflowChecking.Checked;
      asm_source:=CompilerOptionsWindow.ListSource.Checked;
      asm_register_alloc:=CompilerOptionsWindow.ListRegisters.Checked;
      asm_temp_alloc:=CompilerOptionsWindow.ListTemp.Checked;
      browser_style:=CompilerOptionsWindow.Browser.ItemIndex;
      if CompilerOptionsWindow.GenerateFasterCode.Checked then code_style:=0
                                                          else code_style:=1;
      asm_output:=CompilerOptionsWindow.AssemblerOutput.ItemIndex;
      target_processor:=CompilerOptionsWindow.TargetProcessor.ItemIndex;
      asm_style:=CompilerOptionsWindow.AssemblerReader.ItemIndex;
     end;
   end;
end;

procedure TMainForm.PrimaryFileWindowCallback(swc:boolean);
begin
 Enabled:=true;
 if swc then EditorOptions.primary_file:=PrimaryFileWindow.FileList.ItemIndex;
end;

procedure TMainForm.EditorOptionsWindowCallback(swc:boolean);
var i:integer;
begin
  Enabled:=true;
  if swc then
   begin
    with EditorOptions do
     begin
      auto_indent:=EditorOptionsWindow.AutoIndent.Checked;
      tab_indent:=EditorOptionsWindow.tabindent.Checked;
      auto_indent_on_paste:=EditorOptionsWindow.autoindentonpaste.checked;
      drag_and_drop:=EditorOptionsWindow.DragAndDropEditing.checked;
      drop_files:=EditorOptionsWindow.DropFiles.checked;
      enhance_home:=EditorOptionsWindow.EnhanceHomeKey.checked;
      no_caret:=EditorOptionsWindow.nocaret.checked;
      smart_tabs:=EditorOptionsWindow.smarttabs.checked;
      tabs_to_spaces:=EditorOptionsWindow.tabstospaces.checked;
      double_click_selects_line:=EditorOptionsWindow.doubleclickselectsline.checked;
      right_mouse_moves_cursor:=EditorOptionsWindow.RightMouseMovesCursor.checked;
      line_numbers:=EditorOptionsWindow.ShowLineNumbers.checked;
      scroll_by_one_less:=EditorOptionsWindow.scrollbyoneless.checked;
      highlight_brackets:=EditorOptionsWindow.highlightbrackets.checked;
      insert_mode:=EditorOptionsWindow.preferinsertmode.checked;
     end;
    for i:=0 to PageController.PageCount-1 do EditorOptions.Setup(GetEditor(i));
   end;
end;

function min(a,b:integer):integer;inline;
begin
  if a>b then exit(b);
  exit(a);
end;


procedure TMainForm.ASCIITableCallback(b:byte);
var s:string;
    i:integer;
    f:boolean;
begin
 if EditorsAvailable then
  begin
   s:=GetActiveEditor().Lines[GetActiveEditor().CaretY-1];
   f:=false;
   for i:=1 to min(GetActiveEditor().caretX-1,length(s)) do
    if s[i]='''' then f:=not(f);
   if f then Insert('''+char($'+IntToHex(b,2)+')+''',s,GetActiveEditor.CaretX)
        else Insert('char($'+IntToHex(b,2)+')',s,GetActiveEditor.CaretX);
  GetActiveEditor().Lines[GetActiveEditor().CaretY-1]:=s;
  end;
end;

procedure TMainForm.TargetWindowCallback(swc:boolean);
begin
  Enabled:=true;
  if swc then EditorOptions.target:=TargetWindow.Target.itemIndex;
end;

procedure TMainForm.AboutWindowCallback();
begin
  Enabled:=true;
end;

procedure TMainForm.EditorMouseClick(Sender: TObject);
begin
  StatusBar.Panels[1].text:='Ln '+IntToStr(GetActiveEditor().caretY)+', Col '+IntToStr(GetActiveEditor().caretX);
end;

procedure TMainForm.EditorStyleWindowCallback(swc:boolean);
var i:integer;
begin
 Enabled:=true;
 if swc then
  begin
   EditorOptions.syntax_highlight:=EditorStyleWindow.a;
   EditorOptions.font_name:=EditorStyleWindow.Preview.Font.Name;
   EditorOptions.font_size:=EditorStyleWindow.FontSize.Value;
   EditorOptions.UpdateHighlighter();
   for i:=0 to PageController.PageCount-1 do
    begin
     GetEditor(i).font.name:=EditorOptions.Font_name;
     GetEditor(i).font.size:=EditorOptions.Font_size;
    end;
  end;
end;


initialization
  {$I umain.lrs}

end.

