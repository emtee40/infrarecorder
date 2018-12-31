; Infra Recorder Installation Script
;  written by Christian Kindahl
;
;--------------------------------
; Include Modern UI

  !include "MUI.nsh"
  !include "LogicLib.nsh"
  !include "FileFunc.nsh"

;--------------------------------
; Definitions

  !define MUI_COMPONENTSPAGE_SMALLDESC
  ;!define MUI_HEADERIMAGE
  ;!define MUI_HEADERIMAGE_BITMAP "resources\header-logo.bmp"
  ;!define MUI_HEADERIMAGE_RIGHT
  !define MUI_ABORTWARNING

  ; GPL-3 is not an EULA, no need to agree to it.
  !define MUI_LICENSEPAGE_BUTTON $(^NextBtn)
  !define MUI_LICENSEPAGE_TEXT_BOTTOM "You are now aware of your rights. Click Next to continue."

;--------------------------------
; Plugins

  !addplugindir ir_plugin\win32\release\

;--------------------------------
; StrStr function.
Function StrStr 
  ; Get input from user
  Exch $R0
  Exch
  Exch $R1
  Push $R2
  Push $R3
  Push $R4
  Push $R5
 
  ; Get "String" and "SubString" length
  StrLen $R2 $R0
  StrLen $R3 $R1
  ; Start "StartCharPos" counter
  StrCpy $R4 0
 
  ; Loop until "SubString" is found or "String" reaches its end
  ${Do}
    ; Remove everything before and after the searched part ("TempStr")
    StrCpy $R5 $R1 $R2 $R4
 
    ; Compare "TempStr" with "SubString"
    ${IfThen} $R5 == $R0 ${|} ${ExitDo} ${|}
    ; If not "SubString", this could be "String"'s end
    ${IfThen} $R4 >= $R3 ${|} ${ExitDo} ${|}
    ; If not, continue the loop
    IntOp $R4 $R4 + 1
  ${Loop}
 
  ; Remove part before "SubString" on "String" (if there has one)
  StrCpy $R0 $R1 `` $R4
 
  ; Return output to user
  Pop $R5
  Pop $R4
  Pop $R3
  Pop $R2
  Pop $R1
  Exch $R0
FunctionEnd

;--------------------------------
; StrLower function
Function StrLower 
  Exch $0 ; Original string 
  Push $1 ; Final string 
  Push $2 ; Current character 
  Push $3 
  Push $4 
  StrCpy $1 "" 
Loop: 
  StrCpy $2 $0 1 ; Get next character 
  StrCmp $2 "" Done 
  StrCpy $0 $0 "" 1 
  StrCpy $3 122 ; 122 = ASCII code for z 
Loop2: 
  IntFmt $4 %c $3 ; Get character from current ASCII code 
  StrCmp $2 $4 Match 
  IntOp $3 $3 - 1 
  StrCmp $3 91 NoMatch Loop2 ; 90 = ASCII code one beyond Z 
Match: 
  StrCpy $2 $4 ; It 'matches' (either case) so grab the lowercase version 
  NoMatch: 
  StrCpy $1 $1$2 ; Append to the final string 
  Goto Loop 
Done: 
  StrCpy $0 $1 ; Return the final string 
  Pop $4 
  Pop $3 
  Pop $2 
  Pop $1 
  Exch $0 
FunctionEnd

;--------------------------------
; General

  ; Application name.
  Name "InfraRecorder"

  ; Default installation folder.
  InstallDir "$PROGRAMFILES\InfraRecorder"
  
  ; Get installation folder from registry if available.
  InstallDirRegKey HKCU "Software\InfraRecorder" ""

!ifdef INNER
  !echo "Inner invocation"

  ; Output file.
  OutFile "$%TEMP%\ir.exe"

  ; Compression settings.
  SetCompress off
!else
  !echo "Outer invocation"
 
  ; Call makensis again, defining INNER. This writes an installer for us which, 
  ; when it is invoked, will just write the uninstaller to some location, and
  ; then exit.
  !system "$\"${NSISDIR}\makensis$\" /DINNER setup_nsis.nsi" = 0
 
  ; Run that installer we just created. Since it calls quit the return value
  ; isn't zero.
  !system "$%TEMP%\ir.exe" = 2
 
  ; That will have written an uninstaller binary for us. Now we sign it.
  !system "call ..\..\sign.bat $%TEMP%\uninstall.exe" = 0
 
  ; Output file.
  OutFile "..\..\dist\ir.exe"

  ; Compression settings.
  ;SetCompress off
  SetCompress force
  SetCompressor /SOLID lzma
!endif

;--------------------------------
; Pages

  !insertmacro MUI_PAGE_WELCOME
  !insertmacro MUI_PAGE_LICENSE "..\..\license.txt"
  !insertmacro MUI_PAGE_COMPONENTS
  !insertmacro MUI_PAGE_DIRECTORY
  !insertmacro MUI_PAGE_INSTFILES
  
  !insertmacro MUI_UNPAGE_WELCOME
  !insertmacro MUI_UNPAGE_CONFIRM
  !insertmacro MUI_UNPAGE_INSTFILES
  
;--------------------------------
; Languages

  !insertmacro MUI_LANGUAGE "Arabic"
;  !insertmacro MUI_LANGUAGE "Armenian"
  !insertmacro MUI_LANGUAGE "Basque"
  !insertmacro MUI_LANGUAGE "Bosnian"
  !insertmacro MUI_LANGUAGE "Bulgarian"
  !insertmacro MUI_LANGUAGE "Catalan"
  !insertmacro MUI_LANGUAGE "SimpChinese"
  !insertmacro MUI_LANGUAGE "TradChinese"
;  !insertmacro MUI_LANGUAGE "Chuvash"
  !insertmacro MUI_LANGUAGE "Croatian"
  !insertmacro MUI_LANGUAGE "Czech"
  !insertmacro MUI_LANGUAGE "Danish"
  !insertmacro MUI_LANGUAGE "Dutch"
  !insertmacro MUI_LANGUAGE "English"
  !insertmacro MUI_LANGUAGE "Estonian"
  !insertmacro MUI_LANGUAGE "Farsi"
  !insertmacro MUI_LANGUAGE "Finnish"
  !insertmacro MUI_LANGUAGE "French"
  !insertmacro MUI_LANGUAGE "Galician"
  !insertmacro MUI_LANGUAGE "German"
;  !insertmacro MUI_LANGUAGE "Georgian"
  !insertmacro MUI_LANGUAGE "Greek"
  !insertmacro MUI_LANGUAGE "Hebrew"
  !insertmacro MUI_LANGUAGE "Hungarian"
  !insertmacro MUI_LANGUAGE "Indonesian"
  !insertmacro MUI_LANGUAGE "Italian"
  !insertmacro MUI_LANGUAGE "Japanese"
  !insertmacro MUI_LANGUAGE "Korean"
  !insertmacro MUI_LANGUAGE "Latvian"
  !insertmacro MUI_LANGUAGE "Lithuanian"
  !insertmacro MUI_LANGUAGE "Macedonian"
  !insertmacro MUI_LANGUAGE "Norwegian"
  !insertmacro MUI_LANGUAGE "Polish"
  !insertmacro MUI_LANGUAGE "Portuguese"
  !insertmacro MUI_LANGUAGE "PortugueseBR"
  !insertmacro MUI_LANGUAGE "Romanian"
  !insertmacro MUI_LANGUAGE "Russian"
  !insertmacro MUI_LANGUAGE "Serbian"
  !insertmacro MUI_LANGUAGE "SerbianLatin"
  !insertmacro MUI_LANGUAGE "Slovak"
  !insertmacro MUI_LANGUAGE "Slovenian"
  !insertmacro MUI_LANGUAGE "Spanish"
  !insertmacro MUI_LANGUAGE "Swedish"
  !insertmacro MUI_LANGUAGE "Thai"
  !insertmacro MUI_LANGUAGE "Turkish"
  !insertmacro MUI_LANGUAGE "Ukrainian"
;  !insertmacro MUI_LANGUAGE "Valencian"
;  !insertmacro MUI_LANGUAGE "Vietnamese"

;--------------------------------
; A customized language selection dialog.
!macro IR_MUI_LANGDLL_DISPLAY

  !verbose push
  !verbose ${MUI_VERBOSE}

  !ifdef NSIS_CONFIG_SILENT_SUPPORT
    IfSilent mui.langdll_done
  !endif

  !insertmacro MUI_DEFAULT MUI_LANGDLL_WINDOWTITLE "InfraRecorder Language"
  !insertmacro MUI_DEFAULT MUI_LANGDLL_INFO "Please select a language to use in InfraRecorder."

  !ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME

    ReadRegStr $MUI_TEMP1 "${MUI_LANGDLL_REGISTRY_ROOT}" "${MUI_LANGDLL_REGISTRY_KEY}" "${MUI_LANGDLL_REGISTRY_VALUENAME}"
    StrCmp $MUI_TEMP1 "" mui.langdll_show
      StrCpy $LANGUAGE $MUI_TEMP1
      !ifndef MUI_LANGDLL_ALWAYSSHOW
        Goto mui.langdll_done
      !endif
    mui.langdll_show:

  !endif

  LangDLL::LangDialog "${MUI_LANGDLL_WINDOWTITLE}" "${MUI_LANGDLL_INFO}" A ${MUI_LANGDLL_LANGUAGES} ""
;  !ifdef MUI_LANGDLL_ALLLANGUAGES
;    LangDLL::LangDialog "${MUI_LANGDLL_WINDOWTITLE}" "${MUI_LANGDLL_INFO}" A ${MUI_LANGDLL_LANGUAGES} ""
;  !else
;    LangDLL::LangDialog "${MUI_LANGDLL_WINDOWTITLE}" "${MUI_LANGDLL_INFO}" AC ${MUI_LANGDLL_LANGUAGES_CP} ""
;  !endif

  Pop $LANGUAGE
  StrCmp $LANGUAGE "cancel" 0 +2
    Abort

  !ifdef NSIS_CONFIG_SILENT_SUPPORT
    mui.langdll_done:
  !else ifdef MUI_LANGDLL_REGISTRY_ROOT & MUI_LANGDLL_REGISTRY_KEY & MUI_LANGDLL_REGISTRY_VALUENAME
    mui.langdll_done:
  !endif

  !verbose pop

