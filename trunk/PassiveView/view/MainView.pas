unit MainView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, view.common, StdCtrls, presenter.Main, Grids, VirtualTrees,
  ComCtrls;

type
  TfrmMain = class(TForm, IMainView)
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    ListView1: TListView;
    Button2: TButton;
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private declarations }
    FGridAdapter: IGridAdapter;
    FPresenter: IMainPresenter;
  public
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    function GetFirstName: String;
    function GetLastName: String;
    procedure SetGUID(const Value: string);
    function GetGrid: IGridAdapter;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  model.common, model.Speaker, ListViewAdapterU;

{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.Button1Click(Sender: TObject);
begin
  FPresenter.OnCreateSpeaker;
end;

procedure TfrmMain.Button2Click(Sender: TObject);
begin
  FPresenter.OnDeleteSpeaker;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FGridAdapter := TListViewAdapter.Create(ListView1);
  FPresenter := TMainPresenter.Create(self);
  FPresenter.OnInit;
end;

function TfrmMain.GetFirstName: String;
begin
  Result := Edit3.Text;
end;

function TfrmMain.GetGrid: IGridAdapter;
begin
  Result := FGridAdapter;
end;

function TfrmMain.GetLastName: String;
begin
  Result := Edit2.Text;
end;

procedure TfrmMain.SetFirstName(const Value: string);
begin
  Edit3.Text := Value;
end;

procedure TfrmMain.SetGUID(const Value: string);
begin

end;

procedure TfrmMain.SetLastName(const Value: string);
begin
  Edit2.Text := Value;
end;

end.
