unit MGM;

interface

uses
  Generics.Collections,
  RTTI, sysutils, func, Classes;

type
  TSubject = class;
  TSubjectDataSource = class;

  TCloneable = class
    function CopyTo(ACloneable: TCloneable): TCloneable; virtual;
  end;

  TSubject = class(TCloneable)
  private
    FObservers: TObjectList<TSubjectDataSource>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AObserver: TSubjectDataSource);
    procedure RemoveObserver(AObserver: TSubjectDataSource);
    procedure NotifyObservers; virtual;
  end;

  TSubjectListDataSource<T: TSubject, constructor> = class;
  TSubjectList<T: TSubject, constructor> = class;

  TSubjectList<T: TSubject, constructor> = class(TSubject)
  private
    FItems: TObjectList<T>;
    FUpdateCount: Cardinal;
    FObservers: TObjectList < TSubjectListDataSource<T>> ;
    function GetItem(index: Int64): T;
    procedure SetItem(index: Int64; const Value: T);
  protected
    procedure Notify(const Item: T; Action: TCollectionNotification);
  public
    function CopyTo(ACloneable: TCloneable): TCloneable; override;
    procedure BeginUpdate;
    procedure EndUpdate;
    constructor Create; reintroduce; virtual;
    destructor Destroy; override;
    procedure AddObserver(AObserver: TSubjectListDataSource<T>);
    procedure RemoveObserver(AObserver: TSubjectListDataSource<T>);
    procedure NotifyObservers; override;
    //List method
    function GetEnumerator: TList<T>.TEnumerator;
    function Add(AItem: T): TSubjectList<T>;
    function Remove(AItem: T): TSubjectList<T>;
    function Count: Int64;
    function Clear: TSubjectList<T>;
    property Items[index: Int64]: T read GetItem write SetItem; default;
  end;

  TMediatorObserver = class;

  TSubjectDataSource = class
  private
    FObservers: TObjectList<TMediatorObserver>;
    FCurrentSubject: TSubject;
    procedure SetCurrentSubject(const Value: TSubject);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AObserver: TMediatorObserver);
    procedure NotifyObservers; virtual;
    procedure Update(ASubject: TSubject); virtual;
    property CurrentSubject: TSubject read FCurrentSubject write SetCurrentSubject;
  end;

  TListMediatorObserver<T: TSubject, constructor> = class;

  TSubjectListDataSource<T: TSubject, constructor> = class
  private
    FObservers: TObjectList < TListMediatorObserver < T >> ;
    FCurrentListSubject: TSubjectList<T>;
    procedure SetCurrentListSubject(const Value: TSubjectList<T>);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AListObserver: TListMediatorObserver<T>);
    procedure NotifyObservers; virtual;
    procedure Update(ASubjectList: TSubjectList<T>); virtual;
    property CurrentListSubject
      : TSubjectList<T>read FCurrentListSubject write SetCurrentListSubject;
  end;

  TMediatorObserver = class
  protected
    DataSource: TSubjectDataSource;
    CTX: TRTTIContext;
    procedure CheckNotAssignedEvent(NotifyEvent: TNotifyEvent; Name: String); virtual;
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); virtual;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); virtual;
  public
    procedure Update(ASubjectDataSource: TSubjectDataSource); virtual;
  end;

  TListMediatorObserver<T: TSubject, constructor> = class
  protected
    DataSource: TSubjectListDataSource<T>;
    CTX: TRTTIContext;
    procedure ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
    procedure GUIToObject(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
  public
    procedure Update(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
  end;

implementation

uses
  Windows,
  TypInfo;

{ TSubject }

procedure TSubject.AddObserver(AObserver: TSubjectDataSource);
begin
  FObservers.Add(AObserver);
end;

function TCloneable.CopyTo(ACloneable: TCloneable): TCloneable;
var
  CTX: TRTTIContext;
  the_type: TRttiType;
  field: TRTTIField;
  fields: TArray<TRTTIField>;
  qn: string;
  xx: TCloneable;
  obj_self: TValue;
  obj_subject: TValue;
begin
  the_type := CTX.GetType(Self.ClassType);
  fields := the_type.GetFields;
  for field in fields do
  begin
    qn:= field.Name + ' @ ' + field.Parent.Name;
    case field.FieldType.TypeKind of
      tkInteger, tkChar, tkEnumeration, tkFloat,
      tkString, tkSet, tkWChar, tkLString,
      tkWString, tkVariant, tkArray, tkRecord,
      tkInt64, tkUString: begin
          field.SetValue(ACloneable, field.GetValue(self));
        end;
      tkClass: begin
        obj_self := the_type.GetField(field.Name).GetValue(Self);
        if obj_self.IsType<TCloneable> then
        begin
          obj_subject := the_type.GetField(field.Name).GetValue(ACloneable);
//          ref_copy_to := the_type.GetMethod('CopyTo');
          xx := obj_self.AsType<TCloneable>;
          xx.CopyTo(obj_subject.AsObject as TCloneable);
        end;
      end;
    end;
  end;
  Result := Self;
end;

constructor TSubject.Create;
begin
  inherited;
  FObservers := TObjectList<TSubjectDataSource>.Create(false);
end;

destructor TSubject.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TSubject.NotifyObservers;
var
  Observer: TSubjectDataSource;
begin
  for Observer in FObservers do
  begin
    Observer.Update(self)
  end;
end;

procedure TSubject.RemoveObserver(AObserver: TSubjectDataSource);
begin
  FObservers.Remove(AObserver);
end;

{ TSubjectDataSource }

procedure TSubjectDataSource.AddObserver(AObserver: TMediatorObserver);
begin
  FObservers.Add(AObserver);
end;

constructor TSubjectDataSource.Create;
begin
  inherited;
  FObservers := TObjectList<TMediatorObserver>.Create(true);
end;

destructor TSubjectDataSource.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TSubjectDataSource.NotifyObservers;
var
  Observer: TMediatorObserver;
begin
  for Observer in FObservers do
  begin
    Observer.Update(self);
  end;
end;

procedure TSubjectDataSource.SetCurrentSubject(const Value: TSubject);
begin
  if Value <> FCurrentSubject then
  begin
    if Assigned(FCurrentSubject) then
      FCurrentSubject.RemoveObserver(self);
    FCurrentSubject := Value;
    FCurrentSubject.AddObserver(self);
    NotifyObservers;
  end;
end;

procedure TSubjectDataSource.Update(ASubject: TSubject);
begin
  FCurrentSubject := ASubject;
  NotifyObservers;
end;

{ TMediatorObserver }

procedure TMediatorObserver.CheckNotAssignedEvent(NotifyEvent: TNotifyEvent;
  Name: String);
begin
  if Assigned(NotifyEvent) then
    raise Exception.Create('Event ' + Name + ' already assigned');
end;

procedure TMediatorObserver.GUIToObject(ASubjectDataSource: TSubjectDataSource);
begin
  // do nothing
end;

procedure TMediatorObserver.ObjectToGUI(ASubjectDataSource: TSubjectDataSource);
begin
  // do nothing
end;

procedure TMediatorObserver.Update(ASubjectDataSource: TSubjectDataSource);
begin
  DataSource := ASubjectDataSource;
  ObjectToGUI(ASubjectDataSource);
end;

{ TSubjectList }

function TSubjectList<T>.Add(AItem: T): TSubjectList<T>;
begin
  FItems.Add(AItem);
  Result := Self;
  NotifyObservers;
end;

procedure TSubjectList<T>.AddObserver(AObserver: TSubjectListDataSource<T>);
begin
  FObservers.Add(AObserver);
end;

procedure TSubjectList<T>.BeginUpdate;
begin
  Inc(FUpdateCount);
end;

function TSubjectList<T>.Clear: TSubjectList<T>;
begin
  FItems.Clear;
  Result := Self;
end;

function TSubjectList<T>.CopyTo(ACloneable: TCloneable): TCloneable;
var
  item: T;
  o: TSubject;
  lst: TSubjectList<T>;
begin
  lst := TSubjectList<T>(ACloneable);
  lst.Clear;
  for item in self do
  begin
    o := T.Create;
    item.CopyTo(o);
    lst.Add(o);
  end;
  Result := Self;
end;

function TSubjectList<T>.Count: Int64;
begin
  Result := FItems.Count;
end;

constructor TSubjectList<T>.Create;
begin
  inherited Create;
  FItems := TObjectList<T>.Create(true);
  FUpdateCount := 0;
  FObservers := TObjectList < TSubjectListDataSource < T >> .Create(false);
end;

destructor TSubjectList<T>.Destroy;
begin
  FObservers.Free;
  FItems.Free;
  inherited;
end;

procedure TSubjectList<T>.EndUpdate;
begin
  Dec(FUpdateCount);
end;

function TSubjectList<T>.GetEnumerator: TList<T>.TEnumerator;
begin
  Result := FItems.GetEnumerator;
end;

function TSubjectList<T>.GetItem(index: Int64): T;
begin
  Result := FItems[index];
end;

procedure TSubjectList<T>.Notify(const Item: T; Action: TCollectionNotification);
begin
  inherited;
  NotifyObservers;
end;

procedure TSubjectList<T>.NotifyObservers;
var
  Observer: TSubjectListDataSource<T>;
begin
  if (FUpdateCount = 0) and (FObservers.Count > 0) then
    for Observer in FObservers do
      Observer.Update(self)
end;

function TSubjectList<T>.Remove(AItem: T): TSubjectList<T>;
begin
  FItems.Remove(AItem);
  Result := Self;
  NotifyObservers;
end;

procedure TSubjectList<T>.RemoveObserver(AObserver: TSubjectListDataSource<T>);
begin
  FObservers.Remove(AObserver);
end;

procedure TSubjectList<T>.SetItem(index: Int64; const Value: T);
begin
  FItems.Items[index] := Value;
  NotifyObservers;
end;

{ TListSubjectDataSource }

procedure TSubjectListDataSource<T>.AddObserver(AListObserver: TListMediatorObserver<T>);
begin
  FObservers.Add(AListObserver);
end;

constructor TSubjectListDataSource<T>.Create;
begin
  inherited;
  FObservers := TObjectList < TListMediatorObserver < T >> .Create(true);
end;

destructor TSubjectListDataSource<T>.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TSubjectListDataSource<T>.NotifyObservers;
var
  Observer: TListMediatorObserver<T>;
begin
  for Observer in FObservers do
  begin
    Observer.Update(self);
  end;
end;

procedure TSubjectListDataSource<T>.SetCurrentListSubject(const Value: TSubjectList<T>);
begin
  if Value <> FCurrentListSubject then
  begin
    if Assigned(FCurrentListSubject) then
      FCurrentListSubject.RemoveObserver(self);
    FCurrentListSubject := Value;
    FCurrentListSubject.AddObserver(self);
    NotifyObservers;
  end;
end;

procedure TSubjectListDataSource<T>.Update(ASubjectList: TSubjectList<T>);
begin
  FCurrentListSubject := ASubjectList;
  NotifyObservers;
end;

{ TListMediatorObserver }

procedure TListMediatorObserver<T>.GUIToObject(AListSubjectDataSource: TSubjectListDataSource<T>);
begin
  // do nothing
end;

procedure TListMediatorObserver<T>.ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>);
begin
  // do nothing
end;

procedure TListMediatorObserver<T>.Update(AListSubjectDataSource: TSubjectListDataSource<T>);
begin
  DataSource := AListSubjectDataSource;
  ObjectToGUI(AListSubjectDataSource);
end;

end.