!macroend

;--------------------------------
; Installation types

  InstType "Full"
  InstType "Minimal"

;--------------------------------
; Installer Functions
!insertmacro GetParameters

Function .onInit
!ifdef INNER
  ; If INNER is defined, then we aren't supposed to do anything except write
  ; out the installer. This is better than processing a command line option as
  ; it means this entire code path is not present in the final (real)
  ; installer.
  WriteUninstaller "$%TEMP%\uninstall.exe"
  Quit
!endif

  ; Display the language selector.
  !insertmacro IR_MUI_LANGDLL_DISPLAY

  ; Parse the command-line.
  ;Call GetParameters
  ;Pop $3
  ${GetParameters} $3
  ;Search for quoted /LANGUAGE.
  StrCpy $2 '"'
  Push $3
  Push '"/LANGUAGE='
  Call StrStr
  Pop $1
  StrCpy $1 $1 "" 1 # skip quote
  StrCmp $1 "" "" Next
    ;Search for non quoted /LANGUAGE.
    StrCpy $2 ' '
    Push $3
    Push '/LANGUAGE='
    Call StrStr
    Pop $1
Next:
  StrCmp $1 "" done
    ;Copy the value after /LANGUAGE=.
    StrCpy $1 $1 "" 10
  ; Search for the next parameter.
  Push $1
  Push $2
  Call StrStr
  Pop $2
  StrCmp $2 "" Done
  StrLen $2 $2
  StrCpy $1 $1 -$2
Done:

  ; Convert the language parameter to lowercase.
  Push $1
  Call StrLower
  Pop $1
  ;MessageBox MB_OK $1

  ClearErrors
  UserInfo::GetName
  IfErrors Win9x
  UserInfo::GetAccountType
  Pop $0
  StrCmp $0 "Admin" 0 +3
  	SetShellVarContext all
  	Goto cont_done
  	SetShellVarContext current
  Win9x:
  	SetShellVarContext current
  cont_done:
FunctionEnd

