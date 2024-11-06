
######################################################
# NSIS windows installer script file
#
# Requirements: NSIS 3.0 must be installed with the MUI plugin
# Usage notes:
# This script expects to be executed from the directory it is
# currently stored in.  It expects a 32 bit and 64 bit windows openssl
# build to be present in the ..\${BUILD32} and ..\${BUILD64} directories
# respectively
# ####################################################

!include "MUI.nsh"
!include "winmessages.nsh"

!define PRODUCT_NAME "OpenSSL"

# The name of the output file we create when building this
# NOTE major/minor/patch values are passed with the /D option
# on the command line
OutFile "openssl-installer.exe"

# The name that will appear in the installer title bar
NAME "${PRODUCT_NAME}"

ShowInstDetails show


Var DataDir
Var ModDir

Function .onInit
    StrCpy $INSTDIR "C:\OpenSSL_build"
FunctionEnd

!ifdef BUILD64
# This section is run if installation of the 64 bit binaries are selectd
SectionGroup "64 Bit Installation"
    Section "64 Bit Binaries"
        SetOutPath $INSTDIR\x86_64\lib
        File /r "C:\OpenSSL_build\lib\"
        SetOutPath $INSTDIR\x86_64\bin
        File /r "C:\OpenSSL_build\bin\"
        SetOutPath "$INSTDIR\x86_64\Common Files"
        File /r "C:\Program Files\Common Files\"
    SectionEnd
    Section "x86_64 Development Headers"
        SetOutPath $INSTDIR\x86_64\include
        File /r "C:\OpenSSL_build\include\"
    SectionEnd
SectionGroupEnd
!endif

!ifdef BUILD64
Section "Documentation"
    SetOutPath $INSTDIR\html
    File /r "C:\OpenSSL_build\html\"
SectionEnd
!endif

# Always install the uninstaller and set a registry key
Section
    WriteUninstaller $INSTDIR\uninstall.exe
SectionEnd

!define env_hklm 'HKLM "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"'
!define openssl_hklm 'HKLM "SOFTWARE\OpenSSL"'

# This is run on uninstall
Section "Uninstall"
    RMDIR /r $INSTDIR
    DeleteRegValue ${openssl_hklm} OPENSSLDIR
    DeleteRegValue ${openssl_hklm} MODULESDIR
    DeleteRegValue ${openssl_hklm} ENGINESDIR
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
SectionEnd

!insertmacro MUI_PAGE_WELCOME

Function CheckRunUninstaller
    ifFileExists $INSTDIR\uninstall.exe 0 +2
        ExecWait "$INSTDIR\uninstall.exe /S _?=$INSTDIR"
FunctionEnd

Function WriteRegistryKeys
!ifdef BUILD64
    StrCpy $DataDir "$INSTDIR\x86_64\Common Files\SSL"
    StrCpy $ModDir  "$INSTDIR\x86_64\lib\ossl-modules"
!else
    StrCpy $DataDir "$INSTDIR\x86\Common Files\SSL"
    StrCpy $ModDir  "$INSTDIR\x86\lib\ossl-modules"
!endif
    WriteRegExpandStr ${openssl_hklm} OPENSSLDIR "$DataDir"
    WriteRegExpandStr ${openssl_hklm} ENGINESDIR "$ModDir"
    WriteRegExpandStr ${openssl_hklm} MODULESDIR "$ModDir"
    SendMessage ${HWND_BROADCAST} ${WM_WININICHANGE} 0 "STR:Environment" /TIMEOUT=5000
FunctionEnd

Function DoDirectoryWork
    Call CheckRunUninstaller
    call WriteRegistryKeys
FunctionEnd

!insertmacro MUI_PAGE_COMPONENTS

!define MUI_PAGE_CUSTOMFUNCTION_LEAVE DoDirectoryWork
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Installation Directory"
!insertmacro MUI_PAGE_DIRECTORY

!define MUI_DIRECTORYPAGE_VARIABLE $DataDir
!define MUI_DIRECTORYPAGE_TEXT_TOP "Select Configuration/Data Directory"
!define MUI_DIRECTORYPAGE_TEXT_DESTINATION "Configuration/Data Directory"
!insertmacro MUI_PAGE_DIRECTORY

!insertmacro MUI_PAGE_INSTFILES

!insertmacro MUI_UNPAGE_WELCOME
!insertmacro MUI_UNPAGE_CONFIRM
!insertmacro MUI_UNPAGE_INSTFILES
!insertmacro MUI_UNPAGE_FINISH

!insertmacro MUI_LANGUAGE "English"

!ifdef SIGN
!define OutFileSignSHA1 "SignTool.exe sign /f ${SIGN} /p ${SIGNPASS} /fd sha1 /t http://timestamp.comodoca.com /v"
!define OutFileSignSHA256 "SignTool.exe sign /f ${SIGN} /p ${SIGNPASS} /fd sha256 /tr http://timestamp.comodoca.com?td=sha256 /td sha256 /v"

!finalize "${OutFileSignSHA1} .\openssl-installer.exe"
!finalize "${OutFileSignSHA256} .\openssl-installer.exe"
!endif