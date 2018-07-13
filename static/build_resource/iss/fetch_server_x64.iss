[Setup]
; 使用管理员运行
; PrivilegesRequired=admin
PrivilegesRequired=poweruser

; 应用名称
AppName=Fetch_Server

; 应用版本
AppVersion={{version}}

; 是否显示语言选择选项，默认开启
ShowLanguageDialog=yes

; 是否使用上一次安装时选择的语言
UsePreviousLanguage=no

; 带版本的名字
AppVerName=Fetch_Server_{{version}}

; 发布者
AppPublisher={{publisher}}

; 发布者的链接
AppPublisherURL={{url}}

; 支持链接
AppSupportURL={{url}}

; 更新链接
AppUpdatesURL={{url}}

; 安装时显示的默认的安装目录
DefaultDirName=D:\KWM\Fetch_Server

; 默认的组
DefaultGroupName=Fetch

; 打包之后的文件名
OutputBaseFilename=Fetch_Server_x64_Setup

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
; MSVC2017_redist.exe
Source: "Base\Other\VC2017_redist.x64.exe"; DestDir: "{app}\..\Base\Other"; Flags: onlyifdoesntexist
; Apache 2.4
Source: "Base\Apache\*"; DestDir: "{app}\..\Base\Apache"; Flags: recursesubdirs createallsubdirs ignoreversion onlyifdoesntexist
; PHP 7.2
Source: "Base\PHP\*"; DestDir: "{app}\..\Base\PHP"; Flags: recursesubdirs createallsubdirs ignoreversion onlyifdoesntexist
; 分类程序、热词统计程序
Source: "Fetch_Server\*"; DestDir: "{app}"; Flags: recursesubdirs createallsubdirs ignoreversion
; 需要的批处理
Source: "Base\Init\PHP*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist
Source: "Base\Init\Apache*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist
Source: "Base\Init\Fetch*"; DestDir: "{app}\..\Base\Init"; Flags: onlyifdoesntexist


; 注册表修改
[Registry]


; 创建目录
[Dirs]
; 创建 MySQL 的数据目录
; Name: "{app}\Data"; Flags: uninsalwaysuninstall;

; Pascal 脚本
[Code]
const
  EnvironmentKey = 'SYSTEM\CurrentControlSet\Control\Session Manager\Environment';

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
Filename: "{app}\..\Base\Other\VC2017_redist.x64.exe"; Flags: runascurrentuser; Check: NeedsMSVCInstall('SOFTWARE\Microsoft\VisualStudio\14.0\VC\Runtimes\x64');
; 初始化分析服务器，安装各种依赖的服务添加 Path 变量等
Filename: "{app}\..\Base\Init\Fetch_Server_Init.bat"; Flags: runascurrentuser;

[UninstallRun]
; Filename: "{app}\..\Base\Init\Fetch_Server_Init.bat"; Flags: runascurrentuser;

