unit presenter.Main;

interface

uses
  view.common, model.common, Contnrs, Classes;

type
  IMainPresenter = interface
    ['{394A5A99-3AA7-41B0-91D0-3BF589728B9E}']
    procedure OnCreateSpeaker;
    procedure OnDeleteSpeaker;
    procedure OnInit;
    procedure SetView(AView: IMainView);
    procedure SetModel(AModel: ISpeakerMapper);
  end;

  TMainPresenter = class(TInterfacedObject, IMainPresenter)
  private
    s: ISpeaker;
  protected
    FMainView: IMainView;
    FSpeakerMapper: ISpeakerMapper;
    FSpeakers: TInterfacelist;
    procedure FillList;
  public
    constructor Create(AView: IMainView); overload;
    constructor Create(AView: IMainView; AModel: ISpeakerMapper); overload;
    destructor Destroy; override;
    procedure OnCreateSpeaker;
    procedure OnDeleteSpeaker;    
    procedure OnInit;
    procedure SetView(AView: IMainView);
    procedure SetModel(AModel: ISpeakerMapper);
  end;

implementation

uses
  model.SpeakerMapper, model.Speaker;

{ TMainPresenter }

constructor TMainPresenter.Create(AView: IMainView);
begin
  inherited Create;
  FSpeakers := TInterfaceList.Create;
  FMainView := AView;
  FSpeakerMapper := TSpeakerMapper.Create;
end;

constructor TMainPresenter.Create(AView: IMainView; AModel: ISpeakerMapper);
begin
  inherited Create;
  FSpeakerMapper := AModel;
  FMainView := AView;
end;

destructor TMainPresenter.Destroy;
begin
  FSpeakers.Free;
  inherited;
end;

procedure TMainPresenter.FillList;
var
  list: IInterfaceList;
  spk: ISpeaker;
  I: Integer;
begin
  FMainView.GetGrid.BeginUpdate;
  try
    FMainView.GetGrid.ClearRow;
    list := FSpeakerMapper.LoadAll;
    if list.Count > 0 then
      for I := 0 to list.Count - 1 do
      begin
        spk := ISpeaker(list[i]);
        FMainView.GetGrid.AddObject(spk);
      end;
  finally
    FMainView.GetGrid.EndUpdate;
  end;
end;

procedure TMainPresenter.OnCreateSpeaker;
var
  Speaker: ISpeaker;
begin
  Speaker := TSpeaker.Create;
  Speaker.FirstName := FMainView.GetFirstName;
  Speaker.LastName := FMainView.GetLastName;
  FSpeakerMapper.Insert(Speaker);
  FillList;
end;

procedure TMainPresenter.OnDeleteSpeaker;
var
  Speaker: ISpeaker;
begin
  Speaker := FMainView.GetGrid.SelectedSpeaker;
  if Assigned(Speaker) then
    FSpeakerMapper.Delete(Speaker);
  FillList;
end;

procedure TMainPresenter.OnInit;
begin
  FMainView.SetFirstName('Write a FirstName');
  FMainView.SetLastName('Write a LastName');
  FMainView.GetGrid.ClearHeader;
  FMainView.GetGrid.ClearRow;
  FMainView.GetGrid.AddHeader('First Name', 200);
  FMainView.GetGrid.AddHeader('Last Name', 200);
  FillList;
end;

procedure TMainPresenter.SetModel(AModel: ISpeakerMapper);
begin
  FSpeakerMapper := AModel;
end;

procedure TMainPresenter.SetView(AView: IMainView);
begin
  FMainView := AView;
end;

end.

