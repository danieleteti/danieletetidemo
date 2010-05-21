unit PersonU;

interface

uses
  MGM;

type
  TTelefono = class(TSubject)
  private
    FNumero: string;
    FTipo: string;
    procedure SetNumero(const Value: string);
    procedure SetTipo(const Value: string);
  public
    property Numero: string read FNumero write SetNumero;
    property Tipo: string read FTipo write SetTipo;
  end;

  TTelefoni = class(TSubjectList<TTelefono>)
  end;

  TPersona = class(TSubject)
  private
    FCognome: string;
    FEta: Integer;
    FNome: string;
    FTelefoni: TTelefoni;
    FSalario: Currency;
    procedure SetCognome(const Value: string);
    procedure SetEta(const Value: Integer);
    procedure SetNome(const Value: string);
    procedure SetTelefoni(const Value: TTelefoni);
    procedure SetSalario(const Value: Currency);
  public
    class function CreateNew: TPersona;
    constructor Create;
    destructor Destroy; override;
    property Telefoni: TTelefoni read FTelefoni write SetTelefoni;
    property Nome: string read FNome write SetNome;
    property Cognome: string read FCognome write SetCognome;
    property Eta: Integer read FEta write SetEta;
    property Salario: Currency read FSalario write SetSalario;
  end;

  TPersone = class(TSubjectList<TPersona>)
  end;


implementation

uses
  SysUtils, math;

{ TPersona }

constructor TPersona.Create;
begin
  inherited;
  FTelefoni := TTelefoni.Create;
end;

class function TPersona.CreateNew: TPersona;
var
  Tel: TTelefono;
begin
  Result := TPersona.Create;
  Result.Nome := 'Daniele' + IntToStr(Random(10));
  Result.Cognome := 'Teti' + IntToStr(Random(10));
  Result.Eta := 20 + Random(20);
  Result.Salario := RandomRange(100000, 500000) / 100;
  Tel := TTelefono.Create;
  Tel.Numero := '872648726' + IntToStr(Random(20));
  Tel.Tipo := inttostr(RandomFrom([0,1,2]));
  Result.Telefoni.Add(Tel);
  Tel := TTelefono.Create;
  Tel.Numero := '979872347' + IntToStr(Random(20));
  Tel.Tipo := inttostr(RandomFrom([0,1,2]));
  Result.Telefoni.Add(Tel);
  Tel := TTelefono.Create;
  Tel.Numero := '555-98723498' + IntToStr(Random(20));
  Tel.Tipo := inttostr(RandomFrom([0,1,2]));
  Result.Telefoni.Add(Tel);
end;

destructor TPersona.Destroy;
begin
  FTelefoni.Free;
  inherited;
end;

procedure TPersona.SetCognome(const Value: string);
begin
  FCognome := Value;
  NotifyObservers;
end;

procedure TPersona.SetEta(const Value: Integer);
begin
  FEta := Value;
  NotifyObservers;
end;

procedure TPersona.SetNome(const Value: string);
begin
  FNome := Value;
  NotifyObservers;
end;

procedure TPersona.SetSalario(const Value: Currency);
begin
  FSalario := Value;
end;

procedure TPersona.SetTelefoni(const Value: TTelefoni);
begin
  FTelefoni := Value;
end;

{ TTelefono }

procedure TTelefono.SetNumero(const Value: string);
begin
  FNumero := Value;
end;

procedure TTelefono.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

end.