;--------------------------------
; Language Strings

  ; Language strings (Albanian)
  LangString NAME_SecCore ${LANG_ALBANIAN} "Skedar�t baz� t� InfraRecorder (t� domosdoshme)"
  LangString NAME_SecStartShortcut ${LANG_ALBANIAN} "Shkurtoret e Menus� Start"
  LangString NAME_SecDeskShortcut ${LANG_ALBANIAN} "Shkurtore e Desktopit"
  LangString NAME_SecQuickShortcut ${LANG_ALBANIAN} "Shkurtore e hapjes s� shpejt�"
  LangString NAME_SecLang ${LANG_ALBANIAN} "Skedar�t e gjuh�s"
  LangString DESC_SecCore ${LANG_ALBANIAN} "Skedar�t baz� q� duhen p�r t� p�rdorur InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ALBANIAN} "Shto ikonat n� menun� start p�r akses t� shpejt�."
  LangString DESC_SecDeskShortcut ${LANG_ALBANIAN} "Shto nj� ikon� n� desktop."
  LangString DESC_SecQuickShortcut ${LANG_ALBANIAN} "Shto nj� ikon� n� shiritin e hapjes s� shpejt�."
  LangString DESC_SecLang ${LANG_ALBANIAN} "Skedar�t e gjuh�s q� p�rdoren p�r t� mb�shtetur gjuh� t� tjera n� InfraRecorder."

  ; Language strings (Arabic)
  LangString NAME_SecCore ${LANG_ARABIC} "�������� Infrarecorder����� (������)"
  LangString NAME_SecStartShortcut ${LANG_ARABIC} "������� ������ ����� �������"
  LangString NAME_SecDeskShortcut ${LANG_ARABIC} "������� ������ ��� ������"
  LangString NAME_SecQuickShortcut ${LANG_ARABIC} "������� ������ ������� ������"
  LangString NAME_SecLang ${LANG_ARABIC} "����� ������"
  LangString DESC_SecCore ${LANG_ARABIC} "����� ���� ��������"
  LangString DESC_SecStartShortcut ${LANG_ARABIC} "����� ������� ������ ������� ������ �����"
  LangString DESC_SecDeskShortcut ${LANG_ARABIC} "���� ������� ��� ��� ������"
  LangString DESC_SecQuickShortcut ${LANG_ARABIC} "���� ������� ��� ���� ����� ������"
  LangString DESC_SecLang ${LANG_ARABIC} "����� ������ ���� ������ ���� ���� ������ ��������"

  ; Language strings (Armenian)
  LangString NAME_SecCore ${LANG_ARMENIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_ARMENIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_ARMENIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_ARMENIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_ARMENIAN} "Language Files"
  LangString DESC_SecCore ${LANG_ARMENIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ARMENIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_ARMENIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_ARMENIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_ARMENIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Basque)
  LangString NAME_SecCore ${LANG_BASQUE} "InfraRecorder Core Artxiboak (beharrezkoak)"
  LangString NAME_SecStartShortcut ${LANG_BASQUE} "Hasiera Menuaren Laburbideak"
  LangString NAME_SecDeskShortcut ${LANG_BASQUE} "Idazmahaiaren Laburbidea"
  LangString NAME_SecQuickShortcut ${LANG_BASQUE} "Laburbide Arina"
  LangString NAME_SecLang ${LANG_BASQUE} "Hizkuntza artxiboak"
  LangString DESC_SecCore ${LANG_BASQUE} "InfraRecorder erabiltzeko behar diren artxiboak"
  LangString DESC_SecStartShortcut ${LANG_BASQUE} "Ikonoak gehitzen dizkio zure hasiera menuari akzesoa errazagoa izan dadin"
  LangString DESC_SecDeskShortcut ${LANG_BASQUE} "Ikonoak gehitzen dizkio zure idazmahaiari"
  LangString DESC_SecQuickShortcut ${LANG_BASQUE} "Ikono bat gehitzen dio arin-hasteko barrari"
  LangString DESC_SecLang ${LANG_BASQUE} "Hizkuntza desberdinak onartzeko erabiltzen diren artxiboak"

  ; Language strings (Bosnian)
  LangString NAME_SecCore ${LANG_BOSNIAN} "Kljucna datoteka InfraRecorder-a (zahtijevano)"
  LangString NAME_SecStartShortcut ${LANG_BOSNIAN} "Precica za Start Menu"
  LangString NAME_SecDeskShortcut ${LANG_BOSNIAN} "Precica za Desktop"
  LangString NAME_SecQuickShortcut ${LANG_BOSNIAN} "Precica za Brzo pokretanje"
  LangString NAME_SecLang ${LANG_BOSNIAN} "Datoteke jezika"
  LangString DESC_SecCore ${LANG_BOSNIAN} "InfraRecorder zahtijeva kljucne datoteke."
  LangString DESC_SecStartShortcut ${LANG_BOSNIAN} "Dodaj ikonu u start menu za jednostavniji pristup."
  LangString DESC_SecDeskShortcut ${LANG_BOSNIAN} "Dodaj ikonu na desktop."
  LangString DESC_SecQuickShortcut ${LANG_BOSNIAN} "Dodaj ikonu za brzo pokretanje."
  LangString DESC_SecLang ${LANG_BOSNIAN} "Datoteke jezika se koriste za prikaz InfraRecorder-a u razlicitim jezicima."

  ; Language strings (Bulgarian)
  LangString NAME_SecCore ${LANG_BULGARIAN} "������� ������� �� InfraRecorder (������������)"
  LangString NAME_SecStartShortcut ${LANG_BULGARIAN} "����� ������ � ���� �����"
  LangString NAME_SecDeskShortcut ${LANG_BULGARIAN} "���� ��� �� �������� ����"
  LangString NAME_SecQuickShortcut ${LANG_BULGARIAN} "���� ��� �� ������� quick launch"
  LangString NAME_SecLang ${LANG_BULGARIAN} "������� �� �������"
  LangString DESC_SecCore ${LANG_BULGARIAN} "������� ������� ��������� �� ��� ������������ �� InfraRecorder"
  LangString DESC_SecStartShortcut ${LANG_BULGARIAN} "�������� �� ����� � ���� ����� �� ����� ������."
  LangString DESC_SecDeskShortcut ${LANG_BULGARIAN} "�������� �� ����� �� ����� ������� ����"
  LangString DESC_SecQuickShortcut ${LANG_BULGARIAN} "�������� �� ����� � ������� quick launch"
  LangString DESC_SecLang ${LANG_BULGARIAN} "������� �� ������� ���������� �� ��������� �� �������� ����� � InfraRecorder"

  ; Language strings (Catalan)
  LangString NAME_SecCore ${LANG_CATALAN} "Fitxers del nucli InfraRecorder (necessari)"
  LangString NAME_SecStartShortcut ${LANG_CATALAN} "Dreceres en men� Inici"
  LangString NAME_SecDeskShortcut ${LANG_CATALAN} "Drecera en Escriptori"
  LangString NAME_SecQuickShortcut ${LANG_CATALAN} "Drecera d'execuci� r�pida"
  LangString NAME_SecLang ${LANG_CATALAN} "Fitxers de idioma"
  LangString DESC_SecCore ${LANG_CATALAN} "Els fitxers del nucli necessaris per utilitzar el InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_CATALAN} "Afegeix icones al vostre men� Inici per facilitar l'acc�s."
  LangString DESC_SecDeskShortcut ${LANG_CATALAN} "Afegeix una icona al vostre escriptori."
  LangString DESC_SecQuickShortcut ${LANG_CATALAN} "Afegeix una icona a la vostre barra d'execuci� r�pida."
  LangString DESC_SecLang ${LANG_CATALAN} "Fitxers de idioma utilitzats per donar suport a diferents idiomes en el InfraRecorder."

  ; Language strings (Croatian)
  LangString NAME_SecCore ${LANG_CROATIAN} "InfraRecorder Jezgrene Datoteke (obavezne)"
  LangString NAME_SecStartShortcut ${LANG_CROATIAN} "Start Meni Precaci"
  LangString NAME_SecDeskShortcut ${LANG_CROATIAN} "Desktop Precac"
  LangString NAME_SecQuickShortcut ${LANG_CROATIAN} "Quick Launch Precac"
  LangString NAME_SecLang ${LANG_CROATIAN} "Datoteke Jezika"
  LangString DESC_SecCore ${LANG_CROATIAN} "Jezgrene datoteke nu�ne za upotrebu InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_CROATIAN} "Dodaje ikoneu Start meni radi lak�eg pokretanja."
  LangString DESC_SecDeskShortcut ${LANG_CROATIAN} "Dodaje ikonu na va� desktop."
  LangString DESC_SecQuickShortcut ${LANG_CROATIAN} "Dodaje ikonu u va� Quick Launch liniju."
  LangString DESC_SecLang ${LANG_CROATIAN} "Datoteke jezika kori�tene za razlicite prijevode InfraRecorder-a."

  ; Language strings (Czech)
  LangString NAME_SecCore ${LANG_CZECH} "Z�kladn� soubory InfraRecorderu (nezbytn�)"
  LangString NAME_SecStartShortcut ${LANG_CZECH} "Z�stupci v nab�dce Start"
  LangString NAME_SecDeskShortcut ${LANG_CZECH} "Z�stupce na Plo�e"
  LangString NAME_SecQuickShortcut ${LANG_CZECH} "Z�stupce v panelu Snadn� spu�t�n�"
  LangString NAME_SecLang ${LANG_CZECH} "Jazykov� soubory"
  LangString DESC_SecCore ${LANG_CZECH} "Z�kladn� soubory pot�ebn� ke spu�t�n� InfraRecorderu."
  LangString DESC_SecStartShortcut ${LANG_CZECH} "P�id� ikony do nab�dky Start."
  LangString DESC_SecDeskShortcut ${LANG_CZECH} "P�id� ikonu na Plochu."
  LangString DESC_SecQuickShortcut ${LANG_CZECH} "P�id� ikonu do panelu Snadn�ho spu�t�n�."
  LangString DESC_SecLang ${LANG_CZECH} "Jazykov� soubory zaji��uj�c� InfraRecorderu podporu r�zn�ch jazyk�."

  ; Language strings (Danish)
  LangString NAME_SecCore ${LANG_DANISH} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_DANISH} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_DANISH} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_DANISH} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_DANISH} "Language Files"
  LangString DESC_SecCore ${LANG_DANISH} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_DANISH} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_DANISH} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_DANISH} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_DANISH} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Dutch)
  LangString NAME_SecCore ${LANG_DUTCH} "InfraRecorder essenti�le bestanden (benodigd)"
  LangString NAME_SecStartShortcut ${LANG_DUTCH} "Start Menu snelkoppelingen"
  LangString NAME_SecDeskShortcut ${LANG_DUTCH} "Bureaublad snelkoppeling"
  LangString NAME_SecQuickShortcut ${LANG_DUTCH} "Snel starten snelkoppeling"
  LangString NAME_SecLang ${LANG_DUTCH} "Taal bestanden"
  LangString DESC_SecCore ${LANG_DUTCH} "De essenti�le bestanden zijn nodig om InfraRecorder te kunnen gebruiken."
  LangString DESC_SecStartShortcut ${LANG_DUTCH} "Voegt pictogrammen toe aan het start menu voor snelle toegang."
  LangString DESC_SecDeskShortcut ${LANG_DUTCH} "Voegt een pictogram op het bureaublad toe."
  LangString DESC_SecQuickShortcut ${LANG_DUTCH} "Voegt een pictogram toe aan Snel starten op de taakbalk."
  LangString DESC_SecLang ${LANG_DUTCH} "Taal bestanden gebruikt voor ondersteuning van verschillende talen in InfraRecorder."

  ; Language strings (English)
  LangString NAME_SecCore ${LANG_ENGLISH} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_ENGLISH} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_ENGLISH} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_ENGLISH} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_ENGLISH} "Language Files"
  LangString DESC_SecCore ${LANG_ENGLISH} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ENGLISH} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_ENGLISH} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_ENGLISH} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_ENGLISH} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Estonian)
  LangString NAME_SecCore ${LANG_ESTONIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_ESTONIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_ESTONIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_ESTONIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_ESTONIAN} "Language Files"
  LangString DESC_SecCore ${LANG_ESTONIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ESTONIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_ESTONIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_ESTONIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_ESTONIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Farsi)
  LangString NAME_SecCore ${LANG_FARSI} "(���� ��� ���� ������ј����(�����"
  LangString NAME_SecStartShortcut ${LANG_FARSI} "�������� �� ���� ����"
  LangString NAME_SecDeskShortcut ${LANG_FARSI} "������ ��Ҙ��"
  LangString NAME_SecQuickShortcut ${LANG_FARSI} "������ ������ ����"
  LangString NAME_SecLang ${LANG_FARSI} "������� ����"
  LangString DESC_SecCore ${LANG_FARSI} "���� ��� ���� ��� ������� ������ј���� ����� �� ����"
  LangString DESC_SecStartShortcut ${LANG_FARSI} "����� ����� ���� �� �� ���� ���� ��� ������ ����"
  LangString DESC_SecDeskShortcut ${LANG_FARSI} "����� ����� ���� �� ��Ҙ��"
  LangString DESC_SecQuickShortcut ${LANG_FARSI} "����� ����� ���� �� ���� ������ ����"
  LangString DESC_SecLang ${LANG_FARSI} "���� ��� ���� ��� �������� �� ���� ��� ����� �� ������ј���� ������� �� ����"

  ; Language strings (Finnish)
  LangString NAME_SecCore ${LANG_FINNISH} "InfraRecorderin perustiedosto (pakollinen)"
  LangString NAME_SecStartShortcut ${LANG_FINNISH} "K�ynnist�valikon pikakuvakkeet"
  LangString NAME_SecDeskShortcut ${LANG_FINNISH} "Ty�p�yd�n pikakuvake"
  LangString NAME_SecQuickShortcut ${LANG_FINNISH} "Pikak�ynnistyspalkin kuvake"
  LangString NAME_SecLang ${LANG_FINNISH} "Kielitiedostot"
  LangString DESC_SecCore ${LANG_FINNISH} "InfraRecorder'in k�ytt�miseen tarvittavat keskeiset tiedostot."
  LangString DESC_SecStartShortcut ${LANG_FINNISH} "Lis�� kuvakkeet K�ynnist�-valikkoon k�yt�n helpottamiseksi."
  LangString DESC_SecDeskShortcut ${LANG_FINNISH} "Lis�� kuvake ty�p�yd�lle."
  LangString DESC_SecQuickShortcut ${LANG_FINNISH} "Lis�� kuvake pikak�ynnistyspalkkiin."
  LangString DESC_SecLang ${LANG_FINNISH} "Kielitiedostojen avulla InfraRecorderia voidaan k�ytt�� eri kielill�."

  ; Language strings (French)
  LangString NAME_SecCore ${LANG_FRENCH} "Fichiers requis pour InfraRecorder"
  LangString NAME_SecStartShortcut ${LANG_FRENCH} "Raccourcis dans le Menu D�marrer"
  LangString NAME_SecDeskShortcut ${LANG_FRENCH} "Raccourcis sur le Bureau"
  LangString NAME_SecQuickShortcut ${LANG_FRENCH} "Raccourci pour la barre de lancement rapide"
  LangString NAME_SecLang ${LANG_FRENCH} "Fichiers de Langues"
  LangString DESC_SecCore ${LANG_FRENCH} "Fichier requis pour le fonctionnement d'InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_FRENCH} "Ajouter des icones � votre Menu D�marrer pour un acc�s simplifi�."
  LangString DESC_SecDeskShortcut ${LANG_FRENCH} "Ajouter un icone sur le Bureau."
  LangString DESC_SecQuickShortcut ${LANG_FRENCH} "Ajouter un icone � votre barre de lancement rapide."
  LangString DESC_SecLang ${LANG_FRENCH} "Fichiers de langues n�cessaires pour la traduction d'InfraRecorder."

  ; Language strings (Galician)
  LangString NAME_SecCore ${LANG_GALICIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_GALICIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_GALICIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_GALICIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_GALICIAN} "Language Files"
  LangString DESC_SecCore ${LANG_GALICIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_GALICIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_GALICIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_GALICIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_GALICIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (German)
  LangString NAME_SecCore ${LANG_GERMAN} "InfraRecorder Programmdateien (notwendig)"
  LangString NAME_SecStartShortcut ${LANG_GERMAN} "Startmen�-Eintr�ge"
  LangString NAME_SecDeskShortcut ${LANG_GERMAN} "Desktop-Eintrag"
  LangString NAME_SecQuickShortcut ${LANG_GERMAN} "Schnellstart-Eintrag"
  LangString NAME_SecLang ${LANG_GERMAN} "Zus�tzliche Sprachen"
  LangString DESC_SecCore ${LANG_GERMAN} "Alle ben�tigten Programmdateien f�r den Einsatz von InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_GERMAN} "F�r leichten Zugriff Symbole zum Startmen� hinzuf�gen."
  LangString DESC_SecDeskShortcut ${LANG_GERMAN} "Symbol auf dem Desktop erstellen."
  LangString DESC_SecQuickShortcut ${LANG_GERMAN} "Symbol auf Schnellstartleiste erstellen."
  LangString DESC_SecLang ${LANG_GERMAN} "Weitere Sprachdateien f�r den mehrsprachigen Betrieb von InfraRecorder hinzuf�gen."

  ; Language strings (Georgian)
  LangString NAME_SecCore ${LANG_GEORGIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_GEORGIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_GEORGIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_GEORGIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_GEORGIAN} "Language Files"
  LangString DESC_SecCore ${LANG_GEORGIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_GEORGIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_GEORGIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_GEORGIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_GEORGIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Greek)
  LangString NAME_SecCore ${LANG_GREEK} "������ ������ ��� InfraRecorder (����������)"
  LangString NAME_SecStartShortcut ${LANG_GREEK} "������������ ��� ����� ������"
  LangString NAME_SecDeskShortcut ${LANG_GREEK} "���������� ���� ��������� ��������"
  LangString NAME_SecQuickShortcut ${LANG_GREEK} "���������� ��� ������ �������� ���������"
  LangString NAME_SecLang ${LANG_GREEK} "������������ ����������"
  LangString DESC_SecCore ${LANG_GREEK} "�� ������ ������ ����������� ��� �� ��������������� ��� InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_GREEK} "��������� ��������� ��� ����� ������ ��� ������ ��������."
  LangString DESC_SecDeskShortcut ${LANG_GREEK} "��������� ��� ��������� ���� ��������� �������� ���."
  LangString DESC_SecQuickShortcut ${LANG_GREEK} "��������� ��� ��������� ��� ������ �������� ��������� ���."
  LangString DESC_SecLang ${LANG_GREEK} "� ������������ ���������� ��������������� ��� �� ����������� ������������ ������� ���� InfraRecorder."

  ; Language strings (Hebrew)
  LangString NAME_SecCore ${LANG_HEBREW} "Infra Recorder ���� ������ (required)"
  LangString NAME_SecStartShortcut ${LANG_HEBREW} "����� ������ ����"
  LangString NAME_SecDeskShortcut ${LANG_HEBREW} "����� �� ����� ������"
  LangString NAME_SecQuickShortcut ${LANG_HEBREW} "����� ������� ����� �����"
  LangString NAME_SecLang ${LANG_HEBREW} "���� ���� ������"
  LangString DESC_SecCore ${LANG_HEBREW} "���� ������ �������� ������ ������."
  LangString DESC_SecStartShortcut ${LANG_HEBREW} "����� ������ ������ ����."
  LangString DESC_SecDeskShortcut ${LANG_HEBREW} "����� ������ �� ����� ������."
  LangString DESC_SecQuickShortcut ${LANG_HEBREW} "����� ������ ������� ����� �����."
  LangString DESC_SecLang ${LANG_HEBREW} "���� ���� ������ ����� ������ ������."

  ; Language strings (Hungarian)
  LangString NAME_SecCore ${LANG_HUNGARIAN} "InfraRecorder Programf�jlok (sz�ks�ges)"
  LangString NAME_SecStartShortcut ${LANG_HUNGARIAN} "Start Men� Parancsikonok"
  LangString NAME_SecDeskShortcut ${LANG_HUNGARIAN} "Asztali Parancsikon"
  LangString NAME_SecQuickShortcut ${LANG_HUNGARIAN} "Gyorsind�t� Parancsikon"
  LangString NAME_SecLang ${LANG_HUNGARIAN} "Nyelvi F�jlok"
  LangString DESC_SecCore ${LANG_HUNGARIAN} "A programf�jlok sz�ks�gesek az InfraRecorder haszn�lat�hoz."
  LangString DESC_SecStartShortcut ${LANG_HUNGARIAN} "Ikonok hozz�ad�sa a start men�h�z a gyorsabb el�r�s �rdek�ben."
  LangString DESC_SecDeskShortcut ${LANG_HUNGARIAN} "Ikon elhelyez�se az asztalra."
  LangString DESC_SecQuickShortcut ${LANG_HUNGARIAN} "Ikon elhelyez�se a gyorsind�t� pulton."
  LangString DESC_SecLang ${LANG_HUNGARIAN} "A nyelvi f�jlok seg�ts�g�vel k�l�nb�z� nyelveken haszn�lhatja az InfraRecordert."

  ; Language strings (Indonesian)
  LangString NAME_SecCore ${LANG_INDONESIAN} "Berkas Inti InfraRecorder (dibutuhkan)"
  LangString NAME_SecStartShortcut ${LANG_INDONESIAN} "Jalan Pintas Menu Start"
  LangString NAME_SecDeskShortcut ${LANG_INDONESIAN} "Jalan Pintas Destop"
  LangString NAME_SecQuickShortcut ${LANG_INDONESIAN} "Jalan Pintas Luncur Cepat"
  LangString NAME_SecLang ${LANG_INDONESIAN} "Berkas Bahasa"
  LangString DESC_SecCore ${LANG_INDONESIAN} "Berkas inti yang dibutuhkan untuk menggunakan InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_INDONESIAN} "Tambah ikon ke menu start anda untuk kemudahan akses."
  LangString DESC_SecDeskShortcut ${LANG_INDONESIAN} "Tambah ikon ke destop anda."
  LangString DESC_SecQuickShortcut ${LANG_INDONESIAN} "Tambah ikon ke batang luncur cepat anda."
  LangString DESC_SecLang ${LANG_INDONESIAN} "Berkas bahasa yang digunakan untuk dukungan bahasa yang berbeda di InfraRecorder."

  ; Language strings (Italian)
  LangString NAME_SecCore ${LANG_ITALIAN} "File del programma InfraRecorder (Necessari)"
  LangString NAME_SecStartShortcut ${LANG_ITALIAN} "Collegamenti del menu' avvio"
  LangString NAME_SecDeskShortcut ${LANG_ITALIAN} "Icona sul desktop"
  LangString NAME_SecQuickShortcut ${LANG_ITALIAN} "Icona in avvio veloce"
  LangString NAME_SecLang ${LANG_ITALIAN} "File per le lingue"
  LangString DESC_SecCore ${LANG_ITALIAN} "I file del programma InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ITALIAN} "Aggiunge le icone del programma al menu avvio per un comodo accesso."
  LangString DESC_SecDeskShortcut ${LANG_ITALIAN} "Aggiunge una icona sul desktop."
  LangString DESC_SecQuickShortcut ${LANG_ITALIAN} "Aggiunge una icona alla barra di avvio veloce."
  LangString DESC_SecLang ${LANG_ITALIAN} "File usati da InfraRecorder per il supporto delle lingue."

  ; Language strings (Japanese)
  LangString NAME_SecCore ${LANG_JAPANESE} "InfraRecorder �{�̃t�@�C�� (�K�{)"
  LangString NAME_SecStartShortcut ${LANG_JAPANESE} "[�X�^�[�g] ���j���[ �V���[�g�J�b�g"
  LangString NAME_SecDeskShortcut ${LANG_JAPANESE} "�f�X�N�g�b�v �V���[�g�J�b�g"
  LangString NAME_SecQuickShortcut ${LANG_JAPANESE} "[�N�C�b�N�N��] �V���[�g�J�b�g"
  LangString NAME_SecLang ${LANG_JAPANESE} "����t�@�C��"
  LangString DESC_SecCore ${LANG_JAPANESE} "�{�̃t�@�C���� InfraRecorder ���g�p����̂ɕK�v�ł��B"
  LangString DESC_SecStartShortcut ${LANG_JAPANESE} "�ȒP�ȃA�N�Z�X�̂��߂ɃA�C�R�������g���� [�X�^�[�g] ���j���[�ɒǉ����܂��B"
  LangString DESC_SecDeskShortcut ${LANG_JAPANESE} "�A�C�R�������g���̃f�X�N�g�b�v�ɒǉ����܂��B"
  LangString DESC_SecQuickShortcut ${LANG_JAPANESE} "�A�C�R�������g���� [�N�C�b�N�N��] �o�[�ɒǉ����܂��B"
  LangString DESC_SecLang ${LANG_JAPANESE} "����t�@�C���� InfraRecorder ���قȂ�������ŃT�|�[�g����̂Ɏg�p����܂��B"

  ; Language strings (Korean)
  LangString NAME_SecCore ${LANG_KOREAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_KOREAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_KOREAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_KOREAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_KOREAN} "Language Files"
  LangString DESC_SecCore ${LANG_KOREAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_KOREAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_KOREAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_KOREAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_KOREAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Latvian)
  LangString NAME_SecCore ${LANG_LATVIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_LATVIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_LATVIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_LATVIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_LATVIAN} "Language Files"
  LangString DESC_SecCore ${LANG_LATVIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_LATVIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_LATVIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_LATVIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_LATVIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Lithuanian)
  LangString NAME_SecCore ${LANG_LITHUANIAN} "InfraRecorder pagrindiniai failai (b�tini)"
  LangString NAME_SecStartShortcut ${LANG_LITHUANIAN} "Start Menu nuorodos"
  LangString NAME_SecDeskShortcut ${LANG_LITHUANIAN} "Darbastalio nuoroda"
  LangString NAME_SecQuickShortcut ${LANG_LITHUANIAN} "Greito paleidimo nuoroda"
  LangString NAME_SecLang ${LANG_LITHUANIAN} "Kalbos failai"
  LangString DESC_SecCore ${LANG_LITHUANIAN} "Pagrindiniai failai b�ti norint naudotis InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_LITHUANIAN} "Sukuria ikonas � start meniu greitam pri�jimui."
  LangString DESC_SecDeskShortcut ${LANG_LITHUANIAN} "Sukuria ikon� ant darbastalio."
  LangString DESC_SecQuickShortcut ${LANG_LITHUANIAN} "Sukuria ikon� � greito paleidimo juost�."
  LangString DESC_SecLang ${LANG_LITHUANIAN} "Kalbos failai reikalingi norint kad InfraRecorder vartotojo s�saja dirbt� skirtingomis kalbomis."

  ; Language strings (Macedonian)
  LangString NAME_SecCore ${LANG_MACEDONIAN} "������� ���������� �� InfraRecorder (������������)"
  LangString NAME_SecStartShortcut ${LANG_MACEDONIAN} "����� �� ��������� ����"
  LangString NAME_SecDeskShortcut ${LANG_MACEDONIAN} "����� �� ��������� ��������"
  LangString NAME_SecQuickShortcut ${LANG_MACEDONIAN} "����� �� ������� �� ���� �������"
  LangString NAME_SecLang ${LANG_MACEDONIAN} "������� ����������"
  LangString DESC_SecCore ${LANG_MACEDONIAN} "��������� ���������� �������� �� ��������� �� InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_MACEDONIAN} "������ ����� �� ��������� ���� �� ����� �������."
  LangString DESC_SecDeskShortcut ${LANG_MACEDONIAN} "������ ����� �� ��������� ��������."
  LangString DESC_SecQuickShortcut ${LANG_MACEDONIAN} "������ ����� �� ������� �� ���� �������."
  LangString DESC_SecLang ${LANG_MACEDONIAN} "������� ���������� �� ����� ������ �� ���������� �� InfraRecorder."

  ; Language strings (Norwegian)
  LangString NAME_SecCore ${LANG_NORWEGIAN} "InfraRecorder kjernefiler (obligatorisk)"
  LangString NAME_SecStartShortcut ${LANG_NORWEGIAN} "Snarvei i startmenyen"
  LangString NAME_SecDeskShortcut ${LANG_NORWEGIAN} "Snarvei p� skrivebordet"
  LangString NAME_SecQuickShortcut ${LANG_NORWEGIAN} "Snarvei p� hurtigstartlinjen"
  LangString NAME_SecLang ${LANG_NORWEGIAN} "Spr�kfiler"
  LangString DESC_SecCore ${LANG_NORWEGIAN} "Installerer kjernefiler som kreves for � kj�re InfraRecorder"
  LangString DESC_SecStartShortcut ${LANG_NORWEGIAN} "Oppretter programmappe for InfraRecorder i startmenyen"
  LangString DESC_SecDeskShortcut ${LANG_NORWEGIAN} "Oppretter programikon for InfraRecorder p� skrivebordet"
  LangString DESC_SecQuickShortcut ${LANG_NORWEGIAN} "Oppretter programikon for InfraRecorder p� hurtigstartlinjen"
  LangString DESC_SecLang ${LANG_NORWEGIAN} "Installerer spr�kfiler som tillater bruk av ulike spr�k i InfraRecorder"

  ; Language strings (Polish)
  LangString NAME_SecCore ${LANG_POLISH} "G��wne pliki InfraRecorder (wymagane)"
  LangString NAME_SecStartShortcut ${LANG_POLISH} "Skr�ty menu Start"
  LangString NAME_SecDeskShortcut ${LANG_POLISH} "Skr�ty na pulpicie"
  LangString NAME_SecQuickShortcut ${LANG_POLISH} "Skr�ty w szybkim uruchamianiu"
  LangString NAME_SecLang ${LANG_POLISH} "Pliki j�zykowe"
  LangString DESC_SecCore ${LANG_POLISH} "G��wne pliki wymagane przez InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_POLISH} "Dodaje ikony w menu Start."
  LangString DESC_SecDeskShortcut ${LANG_POLISH} "Dodaje ikon� na pulpicie."
  LangString DESC_SecQuickShortcut ${LANG_POLISH} "Dodaje ikon� w pasku szybkiego uruchamiania."
  LangString DESC_SecLang ${LANG_POLISH} "Pliki j�zykowe dla obs�ugi innych j�zyk�w w InfraRecorder."

  ; Language strings (Portuguese)
  LangString NAME_SecCore ${LANG_PORTUGUESE} "Ficheiros Base do 'InfraRecorder' (obrigatorios)"
  LangString NAME_SecStartShortcut ${LANG_PORTUGUESE} "Atalhos do Menu de Programas"
  LangString NAME_SecDeskShortcut ${LANG_PORTUGUESE} "Atalho do Ambiente de Trabalho"
  LangString NAME_SecQuickShortcut ${LANG_PORTUGUESE} "Atalho da Barra de Iniciacao Rapida"
  LangString NAME_SecLang ${LANG_PORTUGUESE} "Ficheiros de Linguas"
  LangString DESC_SecCore ${LANG_PORTUGUESE} "Os ficheiros base obrigatorios para correr o 'InfraRecorder'."
  LangString DESC_SecStartShortcut ${LANG_PORTUGUESE} "Adiciona 'icons' ao menu de programas para um melhor acesso."
  LangString DESC_SecDeskShortcut ${LANG_PORTUGUESE} "Adiciona um 'icon' ao ambiente de trabalho."
  LangString DESC_SecQuickShortcut ${LANG_PORTUGUESE} "Adiciona um 'icon' a barra de iniciacao rapida."
  LangString DESC_SecLang ${LANG_PORTUGUESE} "Ficheiros de linguas usados para suportar o 'InfraRecorder' em modo multi-lingual."

  ; Language strings (Brazilian Portuguese)
  LangString NAME_SecCore ${LANG_PORTUGUESEBR} "Arquivos de N�cleo do InfraRecorder (requeridos)"
  LangString NAME_SecStartShortcut ${LANG_PORTUGUESEBR} "Atalhos do Menu Iniciar"
  LangString NAME_SecDeskShortcut ${LANG_PORTUGUESEBR} "Atalho do Desktop"
  LangString NAME_SecQuickShortcut ${LANG_PORTUGUESEBR} "Atalho da Barra de Inicializa��o R�pida"
  LangString NAME_SecLang ${LANG_PORTUGUESEBR} "Arquivos de Linguagem"
  LangString DESC_SecCore ${LANG_PORTUGUESEBR} "Os arquivos de n�cleo requeridos pelo InfraRecorder"
  LangString DESC_SecStartShortcut ${LANG_PORTUGUESEBR} "Adiciona �cones ao menu iniciar para acesso f�cil"
  LangString DESC_SecDeskShortcut ${LANG_PORTUGUESEBR} "Adicionar um �cone no Desktop"
  LangString DESC_SecQuickShortcut ${LANG_PORTUGUESEBR} "Adicionar um �cone na Barra de Inicializa��o R�pida"
  LangString DESC_SecLang ${LANG_PORTUGUESEBR} "Arquivos de linguagem utilizados para o suporte multil�ng�e no InfraRecorder"

  ; Language strings (Romanian)
  LangString NAME_SecCore ${LANG_ROMANIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_ROMANIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_ROMANIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_ROMANIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_ROMANIAN} "Language Files"
  LangString DESC_SecCore ${LANG_ROMANIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_ROMANIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_ROMANIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_ROMANIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_ROMANIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Russian)
  LangString NAME_SecCore ${LANG_RUSSIAN} "��������� ����� InfraRecorder (�����������)"
  LangString NAME_SecStartShortcut ${LANG_RUSSIAN} "������ � ������� ����"
  LangString NAME_SecDeskShortcut ${LANG_RUSSIAN} "����� �� ������� �����"
  LangString NAME_SecQuickShortcut ${LANG_RUSSIAN} "����� �� ������ �������� �������"
  LangString NAME_SecLang ${LANG_RUSSIAN} "�������� �����"
  LangString DESC_SecCore ${LANG_RUSSIAN} "��������� �����, ����������� ��� ������ InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_RUSSIAN} "�������� ������ � ������� ���� ��� ��������� ������� � ���������."
  LangString DESC_SecDeskShortcut ${LANG_RUSSIAN} "�������� ������ �� ������� ����."
  LangString DESC_SecQuickShortcut ${LANG_RUSSIAN} "�������� ������ �� ������ �������� �������."
  LangString DESC_SecLang ${LANG_RUSSIAN} "�������� ����� ��� ��������� ��������� ������ � InfraRecorder."

  ; Language strings (Cyrillic Serbian)
  LangString NAME_SecCore ${LANG_SERBIAN} "InfraRecorder �������� (��������)"
  LangString NAME_SecStartShortcut ${LANG_SERBIAN} "������� ����� �����"
  LangString NAME_SecDeskShortcut ${LANG_SERBIAN} "������� ����� ��������"
  LangString NAME_SecQuickShortcut ${LANG_SERBIAN} "������� ����� ���������"
  LangString NAME_SecLang ${LANG_SERBIAN} "������� ��������"
  LangString DESC_SecCore ${LANG_SERBIAN} "�������� �� ��� InfraRecorder-�."
  LangString DESC_SecStartShortcut ${LANG_SERBIAN} "���� ����� � ����� ����� �� ����� �������."
  LangString DESC_SecDeskShortcut ${LANG_SERBIAN} "���� ����� �� ����� ��������."
  LangString DESC_SecQuickShortcut ${LANG_SERBIAN} "���� ����� �� ����� ����� ���������."
  LangString DESC_SecLang ${LANG_SERBIAN} "������� �������� �� InfraRecorder."

  ; Language strings (Latin Serbian)
  LangString NAME_SecCore ${LANG_SERBIANLATIN} "InfraRecorder datoteke (potrebno)"
  LangString NAME_SecStartShortcut ${LANG_SERBIANLATIN} "Pre�ica Start menija"
  LangString NAME_SecDeskShortcut ${LANG_SERBIANLATIN} "Pre�ica radne povr�ine"
  LangString NAME_SecQuickShortcut ${LANG_SERBIANLATIN} "Pre�ica brzog pokretanja"
  LangString NAME_SecLang ${LANG_SERBIANLATIN} "Jezi�ke datoteke"
  LangString DESC_SecCore ${LANG_SERBIANLATIN} "Datoteke za rad InfraRecorder-a."
  LangString DESC_SecStartShortcut ${LANG_SERBIANLATIN} "Dodaj ikone u start meniju za lak�i pristup."
  LangString DESC_SecDeskShortcut ${LANG_SERBIANLATIN} "Dodaj ikonu na radnoj povr�ini."
  LangString DESC_SecQuickShortcut ${LANG_SERBIANLATIN} "Dodaj ikonu na traku brzog pokretanja."
  LangString DESC_SecLang ${LANG_SERBIANLATIN} "Jezi�ke datoteke za InfraRecorder."

  ; Language strings (Slovak)
  LangString NAME_SecCore ${LANG_SLOVAK} "Z�kladn� s�bory InfraRecorderu (nutn�)"
  LangString NAME_SecStartShortcut ${LANG_SLOVAK} "Odkazy v menu �tart"
  LangString NAME_SecDeskShortcut ${LANG_SLOVAK} "Odkaz na Plochu"
  LangString NAME_SecQuickShortcut ${LANG_SLOVAK} "Odkaz do panelu R�chle spustenie"
  LangString NAME_SecLang ${LANG_SLOVAK} "S�bory jazykov"
  LangString DESC_SecCore ${LANG_SLOVAK} "Z�kladn� s�bory nutn� na pou��vanie InfraRecorderu"
  LangString DESC_SecStartShortcut ${LANG_SLOVAK} "Prid� ikony do ponuky �tart pre zjednodu�nie pr�stupu."
  LangString DESC_SecDeskShortcut ${LANG_SLOVAK} "Prid� ikonu na Plochu"
  LangString DESC_SecQuickShortcut ${LANG_SLOVAK} "Prid� ikonu do V�ho panelu R�chle spustenie."
  LangString DESC_SecLang ${LANG_SLOVAK} "S�bory jazykov, pou�it� pre podporu r�znych jazykov InfraRecorderu"

  ; Language strings (Slovenian)
  LangString NAME_SecCore ${LANG_SLOVENIAN} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_SLOVENIAN} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_SLOVENIAN} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_SLOVENIAN} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_SLOVENIAN} "Language Files"
  LangString DESC_SecCore ${LANG_SLOVENIAN} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_SLOVENIAN} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_SLOVENIAN} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_SLOVENIAN} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_SLOVENIAN} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Simplified Chinese)
  LangString NAME_SecCore ${LANG_SIMPCHINESE} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_SIMPCHINESE} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_SIMPCHINESE} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_SIMPCHINESE} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_SIMPCHINESE} "Language Files"
  LangString DESC_SecCore ${LANG_SIMPCHINESE} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_SIMPCHINESE} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_SIMPCHINESE} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_SIMPCHINESE} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_SIMPCHINESE} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Spanish)
  LangString NAME_SecCore ${LANG_SPANISH} "N�cleo de InfraRecorder (requerido)"
  LangString NAME_SecStartShortcut ${LANG_SPANISH} "Accesos directos en men� de inicio"
  LangString NAME_SecDeskShortcut ${LANG_SPANISH} "Acceso directo en el escritorio"
  LangString NAME_SecQuickShortcut ${LANG_SPANISH} "Acceso directo en inicio r�pido"
  LangString NAME_SecLang ${LANG_SPANISH} "Archivos de idiomas"
  LangString DESC_SecCore ${LANG_SPANISH} "El n�cleo de archivos necesario para usar InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_SPANISH} "Agrega iconos a su men� de inicio para acceder f�cilmente."
  LangString DESC_SecDeskShortcut ${LANG_SPANISH} "Agrega un icono a su escritorio."
  LangString DESC_SecQuickShortcut ${LANG_SPANISH} "Agrega un icono a su barra de inicio r�pido."
  LangString DESC_SecLang ${LANG_SPANISH} "Archivos usados para soporte de diferentes idiomas en InfraRecorder."

  ; Language strings (Swedish)
  LangString NAME_SecCore ${LANG_SWEDISH} "InfraRecorder huvudfiler (kr�vs)"
  LangString NAME_SecStartShortcut ${LANG_SWEDISH} "Startmeny genv�gar"
  LangString NAME_SecDeskShortcut ${LANG_SWEDISH} "Skrivbord genv�g"
  LangString NAME_SecQuickShortcut ${LANG_SWEDISH} "Snabbstart genv�g"
  LangString NAME_SecLang ${LANG_SWEDISH} "Spr�kfiler"
  LangString DESC_SecCore ${LANG_SWEDISH} "Huvudfilerna som kr�vs f�r att anv�nda InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_SWEDISH} "L�gger till ikoner p� din startmeny."
  LangString DESC_SecDeskShortcut ${LANG_SWEDISH} "L�gger till en ikon p� ditt skrivbord."
  LangString DESC_SecQuickShortcut ${LANG_SWEDISH} "L�gger till en ikon p� snabbstartf�ltet."
  LangString DESC_SecLang ${LANG_SWEDISH} "Spr�kfiler som anv�nds f�r att st�dja olika spr�k i InfraRecorder."

  ; Language strings (Thai)
  LangString NAME_SecCore ${LANG_THAI} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_THAI} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_THAI} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_THAI} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_THAI} "Language Files"
  LangString DESC_SecCore ${LANG_THAI} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_THAI} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_THAI} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_THAI} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_THAI} "Language files used for supporting different languages in InfraRecorder."

  ; Language strings (Traditional Chinese)
  LangString NAME_SecCore ${LANG_TRADCHINESE} "InfraRecorder�֤��ɮ�(���n�w��)"
  LangString NAME_SecStartShortcut ${LANG_TRADCHINESE} "�}�l�\����|"
  LangString NAME_SecDeskShortcut ${LANG_TRADCHINESE} "�ୱ���|"
  LangString NAME_SecQuickShortcut ${LANG_TRADCHINESE} "�ֳt�Ұʼ�b"
  LangString NAME_SecLang ${LANG_TRADCHINESE} "�y���ɮ�"
  LangString DESC_SecCore ${LANG_TRADCHINESE} "���� InfraRecorder �һݭn���֤��ɮ�"
  LangString DESC_SecStartShortcut ${LANG_TRADCHINESE} "�W�[�ϥܦܶ}�l�\���"
  LangString DESC_SecDeskShortcut ${LANG_TRADCHINESE} "�W�[�ϥܦܮୱ"
  LangString DESC_SecQuickShortcut ${LANG_TRADCHINESE} "�W�[�ϥܦܧֳt�Ұ�"
  LangString DESC_SecLang ${LANG_TRADCHINESE} "�� InfraRecorder �䴩���P��a���y��"

  ; Language strings (Turkish)
  LangString NAME_SecCore ${LANG_TURKISH} "InfraRecorder Ana Dosyalar� (Gerekli)"
  LangString NAME_SecStartShortcut ${LANG_TURKISH} "Ba�lat Men�s� K�sayollar�"
  LangString NAME_SecDeskShortcut ${LANG_TURKISH} "Masa�st� K�sayolu"
  LangString NAME_SecQuickShortcut ${LANG_TURKISH} "H�zl� Ba�lat K�sayolu"
  LangString NAME_SecLang ${LANG_TURKISH} "Dil Dosyalar�"
  LangString DESC_SecCore ${LANG_TURKISH} "InfraRecorder'� kullanabilmek i�in gereken ana dosyalar."
  LangString DESC_SecStartShortcut ${LANG_TURKISH} "Ba�lat Men�s�ne programa h�zl� eri�ebilmek i�in simgeleri ekler."
  LangString DESC_SecDeskShortcut ${LANG_TURKISH} "Masa�st�ne simge ekler."
  LangString DESC_SecQuickShortcut ${LANG_TURKISH} "H�zl� Ba�lata simge ekler"
  LangString DESC_SecLang ${LANG_TURKISH} "InfraRecorder'� farkl� dillerde kullanabilmek i�in dil dosyalar�."

  ; Language strings (Ukrainian)
  LangString NAME_SecCore ${LANG_UKRAINIAN} "������ ����� InfraRecorder (���������)"
  LangString NAME_SecStartShortcut ${LANG_UKRAINIAN} "������� ��� ���� '����'"
  LangString NAME_SecDeskShortcut ${LANG_UKRAINIAN} "������� �� ������� ���"
  LangString NAME_SecQuickShortcut ${LANG_UKRAINIAN} "������� ��� ���� �������� �������"
  LangString NAME_SecLang ${LANG_UKRAINIAN} "���� �����"
  LangString DESC_SecCore ${LANG_UKRAINIAN} "������ ����� ������ ��� ������ InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_UKRAINIAN} "���� ������ �� ������ ���� '����' ��� ��������� ������..."
  LangString DESC_SecDeskShortcut ${LANG_UKRAINIAN} "���� ������ �� ������ �������� �����."
  LangString DESC_SecQuickShortcut ${LANG_UKRAINIAN} "���� ������ �� ����� �������� �������."
  LangString DESC_SecLang ${LANG_UKRAINIAN} "����� ���� ���������������� ��� �������� ����� ��� � InfraRecorder."

  ; Language strings (Vietnamese)
  LangString NAME_SecCore ${LANG_VIETNAMESE} "InfraRecorder Core Files (required)"
  LangString NAME_SecStartShortcut ${LANG_VIETNAMESE} "Start Menu Shortcuts"
  LangString NAME_SecDeskShortcut ${LANG_VIETNAMESE} "Desktop Shortcut"
  LangString NAME_SecQuickShortcut ${LANG_VIETNAMESE} "Quick Launch Shortcut"
  LangString NAME_SecLang ${LANG_VIETNAMESE} "Language Files"
  LangString DESC_SecCore ${LANG_VIETNAMESE} "The core files required to use InfraRecorder."
  LangString DESC_SecStartShortcut ${LANG_VIETNAMESE} "Adds icons to your start menu for easy access."
  LangString DESC_SecDeskShortcut ${LANG_VIETNAMESE} "Adds an icon to your desktop."
  LangString DESC_SecQuickShortcut ${LANG_VIETNAMESE} "Adds an icon to your quick launch bar."
  LangString DESC_SecLang ${LANG_VIETNAMESE} "Language files used for supporting different languages in InfraRecorder."

