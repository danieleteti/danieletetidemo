unit PhoneEditForm;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  StdCtrls,
  PersonU,
  MGM, MGM.EditMediator;

type
  TForm2 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Edit1: TEdit;
    Edit2: TEdit;
    Label1: TLabel;
    Label2: TLabel;
  strict protected
    FPhone: TTelefono;
    ds: TSubjectDataSource;
  public
    function GetTelefono: TTelefono;
    destructor Destroy; override;
    constructor Create(AOwner: TComponent; APhone: TTelefono);
  end;

implementation

{$R *.dfm}
{ TForm2 }

constructor TForm2.Create(AOwner: TComponent; APhone: TTelefono);
begin
  inherited Create(AOwner);
  ds := TSubjectDataSource.Create;
  FPhone := APhone;
  ds.CurrentSubject := FPhone;
  ds.AddObserver(TEditMediator.Create(Edit1, 'Numero'));
  ds.AddObserver(TEditMediator.Create(Edit2, 'Tipo'));
  ds.NotifyObservers;
end;

destructor TForm2.Destroy;
begin
  ds.Free;
  FPhone.Free;
  inherited;
end;

function TForm2.GetTelefono: TTelefono;
begin
  Result := FPhone;
end;

end.
