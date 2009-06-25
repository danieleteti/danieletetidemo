unit presenter.Main;

interface

uses
  view.common, model.common;

type
  IMainPresenter = interface
    ['{394A5A99-3AA7-41B0-91D0-3BF589728B9E}']
    procedure OnCreateSpeaker;
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
  public
    constructor Create(AView: IMainView); overload;
    constructor Create(AView: IMainView; AModel: ISpeakerMapper); overload;
    procedure OnCreateSpeaker;
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
  FMainView := AView;
  FSpeakerMapper := TSpeakerMapper.Create;
end;

constructor TMainPresenter.Create(AView: IMainView; AModel: ISpeakerMapper);
begin
  inherited Create;
  FSpeakerMapper := AModel;
  FMainView := AView;
end;

procedure TMainPresenter.OnCreateSpeaker;
begin

end;

procedure TMainPresenter.OnInit;
begin
  FMainView.SetFirstName('Write a FirstName');
  FMainView.SetLastName('Write a LastName');

//  FMainView.GetGrid.ClearHeader;
//  FMainView.GetGrid.AddHeader('First Name');
//  FMainView.GetGrid.AddHeader('Last Name');
//  FMainView.GetGrid.ClearRow;

  s := TSpeaker.Create;
  s.FirstName := 'Daniele';
  s.LastName := 'Teti';
  FMainView.GetGrid.AddObject(s);
  FMainView.GetGrid.AddObject(s);
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
