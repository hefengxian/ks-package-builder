; 定义重复使用的变量
#define EnvironmentKey "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

[Setup]
; 使用管理员运行
; PrivilegesRequired=admin
PrivilegesRequired=poweruser

; 应用名称
AppName={cm:AppName}

; 应用版本
AppVersion={{version}}

; 是否显示语言选择选项，默认开启
ShowLanguageDialog=yes

; 是否使用上一次安装时选择的语言
UsePreviousLanguage=no

; 带版本的名字
AppVerName={cm:AppName} {{version}}

; 发布者
AppPublisher={{publisher}}

; 发布者的链接
AppPublisherURL={{url}}

; 支持链接
AppSupportURL={{url}}

; 更新链接
AppUpdatesURL={{url}}

; 安装时显示的默认的安装目录
DefaultDirName=D:\KWM\Third_Party

; 默认的组
DefaultGroupName=Third_Party

; 打包之后的文件名
OutputBaseFilename=Third_Party_x64_Setup

; 压缩算法
Compression={{compress}}

; 启用结实压缩
SolidCompression=yes

; 告知系统会修改环境变量，否则用户的电脑不重启或者注销有写环境变量和设置会不生效
ChangesEnvironment=true

; 打包的输入文件目录
SourceDir={{rootPath}}\Input\KWM

; 打包之后输出文件的目录
OutputDir={{rootPath}}\Output\{{currentDate}}


; 安装界面多语言配置
[Languages]
; 英语配置
Name: "en"; MessagesFile: "compiler:Default.isl"
; 简体中文配置
Name: "cn_simplify"; MessagesFile: "compiler:Languages\ChineseSimplified.isl"


[CustomMessages]
en.AppName=Third-Party Library
en.Copyright=
en.Publisher=
en.PublisherURL=

en.InstallSogouInput=Install Sogou Pinyin Input Method
en.InstallNotepadPlus=Install Notepad++
en.InstallPDFReader=Install Foxit PDF Reader
en.DefaultGroupName=


cn_simplify.AppName=第三方工具软件包
cn_simplify.Copyright=
cn_simplify.Publisher=
cn_simplify.PublisherURL=

cn_simplify.InstallSogouInput=安装搜狗拼音输入法
cn_simplify.InstallNotepadPlus=安装 Notepad++
cn_simplify.InstallPDFReader=安装 Foxit Reader PDF 阅读器
cn_simplify.DefaultGroupName=


; 文件映射
[Files]
; *.exe
Source: "Third_Party\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion onlyifdoesntexist


; 注册表修改
[Registry]


; 创建目录
[Dirs]


; Pascal 脚本
[Code]


[Run]
; 安装之后就运行的脚本、程序
Filename: "{app}\npp.Installer.x64.exe"; Flags: runascurrentuser;
Filename: "{app}\HeidiSQL_Setup.exe"; Flags: runascurrentuser;
Filename: "{app}\sogou_pinyin.exe"; Flags: runascurrentuser;
Filename: "{app}\SumatraPDF-install.exe"; Flags: runascurrentuser;


[UninstallRun]

