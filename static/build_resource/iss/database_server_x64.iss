; 数据库打包流程
; 拷贝文件

; 定义重复使用的变量
#define EnvironmentKey "SYSTEM\CurrentControlSet\Control\Session Manager\Environment"

[Setup]
; 使用管理员运行
; PrivilegesRequired=admin
PrivilegesRequired=poweruser

; 应用名称
AppName=Database_Server

; 应用版本
AppVersion={{version}}

; 是否显示语言选择选项，默认开启
ShowLanguageDialog=yes

; 是否使用上一次安装时选择的语言
UsePreviousLanguage=no

; 带版本的名字
AppVerName=Database_Server_{{version}}

; 发布者
AppPublisher={{publisher}}

; 发布者的链接
AppPublisherURL={{url}}

; 支持链接
AppSupportURL={{url}}

; 更新链接
AppUpdatesURL={{url}}

; 安装时显示的默认的安装目录
DefaultDirName=D:\KWM\Database_Server

; 默认的组
DefaultGroupName=Database

; 打包之后的文件名
OutputBaseFilename=Database_Server_x64_Setup

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


; 文件映射
[Files]
; MySQL 二进制可执行程序
Source: "Base\MySQL\*"; DestDir: "{app}\..\Base\MySQL"; Flags: recursesubdirs createallsubdirs ignoreversion
; MSVC2017_redist.exe
Source: "Base\Other\VC2017_redist.x64.exe"; DestDir: "{app}\..\Base\Other";
; MySQL 初始化文件
Source: "Database_Server\*"; DestDir: "{app}"; Excludes: "Data\*"; Flags: recursesubdirs createallsubdirs ignoreversion
; MySQL Data 初始化文件
Source: "Database_Server\Data\*"; DestDir: "{{mysqlDataDir}}"; Flags: recursesubdirs createallsubdirs ignoreversion
; 初始化 MySQL 的批处理
Source: "Base\Init\MySQL*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist
; 初始化 PHP 的批处理
Source: "Base\Init\PHP*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist
; 初始化 Db Server
Source: "Base\Init\Database*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist


; 注册表修改
[Registry]
; setx 设置的字符长度限制比较严格，所以使用注册表添加
; 添加 MySQL 到 Path 环境变量
Root: HKLM; Subkey: "{#EnvironmentKey}"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};D:\KWM\Base\MySQL\bin"; Check: NeedsAddPath('D:\KWM\Base\MySQL\bin');
; 添加 PHP 到 Path 环境变量
Root: HKLM; Subkey: "{#EnvironmentKey}"; ValueType: expandsz; ValueName: "Path"; ValueData: "{olddata};D:\KWM\Base\PHP"; Check: NeedsAddPath('D:\KWM\Base\PHP');


; 创建目录
[Dirs]
; 创建 MySQL 的数据目录
; Name: "{app}\Data"; Flags: uninsalwaysuninstall;

; Pascal 脚本
[Code]
const
  EnvironmentKey = '{#EnvironmentKey}';

// 检查 MSVC 是否安装，通过注册表中对应的项目来检查
function NeedsMSVCInstall(Path: String):Boolean;
begin
    // 例如：{reg:HKLM\SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64,Version|FALSE}
    // Log('{reg:HKLM\' + Path + ',Version|False}' + ' ----> ' + ExpandConstant('{reg:HKLM\' + Path + ',Version|False}'))
    Result := (ExpandConstant('{reg:HKLM\' + Path + ',Version|False}') = 'False')
end;

//判断是否要添加环境变量
function NeedsAddPath(Param: string): boolean;
var
  OrigPath: string;
begin
  if not RegQueryStringValue(HKEY_LOCAL_MACHINE, EnvironmentKey, 'Path', OrigPath)
  then begin
    Result := True;
    exit;
  end;
  // look for the path with leading and trailing semicolon
  // Pos() returns 0 if not found
  Result := Pos(';' + UpperCase(Param) + ';', ';' + UpperCase(OrigPath) + ';') = 0;  
end;

[Run]
; 安装之后就运行的脚本

; 安装 MSVC 2017
Filename: "{app}\..\Base\Other\VC2017_redist.x64.exe"; Flags: runascurrentuser nowait; Check: NeedsMSVCInstall('SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64');
; 初始化数据库服务器，安装各种依赖的服务添加 Path 变量等
Filename: "{app}\..\Base\Init\Database_Server_Init.bat"; Flags: runascurrentuser;
; 运行 Apahce/Tomcat 服务监测程序
; Filename: "{app}\..\Base\Tomcat\Start_Tomcat_Monitor.bat";
; Filename: "{app}\..\Base\Apache\Start_Apache_Monitor.bat";

[UninstallRun]
; Filename: "{app}\..\Base\Init\Database_Server_Uninstall.bat"; Flags: runascurrentuser;