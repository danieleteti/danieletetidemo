unit MGM;

interface

uses
  Generics.Collections,
  RTTI;

type
  TSubjectDataSource = class;
  TSubjectListDataSource<T: class> = class;

  TSubject = class
  private
    FObservers: TObjectList<TSubjectDataSource>;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AObserver: TSubjectDataSource);
    procedure RemoveObserver(AObserver: TSubjectDataSource);
    procedure NotifyObservers; virtual;
  end;

  TSubjectList<T: class> = class(TObjectList<T>)
  private
    FObservers: TObjectList<TSubjectListDataSource<T>>;
  protected
    procedure Notify(const Item: T; Action: TCollectionNotification); override;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AObserver: TSubjectListDataSource<T>);
    procedure RemoveObserver(AObserver: TSubjectListDataSource<T>);
    procedure NotifyObservers; virtual;
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

  TListMediatorObserver<T: class> = class;

  TSubjectListDataSource<T: class> = class
  private
    FObservers: TObjectList<TListMediatorObserver<T>>;
    FCurrentListSubject: TSubjectList<T>;
    procedure SetCurrentListSubject(const Value: TSubjectList<T>);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObserver(AListObserver: TListMediatorObserver<T>);
    procedure NotifyObservers; virtual;
    procedure Update(ASubjectList: TSubjectList<T>); virtual;
    property CurrentListSubject: TSubjectList<T> read FCurrentListSubject write SetCurrentListSubject;
  end;

  TMediatorObserver = class
  protected
    DataSource: TSubjectDataSource;
    CTX: TRTTIContext;
    procedure ObjectToGUI(ASubjectDataSource: TSubjectDataSource); virtual;
    procedure GUIToObject(ASubjectDataSource: TSubjectDataSource); virtual;
  public
    procedure Update(ASubjectDataSource: TSubjectDataSource); virtual;
  end;

  TListMediatorObserver<T: class> = class
  protected
    DataSource: TSubjectListDataSource<T>;
    CTX: TRTTIContext;
    procedure ObjectToGUI(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
    procedure GUIToObject(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
  public
    procedure Update(AListSubjectDataSource: TSubjectListDataSource<T>); virtual;
  end;

implementation

{ TSubject }

procedure TSubject.AddObserver(AObserver: TSubjectDataSource);
begin
  FObservers.Add(AObserver);
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

procedure TSubjectList<T>.AddObserver(AObserver: TSubjectListDataSource<T>);
begin
  FObservers.Add(AObserver);
end;

constructor TSubjectList<T>.Create;
begin
  inherited Create(true);
  FObservers := TObjectList<TSubjectListDataSource<T>>.Create(false);
end;

destructor TSubjectList<T>.Destroy;
begin
  FObservers.Free;
  inherited;
end;

procedure TSubjectList<T>.Notify(const Item: T;
  Action: TCollectionNotification);
begin
  inherited;
  NotifyObservers;
end;

procedure TSubjectList<T>.NotifyObservers;
var
  Observer: TSubjectListDataSource<T>;
begin
  for Observer in FObservers do
  begin
    Observer.Update(self)
  end;
end;

procedure TSubjectList<T>.RemoveObserver(AObserver: TSubjectListDataSource<T>);
begin
  FObservers.Remove(AObserver);
end;

{ TListSubjectDataSource }

procedure TSubjectListDataSource<T>.AddObserver(AListObserver: TListMediatorObserver<T>);
begin
  FObservers.Add(AListObserver);
end;

constructor TSubjectListDataSource<T>.Create;
begin
  inherited;
  FObservers := TObjectList<TListMediatorObserver<T>>.Create(true);
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
