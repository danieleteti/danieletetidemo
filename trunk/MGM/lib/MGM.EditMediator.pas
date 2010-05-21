unit MGM.EditMediator;

interface

uses
  MGM,
  StdCtrls;

type
  TChangeEvent = (ceOnChange, ceOnExit);

  TEditMediator = class(TMediatorObserver)
  strict protected
    FEdit: TEdit;
    FPropertyName: string;
    procedure OnChange(Sender: TObject);
  public
    constructor Create(AEdit: TEdit; APropertyName: string; OnChangeEvent: TChangeEvent = ceOnChange); virtual;
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); override;
  end;

  TEditIntegerMediator = class(TEditMediator)
  public
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); override;
  end;

  TEditCurrencyMediator = class(TEditMediator)
  public
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); override;
  end;


implementation

uses
  RTTI,
  SysUtils;

{ TEditMediator }

constructor TEditMediator.Create(AEdit: TEdit; APropertyName: string; OnChangeEvent: TChangeEvent);
begin
  inherited Create;
  FEdit := AEdit;
  FPropertyName := APropertyName;
  if OnChangeEvent = ceOnChange then
    FEdit.OnChange := OnChange
  else
    FEdit.OnExit := OnChange;
end;

procedure TEditMediator.GUIToObject(ASubjectDataSource: TSubjectDataSource);
begin
  CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName).SetValue
    (ASubjectDataSource.CurrentSubject, FEdit.Text);
end;

procedure TEditMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  inherited;
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FEdit.Text := PropValue.AsString;
end;

procedure TEditMediator.OnChange(Sender: TObject);
begin
  GUIToObject(DataSource);
end;

{ TEditIntegerMediator }

procedure TEditIntegerMediator.GUIToObject(ASubjectDataSource: TSubjectDataSource);
begin
  CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName).SetValue
    (ASubjectDataSource.CurrentSubject, StrToInt(FEdit.Text));
end;

procedure TEditIntegerMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FEdit.Text := IntToStr(PropValue.AsInteger);
end;

{ TEditCurrencyMediator }

procedure TEditCurrencyMediator.GUIToObject(
  ASubjectDataSource: TSubjectDataSource);
begin
  CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName).SetValue
    (ASubjectDataSource.CurrentSubject, StrToCurr(FEdit.Text));
end;

procedure TEditCurrencyMediator.ObjectToGUI(
  ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FEdit.Text := CurrToStr(PropValue.AsCurrency);
end;

end.
