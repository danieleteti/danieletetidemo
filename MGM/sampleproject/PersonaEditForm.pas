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
  MGM.EditMediator;

type
  TfrmPersoneEdit = class(TForm)
    OKBtn: TButton;
    CancelBtn: TButton;
    Bevel1: TBevel;
    Edit1: TEdit;
    Edit2: TEdit;
    Edit3: TEdit;
  strict protected
    FPersona: TPersona;
    dsPersona: TSubjectDataSource;
  public
    constructor Create(AOwner: TComponent; APersona: TPersona);
  end;

implementation

{$R *.dfm}
{ TfrmPersoneEdit }

constructor TfrmPersoneEdit.Create(AOwner: TComponent; APersona: TPersona);
begin
  inherited Create(AOwner);
  dsPersona := TSubjectDataSource.Create;
  FPersona := APersona;
  dsPersona.CurrentSubject := FPersona;
  dsPersona.AddObserver(TEditMediator.Create(Edit1, 'Nome'));
  dsPersona.AddObserver(TEditMediator.Create(Edit2, 'Indirizzo'));
  dsPersona.AddObserver(TEditMediator.Create(Edit3, 'Tipo'));
  dsPersona.NotifyObservers;
end;

end.
