; 安装程序基本信息
Name "OpenSSL Installer"
OutFile "openssl_installer.exe"
InstallDir $PROGRAMFILES\OpenSSL

; 安装程序界面设置
ShowInstDetails show
ShowUnInstDetails show

; 安装页面
Page license
Page components
Page directory
Page instfiles
Page postinst

; 卸载页面
Page uninstConfirm
Page uninstProgress

; 语言设置
!insertmacro MUI_LANGUAGE "English"

; 安装模式选择（完整安装、自定义安装等）
!define MUI_COMPONENTSPAGE_SMALLDESC
!define MUI_COMPONENTSPAGE_NODESC
!define MUI_COMPONENTSPAGE_DISABLEDESCCHECKBOX
!insertmacro MUI_PAGE_COMPONENTS

; 定义安装组件
!define COMPONENT_BIN "BinFiles"
!define COMPONENT_LIB "LibFiles"
!define COMPONENT_INCLUDE "IncludeFiles"
!insertmacro MUI_COMPONENT_DESCRIPTION ${COMPONENT_BIN} "OpenSSL Binary Files"
!insertmacro MUI_COMPONENT_DESCRIPTION ${COMPONENT_LIB} "OpenSSL Library Files"
!insertmacro MUI_COMPONENT_DESCRIPTION ${COMPONENT_INCLUDE} "OpenSSL Include Files"

; 安装部分
Section "${COMPONENT_BIN}"
    SetOutPath $INSTDIR\bin
    File /r "C:\OpenSSL_build\bin\*.*"
    CreateShortCut "$SMPROGRAMS\OpenSSL\openssl.exe.lnk" "$INSTDIR\bin\openssl.exe"
SectionEnd

Section "${COMPONENT_LIB}"
    SetOutPath $INSTDIR\lib
    File /r "C:\OpenSSL_build\lib\*.*"
SectionEnd

Section "${COMPONENT_INCLUDE}"
    SetOutPath $INSTDIR\include
    File /r "C:\OpenSSL_build\include\*.*"
SectionEnd

; 卸载部分
Section "Uninstall"
    Delete "$SMPROGRAMS\OpenSSL\openssl.exe.lnk"
    RMDir "$SMPROGRAMS\OpenSSL"
    RMDir /r $INSTDIR
SectionEnd