;--------------------------------
; Installer Sections

Section $(NAME_SecCore) SecCore
  SectionIn 1 2 RO

  SetOutPath "$INSTDIR"
  File "..\..\readme.txt"
  File "..\..\license.txt"
  File "..\..\doc\english\infrarecorder.chm"
  File "..\..\bin\win32\release\infrarecorder.exe"
  File "..\..\bin\win32\release\shell.dll"
  File "..\..\dep\smoke\win32\smoke.exe"

  SetOutPath "$INSTDIR\codecs"
  ;File "..\..\bin\win32\release\codecs\wave.irc"
  File "..\..\bin\win32\release\codecs\sndfile.irc"
  File "..\..\dep\libsndfile\win32\libsndfile-1.dll"
  File "..\..\bin\win32\release\codecs\wma.irc"
  File "..\..\bin\win32\release\codecs\vorbis.irc"

!ifdef CDRKIT
  SetOutPath "$INSTDIR\cdrkit"
  File "..\..\dep\cdrkit\icedax.exe"
  File "..\..\dep\cdrkit\wodim.exe"
  File "..\..\dep\cdrkit\cygwin1.dll"
  File "..\..\dep\cdrkit\readom.exe"
  File "..\..\dep\cdrkit\COPYING"
!else
  SetOutPath "$INSTDIR\cdrtools"
  File "..\..\dep\cdrtools\cdda2wav.exe"
  File "..\..\dep\cdrtools\cdrecord.exe"
  File "..\..\dep\cdrtools\cygwin1.dll"
  File "..\..\dep\cdrtools\readcd.exe"
  File "..\..\dep\cdrtools\COPYING"
