program MobileOCR;

uses
  uniGUIApplication,
  uMainForm in 'uMainForm.pas' {MainmForm},
  uMainModule in 'uMainModule.pas' {MainModule: TUniGUIMainModule},
  uServerModule in 'uServerModule.pas' {UniServerModule: TUniServerModule};

{$R *.res}

begin
  ReportMemoryLeaksOnShutdown := True;
  if IsLibrary then
    uniGUIServerModule.Initialize;
  if WebMode then
    UniServerModule.Start;
  UniGUIServerModuleInstance := TUniServerModule.Create(nil);
  try
    UniGUIServerModuleInstance.InitApplication;
    UniGUIServerModuleInstance.LoadConfig;
    UniGUIServerModuleInstance.Run;
  finally
    UniGUIServerModuleInstance.Free;
  end;
end.
