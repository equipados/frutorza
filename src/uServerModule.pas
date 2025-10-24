unit uServerModule;

interface

uses
  System.SysUtils,
  System.Classes,
  uniGUIServer,
  uniGUIServerUtils,
  uniGUIClasses,
  uniGUIServerModule,
  uniGUIRegClasses;

type
  TUniServerModule = class(TUniGUIServerModule)
  protected
    procedure InitServerModule(Sender: TObject); override;
  end;

function UniServerModule: TUniServerModule;

implementation

{$R *.dfm}

procedure TUniServerModule.InitServerModule(Sender: TObject);
begin
  inherited;
  FilesFolderPath := IncludeTrailingPathDelimiter(ExtractFilePath(ParamStr(0))) + 'files\';
  ForceDirectories(FilesFolderPath);
end;

function UniServerModule: TUniServerModule;
begin
  Result := TUniServerModule(UniGUIServerModuleInstance);
end;

initialization
  RegisterServerModuleClass(TUniServerModule);

end.
