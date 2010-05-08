unit MGM.ListMediator;

interface

uses
  MGM,
  StdCtrls;

type
  TListBoxMediator<T: class> = class(TListMediatorObserver<T>)
  strict protected
    FListBox: TListBox;
    FPropertyName: string;
    procedure ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>); override;
  public
    constructor Create(AListBox: TListBox; APropertyName: string); virtual;
    function Selected: T;
  end;

implementation

uses
  RTTI;

{ TListBoxMediator }

constructor TListBoxMediator<T>.Create(AListBox: TListBox; APropertyName: string);
begin
  inherited Create;
  FListBox := AListBox;
  FPropertyName := APropertyName;
end;

procedure TListBoxMediator<T>.ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>);
var
  List: TSubjectList<T>;
  Subject: T;
  TheType: TRttiType;
  obj: TObject;
  prop: TRttiProperty;
begin
  FListBox.Items.BeginUpdate;
  try
    TheType := nil;
    FListBox.Items.Clear;
    List := AListSubjectDataSource.CurrentListSubject;
    for Subject in List do
    begin
      if not Assigned(TheType) then
        TheType := CTX.GetType(Subject.ClassInfo);
      Obj := Subject; //Compiler will be happy
      FListBox.Items.Add(TheType.GetProperty(FPropertyName).GetValue(Obj).AsString);
    end;
  finally
    FListBox.Items.EndUpdate;
  end;
end;

function TListBoxMediator<T>.Selected: T;
begin
  Result := nil;
  if FListBox.ItemIndex > -1 then
    Result := DataSource.CurrentListSubject[FListBox.ItemIndex];
end;

end.
