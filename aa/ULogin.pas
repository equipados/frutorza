unit ULogin;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, uniGUITypes, uniGUIAbstractClasses,
  uniGUIClasses, uniGUImClasses, uniGUIRegClasses, uniGUIForm, uniGUImForm, uniGUImJSForm;

type
  TFLogin = class(TUnimLoginForm)
  private
    { Private declarations }
  public
    { Public declarations }
  end;

function FLogin: TFLogin;

implementation

{$R *.dfm}

uses
  uniGUIVars, MainModule, uniGUIApplication;

function FLogin: TFLogin;
begin
  Result := TFLogin(UniMainModule.GetFormInstance(TFLogin));
end;

initialization
  RegisterAppFormClass(TFLogin);

end.
