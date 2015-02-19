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
  Interfaces, // this includes the LCL widgetset
  Forms
  { add your units here }, uMain, uDirectoriesWindow,uCompilerModeWindow,
  uMemorySizesWindow, uLinkerWindow, uCompilerOptionsWindow,uGotoLinewindow,
  uRuntimeParametersWindow, uAboutWindow,uEditorOptionsWindow, uFindWindow,
  uPrimaryFileWindow, uEditorStyleWindow,uEditorOptionsController,
  uMessageBoxController, uAsciiTable, uTargetWindow, uProcessListWindow;

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TDirectoriesWindow, DirectoriesWindow);
  Application.CreateForm(TCompilerModeWindow, CompilerModeWindow);
  Application.CreateForm(TMemorySizesWindow, MemorySizesWindow);
  Application.CreateForm(TLinkerWindow, LinkerWindow);
  Application.CreateForm(TCompilerOptionsWindow, CompilerOptionsWindow);
  Application.CreateForm(TGotoLineWindow, GotoLineWindow);
  Application.CreateForm(TRuntimeParametersWindow, RuntimeParametersWindow);
  Application.CreateForm(TAboutWindow, AboutWindow);
  Application.CreateForm(TEditorOptionsWindow, EditorOptionsWindow);
  Application.CreateForm(TFindWindow, FindWindow);
  Application.CreateForm(TPrimaryFileWindow, PrimaryFileWindow);
  Application.CreateForm(TEditorStyleWindow, EditorStyleWindow);
  Application.CreateForm(TMessageBoxController, MessageBoxController);
  Application.CreateForm(TASCIITable, ASCIITable);
  Application.CreateForm(TTargetWindow, TargetWindow);
  Application.CreateForm(TProcessListWindow, ProcessListWindow);
  MainForm.RegisterCallbacks();
  Application.CreateForm(TCompilerOptionsWindow, CompilerOptionsWindow);
  Application.Run;

end.

