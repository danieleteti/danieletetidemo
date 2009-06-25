unit MainView;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, view.common, StdCtrls, presenter.Main, Grids, VirtualTrees, VirtualStringTreeAdapterU;

type
  TfrmMain = class(TForm, IMainView)
    Edit2: TEdit;
    Edit3: TEdit;
    Button1: TButton;
    vst: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FGridAdapter: TVirtualStringTreeAdapter;
    FPresenter: IMainPresenter;
  public
    procedure SetFirstName(const Value: string);
    procedure SetLastName(const Value: string);
    procedure SetGUID(const Value: string);
    function GetGrid: IGridAdapter;
  end;

var
  frmMain: TfrmMain;

implementation

uses
  model.common, model.Speaker;



{$R *.dfm}

{ TfrmMain }

procedure TfrmMain.FormCreate(Sender: TObject);
begin
  FGridAdapter := TVirtualStringTreeAdapter.Create(vst);
  FPresenter := TMainPresenter.Create(self);
  FPresenter.OnInit;
end;

function TfrmMain.GetGrid: IGridAdapter;
begin
  Result := FGridAdapter;
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
