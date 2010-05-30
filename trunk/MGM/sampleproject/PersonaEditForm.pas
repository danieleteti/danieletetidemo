unit PersonaEditForm;

interface

uses
  Windows,
  SysUtils,
  Classes,
  Graphics,
  Forms,
  Controls,
  StdCtrls,
  Buttons,
  ExtCtrls,
  bo,
  MGM,
  MGM.EditMediator, ComCtrls, MGM.ListMediator;

type
  TfrmPersoneEdit = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
    Bevel2: TBevel;
    Edit4: TEdit;
    Edit5: TEdit;
    Edit6: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ListView1: TListView;
  strict protected
    FPersona: TPersona;
    dsPersona, dsAutomobile: TSubjectDataSource;
    dsContatti: TSubjectListDataSource<TContatto>;
  public
    constructor Create(AOwner: TComponent; APersona: TPersona);
    destructor Destroy; override;
  end;

implementation

{$R *.dfm}
{ TfrmPersoneEdit }

constructor TfrmPersoneEdit.Create(AOwner: TComponent; APersona: TPersona);
begin
  inherited Create(AOwner);
  dsPersona := TSubjectDataSource.Create;
  dsAutomobile := TSubjectDataSource.Create;
  dsContatti := TSubjectListDataSource<TContatto>.Create;

  FPersona := APersona;
  dsPersona.CurrentSubject := FPersona;
  dsAutomobile.CurrentSubject := FPersona.Automobile;
  dsContatti.CurrentListSubject := FPersona.Contatti;

  dsPersona.AddObserver(TEditMediator.Create(Edit1, 'Nome'));
  dsPersona.AddObserver(TEditMediator.Create(Edit2, 'Indirizzo'));
  dsPersona.AddObserver(TEditMediator.Create(Edit3, 'Tipo'));

  dsAutomobile.AddObserver(TEditMediator.Create(Edit4, 'Marca'));
  dsAutomobile.AddObserver(TEditMediator.Create(Edit5, 'Modello'));
  dsAutomobile.AddObserver(TEditIntegerMediator.Create(Edit6, 'AnnoImmatricolazione'));

  dsContatti.AddObserver(TListViewMediator<TContatto>.Create(ListView1,
  procedure (li: TListItem; Value: TContatto) begin
    li.Caption := Value.Tipo;
    li.SubItems.Add(Value.Valore);
  end));

  dsPersona.NotifyObservers;
  dsAutomobile.NotifyObservers;
  dsContatti.NotifyObservers;
end;

destructor TfrmPersoneEdit.Destroy;
begin
  dsPersona.Free;
  dsAutomobile.Free;
  dsContatti.Free;
  inherited;
end;

end.