!endif
  
  ; Store installation folder.
  WriteRegStr HKCU "Software\InfraRecorder" "" $INSTDIR
  
  ; Create uninstaller.
!ifndef INNER
  SetOutPath "$INSTDIR"
 
  ; Package the signed uninstaller.
  File $%TEMP%\uninstall.exe
!endif

  ; Add an entry to Add/Remove Programs.
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\InfraRecorder" \
	"DisplayName" "InfraRecorder"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\InfraRecorder" \
	"Publisher" "Christian Kindahl"
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\InfraRecorder" \
	"UninstallString" "$\"$INSTDIR\uninstall.exe$\""
  WriteRegStr HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\InfraRecorder" \
	"DisplayIcon" "$INSTDIR\infrarecorder.exe"
SectionEnd

Section $(NAME_SecStartShortcut) SecStartShortcut
  SectionIn 1

  ; Start menu shortcuts.
  CreateDirectory "$SMPROGRAMS\InfraRecorder"
  CreateShortCut "$SMPROGRAMS\InfraRecorder\InfraRecorder.lnk" "$INSTDIR\infrarecorder.exe"
  CreateShortCut "$SMPROGRAMS\InfraRecorder\InfraRecorder Help.lnk" "$INSTDIR\infrarecorder.chm"
  CreateShortCut "$SMPROGRAMS\InfraRecorder\Uninstall.lnk" "$INSTDIR\uninstall.exe"
