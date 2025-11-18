unit MainModule;

interface

uses
  uniGUIMainModule, SysUtils, Classes, inifiles, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf,
  FireDAC.Stan.Def, FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  FireDAC.Phys.FBDef, FireDAC.Phys.IBBase, FireDAC.Phys.FB;

type
  TModuloDatos = class(TUniGUIMainModule)
    BD: TFDConnection;
    Qpalets: TFDQuery;
    FDPhysFBDriverLink1: TFDPhysFBDriverLink;
    Qalmacenes: TFDQuery;
    QalmacenesCODIGO: TIntegerField;
    QalmacenesNOMBRE: TStringField;
    QpaletsINDICE: TIntegerField;
    QpaletsALMACEN: TIntegerField;
    QpaletsLOTE: TStringField;
    QpaletsFECHA: TDateField;
    QpaletsALBARAN: TStringField;
    QpaletsIMAGEN: TStringField;
    QimagenesPalets: TFDQuery;
    QimagenesPaletsINDICE: TIntegerField;
    QimagenesPaletsPALET: TIntegerField;
    QimagenesPaletsRUTA: TStringField;
    procedure UniGUIMainModuleCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ServidorFB,BDFB : string;
    puertoFB : integer;
    function GetNombreAlmacen(Codigo : integer) : string;
  end;

function ModuloDatos: TModuloDatos;

implementation

{$R *.dfm}

uses
  UniGUIVars, ServerModule, uniGUIApplication;

function ModuloDatos: TModuloDatos;
begin
  Result := TModuloDatos(UniApplication.UniMainModule)
end;

function TModuloDatos.GetNombreAlmacen(Codigo : integer) : string;
var
  VQ : TFDQuery;
begin
  VQ := TFDQuery.Create(nil);
  try
    VQ.Connection := BD;
    VQ.SQL.Add('SELECT NOMBRE FROM ALMACEN WHERE CODIGO=:CODIGO');
    VQ.ParamByName('CODIGO').AsInteger := codigo;
    VQ.Open;
    result :=  VQ.FieldByName('NOMBRE').asstring;
  finally
    VQ.Free;
  end;
end;

procedure TModuloDatos.UniGUIMainModuleCreate(Sender: TObject);
var
 ini : Tinifile;
begin
  Ini:= TIniFile.Create(ChangeFileExt(uniServerModule.StartPath,'.ini'));
  ServidorFB := ini.readstring('BASEDATOS','Servidor','');
  BDFB := ini.readstring('BASEDATOS','BD','');
  puertoFB := ini.ReadInteger('BASEDATOS','Puerto',0);
  if ServidorFB<>'' then
  begin
    BD.DriverName := 'FB';
    with BD.Params as TFDPhysFBConnectionDefParams do begin
     Server := ServidorFB;
     Database := BDFB;
     UserName := 'sysdba';
     Password := 'masterkey';
     Port := puertoFB;
   end;
   BD.Connected := True
  end;



end;

initialization
  RegisterMainModuleClass(TModuloDatos);
end.
