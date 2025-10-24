unit uMainModule;

interface

uses
  System.SysUtils,
  System.Classes,
  uniGUIMainModule,
  UniGUIMsgs,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUIApplication,
  REST.Client,
  REST.Types,
  REST.Response.Adapter,
  System.JSON;

type
  TMainModule = class(TUniGUIMainModule)
  private
    FSubscriptionKey: string;
    FEndpoint: string;
    procedure LoadConfig;
  public
    constructor Create(AOwner: TComponent); override;
    function RecognizeLabel(const AImageStream: TStream): TJSONObject;
    property SubscriptionKey: string read FSubscriptionKey;
    property Endpoint: string read FEndpoint;
  end;

function MainModule: TMainModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  IniFiles;

constructor TMainModule.Create(AOwner: TComponent);
begin
  inherited;
  LoadConfig;
end;

procedure TMainModule.LoadConfig;
var
  LIni: TIniFile;
  LConfigPath: string;
begin
  LConfigPath := UniServerModule.FilesFolderPath + 'config.ini';
  if FileExists(LConfigPath) then
  begin
    LIni := TIniFile.Create(LConfigPath);
    try
      FSubscriptionKey := LIni.ReadString('vision', 'subscriptionKey', '');
      FEndpoint := LIni.ReadString('vision', 'endpoint', '');
    finally
      LIni.Free;
    end;
  end
  else
  begin
    FSubscriptionKey := '';
    FEndpoint := '';
  end;
end;

function TMainModule.RecognizeLabel(const AImageStream: TStream): TJSONObject;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LURL: string;
  LJSON: TJSONObject;
begin
  Result := nil;
  if (FEndpoint = '') or (FSubscriptionKey = '') then
    Exit;

  LClient := TRESTClient.Create(FEndpoint);
  try
    LRequest := TRESTRequest.Create(nil);
    LResponse := TRESTResponse.Create(nil);
    try
      LRequest.Client := LClient;
      LRequest.Response := LResponse;
      LRequest.Method := rmPOST;

      LURL := 'vision/v3.2/read/analyze';
      LRequest.Resource := LURL;
      LRequest.AddParameter('Ocp-Apim-Subscription-Key', FSubscriptionKey, pkHTTPHEADER, [poDoNotEncode]);
      LRequest.AddParameter('Content-Type', 'application/octet-stream', pkHTTPHEADER, [poDoNotEncode]);

      LRequest.AddBody(AImageStream, ctAPPLICATION_OCTET_STREAM);
      LRequest.Execute;

      if (LResponse.StatusCode >= 200) and (LResponse.StatusCode < 300) then
      begin
        LJSON := TJSONObject.ParseJSONValue(LResponse.Content) as TJSONObject;
        Result := LJSON;
      end;
    finally
      LRequest.Free;
      LResponse.Free;
    end;
  finally
    LClient.Free;
  end;
end;

function MainModule: TMainModule;
begin
  Result := TMainModule(UniApplication.UniMainModule);
end;

initialization
  RegisterMainModuleClass(TMainModule);

end.
