unit MGM.ListMediator;

interface

uses
  MGM,
  SysUtils,
  ComCtrls,
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

  TComboBoxMediator<T: class> = class(TListMediatorObserver<T>)
  strict protected
    FComboBox: TComboBox;
    FPropertyName: string;
    procedure ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>); override;
  public
    constructor Create(AComboBox: TComboBox; APropertyName: string); virtual;
    function Selected: T;
  end;

  TListViewMediator<T: class> = class(TListMediatorObserver<T>)
  strict protected
    FListView: TListView;
    FPropertyName: string;
    FProcRow: TProc<TListItem, T>;
    procedure ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>); override;
  public
    constructor Create(AListView: TListView; AProcRow: TProc<TListItem, T>); virtual;
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
      obj := Subject; // Compiler will be happy
      FListBox.Items.Add(TheType.GetProperty(FPropertyName).GetValue(obj).AsString);
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

{ TListViewMediator<T> }

constructor TListViewMediator<T>.Create(AListView: TListView; AProcRow: TProc<TListItem, T>);
begin
  inherited Create;
  FListView := AListView;
//  FPropertyName := APropertyName;
  FProcRow := AProcRow;
end;

procedure TListViewMediator<T>.ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>);
var
  List: TSubjectList<T>;
  Subject: T;
  obj: TObject;
  prop: TRttiProperty;
  li: TListItem;
begin
  FListView.Items.BeginUpdate;
  try
    FListView.Items.Clear;
    List := AListSubjectDataSource.CurrentListSubject;
    for Subject in List do
    begin
      li := FListView.Items.Add;
      li.Data := TObject(Subject);
      FProcRow(li, Subject);
    end;
  finally
    FListView.Items.EndUpdate;
  end;
end;

function TListViewMediator<T>.Selected: T;
begin
  Result := nil;
  if FListView.ItemIndex > -1 then
    Result := DataSource.CurrentListSubject[FListView.ItemIndex];
end;

{ TComboBoxMediator<T> }

constructor TComboBoxMediator<T>.Create(AComboBox: TComboBox;
  APropertyName: string);
begin
  inherited Create;
  FComboBox := AComboBox;
  FPropertyName := APropertyName;
end;

procedure TComboBoxMediator<T>.ObjectToGUI(
  AListSubjectDataSource: TSubjectListDataSource<T>);
var
  List: TSubjectList<T>;
  Subject: T;
  TheType: TRttiType;
  obj: TObject;
  prop: TRttiProperty;
begin
  FComboBox.Items.BeginUpdate;
  try
    TheType := nil;
    FComboBox.Items.Clear;
    List := AListSubjectDataSource.CurrentListSubject;
    for Subject in List do
    begin
      if not Assigned(TheType) then
        TheType := CTX.GetType(Subject.ClassInfo);
      Obj := Subject; //Compiler will be happy
      FComboBox.Items.Add(TheType.GetProperty(FPropertyName).GetValue(Obj).AsString);
    end;
  finally
    FComboBox.Items.EndUpdate;
  end;
end;


function TComboBoxMediator<T>.Selected: T;
begin
  Result := nil;
  if FComboBox.ItemIndex > -1 then
    Result := DataSource.CurrentListSubject[FComboBox.ItemIndex];
end;

end.
