unit bo;

interface

uses
  MGM;

type
  TContatti = class;
  TContatto = class;
  TPersona = class;

  TPersone = class(TSubjectList<TPersona>)
  end;

  TPersona = class(TSubject)
  private
    FIndirizzo: string;
    FNome: string;
    FTipo: string;
    FContatti: TContatti;
    procedure SetIndirizzo(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetTipo(const Value: string);
    procedure SetContatti(const Value: TContatti);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Nome: string read FNome write SetNome;
    property Indirizzo: string read FIndirizzo write SetIndirizzo;
    property Tipo: string read FTipo write SetTipo;
    property Contatti: TContatti read FContatti write SetContatti;
  end;

  TContatti = class(TSubjectList<TContatto>)
  end;

  TContatto = class(TSubject)
  private
    FValore: string;
    FTipo: string;
    procedure SetTipo(const Value: string);
    procedure SetValore(const Value: string);
  public
    property Tipo: string read FTipo write SetTipo;
    property Valore: string read FValore write SetValore;
  end;

  TData = class
  protected
    class var FInstance: TPersone;
    constructor Create;
    destructor Destroy; override;
    class procedure FillPersone(Persone: TPersone);
  public
    class function GetInstance: TPersone;
  end;

implementation

{ TPersona }

constructor TPersona.Create;
begin
  inherited;
  Nome := '<insert your name>';
end;

destructor TPersona.Destroy;
begin

  inherited;
end;

procedure TPersona.SetContatti(const Value: TContatti);
begin
  FContatti := Value;
end;

procedure TPersona.SetIndirizzo(const Value: string);
begin
  FIndirizzo := Value;
end;

procedure TPersona.SetNome(const Value: string);
begin
  FNome := Value;
end;

procedure TPersona.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

{ TContatto }

procedure TContatto.SetTipo(const Value: string);
begin
  FTipo := Value;
end;

procedure TContatto.SetValore(const Value: string);
begin
  FValore := Value;
end;

{ TData }

constructor TData.Create;
begin
  inherited;
end;

destructor TData.Destroy;
begin
  inherited;
end;

class procedure TData.FillPersone(Persone: TPersone);
var
  Persona: TPersona;
begin
  Persona := TPersona.Create;
  Persona.Nome := 'Daniele Teti';
  Persona.Indirizzo := 'Via Roma, 13';
  Persona.Tipo := 'Amico';
  Persone.Add(Persona);

  Persona := TPersona.Create;
  Persona.Nome := 'Bruce Banner';
  Persona.Indirizzo := 'Via Firenze, 30';
  Persona.Tipo := 'Collega';
  Persone.Add(Persona);

  Persona := TPersona.Create;
  Persona.Nome := 'Scott Summer';
  Persona.Indirizzo := 'Via Sempronio, 40';
  Persona.Tipo := 'Oculista';
  Persone.Add(Persona);
end;

class function TData.GetInstance: TPersone;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TPersone.Create;
    FillPersone(FInstance);
  end;
  Result := FInstance;
end;

end.
