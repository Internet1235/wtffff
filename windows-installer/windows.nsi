; 安装程序基本信息
Name "OpenSSL Installer"
OutFile "openssl_installer.exe"
InstallDir $PROGRAMFILES\OpenSSL

; 页面设置
Page directory
Page instfiles

; 安装部分
Section
    ; 创建安装目录
    SetOutPath $INSTDIR

    ; 假设你的 OpenSSL 有 bin、lib、include 等目录，这里以 bin 目录为例安装可执行文件
    File /r "path\to\openssl\bin\*.*"
    File /r "path\to\openssl\lib\*.*"
    File /r "path\to\openssl\include\*.*"

    ; 创建开始菜单快捷方式（这里假设 openssl.exe 是主要的可执行文件）
    CreateShortCut "$SMPROGRAMS\OpenSSL\openssl.exe.lnk" "$INSTDIR\bin\openssl.exe"

    ; 创建桌面快捷方式（可选）
    CreateShortCut "$DESKTOP\openssl.exe.lnk" "$INSTDIR\bin\openssl.exe"
SectionEnd

; 卸载部分
Section "Uninstall"
    ; 删除开始菜单快捷方式
    Delete "$SMPROGRAMS\OpenSSL\openssl.exe.lnk"
    RMDir "$SMPROGRAMS\OpenSSL"

    ; 删除桌面快捷方式（可选）
    Delete "$DESKTOP\openssl.exe.lnk"

    ; 删除安装目录及其中所有文件
    RMDir /r $INSTDIR
SectionEnd