unit MGM.ButtonMediator;

interface

uses
  MGM,
  StdCtrls,
  SysUtils;

type
  TButtonMediator = class(TMediatorObserver)
  strict protected
    FButton: TButton;
    FPropertyName: string;
  public
    constructor Create(AButton: TButton; APropertyName: string); virtual;
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); override;
  end;

  TButtonIntegerMediator = class(TButtonMediator)
  public
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); override;
  end;

implementation

uses
  RTTI;

{ TButtonMediator }

constructor TButtonMediator.Create(AButton: TButton; APropertyName: string);
begin
  inherited Create;
  FButton := AButton;
  FPropertyName := APropertyName;
end;

procedure TButtonMediator.GUIToObject(ASubjectDataSource: TSubjectDataSource);
begin
end;

procedure TButtonMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  inherited;
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FButton.Caption := PropValue.AsString;
end;

{ TButtonIntegerMediator }

procedure TButtonIntegerMediator.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
var
  PropValue: TValue;
begin
  PropValue := CTX.GetType(ASubjectDataSource.CurrentSubject.ClassInfo).GetProperty(FPropertyName)
    .GetValue(ASubjectDataSource.CurrentSubject);
  FButton.Caption := IntToStr(PropValue.AsInteger);
end;

end.
