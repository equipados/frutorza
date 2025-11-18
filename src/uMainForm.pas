unit uMainForm;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  uniGUIBaseClasses,
  uniGUIClasses,
  uniGUImForm,
  uniGUIApplication,
  UnimFileUpload,
  UnimPanel,
  UnimLabel,
  UnimButton,
  UnimMemo,
  System.NetEncoding,
  uLabelParser;

type
  TMainmForm = class(TUnimForm)
    pnlHeader: TUnimPanel;
    lblTitle: TUnimLabel;
    pnlContent: TUnimPanel;
    pnlAction: TUnimPanel;
    lblIntro: TUnimLabel;
    pnlResult: TUnimPanel;
    lblResults: TUnimLabel;
    btnCapture: TUnimButton;
    memResult: TUnimMemo;
    Upload: TUnimFileUpload;
    procedure UnimFormCreate(Sender: TObject);
    procedure btnCaptureClick(Sender: TObject);
    procedure UploadCompleted(Sender: TObject); override;
  private
    procedure AnalyzeStream(AStream: TStream);
    procedure ShowResult(const AInfo: TLabelInfo);
    procedure ShowError(const AMessage: string);
  public
  end;

function MainmForm: TMainmForm;

implementation

{$R *.dfm}

uses
  uMainModule;

procedure TMainmForm.AnalyzeStream(AStream: TStream);
var
  LJSON: TJSONObject;
  LInfo: TLabelInfo;
begin
  memResult.Lines.Clear;
  if AStream = nil then
  begin
    ShowError('No se recibió imagen.');
    Exit;
  end;

  AStream.Position := 0;
  LJSON := MainModule.RecognizeLabel(AStream);
  try
    if LJSON = nil then
      ShowError('No fue posible contactar con el servicio de OCR.')
    else
    begin
      LInfo := TLabelParser.ParseReadAPIResponse(LJSON);
      ShowResult(LInfo);
    end;
  finally
    LJSON.Free;
  end;
end;

procedure TMainmForm.btnCaptureClick(Sender: TObject);
begin
  Upload.Reset;
  Upload.Execute;
end;

procedure TMainmForm.ShowError(const AMessage: string);
begin
  memResult.Lines.Text := '⚠ ' + AMessage;
end;

procedure TMainmForm.ShowResult(const AInfo: TLabelInfo);
begin
  memResult.Lines.BeginUpdate;
  try
    memResult.Lines.Clear;
    memResult.Lines.Add('Lote: ' + AInfo.Lot);
    memResult.Lines.Add('Fecha: ' + AInfo.HarvestDate);
    memResult.Lines.Add('Cooperativa: ' + AInfo.Cooperative);
    memResult.Lines.Add('Producto: ' + AInfo.Product);
    memResult.Lines.Add('Categoría: ' + AInfo.Category);
    memResult.Lines.Add('Nº Bultos: ' + AInfo.BunchCount);
  finally
    memResult.Lines.EndUpdate;
  end;
end;

procedure TMainmForm.UnimFormCreate(Sender: TObject);
begin
  Caption := 'Lector de Etiquetas';
  pnlHeader.LayoutConfig.Cls := 'x-toolbar-dark';
  lblTitle.Caption := 'Lector de Lotes';
  btnCapture.Caption := 'Capturar etiqueta';
  memResult.EmptyText := 'Los resultados aparecerán aquí';
  Upload.Accept := 'image/*';
  Upload.Capture := ucCamera;
  Upload.MaxFiles := 1;
end;

procedure TMainmForm.UploadCompleted(Sender: TObject);
var
  LStream: TMemoryStream;
begin
  inherited;
  if Upload.Files.Count = 0 then
  begin
    ShowError('No se seleccionó ninguna imagen.');
    Exit;
  end;

  LStream := TMemoryStream.Create;
  try
    Upload.Files[0].SaveToStream(LStream);
    AnalyzeStream(LStream);
  finally
    LStream.Free;
  end;
end;

function MainmForm: TMainmForm;
begin
  Result := TMainmForm(UniMainModule.GetFormInstance(TMainmForm));
end;

initialization
  RegisterAppFormClass(TMainmForm);

end.
