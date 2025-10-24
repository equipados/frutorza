unit uMainModule;

interface

uses
  System.SysUtils,
  System.Classes,
  System.NetEncoding,
  System.JSON,
  uniGUIMainModule,
  UniGUIMsgs,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUIApplication,
  REST.Client,
  REST.Types,
  REST.Response.Adapter;

type
  TMainModule = class(TUniGUIMainModule)
  private
    FApiKey: string;
    FModel: string;
    FBaseUrl: string;
    procedure LoadConfig;
    function BuildRequestBody(const ABase64Image: string): TJSONObject;
    function ExtractContentAsJson(const AResponse: string): TJSONObject;
  public
    constructor Create(AOwner: TComponent); override;
    function RecognizeLabel(const AImageStream: TStream): TJSONObject;
    property ApiKey: string read FApiKey;
    property Model: string read FModel;
  end;

function MainModule: TMainModule;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}

uses
  IniFiles,
  uServerModule;

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
      FApiKey := LIni.ReadString('openai', 'apiKey', '');
      FModel := LIni.ReadString('openai', 'model', 'gpt-4o-mini');
      FBaseUrl := LIni.ReadString('openai', 'baseUrl', 'https://api.openai.com/v1/chat/completions');
    finally
      LIni.Free;
    end;
  end
  else
  begin
    FApiKey := '';
    FModel := 'gpt-4o-mini';
    FBaseUrl := 'https://api.openai.com/v1/chat/completions';
  end;
end;

function TMainModule.BuildRequestBody(const ABase64Image: string): TJSONObject;
var
  LBody: TJSONObject;
  LMessages: TJSONArray;
  LSystemMessage, LUserMessage: TJSONObject;
  LContentArray: TJSONArray;
  LTextPart, LImagePart: TJSONObject;
  LImageUrl: TJSONObject;
  LResponseFormat: TJSONObject;
begin
  LBody := TJSONObject.Create;
  LBody.AddPair('model', FModel);

  LMessages := TJSONArray.Create;
  LBody.AddPair('messages', LMessages);

  LSystemMessage := TJSONObject.Create;
  LSystemMessage.AddPair('role', 'system');
  LSystemMessage.AddPair('content', 'Eres un asistente que extrae datos estructurados de etiquetas agrícolas. Devuelve únicamente un JSON válido.');
  LMessages.AddElement(LSystemMessage);

  LUserMessage := TJSONObject.Create;
  LUserMessage.AddPair('role', 'user');
  LMessages.AddElement(LUserMessage);

  LContentArray := TJSONArray.Create;
  LUserMessage.AddPair('content', LContentArray);

  LTextPart := TJSONObject.Create;
  LTextPart.AddPair('type', 'text');
  LTextPart.AddPair('text', 'Analiza la imagen y extrae lote, fecha de recolección, cooperativa, producto, categoría y número de bultos. Usa cadenas vacías si falta algún dato. Responde con JSON.');
  LContentArray.AddElement(LTextPart);

  LImagePart := TJSONObject.Create;
  LImagePart.AddPair('type', 'image_url');
  LImageUrl := TJSONObject.Create;
  LImageUrl.AddPair('url', 'data:image/jpeg;base64,' + ABase64Image);
  LImagePart.AddPair('image_url', LImageUrl);
  LContentArray.AddElement(LImagePart);

  LResponseFormat := TJSONObject.Create;
  LResponseFormat.AddPair('type', 'json_object');
  LBody.AddPair('response_format', LResponseFormat);

  Result := LBody;
end;

function TMainModule.ExtractContentAsJson(const AResponse: string): TJSONObject;
var
  LRoot: TJSONObject;
  LChoices: TJSONArray;
  LChoiceObj, LMessage: TJSONObject;
  LContent: string;
begin
  Result := nil;
  LRoot := TJSONObject.ParseJSONValue(AResponse) as TJSONObject;
  try
    if LRoot = nil then
      Exit(nil);

    LChoices := LRoot.GetValue<TJSONArray>('choices');
    if (LChoices = nil) or (LChoices.Count = 0) then
      Exit(nil);

    LChoiceObj := LChoices.Items[0] as TJSONObject;
    if LChoiceObj = nil then
      Exit(nil);

    LMessage := LChoiceObj.GetValue<TJSONObject>('message');
    if LMessage = nil then
      Exit(nil);

    LContent := LMessage.GetValue<string>('content', '');
    if LContent = '' then
      Exit(nil);

    Result := TJSONObject.ParseJSONValue(LContent) as TJSONObject;
  finally
    LRoot.Free;
  end;
end;

function TMainModule.RecognizeLabel(const AImageStream: TStream): TJSONObject;
var
  LClient: TRESTClient;
  LRequest: TRESTRequest;
  LResponse: TRESTResponse;
  LBytes: TBytes;
  LBase64: string;
  LBody: TJSONObject;
begin
  Result := nil;
  if (FApiKey = '') or (FModel = '') then
    Exit;

  SetLength(LBytes, AImageStream.Size);
  if Length(LBytes) = 0 then
    Exit;

  AImageStream.Position := 0;
  AImageStream.ReadBuffer(LBytes[0], Length(LBytes));
  LBase64 := TNetEncoding.Base64.EncodeBytesToString(LBytes);

  LBody := BuildRequestBody(LBase64);

  LClient := TRESTClient.Create(FBaseUrl);
  try
    LRequest := TRESTRequest.Create(nil);
    LResponse := TRESTResponse.Create(nil);
    try
      LRequest.Client := LClient;
      LRequest.Response := LResponse;
      LRequest.Method := rmPOST;

      LRequest.AddParameter('Authorization', 'Bearer ' + FApiKey, pkHTTPHEADER, [poDoNotEncode]);
      LRequest.AddParameter('Content-Type', 'application/json', pkHTTPHEADER, [poDoNotEncode]);

      LRequest.AddBody(LBody.ToJSON, ctAPPLICATION_JSON);
      LRequest.Execute;

      if (LResponse.StatusCode >= 200) and (LResponse.StatusCode < 300) then
      begin
        Result := ExtractContentAsJson(LResponse.Content);
      end;
    finally
      LRequest.Free;
      LResponse.Free;
      LBody.Free;
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
