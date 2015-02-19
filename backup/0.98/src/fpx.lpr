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

{$R fpx.res}
program fpx;

{$mode objfpc}{$H+}
{$apptype gui}

uses
  Interfaces, Forms, uMain, uDirectoriesDialog, uCompilerModeDialog,
  uMemorySizesDialog, uLinkerDialog, uCompilerOptionsDialog, uGotoLineDialog,
  uRuntimeParametersDialog, uAboutDialog, uEditorOptionsDialog, uFindDialog,
  uPrimaryFileDialog, uEditorStyleDialog, uEditorOptionsController,
  uMessageBoxController, uAsciiTable, uTargetDialog, uProcessListWindow,
  uWatchListWindow, uAddWatchDialog, uDebugOptionsDialog, uBreakPointListWindow,
  uAddBreakPointDialog, uCallStackWindow, uRegistersWindow, uDisassemblyWindow;

begin
  Application.Initialize;
  Application.Title:='Free Pascal IDE';

  Application.CreateForm(TMainForm, MainForm);
  
  //floating windows
  Application.CreateForm(TASCIITable, ASCIITable);
  Application.CreateForm(TProcessListWindow, ProcessListWindow);
  Application.CreateForm(TWatchListWindow, WatchListWindow);
  Application.CreateForm(TBreakPointListWindow, BreakPointListWindow);
  Application.CreateForm(TCallStackWindow, CallStackWindow);
  Application.CreateForm(TRegistersWindow, RegistersWindow);
  Application.CreateForm(TDisassemblyWindow, DisassemblyWindow);
  //dialogs
  Application.CreateForm(TDirectoriesDialog, DirectoriesDialog);
  Application.CreateForm(TCompilerModeDialog, CompilerModeDialog);
  Application.CreateForm(TCompilerOptionsDialog, CompilerOptionsDialog);
  Application.CreateForm(TEditorOptionsDialog, EditorOptionsDialog);
  Application.CreateForm(TEditorStyleDialog, EditorStyleDialog);
  Application.CreateForm(TAboutDialog, AboutDialog);
  Application.CreateForm(TMemorySizesDialog, MemorySizesDialog);
  Application.CreateForm(TFindDialog, FindDialog);
  Application.CreateForm(TGotoLineDialog, GotoLineDialog);
  Application.CreateForm(TLinkerDialog, LinkerDialog);
  Application.CreateForm(TRuntimeParametersDialog, RuntimeParametersDialog);
  Application.CreateForm(TPrimaryFileDialog, PrimaryFileDialog);
  Application.CreateForm(TTargetDialog, TargetDialog);
  Application.CreateForm(TAddWatchDialog, AddWatchDialog);
  Application.CreateForm(TDebugOptionsDialog, DebugOptionsDialog);
  Application.CreateForm(TAddBreakpointDialog, AddBreakpointDialog);
  //message box controller
  Application.CreateForm(TMessageBoxController, MessageBoxController);
  //register callbacks
  MainForm.RegisterCallbacks();
  //run
  Application.Run;
end.

