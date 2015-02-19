!include "MUI.nsh"

Var STARTMENU_FOLDER

!define MUI_ABORTWARNING
!define MUI_STARTMENUPAGE_REGISTRY_ROOT "HKCU" 
!define MUI_STARTMENUPAGE_REGISTRY_KEY "Software\fpx" 
!define MUI_STARTMENUPAGE_REGISTRY_VALUENAME "Start Menu Folder"
InstallDir $PROGRAMFILES\FreePascal

!insertmacro MUI_PAGE_WELCOME
!insertmacro MUI_PAGE_LICENSE "..\license.txt"
!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_STARTMENU Application $STARTMENU_FOLDER
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_PAGE_FINISH
!insertmacro MUI_LANGUAGE "English"

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

Name "fpx 1.0.0"
OutFile "fpx-1.0.0-rc1-i386-win32.exe"
LicenseForceSelection checkbox
XPStyle on

VIAddVersionKey /LANG=${LANG_ENGLISH} "ProductName" "fpx"
VIAddVersionKey /LANG=${LANG_ENGLISH} "Comments" "Graphical Integrated Development Environment for FreePascal"
VIAddVersionKey /LANG=${LANG_ENGLISH} "CompanyName" "N/A"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalTrademarks" "N/A"
VIAddVersionKey /LANG=${LANG_ENGLISH} "LegalCopyright" "© 2005-2006 Dan Radu"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileDescription" "Graphical Integrated Development Environment for FreePascal setup"
VIAddVersionKey /LANG=${LANG_ENGLISH} "FileVersion" "1.0.0"
VIProductVersion "1.0.0.0"

InstType "Typical"
InstType "Minimal"
InstType "Full"

SectionGroup /e "FPC"

  Section "!Compiler" SecCompiler
    SectionIn 1 2 3
    SetOutPath $INSTDIR
    File /r /x fpx.exe bin
    File /r /x fpx.exe msg
    SetOutPath $INSTDIR\units\i386-win32
    File /r units\i386-win32\rtl
    File /r units\i386-win32\fcl
    File /r units\i386-win32\fv

    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
      CreateDirectory "$SMPROGRAMS\$STARTMENU_FOLDER"
      CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\fp.lnk" "$INSTDIR\bin\i386-win32\fp.exe" "$INSTDIR\bin\i386-win32\fp32.ico"
      CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\Uninstall.lnk" "$INSTDIR\Uninstall.exe"
    !insertmacro MUI_STARTMENU_WRITE_END
    WriteUnInstaller "Uninstall.exe"
    ;Configure editor
    WriteINIStr "$INSTDIR\bin\i386-win32\editor.ini" "compiler" "bin-directory" "$INSTDIR\bin\i386-win32"
  SectionEnd
  
  Section "Compiler Source" SecCompilerSrc
    SectionIn 3
    SetOutPath $INSTDIR\src 
    File /r /x fpx src
  SectionEnd
  
  Section "Packages" SecPackages
    SectionIn 1 3
    SetOutPath $INSTDIR\units\i386-win32
    File /r /x rtl /x fcl /x fv units\i386-win32
  SectionEnd
  
  Section "Examples" SecExamples
    SectionIn 1 3
    SetOutPath $INSTDIR\examples 
    File /r examples
  SectionEnd
  
  Section "Documentation" SecDocs
    SectionIn 1 3
    SetOutPath $INSTDIR\doc 
    File /r doc
    ;Configure editor
    WriteINIStr "$INSTDIR\bin\i386-win32\editor.ini" "help" "numfiles" "1"
    WriteINIStr "$INSTDIR\bin\i386-win32\editor.ini" "help" "defaultfile" "0"
    WriteINIStr "$INSTDIR\bin\i386-win32\editor.ini" "help" "file-0" "$INSTDIR\doc\fpctoc.html"
  SectionEnd
  
SectionGroupEnd

SectionGroup /e "fpx"

  Section "!fpx Graphical IDE" Secfpx
    SectionIn 1 2 3
    SetOutPath $INSTDIR\bin\i386-win32 
    File bin\i386-win32\fpx.exe
    !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
        CreateShortCut "$SMPROGRAMS\$STARTMENU_FOLDER\fpx.lnk" "$INSTDIR\bin\i386-win32\fpx.exe" 
    !insertmacro MUI_STARTMENU_WRITE_END
  SectionEnd
  
  Section "fpx Source" SecfpxSrc
    SectionIn 3
    SetOutPath $INSTDIR\src\fpx 
    File /r src\fpx
  SectionEnd
  
  Section "fpx Documentation" SecfpxDocs
    SectionIn 1 3
    SetOutPath $INSTDIR\doc 
    ;File /r doc
  SectionEnd
  
SectionGroupEnd

Section "Uninstall" SecUninstall
  SetOutPath $INSTDIR
  RMDir /r $INSTDIR
  !insertmacro MUI_STARTMENU_WRITE_BEGIN Application
    RMDir /r "$SMPROGRAMS\$STARTMENU_FOLDER"
  !insertmacro MUI_STARTMENU_WRITE_END
SectionEnd

  LangString DESC_COMPILER ${LANG_ENGLISH} "The Free Pascal Compiler and Run Time Library, version 2.0.2"
  LangString DESC_SOURCE ${LANG_ENGLISH} "Sources for FPC and the RTL"
  LangString DESC_PACKAGES ${LANG_ENGLISH} "Extra packages that extend functionality"
  LangString DESC_EXAMPLES ${LANG_ENGLISH} "Various examples"
  LangString DESC_DOCS ${LANG_ENGLISH} "Documentation and reference for the Run Time Library in both PDF and HTML formats"
  LangString DESC_FPX ${LANG_ENGLISH} "fpx Graphical Integrated Development Environment, version 1.0.0"
  LangString DESC_FPXSRC ${LANG_ENGLISH} "Sources for the fpx IDE"
  LangString DESC_FPXDOCS ${LANG_ENGLISH} "Documentation for the fpx IDE"


  ;Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCompiler} $(DESC_COMPILER)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCompilerSrc} $(DESC_SOURCE)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecPackages} $(DESC_PACKAGES)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecExamples} $(DESC_EXAMPLES)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDocs} $(DESC_DOCS)
    !insertmacro MUI_DESCRIPTION_TEXT ${Secfpx} $(DESC_FPX)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecfpxSrc} $(DESC_FPXSRC)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecfpxDocs} $(DESC_FPXDOCS)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END
