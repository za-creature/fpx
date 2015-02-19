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
  {$ifdef win32}Windows,{$endif} Classes, SysUtils, LResources, Forms, Controls,
  Graphics, Dialogs, SynEdit, SynHighlighterPas, Menus, ComCtrls, Process,
  ExtCtrls, EditBtn, ExtDlgs, StdCtrls, Buttons, SynEditTypes, uLinkerDialog,
  uPrimaryFileDialog, uFindDialog, uAboutDialog, uEditorOptionsDialog, LCLType,
  uEditorStyleDialog, uRuntimeParametersDialog, uGotoLineDialog, uHelpDialog,
  uCompilerModeDialog, uDirectoriesDialog, uMemorySizesDialog, uCompileDialog,
  uCompilerOptionsDialog, uEditorOptionsController, uMessageBoxController,
  uAsciiTable, uTargetDialog, uProcessListWindow, uDebugger, uAddWatchDialog,
  uWatchListWindow, uDebugOptionsDialog, uBreakPointListWindow, uAVLTree,
  uCallStackWindow, uRegistersWindow, uDisassemblyWindow, uAddBreakPointDialog,
  uBookmarkListWindow, uHelpFilesDialog, uEvaluatorWindow;
  
type
  THistoryMark=record
   filename:ansistring;
   line,column:integer;
  end;
  TBookmark=class(TCustomBookmark)
   private
    procedure setFileName(v:ansistring);override;
    procedure setLineNumber(v:integer);override;
    procedure setCaption(v:ansistring);override;
   end;

  { TMainForm }

  TMyCustomEditor=class(TCustomEditor)
   public
    canreload,isunsaved:boolean;
    procedure Save();
    procedure Reload();
    procedure SaveAs();
    function RetTabName():string;
    function RetName():string;
    property reloadable:boolean read canreload;
    property unsaved:boolean read isunsaved;
    constructor Create(rldb:boolean);
    destructor Destroy();
  end;
  TMainForm = class(TForm)
    BookmarksSpeedButton: TSpeedButton;
    BookmarksSpeedButton1: TSpeedButton;
    HistoryBackMI: TMenuItem;
    HistoryForwardMI: TMenuItem;
    EvaluatorMI: TMenuItem;
    Separator11: TMenuItem;
    ToggleBookmarkSpeedButton: TSpeedButton;
    CloseAllMI: TMenuItem;
    CloseSpeedButton: TSpeedButton;
    CompilerOutputCloseButton: TButton;
    Calculator: TCalculatorDialog;
    CompilerOutputTitle: TLabel;
    CompilerOutput: TListBox;
    CompileSpeedButton: TSpeedButton;
    CompileSpeedButton1: TSpeedButton;
    CopySpeedButton: TSpeedButton;
    CutSpeedButton: TSpeedButton;
    FindNextSpeedButton: TSpeedButton;
    FindPreviousSpeedButton: TSpeedButton;
    FindSpeedButton: TSpeedButton;
    GotoLineNumberSpeedButton: TSpeedButton;

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
    ContinueMI: TMenuItem;
    DisassembleMI: TMenuItem;
    HelpFilesMI: TMenuItem;
    HelpContentsMI: TMenuItem;
    HelpIndexMI: TMenuItem;
    LineNumbersMI: TMenuItem;
    IndentMI: TMenuItem;
    BookmarksMI: TMenuItem;
    NextBookmarkMI: TMenuItem;
    PreviousBookmarkMI: TMenuItem;
    ToggleBookmarkMI: TMenuItem;
    Separator10: TMenuItem;
    NextBookmarkSpeedButton: TSpeedButton;
    PreviousBookmarkSpeedButton: TSpeedButton;
    UnindentMI: TMenuItem;
    Separator6: TMenuItem;
    SelectDirectoryDialog: TSelectDirectoryDialog;
    ToolbarMI: TMenuItem;
    MessagesMI: TMenuItem;
    ViewMI: TMenuItem;
    NewSpeedButton: TSpeedButton;
    OpenSpeedButton: TSpeedButton;
    PasteSpeedButton: TSpeedButton;
    RedoSpeedButton: TSpeedButton;
    ReloadSpeedButton: TSpeedButton;
    RunSpeedButton: TSpeedButton;
    SaveAsSpeedButton: TSpeedButton;
    SaveSpeedButton: TSpeedButton;
    Separator: TSpeedButton;
    Separator1: TSpeedButton;
    Separator2: TSpeedButton;
    Separator3: TSpeedButton;
    ToolBar: TToolBar;
    TopicSearchMI: TMenuItem;
    Separator5: TMenuItem;
    RegistersMI: TMenuItem;
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
    Separator7: TMenuItem;
    Separator9: TMenuItem;
    NewMI: TMenuItem;
    DebugMI: TMenuItem;
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
    UndoSpeedButton: TSpeedButton;
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
    Separator8: TMenuItem;
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
    
    
    StatusBar: TStatusBar;
    
    procedure AddBreakpointMIClick(Sender: TObject);
    procedure AddWatchMIClick(Sender: TObject);
    procedure ASCIITableMIClick(Sender: TObject);
    procedure BookmarksMIClick(Sender: TObject);
    procedure BookmarksSpeedButtonClick(Sender: TObject);
    procedure BreakpointListMIClick(Sender: TObject);
    procedure BTFPMIClick(Sender: TObject);
    procedure CallStackMIClick(Sender: TObject);
    procedure CloseAllMIClick(Sender: TObject);
    procedure ClosePClick(Sender: TObject);
    procedure CompilerOutputPanelMouseDown(Sender: TOBject;
      Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure CompilerOutputPanelMouseMove(Sender: TObject; Shift: TShiftState;
      X, Y: Integer);
    procedure CompilerOutputPanelMouseUp(Sender: TOBject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure CompilerOutputSelectionChange(Sender: TObject; User: boolean);
    procedure CompileSpeedButtonClick(Sender: TObject);
    procedure CompilerOutputCloseButtonClick(Sender: TObject);
    procedure ContinueMIClick(Sender: TObject);
    procedure DiassembleMIClick(Sender: TObject);
    procedure EvaluatorMIClick(Sender: TObject);
    procedure FindNextSpeedButtonClick(Sender: TObject);
    procedure FindPreviousSpeedButtonClick(Sender: TObject);
    procedure FindSpeedButtonClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormChangeBounds(Sender: TObject);
    procedure HelpContentsMIClick(Sender: TObject);
    procedure HelpFilesMIClick(Sender: TObject);
    procedure HelpIndexMIClick(Sender: TObject);
    procedure HistoryBackMIClick(Sender: TObject);
    procedure HistoryForwardMIClick(Sender: TObject);
    procedure IndentMIClick(Sender: TObject);
    procedure MainFormDestroy(Sender: TObject);
    procedure GotoLineNumberSpeedButtonClick(Sender: TObject);
    procedure MainFormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure MainFormCreate(Sender: TObject);
    procedure MainFormResize(Sender: TObject);
    procedure CopyClick(Sender: TObject);
    procedure LineNumbersMIClick(Sender: TObject);
    procedure NextBookmarkMIClick(Sender: TObject);
    procedure NextBookmarkSpeedButtonClick(Sender: TObject);
    procedure PageControllerMouseUp(Sender: TOBject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure PageControllerPageChanged(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure PreviousBookmarkMIClick(Sender: TObject);
    procedure PreviousBookmarkSpeedButtonClick(Sender: TObject);
    procedure ProcessListMIClick(Sender: TObject);
    procedure RegistersMIClick(Sender: TObject);
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
    procedure StepOverMIClick(Sender: TObject);
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
    procedure ToggleBookmarkMIClick(Sender: TObject);
    procedure ToggleBookmarkSpeedButtonClick(Sender: TObject);
    procedure ToolbarMIClick(Sender: TObject);
    procedure TopicSearchMIClick(Sender: TObject);
    procedure TraceIntoMIClick(Sender: TObject);
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
    procedure UnindentMIClick(Sender: TObject);
    
    procedure ValidateMenus(value:boolean);
    procedure ValidateDebugger(value:boolean);
    procedure ValidateInlineDebugger(value:boolean);

    //asynchronous callbacks
    procedure ASCIITableCallback(b:byte);
    procedure WatchListCloseCallback(Sender:TObject);
    procedure BreakpointListCloseCallback(Sender:TObject);
    procedure CallStackCloseCallback(Sender:TObject);
    procedure RegistersCloseCallback(Sender:TObject);
    procedure DisassemblyCloseCallback(Sender:TObject);
    procedure BookmarkListSelectCallback(i:integer);
    procedure ProcessListCloseCallback(Sender:TObject);
    procedure EvaluatorCloseCallback(Sender:TObject);
    procedure AsciiTableClose(Sender:TObject);
    procedure RegisterCallbacks();
    function GetActiveEditorAsCustomEditor():TCustomEditor;
    function GetEditorAsCustomEditor(id:integer):TCustomEditor;
    
    procedure EditorMouseClick(Sender: TObject);
    function CloseAllEditors():boolean;
    function GetActiveEditor():TMyCustomEditor;
    function GetEditor(id:integer):TMyCustomEditor;
    procedure AddEditor();
    procedure AddEditor(filename:ansistring);
    procedure CloseEditor(id:integer);
    function EditorsAvailable():boolean;
    function GetUntitledName():ansistring;
    function GetName(s:ansistring):ansistring;

    procedure CreateProcess(filename,args,rundir:ansistring;options:TProcessOptions);
    procedure KillProcess(id:integer);
    procedure WatchesMIClick(Sender: TObject);
    function GotoEditor(filename:ansistring;linenumber:integer):boolean;
    function GotoEditor(filename:ansistring;linenumber,columnnumber:integer):boolean;
    function doGotoEditor(filename:ansistring;linenumber,columnnumber:integer):boolean;
    procedure DebuggerProgramTerminated(Sender:TObject);
    
    procedure TabNameChanged(Sender:TObject);
    procedure FileNameChanged(Sender:TOBject);
    procedure BookmarkLineChange(Sender:TObject);
    
  private
    imode:boolean;
    EditorOptions:TEditorOptions;
    um_top,um_left,um_width,um_height:integer;
    error_file:string;
    error_line:integer;
    popupAMI:integer;
    Editors,Processes:TList;
    History:array of THistoryMark;
    HistoryPointer:integer;
    Bookmarks:TList;
    HelpFiles:TStringList;
    debugger:TProgramDebugger;
    COP_x,COP_y:integer;
    COP_MouseDown:boolean;
    { private declarations }
  public
    { public declarations }
  end; 
var
  MainForm: TMainForm;

implementation

procedure TBookmark.setFileName(v:ansistring);
begin
     fFileName:=v;
     if Assigned(onChange) then onChange(self);
end;

procedure TBookmark.setLineNumber(v:integer);
begin
     fLineNumber:=v;
     if Assigned(onChange) then onChange(self);
end;

procedure TBookmark.setCaption(v:ansistring);
begin
     fCaption:=v;
     if Assigned(onChange) then onChange(self);
end;


{$ifdef win32}
function EnumWindowsCallback(hwnd:hwnd;lparam:lparam):longbool;stdcall;
var pid:integer;
begin
     GetWindowThreadProcessId(hwnd,@pid);
     if pid=lparam then
      begin
       BringWindowToTop(hwnd);
       SetForegroundWindow(hwnd);
       result:=false;
      end          else result:=true;
end;
{$endif}

function FixFileName(filename:ansistring):ansistring;
const ds={$ifdef win32}'\'{$else}'/'{$endif};
var i:integer;
begin
     for i:=length(filename) downto 1 do
      if filename[i]=ds then break;
     Result:=Copy(filename,1,i);
     for i:=i+1 to length(filename) do
      if (filename[i]=#9)or(filename[i]=' ')then Result+='_'
                                            else Result+=filename[i];
end;

constructor TMyCustomEditor.Create(rldb:boolean);
begin
     inherited Create(MainForm);
     //self.onFileChange:=@MainForm.FileNameChanged;
     self.onNameChange:=@MainForm.TabNameChanged;
     isunsaved:=false;
     canreload:=rldb;
     activefilename:='';
end;


destructor TMyCustomEditor.Destroy();
begin
     inherited Destroy();
end;

procedure TMyCustomEditor.Save();
begin
     if activefilename='' then
      begin
       MainForm.SaveDialog.Filename:=ExtractFileDir(MainForm.SaveDialog.Filename)+ExtractFileName(activefilename);
       if MainForm.SaveDialog.Execute() then
        begin
         activefilename:=FixFileName(MainForm.SaveDialog.Filename);
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
         activefilename:=FixFileName(MainForm.SaveDialog.Filename);
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

function TMainForm.GetEditor(id:integer):TMyCustomEditor;
begin
     try
      result:=TMyCustomEditor(Editors.Items[id]);
     except
      result:=nil;
     end;
end;

function Exists(t:TStrings;name:ansistring):boolean;inline;
var i:integer;
    usname:ansistring;
begin
     usname:=name+'*';
     for i:=0 to t.count-1 do
      if (t.strings[i]=name)or(t.strings[i]=usname) then exit(true);
     exit(false);
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

function TMainForm.GetUntitledName():ansistring;
var i:integer;
begin
     i:=0;
     while exists(PageController.Pages  ,'untitled'+IntToStr(i)+'.pp') do inc(i);
     exit('untitled'+IntToStr(i)+'.pp');
end;

function TMainForm.GetName(s:ansistring):ansistring;
var i:integer;
begin
 if not exists(PageController.Pages,s) then exit(s);
 i:=2;
 while exists(PageController.Pages,s+' ('+IntToStr(i)+')') do inc(i);
 exit(s+' ('+IntToStr(i)+')');
end;

{ TMainForm }

procedure TMainForm.CreateProcess(filename,args,rundir:ansistring;options:TPRocessOptions);
var p:PDataContainer;
begin
     new(p);
     p^.cmdline:=filename;
     p^.args:=args;
     p^.StartStamp:=FormatDateTime('hh:nn:ss',Now());
     p^.hwnd:=0;
     p^.proc:=TProcess.Create(self);
     p^.proc.CommandLine:=filename+' '+args;
     p^.proc.CurrentDirectory:=rundir;
     p^.proc.Options:=options;
     p^.proc.Execute();
     Processes.Add(p);
     ProcessListWindow.Refresh();
end;

procedure TMainForm.KillProcess(id:integer);
var p:PDataContainer;
begin
     p:=PDataContainer(Processes.Items[id]);
     if p^.proc.Running then p^.proc.Terminate(255);//killed by master
     p^.proc.Destroy();
     dispose(p);
     Processes.Delete(id);
     ProcessListWindow.Refresh();
end;

procedure TMainForm.WatchesMIClick(Sender: TObject);
begin
     WatchListWindow.Visible:=not(WatchListWindow.Visible);
     WatchesMI.Checked:=WatchListWindow.Visible;
end;

procedure TMainForm.MainFormCreate(Sender: TObject);
var i:integer;
begin
  Processes:=TList.Create();
  Editors:=TList.Create();
  HelpFiles:=TStringList.Create();
  EditorOptions:=TEditorOptions.Create('editor.ini');
  Bookmarks:=TList.Create();
  HistoryPointer:=0;
  
  EditorOptions.sbooks:=Bookmarks;

  //build node index
  for i:=0 to length(EditorOptions.helpfiles)-1 do
   if FileExists(EditorOptions.helpfiles[i]+'.index')then
    AddFileContent(EditorOptions.helpfiles[i]+'.index',HelpFiles);

  Toolbar.Visible:=EditorOptions.view_toolbar;
  ToolbarMI.Checked:=EditorOptions.view_toolbar;
{  if Toolbar.Visible then PageController.Top:=26
                     else PageController.Top:=0;
                     
  PageController.Height:=Statusbar.Top-PageController.Top;}
  
  
  LineNumbersMI.Checked:=EditorOptions.line_numbers;


  if EditorOptions.window_maximized then WindowState:=wsMaximized
                                    else WindowState:=wsNormal;


  top:=EditorOptions.window_top;
  left:=EditorOptions.window_left;
  width:=EditorOptions.window_width;
  height:=EditorOptions.window_height;

  {$ifdef win32}


  if Odd(GetKeyState(vk_NumLock)) then StatusBar.Panels[4].Text := 'NUM'
                                  else StatusBar.Panels[4].Text := '';
  if Odd(GetKeyState(vk_Capital)) then StatusBar.Panels[3].Text := 'CAP'
                                  else StatusBar.Panels[3].Text := '';
  {$endif}

  statusbar.panels[1].text:='Ln 0 Col 0';

  EditorOptions.primary_file:=-1;

  ActiveControl:=PageController;
  ValidateDebugger(false);
  ValidateMenus(false);
  
  //the parameters are handled within the RegisterCallbacks method since the components are not created here yet.
end;

function TMainForm.EditorsAvailable():boolean;
begin
     result:=PageController.PageCount>0;
end;

function TMainForm.GetActiveEditorAsCustomEditor():TCustomEditor;
begin
     Result:=GetActiveEditor();
end;

function TMainForm.GetEditorAsCustomEditor(id:integer):TCustomEditor;
begin
     Result:=GetEditor(id);
end;

procedure TMainForm.ProcessListCloseCallback(Sender:TObject);
begin
     ProcessListMI.Checked:=false;
end;

procedure TMainForm.EvaluatorCloseCallback(Sender:TObject);
begin
     EvaluatorMI.Checked:=false;
end;

procedure TMainForm.ASCIITableClose(Sender:TObject);
begin
     AsciiTableMI.Checked:=false;
end;


procedure TMainForm.RegisterCallbacks();
var i:integer;
    mybook:TBookmark;
begin
  ASCIITable.Callback:=@ASCIITableCallback;
  ASCIITable.CloseCallback:=@ASCIITableClose;
  WatchListWindow.Callback:=@WatchListCloseCallback;
  BreakPointListWindow.Callback:=@BreakPointListCloseCallback;
  BreakPointListWindow.l:=Editors;
  BreakPointListWindow.GetCurrentEditor:=@GetActiveEditorAsCustomEditor;
  BreakPointListWindow.GetEditor:=@GetEditorAsCustomEditor;
  CallStackWindow.Callback:=@CallStackCloseCallback;
  RegistersWindow.Callback:=@RegistersCloseCallback;
  DisassemblyWindow.Callback:=@DisassemblyCloseCallback;
  ProcessListWindow.mylist:=Processes;
  BookmarkListWindow.l:=Bookmarks;
  BookmarkListWindow.Callback:=@BookmarkListSelectCallback;
  EvaluatorWindow.Callback:=@EvaluatorCloseCallback;
  ProcessListWindow.Callback:=@ProcessListCloseCallback;
  HelpFilesDialog.HelpIndex:=HelpFiles;
  if EditorOptions.DefaultHelp<>-1 then HelpDialog.ContentHome:=EditorOptions.HelpFiles[EditorOptions.DefaultHelp];
  HelpDialog.HelpIndex:=HelpFiles;
  
  WatchListWindow.Top:=EditorOptions.wlw_top;
  WatchListWindow.Left:=EditorOptions.wlw_left;
  WatchListWindow.Width:=EditorOptions.wlw_width;
  WatchListWindow.Height:=EditorOptions.wlw_height;
  WatchListWindow.Visible:=EditorOptions.wlw_visible;

  BreakpointListWindow.Top:=EditorOptions.bpw_top;
  BreakpointListWindow.Left:=EditorOptions.bpw_left;
  BreakpointListWindow.Width:=EditorOptions.bpw_width;
  BreakpointListWindow.Height:=EditorOptions.bpw_height;
  BreakpointListWindow.Visible:=EditorOptions.bpw_visible;
  
  CallstackWindow.Top:=EditorOptions.csw_top;
  CallstackWindow.Left:=EditorOptions.csw_left;
  CallstackWindow.Width:=EditorOptions.csw_width;
  CallstackWindow.Height:=EditorOptions.csw_height;
  CallstackWindow.Visible:=EditorOptions.csw_visible;

  RegistersWindow.Top:=EditorOptions.rgw_top;
  RegistersWindow.Left:=EditorOptions.rgw_left;
  RegistersWindow.Width:=EditorOptions.rgw_width;
  RegistersWindow.Height:=EditorOptions.rgw_height;
  RegistersWindow.Visible:=EditorOptions.rgw_visible;
  
  DisassemblyWindow.Top:=EditorOptions.daw_top;
  DisassemblyWindow.Left:=EditorOptions.daw_left;
  DisassemblyWindow.Width:=EditorOptions.daw_width;
  DisassemblyWindow.Height:=EditorOptions.daw_height;
  DisassemblyWindow.Visible:=EditorOptions.daw_visible;
  
  BookmarkListWindow.Top:=EditorOptions.bmw_top;
  BookmarkListWindow.Left:=EditorOptions.bmw_left;
  BookmarkListWindow.Width:=EditorOptions.bmw_width;
  BookmarkListWindow.Height:=EditorOptions.bmw_height;
  BookmarkListWindow.Visible:=EditorOptions.bmw_visible;

  AsciiTable.Top:=EditorOptions.at_top;
  AsciiTable.Left:=EditorOptions.at_left;
  AsciiTable.Visible:=EditorOptions.at_visible;

  if (EditorOptions.plw_width<>0)and(EditorOptions.plw_height<>0)then
   begin
    ProcessListWindow.Position:=poDesigned;
    ProcessListWindow.Top:=EditorOptions.plw_top;
    ProcessListWindow.Left:=EditorOptions.plw_left;
    ProcessListWindow.Width:=EditorOptions.plw_width;
    ProcessListWindow.Height:=EditorOptions.plw_height;
   end;
  ProcessListWindow.Visible:=EditorOptions.plw_visible;

  if (EditorOptions.evw_width<>0)and(EditorOptions.evw_height<>0)then
   begin
    EvaluatorWindow.Position:=poDesigned;
    EvaluatorWindow.Top:=EditorOptions.evw_top;
    EvaluatorWindow.Left:=EditorOptions.evw_left;
    EvaluatorWindow.Width:=EditorOptions.evw_width;
    EvaluatorWindow.Height:=EditorOptions.evw_height;
   end;
  EvaluatorWindow.Visible:=EditorOptions.evw_visible;

  
  CompilerOutputPanel.height:=EditorOptions.ms_height;
  if EditorOptions.ms_visible then MessagesClick(self);

  //handle parameters
  
  for i:=1 to paramcount do AddEditor(paramstr(i));

  //build bookmarks
  for i:=0 to length(EditorOptions.bookmarks)-1 do
   begin
    mybook:=TBookmark.Create();
    mybook.LineNumber:=EditorOptions.bookmarks[i].line;
    mybook.ColumnNumber:=EditorOptions.bookmarks[i].column;
    mybook.Caption:=EditorOptions.bookmarks[i].caption;
    mybook.FileName:=EditorOptions.bookmarks[i].filename;
    mybook.onChange:=@BookmarkListWindow.RefreshList;
    Bookmarks.Add(mybook);
   end;

  BookmarkListWindow.RefreshList(self);
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
     BreakpointListWindow.RefreshBreakpointList;
end;

procedure TMainForm.MainFormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
 CanClose:=CloseAllEditors();
 if CanClose then
  begin
   EditorOptions.window_width:=width;
   EditorOptions.window_height:=height;
   EditorOptions.window_top:=top;
   EditorOptions.window_left:=left;

   EditorOptions.bpw_top:=BreakpointListWindow.Top;
   EditorOptions.bpw_left:=BreakpointListWindow.Left;
   EditorOptions.bpw_width:=BreakpointListWindow.Width;
   EditorOptions.bpw_height:=BreakpointListWindow.Height;
   EditorOptions.bpw_visible:=BreakpointListWindow.Visible;

   EditorOptions.csw_top:=CallstackWindow.Top;
   EditorOptions.csw_left:=CallstackWindow.Left;
   EditorOptions.csw_width:=CallstackWindow.Width;
   EditorOptions.csw_height:=CallstackWindow.Height;
   EditorOptions.csw_visible:=CallstackWindow.Visible;

   EditorOptions.rgw_top:=RegistersWindow.Top;
   EditorOptions.rgw_left:=RegistersWindow.Left;
   EditorOptions.rgw_width:=RegistersWindow.Width;
   EditorOptions.rgw_height:=RegistersWindow.Height;
   EditorOptions.rgw_visible:=RegistersWindow.Visible;

   EditorOptions.wlw_top:=WatchlistWindow.Top;
   EditorOptions.wlw_left:=WatchlistWindow.Left;
   EditorOptions.wlw_width:=WatchlistWindow.Width;
   EditorOptions.wlw_height:=WatchlistWindow.Height;
   EditorOptions.wlw_visible:=WatchListWindow.Visible;

   EditorOptions.daw_top:=DisassemblyWindow.Top;
   EditorOptions.daw_left:=DisassemblyWindow.Left;
   EditorOptions.daw_width:=DisassemblyWindow.Width;
   EditorOptions.daw_height:=DisassemblyWindow.Height;
   EditorOptions.daw_visible:=DisassemblyWindow.Visible;

   EditorOptions.plw_top:=ProcessListWindow.Top;
   EditorOptions.plw_left:=ProcessListWindow.Left;
   EditorOptions.plw_width:=ProcessListWindow.Width;
   EditorOptions.plw_height:=ProcessListWindow.Height;
   EditorOptions.plw_visible:=ProcessListWindow.Visible;

   EditorOptions.evw_top:=EvaluatorWindow.Top;
   EditorOptions.evw_left:=EvaluatorWindow.Left;
   EditorOptions.evw_width:=EvaluatorWindow.Width;
   EditorOptions.evw_height:=EvaluatorWindow.Height;
   EditorOptions.evw_visible:=EvaluatorWindow.Visible;
   
   EditorOptions.bmw_top:=BookmarkListWindow.Top;
   EditorOptions.bmw_left:=BookmarkListWindow.Left;
   EditorOptions.bmw_width:=BookmarkListWindow.Width;
   EditorOptions.bmw_height:=BookmarkListWindow.Height;
   EditorOptions.bmw_visible:=BookmarkListWindow.Visible;


   EditorOptions.at_top:=AsciiTable.Top;
   EditorOptions.at_left:=AsciiTable.Left;
   EditorOptions.at_visible:=AsciiTable.Visible;

   EditorOptions.ms_visible:=CompilerOutputPanel.Visible;
   EditorOptions.ms_height:=CompilerOutputPanel.Height;

   if WindowState=wsMaximized then EditorOptions.window_maximized:=true
                              else EditorOptions.Window_maximized:=false;
  end;
end;

procedure TMainForm.CompilerOutputCloseButtonClick(Sender: TObject);
begin
 MessagesClick(sender);
end;

procedure TMainForm.ContinueMIClick(Sender: TObject);
begin
  if debugger=nil then DebugClick(Sender)
                  else
  if debugger<>nil then
   begin
    {$ifdef win32}
     BringWindowToTop(debugger.Handle);
     SetForegroundWindow(debugger.Handle);
    {$endif}
    ValidateInlineDebugger(false);
    debugger.Continue();
    ValidateInlineDebugger(true);
    //check necesarry in case this is the last step
    if debugger<>nil then GotoEditor(debugger.CurrentFileName,debugger.CurrentLineNumber);
    BringToFront();
    SetFocus();
    if WatchListWindow.Visible then WatchListWindow.RefreshWatchList();
    if CallStackWindow.Visible then CallStackWindow.RefreshCallStack();
    if RegistersWindow.Visible then RegistersWindow.RefreshRegisters();
    if DisassemblyWindow.Visible then DisassemblyWindow.RefreshDisassemblyWindow();
   end;
end;

procedure TMainForm.DiassembleMIClick(Sender: TObject);
begin
     DisassemblyWindow.Visible:=not(DisassemblyWindow.Visible);
     DisassembleMI.Checked:=DisassemblyWindow.Visible;
end;

procedure TMainForm.EvaluatorMIClick(Sender: TObject);
begin
  EvaluatorWindow.Visible:=not(EvaluatorWindow.Visible);
  EvaluatorMI.Checked:=EvaluatorWindow.Visible;
end;

procedure TMainForm.CompileSpeedButtonClick(Sender: TObject);
begin
  CompileClick(sender);
end;

procedure TMainForm.ASCIITableMIClick(Sender: TObject);
begin
  ASCIITable.Visible:=not(ASCIITable.Visible);
  ASCIITableMI.Checked:=ASCIITable.Visible;
end;

procedure TMainForm.BookmarksMIClick(Sender: TObject);
begin
  BookmarkListWindow.Visible:=not(BookmarkListWindow.Visible);
  BookmarksMI.Checked:=BookmarkListWindow.Visible;
end;

procedure TMainForm.BookmarksSpeedButtonClick(Sender: TObject);
begin
  BookmarksMIClick(Sender)
end;

procedure TMainForm.BreakpointListMIClick(Sender: TObject);
begin
  BreakPointListWindow.Visible:=not(BreakPointListWindow.Visible);
  BreakPointListMI.Checked:=BreakPointListWindow.Visible;
end;

procedure TMainForm.AddWatchMIClick(Sender: TObject);
begin
  if AddWatchDialog.Execute() then
   begin
    if not WatchListWindow.Visible then WatchListWindow.Visible:=true;
    WatchListWindow.AddWatch(AddWatchDialog.Expression);
   end;
end;

procedure TMainForm.AddBreakpointMIClick(Sender: TObject);
var i:integer;
    aint:TBreakpointSynEditMark;
begin
     if not BreakpointListWindow.Visible then BreakpointListWindow.Visible:=true;
     with GetActiveEditor() do
      begin
       for i:=0 to Marks.Count-1 do
        if (Marks[i] is TBreakpointSynEditMark)and(Marks[i].Line=CaretY) then
         begin
          Marks[i].Destroy();
          Marks.Delete(i);
          BreakpointListWindow.RefreshBreakpointList();
          exit;
         end;
       aint:=TBreakpointSynEditMark.Create(GetActiveEditor());
       aint.Line:=CaretY;
       aint.onLineChange:=@BreakpointListWindow.PostRefresh;
       Marks.Add(aint);
       BreakpointListWindow.RefreshBreakpointList();
      end;
end;

procedure TMainForm.BTFPMIClick(Sender: TObject);
begin
  PageController.PageIndex:=popupAMI;
end;

procedure TMainForm.CallStackMIClick(Sender: TObject);
begin
  CallStackWindow.Visible:=not(CallStackWindow.Visible);
  CallStackMI.Checked:=CallStackWindow.Visible;
end;

procedure TMainForm.CloseAllMIClick(Sender: TObject);
begin
     CloseAllEditors();
end;

procedure TMainForm.ClosePClick(Sender: TObject);
begin
     try
      CloseEditor(popupAMI);
     finally
     end;
end;

procedure TMainForm.CompilerOutputPanelMouseDown(Sender: TOBject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     COP_MouseDown:=true;
     COP_x:=x;
     COP_y:=y;
end;

procedure TMainForm.CompilerOutputPanelMouseMove(Sender: TObject;
  Shift: TShiftState; X, Y: Integer);
var b:integer;
begin
     if COP_MouseDown then
      begin
       b:=CompilerOutputPanel.Height+COP_y-y;
       if b<80 then b:=80;
       if b>StatusBar.Top-100 then b:=StatusBar.Top-100;
       CompilerOutputPanel.Height:=b;
      end;
end;

procedure TMainForm.CompilerOutputPanelMouseUp(Sender: TOBject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
     COP_MouseDown:=false;
end;

procedure TMainForm.CompilerOutputSelectionChange(Sender: TObject; User: boolean);
var l1,l2,f,p:string;
    cx,cy,code,i:integer;
begin
    if CompilerOutput.Items.Count>0 then
      begin
      if CompilerOutput.ItemIndex<0 then exit;
      if CompilerOutput.ItemIndex=CompilerOutput.Items.Count then CompilerOutput.ItemIndex:=CompilerOutput.Items.Count-1;
       p:=CompilerOutput.Items.Strings[CompilerOutput.ItemIndex];
       for i:=1 to length(p) do
        if p[i]='(' then break;
       f:=Copy(p,1,i-1);
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
         val(l1,i,code);

         cy:=i;
         val(l2,i,code);
         if code=0 then cx:=i
                   else cx:=1;
                   
         if GotoEditor(f,cy,cx) then
          begin
           error_file:=f;
           error_line:=cy;
           if error_line>GetActiveEditor().Lines.Count then error_line:=GetActiveEditor().Lines.Count;
           ActiveControl:=GetActiveEditor();
          end;
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

procedure TMainForm.FormActivate(Sender: TObject);
begin
    if GetActiveEditor<>nil then
     GotoEditor(GetActiveEditor().ActiveFileName,GetActiveEditor().CaretY,GetActiveEditor().CaretX);
end;

procedure TMainForm.FormChangeBounds(Sender: TObject);
begin
  if WindowState<>wsMaximized then
   begin
    um_top:=top;
    um_left:=left;
   end;
end;

procedure TMainForm.HelpContentsMIClick(Sender: TObject);
begin
  if EditorOptions.defaulthelp<>-1 then HelpDialog.Execute(EditorOptions.helpfiles[EditorOptions.defaulthelp]);
end;

procedure TMainForm.HelpFilesMIClick(Sender: TObject);
begin
  HelpFilesDialog.Execute(EditorOptions);
  if EditorOptions.DefaultHelp<>-1 then HelpDialog.ContentHome:=EditorOptions.HelpFiles[EditorOptions.DefaultHelp];
end;

procedure TMainForm.HelpIndexMIClick(Sender: TObject);
begin
  HelpDialog.ExecuteIndex('');
end;

procedure TMainForm.HistoryBackMIClick(Sender: TObject);
begin
     if HistoryPointer>0 then
      begin
       Dec(HistoryPointer);
       doGotoEditor(History[HistoryPointer].Filename,History[HistoryPointer].Line,History[HistoryPointer].Column);
      end;
end;

procedure TMainForm.HistoryForwardMIClick(Sender: TObject);
begin
     if HistoryPointer<length(History)-1 then
      begin
       Inc(HistoryPointer);
       doGotoEditor(History[HistoryPointer].Filename,History[HistoryPointer].Line,History[HistoryPointer].Column);
      end;
end;

procedure TMainForm.IndentMIClick(Sender: TObject);
var e:TSynEdit;
    s:string='  ';
    linestart,lineend,i2,i:integer;
    bb,be:TPoint;
begin
  e:=getActiveEditor();
  bb:=e.BlockBegin;
  be:=e.BlockEnd;
  linestart:=e.BlockBegin.Y-1;
  if e.BlockEnd.X=1 then i:=2 else i:=1;
  lineend:=e.BlockEnd.Y-i;
  if lineend<linestart then lineend:=linestart;
  for i2:=linestart to lineend do
   e.Lines[i2]:=s+e.Lines[i2];
  e.BlockBegin:=bb;
  e.BlockEnd:=be;
end;

procedure TMainForm.MainFormDestroy(Sender: TObject);
var i:integer;
begin
 for i:=0 to HelpFiles.Count-1 do HelpFiles.Objects[i].Destroy;
 HelpFiles.Clear();
 if debugger<>nil then debugger.Destroy();//kill the mofo
 Processes.Destroy();
 Editors.Destroy();
 HelpFiles.Destroy();

 EditorOptions.Destroy();

 Bookmarks.Clear();
 Bookmarks.Destroy();
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
 statusbar.panels[0].Width:=statusbar.width-224;
end;

procedure TMainForm.CutClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().CutToClipboard;
end;

procedure TMainForm.CopyClick(Sender: TObject);
begin
  if EditorsAvailable() then GetActiveEditor().CopyToClipboard;
end;

procedure TMainForm.LineNumbersMIClick(Sender: TObject);
var i:integer;
begin
  EditorOptions.line_numbers:=not(EditorOPtions.line_numbers);
  LineNumbersMI.Checked:=EditorOptions.line_numbers;
  for i:=0 to Editors.Count-1 do
   EditorOptions.Setup(GetEditor(i));
end;

procedure TMainForm.NextBookmarkMIClick(Sender: TObject);
var i:integer;
begin
     with GetActiveEditor() do
      begin
       for i:=0 to Marks.Count-1 do
        if Marks[i] is TBookmarkSynEditMark then
         if(Marks[i].Line>CaretY)or((Marks[i].Line=CaretY)and(Marks[i].Column>CaretX))then
          begin
           GotoEditor(GetActiveEditor().ActiveFileName,Marks[i].Line,Marks[i].Column);
           exit;
          end;
        GotoEditor(GetActiveEditor().ActiveFileName,Marks[0].Line,Marks[0].Column);
      end;
end;

procedure TMainForm.NextBookmarkSpeedButtonClick(Sender: TObject);
begin
  NextBookmarkMIClick(Sender);
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

procedure TMainForm.PreviousBookmarkMIClick(Sender: TObject);
var i:integer;
begin
     with GetActiveEditor() do
      begin
       for i:=Marks.Count-1 downto 0 do
        if Marks[i] is TBookmarkSynEditMark then
         if(Marks[i].Line<CaretY)or((Marks[i].Line=CaretY)and(Marks[i].Column<CaretX))then
          begin
           GotoEditor(GetActiveEditor().ActiveFileName,Marks[i].Line,Marks[i].Column);
           exit;
          end;
        GotoEditor(GetActiveEditor().ActiveFileName,Marks[Marks.Count-1].Line,Marks[Marks.Count-1].Column);
      end;
end;

procedure TMainForm.PreviousBookmarkSpeedButtonClick(Sender: TObject);
begin
  PreviousBookmarkMIClick(Sender);
end;

procedure TMainForm.ProcessListMIClick(Sender: TObject);
begin
     ProcessListWindow.Refresh();
     ProcessListWindow.Visible:=not(ProcessListWindow.Visible);
     ProcessListMI.Checked:=ProcessListWindow.Visible;
end;

procedure TMainForm.RegistersMIClick(Sender: TObject);
begin
     RegistersWindow.Visible:=not(RegistersWindow.Visible);
     RegistersMI.Checked:=RegistersWindow.Visible;
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
  CompilerOutputPanel.Visible:=not(CompilerOutputPanel.Visible);
  MessagesMI.Checked:=not(MessagesMI.Checked);
{  if CompilerOutputPanel.visible then PageController.Height:=Statusbar.Top-CompilerOutputPanel.Height-PageController.Top
                                 else PageController.Height:=Statusbar.Top-PageController.Top;}
end;

//debug
procedure TMainForm.DebugClick(Sender: TObject);
var om,mr,b:integer;
    rdir,exefile,s:string;
    cancompile:boolean;
const ds={$ifdef win32}'\'{$else}'/'{$endif};
begin
     if debugger<>nil then
      begin
        mr:=MessageBox('You are currently debugging another application. In order to proceed, the application currently being debugged must be terminated. Do you still wish to continue?','Warning',0);
        if mr=MR_YES then
         begin
          debugger.Destroy();
          debugger:=nil;
         end;
      end;
     if debugger=nil then
      begin
       //attempt to compile
       om:=EditorOptions.Mode;
       EditorOptions.Mode:=1;//set mode to debug
       if EditorOptions.Primary_File=-1 then b:=PageController.PageIndex
                                        else b:=EditorOptions.Primary_File;
       GetEditor(b).Save();
       if GetEditor(b).ActiveFileName<>'' then
        begin
         if CompilerOutputPanel.visible=false then MessagesClick(sender);
         cancompile:=CompileDialog.Execute(GetEditor(b).ActiveFileName,EditorOptions,true);
         if CompileDialog.OutputLines.Count<>0 then CompilerOutput.Items.Assign(CompileDialog.OutputLines);

         s:=GetEditor(b).activefilename;
         exefile:=copy(s,1,length(s)-length(ExtractFileExt(s))){$IFDEF WIN32}+'.exe'{$ENDIF};

         if EditorOptions.rundir<>'' then rdir:=EditorOptions.rundir
                                     else rdir:=ExtractFileDir(exefile);
         //attempt to debug
         if (cancompile)and(FileExists(exefile)) then
          begin
           try
            debugger:=TProgramDebugger.Create(EditorOptions.bin_directory,exefile,rdir,EditorOptions.exeparams);
            debugger.onProgramTermination:=@DebuggerProgramTerminated;
            BreakpointListWindow.Debugger:=debugger;
            WatchListWindow.Debugger:=debugger;
            CallStackWindow.Debugger:=debugger;
            RegistersWindow.Debugger:=debugger;
            DisassemblyWindow.Debugger:=debugger;
            ValidateDebugger(true);
            BreakpointListWindow.Debugging:=true;
            BringToFront();
            SetFocus();
            GotoEditor(debugger.CurrentFileName,debugger.CurrentLineNumber);
           except
            if not CompilerOutputPanel.Visible then MessagesClick(Sender);//make messages window visible
            CompilerOutput.Items.add('Could not execute "'+EditorOptions.bin_directory+ds+'gdb'+{$IFDEF WIN32}'.exe'{$ELSE}''{$ENDIF}+'". Make sure your compiler path is set correctly');
            CompilerOutputTitle.Caption:='Messages';
            CompilerOutputTitle.Width:=CompilerOutputPanel.Width;
            CompilerOutputTitle.Refresh;
           end;
          end;
        end;
       EditorOptions.Mode:=om;//restore mode
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
     BreakpointListWindow.RefreshBreakpointList();
end;

procedure TMainForm.AddEditor();
var aeditor:TMyCustomEditor;
begin
     aeditor:=TMyCustomEditor.Create(false);

     aeditor.Anchors:=[akTop,akLeft,akRight,akBottom];
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
       CompilerOutputPanel.Visible:=Not(CompilerOutputPanel.Visible);
       CompilerOutputPanel.Visible:=Not(CompilerOutputPanel.Visible);
      end;

end;

procedure TMainForm.AddEditor(filename:ansistring);
var aeditor:TMyCustomEditor;
    mymark:TbookmarkSynEditMark;
    i:integer;
begin
     if FileExists(filename) then
      begin
       aeditor:=TMyCustomEditor.Create(true);

       aeditor.Anchors:=[akTop,akLeft,akRight,akBottom];
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
         CompilerOutputPanel.Visible:=Not(CompilerOutputPanel.Visible);
         CompilerOutputPanel.Visible:=Not(CompilerOutputPanel.Visible);
        end;

       for i:=0 to Bookmarks.Count-1 do
        if TBookmark(Bookmarks[i]).FileName=filename then
         with TBookmark(Bookmarks[i]) do
          begin
           mymark:=TBookmarkSynEditMark.Create(GetActiveEditor());
           mymark.Line:=LineNumber;
           mymark.Column:=ColumnNumber;
           mymark.ParentPointer:=TBookmark(Bookmarks[i]);
           ChildPointer:=mymark;
           mymark.onLineChange:=@BookmarkLineChange;
           GetActiveEditor().Marks.Add(mymark);
          end;
       BookmarkListWindow.RefreshList(self);
      end;
end;

procedure TMainForm.NewClick(Sender: TObject);
begin
     AddEditor();
end;

procedure TMainForm.TargetClick(Sender: TObject);
begin
     TargetDialog.Execute(EditorOptions);
end;

procedure TMainForm.PrimaryFileClick(Sender: TObject);
begin
     PrimaryFileDialog.Execute(PageController,EditorOptions);
end;

procedure TMainForm.ClearPrimaryFileClick(Sender: TObject);
begin
  EditorOptions.primary_file:=-1;
end;


procedure TMainForm.OpenClick(Sender: TObject);
var j,i:integer;
    found:boolean;
begin
     OpenDialog.InitialDir:=GetCurrentDir();
     if OpenDialog.Execute then
      begin
       for j:=0 to OpenDialog.Files.Count-1 do
        begin
         found:=false;
         for i:=0 to PageController.PageCount-1 do
          if OpenDialog.Files[j]=GetEditor(i).activefilename then
           begin
            PageController.PageIndex:=i;
            found:=true;
            break;
           end;
         if not found then AddEditor(OpenDialog.Files[j]);
        end;
      end;
end;

procedure TMainForm.SaveClick(Sender: TObject);
begin
     GetActiveEditor().Save();
end;

procedure TMainForm.EditorClick(Sender: TObject);
var i:integer;
begin
     EditorOptionsDialog.Execute(EditorOptions);
     for i:=0 to PageController.PageCount-1 do EditorOptions.Setup(GetEditor(i));
end;

procedure TMainForm.ColorsClick(Sender: TObject);
var i:integer;
begin
   EditorStyleDialog.Execute(EditorOPtions);
   for i:=0 to PageController.PageCount-1 do
    begin
     GetEditor(i).font.name:=EditorOptions.Font_name;
     GetEditor(i).font.size:=EditorOptions.Font_size;
    end;
end;

procedure TMainForm.ExitClick(Sender: TObject);
var canclose:boolean;
begin
  canclose:=false;
  MainFormCloseQuery(sender,canclose);
  if canClose then Application.Terminate();
end;

procedure TMainForm.ToggleBookmarkMIClick(Sender: TObject);
var i:integer;
    mybook:TBookmark;
    mymark:TBookmarkSynEditMark;
begin
  for i:=0 to Bookmarks.Count-1 do
   if
      (
        TBookmark(Bookmarks[i]).LineNumber=GetActiveEditor().CaretY
      )
      and
      (
        (
          TBookmark(Bookmarks[i]).FileName=GetActiveEditor().ActiveFileName
        )
        or
        (
          (
             GetActiveEditor().ActiveFileName=''
          )
          and
          (
             TBookmark(Bookmarks[i]).FileName=GetActiveEditor().RetName
          )
        )
      )
   then
    begin
     GetActiveEditor().Marks.Delete(GetActiveEditor().Marks.IndexOf(TBookmark(Bookmarks[i]).ChildPointer));
     TBookmarkSynEditMark(TBookmark(Bookmarks[i]).ChildPointer).Destroy();
     TBookmark(Bookmarks[i]).Destroy();
     Bookmarks.Delete(i);//deleting still keeps it sorted
     BookmarkListWindow.RefreshList(self);
     exit;
    end;
  mybook:=TBookmark.Create();
  mybook.LineNumber:=GetActiveEditor().CaretY;
  mybook.ColumnNumber:=GetActiveEditor().CaretX;
  mybook.Caption:=GetActiveEditor().Lines[GetActiveEditor().CaretY-1];
  if GetActiveEditor().ActiveFileName<>'' then mybook.FileName:=GetActiveEditor().ActiveFileName
                                          else mybook.FileName:=GetActiveEditor().RetName();
  //retr i
  i:=0;
  while (i<Bookmarks.Count)and(TBookmark(Bookmarks[i]).FileName<mybook.FileName) do inc(i);
  while (i<Bookmarks.Count)and(TBookmark(Bookmarks[i]).FileName=mybook.FileName)and(TBookmark(Bookmarks[i]).LineNumber<mybook.LineNumber) do inc(i);
  Bookmarks.Insert(i,mybook);
  mybook.onChange:=@BookmarkListWindow.RefreshList;
  
  mymark:=TBookmarkSynEditMark.Create(GetActiveEditor());
  mymark.Line:=GetActiveEditor().CaretY;
  mymark.Column:=GetActiveEditor().CaretX;
  mymark.ParentPointer:=mybook;
  mybook.ChildPointer:=mymark;
  mymark.onLineChange:=@BookmarkLineChange;
  
  GetActiveEditor().Marks.Add(mymark);
  BookmarkListWindow.RefreshList(self);
end;

procedure TMainForm.ToggleBookmarkSpeedButtonClick(Sender: TObject);
begin
  ToggleBookmarkMIClick(Sender);
end;

procedure TMainForm.ToolbarMIClick(Sender: TObject);
begin
     EditorOptions.view_toolbar:=not(EditorOptions.view_toolbar);
     ToolbarMI.Checked:=EditorOptions.view_toolbar;
     Toolbar.Visible:=EditorOptions.view_toolbar;
{     if Toolbar.Visible then PageController.Top:=26
                        else PageController.Top:=0;}
end;

procedure TMainForm.TopicSearchMIClick(Sender: TObject);
var l,t:string;
    sl,s,e:integer;
begin
     //chew up a word
     l:=GetActiveEditor().Lines[GetActiveEditor().CaretY-1];
     sl:=length(l);
     s:=GetActiveEditor().CaretX;
     e:=GetActiveEditor().CaretX;
     if sl=0 then exit;
     if not((l[s] in ['a'..'z'])or(l[s] in ['A'..'Z'])or(l[s] in ['0'..'9'])or(l[s]='_')) then exit;
     while (s>1)and((l[s-1] in ['a'..'z'])or(l[s-1] in ['A'..'Z'])or(l[s-1] in ['0'..'9'])or(l[s-1]='_'))do dec(s);
     while (e<sl)and((l[e+1] in ['a'..'z'])or(l[e+1] in ['A'..'Z'])or(l[e+1] in ['0'..'9'])or(l[e+1]='_'))do inc(e);
     t:=Copy(l,s,e-s+1);
     //search for the word
     l:=HelpDialog.TopicSearch(t);
     if l<>'/\' then HelpDialog.Execute(l)
                else HelpDialog.ExecuteIndex(t)
end;

procedure TMainForm.TraceIntoMIClick(Sender: TObject);
begin
  if debugger=nil then DebugClick(Sender)
                  else
  if debugger<>nil then
   begin
    {$ifdef win32}
     BringWindowToTop(debugger.Handle);
     SetForegroundWindow(debugger.Handle);
    {$endif}
    ValidateInlineDebugger(false);
    debugger.TraceInto();
    ValidateInlineDebugger(true);
    //check necesarry in case this is the last step
    if debugger<>nil then GotoEditor(debugger.CurrentFileName,debugger.CurrentLineNumber);
    BringToFront();
    SetFocus();
    if WatchListWindow.Visible then WatchListWindow.RefreshWatchList();
    if CallStackWindow.Visible then CallStackWindow.RefreshCallStack();
    if CallStackWindow.Visible then CallStackWindow.RefreshCallStack();
    if DisassemblyWindow.Visible then DisassemblyWindow.RefreshDisassemblyWindow();
   end;
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

procedure TMainForm.CompileClick(Sender: TObject);
var b:integer;
begin
  if EditorOptions.primary_file<>-1 then b:=EditorOptions.Primary_File
                                    else b:=PageController.PageIndex;
  GetEditor(b).Save();
  if GetEditor(b).ActiveFileName<>'' then
   begin
    CompilerOutput.Items.Clear();
    if CompilerOutputPanel.visible=false then MessagesClick(sender);
    CompileDialog.Execute(GetEditor(b).ActiveFileName,EditorOptions,false);
    if CompileDialog.OutputLines.Count<>0 then
     begin
      CompilerOutput.Items.Assign(CompileDialog.OutputLines);
      CompilerOutput.ItemIndex:=0;
     end;
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
    CompilerOutput.Items.Clear();
    CompileDialog.Execute(GetEditor(b).ActiveFileName+' -B',EditorOptions,false);
    if CompileDialog.OutputLines.Count<>0 then
     begin
      CompilerOutput.Items.Assign(CompileDialog.OutputLines);
      CompilerOutput.ItemIndex:=0;
     end;
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

procedure TMainForm.StepOverMIClick(Sender: TObject);
begin
  if debugger=nil then DebugClick(Sender)
                  else
  if debugger<>nil then
   begin
    {$ifdef win32}
     BringWindowToTop(debugger.Handle);
     SetForegroundWindow(debugger.Handle);
    {$endif}
    ValidateInlineDebugger(false);
    debugger.StepOver();
    ValidateInlineDebugger(true);
    //check necesarry in case this is the last step
    if debugger<>nil then GotoEditor(debugger.CurrentFileName,debugger.CurrentLineNumber);
    BringToFront();
    SetFocus();
    if WatchListWindow.Visible then WatchListWindow.RefreshWatchList();
    if CallStackWindow.Visible then CallStackWindow.RefreshCallStack();
    if CallStackWindow.Visible then CallStackWindow.RefreshCallStack();
    if DisassemblyWindow.Visible then DisassemblyWindow.RefreshDisassemblyWindow();
   end;
end;

procedure TMainForm.StopDebugMIClick(Sender: TObject);
begin
     if debugger<>nil then
      begin
       MessageBox('Program exited with code '+IntToStr(debugger.ExitCode),'Note',MB_CONFIRM or MB_ICONINFO);
       if EditorsAvailable() then GetActiveEditor().Repaint();
       debugger.Running:=false;
       debugger.Destroy(); //whoops
       debugger:=nil;
       WatchListWindow.debugger:=nil;
       BreakpointListWindow.Debugger:=nil;
       CallStackWindow.Debugger:=nil;
       RegistersWindow.Debugger:=nil;
       DisassemblyWindow.Debugger:=nil;
       BreakpointListWindow.Debugging:=false;
       ValidateDebugger(false);
      end;
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
  CompilerModeDialog.Execute(EditorOptions);
end;

procedure TMainForm.CompilerClick(Sender: TObject);
begin
     CompilerOptionsDialog.Execute(EditorOptions);
end;

procedure TMainForm.MemorySizesClick(Sender: TObject);
begin
     MemorySizesDialog.Execute(EditorOptions);
end;

procedure TMainForm.LinkerClick(Sender: TObject);
begin
     LinkerDialog.Execute(EditorOptions);
end;

procedure TMainForm.DebuggerClick(Sender: TObject);
begin
  DebugOptionsDialog.Execute(EditorOptions);
end;

procedure TMainForm.DirectoriesClick(Sender: TObject);
begin
     DirectoriesDialog.Execute(EditorOptions);
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
     RuntimeParametersDialog.Execute(EditorOptions);
end;

procedure TMainForm.SaveAsClick(Sender: TObject);
begin
     GetActiveEditor().SaveAs();
end;

//find
procedure TMainForm.FindClick(Sender: TObject);
begin
  FindDialog.Caption:='Find';
  FindDialog.FindReplaceButton.Caption:='Find';
  FindDialog.ReplaceAllButton.enabled:=false;
  FindDialog.PromptOnReplace.enabled:=false;
  FindDialog.ReplaceInput.Enabled:=false;
  FindDialog.ReplaceWithLabel.Font.color:=clGray;
  if FindDialog.Execute(EditorOptions) then
   GetActiveEditor().SearchReplace(FindDialog.TextInput.Text,FindDialog.ReplaceInput.Text,EditorOptions.op);
end;

procedure TMainForm.FindNextClick(Sender: TObject);
begin
    GetActiveEditor().SearchReplace(FindDialog.TextInput.Text,FindDialog.ReplaceInput.Text,EditorOptions.op);
end;

procedure TMainForm.FindPreviousClick(Sender: TObject);
begin
  if ssoBackwards in EditorOptions.op then
   begin
    EditorOptions.op-=[ssoBackwards];
    GetActiveEditor().SearchReplace(FindDialog.TextInput.Text,FindDialog.TextInput.Text,EditorOptions.op);
    EditorOptions.op+=[ssoBackwards];
   end                  else
   begin
    EditorOptions.op+=[ssoBackwards];
    GetActiveEditor().SearchReplace(FindDialog.TextInput.Text,FindDialog.TextInput.Text,EditorOptions.op);
    EditorOptions.op-=[ssoBackwards];
   end;
end;

procedure TMainForm.ReplaceClick(Sender: TObject);
begin
  FindDialog.Caption:='Replace';
  FindDialog.FindReplaceButton.caption:='Replace';
  FindDialog.ReplaceAllButton.enabled:=true;
  FindDialog.PromptOnReplace.enabled:=true;
  FindDialog.ReplaceInput.enabled:=true;
  FindDialog.ReplaceWithLabel.font.color:=clWindowText;
  if FindDialog.Execute(EditorOptions) then
   GetActiveEditor().SearchReplace(FindDialog.TextInput.Text,FindDialog.ReplaceInput.Text,EditorOptions.op);
end;

procedure TMainForm.GotoLineNumberClick(Sender: TObject);
var myline:integer;
begin
  myline:=0;
  GotoLineDialog.Line.maxvalue:=GetActiveEditor().Lines.count;
  if GotoLineDialog.Execute(myline) then GotoEditor(GetActiveEditor().activefilename,myline);
end;

procedure TMainForm.AboutClick(Sender: TObject);
begin
     AboutDialog.ShowModal();
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
var c:integer;
begin
  if error_line<>-1 then
   begin
    error_line:=-1;
    GetActiveEditor().Paint;
   end;
  StatusBar.Panels[1].text:='Ln '+IntToStr(GetActiveEditor().caretY)+', Col '+IntToStr(GetActiveEditor().caretX);
  {$IFDEF WIN32}
  if Odd(GetKeyState(vk_NumLock)) then StatusBar.Panels[4].Text := 'NUM'
                                  else StatusBar.Panels[4].Text := '';
  if Odd(GetKeyState(vk_Capital)) then StatusBar.Panels[3].Text := 'CAP'
                                  else StatusBar.Panels[3].Text := '';
  {$ENDIF}
  if key=VK_INSERT then imode:=not(GetActiveEditor().InsertMode)
                   else imode:=GetActiveEditor().InsertMode;
  if imode then StatusBar.Panels[2].Text := 'INS'
           else StatusBar.Panels[2].Text := 'OVR';
  //shortcuts
  //file menu
  if (key=VK_N) and (ssCtrl in Shift) then NewClick(sender);
  if (key=VK_O) and (ssCtrl in Shift) then OpenClick(sender);
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
//  if (key=VK_H) and (ssCtrl in Shift) then ReplaceClick(sender);
  if (key=VK_G) and (ssCtrl in Shift) then GotoLineNumberClick(sender);
  if (key=VK_LEFT)and(ssAlt in Shift) then
   begin
    c:=PageController.PageIndex;
    dec(c);
    if c<0 then c:=PageController.Pages.Count-1;
    PageController.PageIndex:=c;
   end;
  if (key=VK_RIGHT)and(ssAlt in Shift) then
   begin
    c:=PageController.PageIndex;
    inc(c);
    if c=PageController.Pages.Count then c:=0;
    PageController.PageIndex:=c;
   end;
end;

procedure TMainForm.EditorSpecialLineColors(Sender: TObject; Line: integer;
  var Special: boolean; var FG, BG: TColor);
var i:integer;
begin
  Special:=false;
  if (ExtractFileName((Sender as TMyCustomEditor).ActiveFileName)=error_file)and(line=error_line) then
   begin
    Special:=true;
    FG:=ClBlack;
    BG:=$00CCCCFF;
   end;
  //breakpoint line
  with (Sender as TMyCustomEditor) do
   for i:=0 to Marks.Count-1 do
    if (Marks[i] is TBreakpointSynEditMark)and (Marks[i].Line=Line) then
     begin
      Special:=true;
      FG:=ClBlack;
      BG:=$00CCFFCC;
     end;
  //watch line
  if (debugger<>nil)and(ExtractFileName((Sender as TMyCustomEditor).activefilename)=ExtractFileName(debugger.CurrentFileName))and(line=debugger.CurrentLineNumber)then
   begin
    Special:=true;
    FG:=ClBlack;
    BG:=$00FFCCCC;
   end;
  //bookmark line
  with (Sender as TMyCustomEditor) do
   for i:=0 to Marks.Count-1 do
    if (Marks[i] is TBookmarkSynEditMark)and(Marks[i].Line=Line) then
     begin
      Special:=true;
      FG:=ClBlack;
      BG:=$00ccffff;
     end;
end;

procedure TMainForm.UnindentMIClick(Sender: TObject);
var e:TSynEdit;
    linestart,lineend,lauf,i:integer;
    s:string;
    bb,be:TPoint;
begin
  e:=getActiveEditor();
  bb:=e.BlockBegin;
  be:=e.BlockEnd;
  linestart:=e.BlockBegin.Y-1;
  if e.BlockEnd.X=1 then i:=2 else i:=1;
  lineend:=e.BlockEnd.Y-i;
  if lineend<linestart then lineend:=linestart;
  for lauf:=linestart to lineend do
   begin
    s:=e.Lines[lauf];
    if (s[1]=' ')or(s[1]=#9) then delete(s,1,1);
    if (s[1]=' ')or(s[1]=#9) then delete(s,1,1);
    e.Lines[Lauf]:=s;
   end;
  e.BlockBegin:=bb;
  e.BlockEnd:=be;
end;
procedure TMainForm.ValidateDebugger(value:boolean);
begin
  StopDebugMI.Enabled:=value;
end;

procedure TMainForm.ValidateInlineDebugger(value:boolean);

begin
     //RunMI.Enabled:=value; we can run multiple processes without a problem
     //DebugMI.Enabled:=value; will notify that another program is being debugged
     ContinueMI.Enabled:=value;
     StepOverMI.Enabled:=value;
     TraceIntoMI.Enabled:=value;
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
    IndentMI.Enabled:=value;
    UnindentMI.Enabled:=value;

    //search menu
    FindMI.Enabled:=value;
    FindNextMI.Enabled:=value;
    FindPreviousMI.Enabled:=value;
    ReplaceMI.Enabled:=value;
    GotoLineNumberMI.Enabled:=value;
    ToggleBookmarkMI.Enabled:=value;
    HistoryBackMI.Enabled:=value;
    HistoryForwardMI.Enabled:=value;
    NextBookmarkMI.Enabled:=value;
    PreviousBookmarkMI.Enabled:=value;

    //run menu

    RunMI.Enabled:=value;
    DebugMI.Enabled:=value;
    RunDirectoryMI.Enabled:=value;
    ParametersMI.Enabled:=value;
    ContinueMI.Enabled:=value;
    StepOverMI.Enabled:=value;
    TraceIntoMI.Enabled:=value;
    
    //compile menu

    CompileMI.Enabled:=value;
    MakeMI.Enabled:=value;
    BuildMI.Enabled:=value;

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
    ToggleBookmarkSpeedButton.Enabled:=value;
    NextBookmarkSpeedButton.Enabled:=value;
    PreviousBookmarkSpeedButton.Enabled:=value;
    
    CompileSpeedButton.Enabled:=value;
    RunSpeedButton.Enabled:=value;
    
    //debug menu
    
    AddBreakPointMI.Enabled:=value;
    BreakPointListMI.Enabled:=value;
    
    //help menu
    TopicSearchMI.Enabled:=value;
end;

procedure TMainForm.PageControllerPageChanged(Sender: TObject);
begin
 BreakPointListWindow.CurrentEditorID:=PageController.PageIndex;
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

function CygFormat(s:ansistring):ansistring;
var i:integer;
begin
        if s='' then exit(s);
        {$ifdef win32}
        result:='/cygdrive/';
        result+=LowerCase(s[1]);
        for i:=2 to length(s) do
         if s[i]<>'\' then
          begin
           if s[i]<>':' then result:=result+s[i]
          end
                      else result:=result+'/';
        {$else}
        result:=s;
        {$endif}
end;

function TMainForm.GotoEditor(filename:ansistring;linenumber:integer):boolean;
begin
     Result:=GotoEditor(filename,linenumber,1);
end;

function TMainForm.doGotoEditor(filename:ansistring;linenumber,columnnumber:integer):boolean;
var i:integer;
    found:boolean=false;
begin
     for i:=0 to Editors.Count-1 do
      if (GetEditor(i).ActiveFileName=filename)or(CygFormat(GetEditor(i).ActiveFileName)=filename) then
       begin
        PageController.PageIndex:=i;
        found:=true;
        break;
       end;
     //attempt to open
     if not found then
      if FileExists(filename) then
       begin
        AddEditor(filename);
        found:=true;
       end;
     //try to see if it's unnamed
     if not found then
      for i:=0 to Editors.Count-1 do
       if GetEditor(i).RetName=filename then
        begin
         PageController.PageIndex:=i;
         found:=true;
         break;
        end;
     if found then
      begin
       GetActiveEditor().CaretY:=linenumber;
       GetActiveEditor().CaretX:=columnnumber;
       GetActiveEditor().Refresh;
       ActiveControl:=GetActiveEditor();
      end;
     result:=found;
end;

function TMainForm.GotoEditor(filename:ansistring;linenumber,columnnumber:integer):boolean;

begin
     if EditorsAvailable then
      begin
       setLength(History,HistoryPointer+2);
       
       if GetActiveEditor().ActiveFileName<>'' then History[HistoryPointer].filename:=GetActiveEditor().ActiveFileName
                                               else History[HistoryPointer].filename:=GetActiveEditor().RetName;
       History[HistoryPointer].line:=GetActiveEditor().CaretY;
       History[HistoryPointer].column:=GetActiveEditor().CaretX;

       inc(HistoryPointer);

       History[HistoryPointer].filename:=filename;
       History[HistoryPointer].line:=linenumber;
       History[HistoryPointer].column:=columnnumber;
      end;

     result:=doGotoEditor(filename,linenumber,columnnumber);
end;

function min(a,b:integer):integer;inline;
begin
  if a>b then exit(b);
  exit(a);
end;

//callbacks

//default handler for the onProgramTerminate event
procedure TMainForm.DebuggerProgramTerminated(Sender:TObject);
begin
     StopDebugMIClick(Sender);
end;

//callback for the ASCII table insert button
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
   if f then Insert('''#'+IntToStr(b)+'''',s,GetActiveEditor.CaretX)
        else Insert('#'+IntToStr(b),s,GetActiveEditor.CaretX);
  GetActiveEditor().Lines[GetActiveEditor().CaretY-1]:=s;
  end;
end;

procedure TMainForm.EditorMouseClick(Sender: TObject);
begin
  StatusBar.Panels[1].text:='Ln '+IntToStr(GetActiveEditor().caretY)+', Col '+IntToStr(GetActiveEditor().caretX);
end;

procedure TMainForm.WatchListCloseCallback(Sender:TObject);
begin
     WatchesMI.Checked:=false;
end;

procedure TMainForm.BreakpointListCloseCallback(Sender:TObject);
begin
     BreakPointListMI.Checked:=false;
end;

procedure TMainForm.CallStackCloseCallback(Sender:TObject);
begin
     CallStackMI.Checked:=false;
end;

procedure TMainForm.RegistersCloseCallback(Sender:TObject);
begin
     RegistersMI.Checked:=false;
end;

procedure TMainForm.DisassemblyCloseCallback(Sender:TObject);
begin
     DisassembleMI.Checked:=false;
end;

procedure TMainForm.BookmarkListSelectCallback(i:integer);
begin
     GotoEditor(TBookmark(Bookmarks[i]).FileName,TBookmark(Bookmarks[i]).LineNumber,TBookmark(BookMarks[i]).ColumnNumber);
end;

procedure TMainForm.TabNameChanged(Sender:TObject);
begin
     BreakpointListWindow.RefreshBreakpointList();
end;

procedure TMainForm.FileNameChanged(Sender:TOBject);
var i:integer;
begin
     with Sender as TMyCustomEditor do
      for i:=0 to Marks.Count-1 do
       if Marks[i] is TBookmarkSynEditMark then
        TBookmark((Marks[i] as TBookmarkSynEditMark).ParentPointer^).FileName:=ActiveFileName;
     BookmarkListWindow.RefreshList(self);
end;

procedure TMainForm.BookmarkLineChange(Sender:TObject);
begin
     if Sender is TBookmarkSynEditMark then
      TBookmark((Sender as TBookmarkSynEditMark).ParentPointer).LineNumber:=(Sender as TBookmarkSynEditMark).Line;
end;

initialization
  {$I uMain.lrs}

end.

