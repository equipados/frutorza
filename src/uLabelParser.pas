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
    class function ParseReadAPIResponse(AJSON: TJSONObject): TLabelInfo;
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

class function TLabelParser.ParseReadAPIResponse(AJSON: TJSONObject): TLabelInfo;
var
  LResult: TLabelInfo;
  LLines: TJSONArray;
  LLine: TJSONObject;
  LText: string;
  I: Integer;
begin
  LResult.Clear;
  if AJSON = nil then
    Exit(LResult);

  LLines := AJSON.Values['lines'] as TJSONArray;
  if LLines = nil then
  begin
    if AJSON.Values['analyzeResult'] is TJSONObject then
      Exit(ParseReadAPIResponse(TJSONObject(AJSON.Values['analyzeResult'])));
    Exit(LResult);
  end;

  for I := 0 to LLines.Count - 1 do
  begin
    LLine := LLines.Items[I] as TJSONObject;
    LText := LLine.GetValue<string>('text', '').ToUpper;

    if (LResult.Cooperative = '') and (Pos('COOP', LText) > 0) then
      LResult.Cooperative := LLine.GetValue<string>('text', '');

    if (LResult.Product = '') and (Pos('PRODUCTO', LText) > 0) then
      LResult.Product := LLine.GetValue<string>('text', '');

    if (LResult.Category = '') and ((Pos('CATEGORIA', LText) > 0) or (Pos('CAT', LText) > 0)) then
      LResult.Category := LLine.GetValue<string>('text', '');

    if (LResult.Lot = '') and (Pos('LOTE', LText) > 0) then
      LResult.Lot := LLine.GetValue<string>('text', '');

    if (LResult.HarvestDate = '') and ((Pos('FECHA', LText) > 0) or (Pos('PRODUCCION', LText) > 0)) then
      LResult.HarvestDate := LLine.GetValue<string>('text', '');

    if (LResult.BunchCount = '') and (Pos('N. BULTOS', LText) > 0) then
      LResult.BunchCount := LLine.GetValue<string>('text', '');
  end;

  Result := LResult;
end;

end.