SectionEnd

Section $(NAME_SecDeskShortcut) SecDeskShortcut
  SectionIn 1

  CreateShortCut "$DESKTOP\InfraRecorder.lnk" "$INSTDIR\infrarecorder.exe"
SectionEnd

Section $(NAME_SecQuickShortcut) SecQuickShortcut
  SectionIn 1

  ; Quick launch shortcut.
  CreateShortCut "$QUICKLAUNCH\InfraRecorder.lnk" "$INSTDIR\infrarecorder.exe"
SectionEnd

Section $(NAME_SecLang) SecLang
  SectionIn 1

  SetOutPath "$INSTDIR\languages"

  File "..\..\etc\translations\software\albanian.irl"
  File "..\..\etc\translations\software\arabic.irl"
  File "..\..\etc\translations\software\armenian.irl"
  File "..\..\etc\translations\software\basque.irl"
  File "..\..\etc\translations\software\bosnian.irl"
  File "..\..\etc\translations\software\bulgarian.irl"
  File "..\..\etc\translations\software\catalan.irl"
  File "..\..\etc\translations\software\chinese-simplified.irl"
  File "..\..\etc\translations\software\chinese-traditional.irl"
  File "..\..\etc\translations\software\chuvash.irl"
  File "..\..\etc\translations\software\croatian.irl"
  File "..\..\etc\translations\software\czech.irl"
  File "..\..\etc\translations\software\danish.irl"
  File "..\..\etc\translations\software\dutch.irl"
  File "..\..\etc\translations\software\estonian.irl"
  File "..\..\etc\translations\software\farsi.irl"
  File "..\..\etc\translations\software\finnish.irl"
  File "..\..\etc\translations\software\french.irl"
  File "..\..\etc\translations\software\galician.irl"
  File "..\..\etc\translations\software\german.irl"
  File "..\..\etc\translations\software\georgian.irl"
  File "..\..\etc\translations\software\greek.irl"
  File "..\..\etc\translations\software\hebrew.irl"
  File "..\..\etc\translations\software\hungarian.irl"
  File "..\..\etc\translations\software\indonesian.irl"
  File "..\..\etc\translations\software\italian.irl"
  File "..\..\etc\translations\software\japanese.irl"
  File "..\..\etc\translations\software\korean.irl"
  File "..\..\etc\translations\software\latvian.irl"
  File "..\..\etc\translations\software\lithuanian.irl"
  File "..\..\etc\translations\software\macedonian.irl"
  File "..\..\etc\translations\software\norwegian.irl"
  File "..\..\etc\translations\software\polish.irl"
  File "..\..\etc\translations\software\portuguese.irl"
  File "..\..\etc\translations\software\portuguese-brazilian.irl"
  File "..\..\etc\translations\software\romanian.irl"
  File "..\..\etc\translations\software\russian.irl"
  File "..\..\etc\translations\software\serbian-cyrillic.irl"
  File "..\..\etc\translations\software\serbian-latin.irl"
  File "..\..\etc\translations\software\slovak.irl"
  File "..\..\etc\translations\software\slovenian.irl"
  File "..\..\etc\translations\software\spanish.irl"
  File "..\..\etc\translations\software\swedish.irl"
  File "..\..\etc\translations\software\thai.irl"
  File "..\..\etc\translations\software\turkish.irl"
  File "..\..\etc\translations\software\ukrainian.irl"
  File "..\..\etc\translations\software\valencian.irl"
  File "..\..\etc\translations\software\vietnamese.irl"
  File "..\..\etc\translations\help\czech.chm"
  File "..\..\etc\translations\help\french.chm"
  File "..\..\etc\translations\help\german.chm"
  File "..\..\etc\translations\help\russian.chm"
  File "..\..\etc\translations\help\thai.chm"
  File "..\..\etc\translations\help\turkish.chm"
  File "..\..\etc\translations\help\ukrainian.chm"

  ; Check if a language has been specified by the commandline.
  ; http://www.microsoft.com/globaldev/reference/oslocversion.mspx
  ; http://www.microsoft.com/globaldev/reference/lcid-all.mspx
  ${Switch} $1
    ${case} "albanian"
      StrCpy $LANGUAGE ${LANG_ALBANIAN}
      ${break}
    ${case} "arabic"	; 1025
      StrCpy $LANGUAGE ${LANG_ARABIC}
      ${break}
    ${case} "armenian"
      StrCpy $LANGUAGE ${LANG_ARMENIAN}
      ${break}
    ${case} "basque"	; 1069
      StrCpy $LANGUAGE ${LANG_BASQUE}
      ${break}
    ${case} "bosnian"	; 5146
      StrCpy $LANGUAGE ${LANG_BOSNIAN}
      ${break}
    ${case} "bulgarian"	; 1026
      StrCpy $LANGUAGE ${LANG_BULGARIAN}
      ${break}
    ${case} "catalan"	; 1027
      StrCpy $LANGUAGE ${LANG_CATALAN}
      ${break}
    ${Case} "simpchinese"	; 2052
      StrCpy $LANGUAGE ${LANG_SIMPCHINESE}
      ${Break}
    ${Case} "tradchinese"	; 1028
      StrCpy $LANGUAGE ${LANG_TRADCHINESE}
      ${Break}
    ${Case} "chuvash"
      StrCpy $LANGUAGE ${LANG_CHUVASH}
      ${Break}
    ${Case} "croatian"	; 1050
      StrCpy $LANGUAGE ${LANG_CROATIAN}
      ${Break}
    ${case} "czech"	; 1029
      StrCpy $LANGUAGE ${LANG_CZECH}
      ${break}
    ${case} "danish"	; 1030
      StrCpy $LANGUAGE ${LANG_DANISH}
      ${break}
    ${Case} "dutch"	; 1043
      StrCpy $LANGUAGE ${LANG_DUTCH}
      ${Break}
    ${Case} "english"	; 1033
      StrCpy $LANGUAGE ${LANG_ENGLISH}
      ${Break}
    ${Case} "estonian"
      StrCpy $LANGUAGE ${LANG_ESTONIAN}
      ${Break}
    ${Case} "farsi"
      StrCpy $LANGUAGE ${LANG_FARSI}
      ${Break}
    ${Case} "finnish"	; 1035
      StrCpy $LANGUAGE ${LANG_FINNISH}
      ${Break}
    ${Case} "french"	; 1036
      StrCpy $LANGUAGE ${LANG_FRENCH}
      ${Break}
    ${Case} "galician"
      StrCpy $LANGUAGE ${LANG_GALICIAN}
      ${Break}
    ${Case} "german"	; 1031
      StrCpy $LANGUAGE ${LANG_GERMAN}
      ${Break}
    ${Case} "georgian"
      StrCpy $LANGUAGE ${LANG_GEORGIAN}
      ${Break}
    ${Case} "greek"	; 1032
      StrCpy $LANGUAGE ${LANG_GREEK}
      ${Break}
    ${Case} "hebrew"	; 1037
      StrCpy $LANGUAGE ${LANG_HEBREW}
      ${Break}
    ${Case} "hungarian"	; 1038
      StrCpy $LANGUAGE ${LANG_HUNGARIAN}
      ${Break}
    ${Case} "indonesian"; 1057
      StrCpy $LANGUAGE ${LANG_INDONESIAN}
      ${Break}
    ${Case} "italian"	; 1040
      StrCpy $LANGUAGE ${LANG_ITALIAN}
      ${Break}
    ${Case} "japanese"	; 1041
      StrCpy $LANGUAGE ${LANG_JAPANESE}
      ${Break}
    ${Case} "korean"	; 1042
      StrCpy $LANGUAGE ${LANG_KOREAN}
      ${Break}
    ${Case} "latvian"
      StrCpy $LANGUAGE ${LANG_LATVIAN}
      ${Break}
    ${Case} "lithuanian"; 1063
      StrCpy $LANGUAGE ${LANG_LITHUANIAN}
      ${Break}
    ${Case} "macedonian"
      StrCpy $LANGUAGE ${LANG_MACEDONIAN}
      ${Break}
    ${Case} "norwegian"; 1044
      StrCpy $LANGUAGE ${LANG_NORWEGIAN}
      ${Break}
    ${Case} "polish"; 	1045
      StrCpy $LANGUAGE ${LANG_POLISH}
      ${Break}
    ${Case} "portuguese"; 2070
      StrCpy $LANGUAGE ${LANG_PORTUGUESE}
      ${Break}
    ${Case} "portuguesebr"; 1046
      StrCpy $LANGUAGE ${LANG_PORTUGUESEBR}
      ${Break}
    ${Case} "romanian"; 1048
      StrCpy $LANGUAGE ${LANG_ROMANIAN}
      ${Break}
    ${Case} "russian"	; 1049
      StrCpy $LANGUAGE ${LANG_RUSSIAN}
      ${Break}
    ${Case} "serbian"	; 3098
      StrCpy $LANGUAGE ${LANG_SERBIAN}
      ${Break}
    ${Case} "serbianlatin"; 2074
      StrCpy $LANGUAGE ${LANG_SERBIANLATIN}
      ${Break}
    ${Case} "slovak"	; 1051
      StrCpy $LANGUAGE ${LANG_SLOVAK}
      ${Break}
    ${Case} "slovenian"	; 1060
      StrCpy $LANGUAGE ${LANG_SLOVENIAN}
      ${Break}
    ${Case} "spanish"	; 1034
      StrCpy $LANGUAGE ${LANG_SPANISH}
      ${Break}
    ${Case} "swedish"	; 1053
      StrCpy $LANGUAGE ${LANG_SWEDISH}
      ${Break}
    ${Case} "thai"	; 1054
      StrCpy $LANGUAGE ${LANG_THAI}
      ${Break}
    ${Case} "turkish"	; 1055
      StrCpy $LANGUAGE ${LANG_TURKISH}
      ${Break}
    ${Case} "ukrainian"	; 1058
      StrCpy $LANGUAGE ${LANG_UKRAINIAN}
      ${Break}
    ${Case} "valencian"	; 1058
      StrCpy $LANGUAGE ${LANG_VALENCIAN}
      ${Break}
    ${Case} "vietnamese"
      StrCpy $LANGUAGE ${LANG_VIETNAMESE}
      ${Break}
  ${EndSwitch}

  ; Calculate file name of the translation file.
  ; http://www.microsoft.com/globaldev/reference/oslocversion.mspx
  ; http://www.microsoft.com/globaldev/reference/lcid-all.mspx
  ${Switch} $LANGUAGE
    ${Case} ${LANG_ALBANIAN}
      StrCpy $0 "albanian.irl"
      ${Break}
    ${Case} ${LANG_ARABIC}	; 1025
      StrCpy $0 "arabic.irl"
      ${Break}
    ${Case} ${LANG_ARMENIAN}
      StrCpy $0 "armenian.irl"
      ${Break}
    ${Case} ${LANG_BASQUE}	; 1069
      StrCpy $0 "basque.irl"
      ${Break}
    ${Case} ${LANG_BOSNIAN}	; 5146
      StrCpy $0 "bosnian.irl"
      ${Break}
    ${Case} ${LANG_BULGARIAN}	; 1026
      StrCpy $0 "bulgarian.irl"
      ${Break}
    ${Case} ${LANG_CATALAN}	; 1027
      StrCpy $0 "catalan.irl"
      ${Break}
    ${Case} ${LANG_SIMPCHINESE}	; 2052
      StrCpy $0 "chinese-simplified.irl"
      ${Break}
    ${Case} ${LANG_TRADCHINESE}	; 1028
      StrCpy $0 "chinese-traditional.irl"
      ${Break}
    ${Case} ${LANG_CHUVASH}
      StrCpy $0 "chuvash.irl"
      ${Break}
    ${Case} ${LANG_CROATIAN}	; 1050
      StrCpy $0 "croatian.irl"
      ${Break}
    ${Case} ${LANG_CZECH}	; 1029
      StrCpy $0 "czech.irl"
      ${Break}
    ${Case} ${LANG_DANISH}	; 1030
      StrCpy $0 "danish.irl"
      ${Break}
    ${Case} ${LANG_DUTCH}	; 1043
      StrCpy $0 "dutch.irl"
      ${Break}
    ${Case} ${LANG_ENGLISH}	; 1033
      StrCpy $0 ""
      ${Break}
    ${Case} ${LANG_ESTONIAN}
      StrCpy $0 "estonian.irl"
      ${Break}
    ${Case} ${LANG_FARSI}
      StrCpy $0 "farsi.irl"
      ${Break}
    ${Case} ${LANG_FINNISH}	; 1035
      StrCpy $0 "finnish.irl"
      ${Break}
    ${Case} ${LANG_FRENCH}	; 1036
      StrCpy $0 "french.irl"
      ${Break}
    ${Case} ${LANG_GALICIAN}
      StrCpy $0 "galician.irl"
      ${Break}
    ${Case} ${LANG_GERMAN}	; 1031
      StrCpy $0 "german.irl"
      ${Break}
    ${Case} ${LANG_GEORGIAN}
      StrCpy $0 "georgian.irl"
      ${Break}
    ${Case} ${LANG_GREEK}	; 1032
      StrCpy $0 "greek.irl"
      ${Break}
    ${Case} ${LANG_HEBREW}	; 1037
      StrCpy $0 "hebrew.irl"
      ${Break}
    ${Case} ${LANG_HUNGARIAN}	; 1038
      StrCpy $0 "hungarian.irl"
      ${Break}
    ${Case} ${LANG_INDONESIAN}	; 1057
      StrCpy $0 "indonesian.irl"
      ${Break}
    ${Case} ${LANG_ITALIAN}	; 1040
      StrCpy $0 "italian.irl"
      ${Break}
    ${Case} ${LANG_JAPANESE}	; 1041
      StrCpy $0 "japanese.irl"
      ${Break}
    ${Case} ${LANG_KOREAN}	; 1042
      StrCpy $0 "korean.irl"
      ${Break}
    ${Case} ${LANG_LATVIAN}
      StrCpy $0 "latvian.irl"
      ${Break}
    ${Case} ${LANG_LITHUANIAN}	; 1063
      StrCpy $0 "lithuanian.irl"
      ${Break}
    ${Case} ${LANG_MACEDONIAN}
      StrCpy $0 "macedonian.irl"
      ${Break}
    ${Case} ${LANG_NORWEGIAN}	; 1044
      StrCpy $0 "norwegian.irl"
      ${Break}
    ${Case} ${LANG_POLISH}	; 1045
      StrCpy $0 "polish.irl"
      ${Break}
    ${Case} ${LANG_PORTUGUESE}	; 2070
      StrCpy $0 "portuguese.irl"
      ${Break}
    ${Case} ${LANG_PORTUGUESEBR}	; 1046
      StrCpy $0 "portuguese-brazilian.irl"
      ${Break}
    ${Case} ${LANG_ROMANIAN}	; 1048
      StrCpy $0 "romanian.irl"
      ${Break}
    ${Case} ${LANG_RUSSIAN}	; 1049
      StrCpy $0 "russian.irl"
      ${Break}
    ${Case} ${LANG_SERBIAN}	; 3098
      StrCpy $0 "serbian-cyrillic.irl"
      ${Break}
    ${Case} ${LANG_SERBIANLATIN} ; 2074
      StrCpy $0 "serbian-latin.irl"
      ${Break}
    ${Case} ${LANG_SLOVAK}	; 1051
      StrCpy $0 "slovak.irl"
      ${Break}
    ${Case} ${LANG_SLOVENIAN}	; 1060
      StrCpy $0 "slovenian.irl"
      ${Break}
    ${Case} ${LANG_SPANISH}	; 1034
      StrCpy $0 "spanish.irl"
      ${Break}
    ${Case} ${LANG_SWEDISH}	; 1053
      StrCpy $0 "swedish.irl"
      ${Break}
    ${Case} ${LANG_THAI}	; 1054
      StrCpy $0 "thai.irl"
      ${Break}
    ${Case} ${LANG_TURKISH}	; 1055
      StrCpy $0 "turkish.irl"
      ${Break}
    ${Case} ${LANG_UKRAINIAN}	; 1058
      StrCpy $0 "ukrainian.irl"
      ${Break}
    ${Case} ${LANG_VALENCIAN}
      StrCpy $0 "valencian.irl"
      ${Break}
    ${Case} ${LANG_VIETNAMESE}
      StrCpy $0 "vietnamese.irl"
      ${Break}
  ${EndSwitch}

  ; Create a configuration file with a preselected language file (if the
  ; selected language is not English).
  ${If} $0 != ""
    ir_plugin::CreateConfig "$INSTDIR\settings.xml" "$0"
  ${EndIf}
