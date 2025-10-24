unit uLabelParser;

interface

uses
  System.SysUtils,
  System.Classes,
  System.JSON,
  System.Generics.Collections;

type
  TLabelInfo = record
    Lot: string;
    HarvestDate: string;
    Cooperative: string;
    Product: string;
    Category: string;
    BunchCount: string;
    procedure Clear;
  end;

  TLabelParser = class
  public
    class function ParseChatGPTResponse(AJSON: TJSONObject): TLabelInfo;
  end;

implementation

{ TLabelInfo }

procedure TLabelInfo.Clear;
begin
  Lot := '';
  HarvestDate := '';
  Cooperative := '';
  Product := '';
  Category := '';
  BunchCount := '';
end;

function GetCaseInsensitiveValue(AJSON: TJSONObject; const AName: string): string;
var
  LPair: TJSONPair;
  LValue: TJSONValue;
begin
  Result := '';
  if AJSON = nil then
    Exit;

  for LPair in AJSON do
  begin
    if SameText(LPair.JsonString.Value, AName) then
    begin
      LValue := LPair.JsonValue;
      if LValue is TJSONString then
        Exit(TJSONString(LValue).Value)
      else
        Exit(LValue.ToJSON);
    end;
  end;
end;

function ExtractNestedObject(AJSON: TJSONObject; const AName: string): TJSONObject;
var
  LValue: TJSONValue;
begin
  Result := nil;
  if AJSON = nil then
    Exit(nil);

  LValue := AJSON.Values[AName];
  if LValue is TJSONObject then
    Result := TJSONObject(LValue)
  else
    Result := nil;
end;

class function TLabelParser.ParseChatGPTResponse(AJSON: TJSONObject): TLabelInfo;
var
  LResult: TLabelInfo;
  LData: TJSONObject;
begin
  LResult.Clear;
  if AJSON = nil then
    Exit(LResult);

  LData := ExtractNestedObject(AJSON, 'data');
  if (LData <> nil) and (LData <> AJSON) then
    Exit(ParseChatGPTResponse(LData));

  LResult.Lot := GetCaseInsensitiveValue(AJSON, 'lot');
  if LResult.Lot = '' then
    LResult.Lot := GetCaseInsensitiveValue(AJSON, 'lote');

  LResult.HarvestDate := GetCaseInsensitiveValue(AJSON, 'harvest_date');
  if LResult.HarvestDate = '' then
    LResult.HarvestDate := GetCaseInsensitiveValue(AJSON, 'fecha');

  LResult.Cooperative := GetCaseInsensitiveValue(AJSON, 'cooperative');
  if LResult.Cooperative = '' then
    LResult.Cooperative := GetCaseInsensitiveValue(AJSON, 'cooperativa');

  LResult.Product := GetCaseInsensitiveValue(AJSON, 'product');
  if LResult.Product = '' then
    LResult.Product := GetCaseInsensitiveValue(AJSON, 'producto');

  LResult.Category := GetCaseInsensitiveValue(AJSON, 'category');
  if LResult.Category = '' then
    LResult.Category := GetCaseInsensitiveValue(AJSON, 'categoria');

  LResult.BunchCount := GetCaseInsensitiveValue(AJSON, 'bunch_count');
  if LResult.BunchCount = '' then
    LResult.BunchCount := GetCaseInsensitiveValue(AJSON, 'bultos');

  Result := LResult;
end;

end.
