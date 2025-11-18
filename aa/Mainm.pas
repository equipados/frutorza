unit Mainm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm, uniGUImJSForm,
  uniLabel, unimLabel, uniGUIBaseClasses, unimPanel, uniImage, unimImage;

type
  TMainmForm = class(TUnimForm)
    pnlAddPAlet: TUnimPanel;
    UnimLabel1: TUnimLabel;
    pnlClas: TUnimPanel;
    UnimLabel2: TUnimLabel;
    UnimLabel3: TUnimLabel;
    pnlEtiquetas: TUnimPanel;
    UnimLabel4: TUnimLabel;
    UnimLabel5: TUnimLabel;
    pnlCentral: TUnimPanel;
    UnimLabel6: TUnimLabel;
    logo: TUnimImage;
    procedure UnimFormCreate(Sender: TObject);
    procedure UnimFormScreenResize(Sender: TObject; AWidth, AHeight: Integer);
    procedure pnlAddPAletClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function MainmForm: TMainmForm;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication, uAddPalet;

function MainmForm: TMainmForm;
begin
  Result := TMainmForm(Modulodatos.GetFormInstance(TMainmForm));
end;

procedure TMainmForm.pnlAddPAletClick(Sender: TObject);
var
  FAddpalet : TFAddpalet;

begin
 FAddpalet := TFAddPalet.create(UniApplication);
 FAddPalet.showmodal;
end;

procedure TMainmForm.UnimFormCreate(Sender: TObject);
begin
  pnlAddPalet.JSInterface.JSCode(#1'.bodyElement.dom.style.setProperty("border-radius","10px");');
  pnlClas.JSInterface.JSCode(#1'.bodyElement.dom.style.setProperty("border-radius","10px");');
  pnlEtiquetas.JSInterface.JSCode(#1'.bodyElement.dom.style.setProperty("border-radius","10px");');
end;

procedure TMainmForm.UnimFormScreenResize(Sender: TObject; AWidth,
  AHeight: Integer);
var
 espacio : integer;
begin

  Espacio := (Awidth - (3 * pnlAddPalet.width)) div 4;
  pnlAddPAlet.Left := espacio;
  Pnlclas.Left := pnlAddpalet.Left + pnladdpalet.Width + espacio;
  pnlEtiquetas.Left := PnlClas.Left + pnlClas.Width + espacio;
  pnlAddpalet.Top := (AHeight   - pnlAddPAlet.Height) div 2;
  pnlClas.Top := pnlAddpalet.Top;
  pnletiquetas.top := pnlAddpalet.Top;

  logo.Top := 10;
  logo.Left := (Awidth div 2) - (logo.Width div 2);

end;

initialization
  RegisterAppFormClass(TMainmForm);

end.