SectionEnd

;--------------------------------
; Description Macros

  ; Assign language strings to sections
  !insertmacro MUI_FUNCTION_DESCRIPTION_BEGIN
    !insertmacro MUI_DESCRIPTION_TEXT ${SecCore} $(DESC_SecCore)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecStartShortcut} $(DESC_SecStartShortcut)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecDeskShortcut} $(DESC_SecDeskShortcut)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecQuickShortcut} $(DESC_SecQuickShortcut)
    !insertmacro MUI_DESCRIPTION_TEXT ${SecLang} $(DESC_SecLang)
  !insertmacro MUI_FUNCTION_DESCRIPTION_END

;--------------------------------
; Uninstaller Section
!ifdef INNER
Section "Uninstall"
  ; Delete program directory.
  RMDir /r /REBOOTOK "$INSTDIR"

  ; Delete start menu shortcuts.
  RMDir /r "$SMPROGRAMS\InfraRecorder"

  ; Delete desktop shortcut.
  Delete "$DESKTOP\InfraRecorder.lnk"

  ; Delete quick launch shortcut.
  Delete "$QUICKLAUNCH\InfraRecorder.lnk"

  DeleteRegKey /ifempty HKCU "Software\InfraRecorder"

  ; Remove InfraRecorder from Add/Remove Programs.
  DeleteRegKey HKLM "Software\Microsoft\Windows\CurrentVersion\Uninstall\InfraRecorder"
SectionEnd
!endif
