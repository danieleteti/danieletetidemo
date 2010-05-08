unit MGM.LabelMediator;

interface

uses
  MGM,
  StdCtrls,
  SysUtils;

type
  TLabelMediator = class(TMediatorObserver)
  strict protected
    FLabel: TLabel;
    FPropertyName: string;
  public
    constructor Create(AEdit: TLabel; APropertyName: string); virtual;
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); override;
  end;

  TLabelIntegerMediator = class(TLabelMediator)
  public
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
  end;

implementation

uses
  RTTI;

{ TLabelMediator }

constructor TLabelMediator.Create(AEdit: TLabel; APropertyName: string);
begin
  inherited Create;
  FLabel := AEdit;
  FPropertyName := APropertyName;
end;

procedure TLabelMediator.GUIToObject(ASubjectDataSource: TSubjectDataSource);
begin
end;

procedure TLabelMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  inherited;
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FLabel.Caption := PropValue.AsString;
end;

{ TLabelIntegerMediator }

procedure TLabelIntegerMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FLabel.Caption := IntToStr(PropValue.AsInteger);
end;

end.
