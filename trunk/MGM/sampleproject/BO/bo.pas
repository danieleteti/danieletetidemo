unit bo;

interface

uses
  MGM;

type
  TContatti = class;
  TContatto = class;

  TAutomobile = class(TSubject)
  private
    FAnnoImmatricolazione: Integer;
    FModello: string;
    FMarca: string;
    procedure SetAnnoImmatricolazione(const Value: Integer);
    procedure SetMarca(const Value: string);
    procedure SetModello(const Value: string);
  public
    constructor Create; reintroduce; overload;
    destructor Destroy; override;
    constructor Create(Marca, Modello: string; AnnoImmatricolazione: Integer); reintroduce; overload;
    property Marca: string read FMarca write SetMarca;
    property Modello: string read FModello write SetModello;
    property AnnoImmatricolazione: Integer read FAnnoImmatricolazione write SetAnnoImmatricolazione;
  end;

  TPersona = class(TSubject)
  private
    FIndirizzo: string;
    FNome: string;
    FTipo: string;
    FContatti: TContatti;
    FAutomobile: TAutomobile;
    procedure SetIndirizzo(const Value: string);
    procedure SetNome(const Value: string);
    procedure SetTipo(const Value: string);
    procedure SetContatti(const Value: TContatti);
    function GetContatti: TContatti;
    procedure SetAutomobile(const Value: TAutomobile);
  public
    constructor Create; override;
    destructor Destroy; override;
    property Nome: string read FNome write SetNome;
    property Indirizzo: string read FIndirizzo write SetIndirizzo;
    property Tipo: string read FTipo write SetTipo;
    property Automobile: TAutomobile read FAutomobile write SetAutomobile;
    property Contatti: TContatti read GetContatti write SetContatti;
  end;

  TPersone = class(TSubjectList<TPersona>)
  end;

  TContatto = class(TSubject)
  private
    FValore: string;
    FTipo: string;
    procedure SetTipo(const Value: string);
    procedure SetValore(const Value: string);
  public
    constructor Create; overload; override;
    constructor Create(Tipo, Valore: string); reintroduce; overload; virtual;
    property Tipo: string read FTipo write SetTipo;
    property Valore: string read FValore write SetValore;
  end;

  TContatti = class(TSubjectList<TContatto>)
    destructor Destroy; override;
  end;

  TData = class
  protected
    class var FInstance: TPersone;
    constructor Create;
    destructor Destroy; override;
    class destructor Destroy;
    class procedure FillPersone(Persone: TPersone);
  public
    class function GetInstance: TPersone;
  end;

implementation

uses
  sysutils;

{ TPersona }

constructor TPersona.Create;
begin
  inherited;
  FContatti := TContatti.Create;
  FAutomobile := TAutomobile.Create;
end;

destructor TPersona.Destroy;
begin
  FContatti.Free;
  FAutomobile.Free;
  inherited;
end;

function TPersona.GetContatti: TContatti;
begin
  Result := FContatti;
end;

procedure TPersona.SetAutomobile(const Value: TAutomobile);
begin
  FAutomobile := Value;
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

constructor TContatto.Create(Tipo, Valore: string);
begin
  inherited Create;
  Self.Tipo := Tipo;
  Self.Valore := Valore;
end;

constructor TContatto.Create;
begin
  inherited;

end;

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

class destructor TData.Destroy;
begin
  if assigned(TData.FInstance) then
    TData.FInstance.Free
end;

class procedure TData.FillPersone(Persone: TPersone);
var
  Persona: TPersona;
begin
  Persona := TPersona.Create;
  Persona.Nome := 'Daniele Teti';
  Persona.Indirizzo := 'Via Roma, 13';
  Persona.Tipo := 'Amico';
  Persona.Automobile.Marca := 'Ford';
  Persona.Automobile.Modello := 'Focus';
  Persona.Automobile.AnnoImmatricolazione := 2004;
  Persona.Contatti.Add(TContatto.Create('Casa','06-76458734'));
  Persona.Contatti.Add(TContatto.Create('Ufficio','06-4050600'));
  Persona.Contatti.Add(TContatto.Create('email','d.teti@bittime.it'));
  Persone.Add(Persona);

  Persona := TPersona.Create;
  Persona.Nome := 'Bruce Banner';
  Persona.Indirizzo := 'Via Firenze, 30';
  Persona.Tipo := 'Collega';
  Persona.Automobile.Marca := 'Lexus';
  Persona.Automobile.Modello := 'CT 200h';
  Persona.Automobile.AnnoImmatricolazione := 2010;
  Persona.Contatti.Add(TContatto.Create('Casa','02-7693489834'));
  Persona.Contatti.Add(TContatto.Create('Ufficio','02-42222200'));
  Persone.Add(Persona);

  Persona := TPersona.Create;
  Persona.Nome := 'Scott Summer';
  Persona.Indirizzo := 'Via Sempronio, 40';
  Persona.Tipo := 'Oculista';
  Persona.Automobile.Marca := 'Ferrari';
  Persona.Automobile.Modello := '360 Modena';
  Persona.Automobile.AnnoImmatricolazione := 2009;
  Persona.Contatti.Add(TContatto.Create('Casa','06-234234234'));
  Persona.Contatti.Add(TContatto.Create('Casa al mare','06-78839934'));
  Persona.Contatti.Add(TContatto.Create('Ufficio','06-443344433'));
  Persona.Contatti.Add(TContatto.Create('email','s.summer@bittime.it'));
  Persone.Add(Persona);
end;

class function TData.GetInstance: TPersone;
var
  I: Integer;
begin
  if not Assigned(FInstance) then
  begin
    FInstance := TPersone.Create;
    for I := 1 to 10 do
      FillPersone(FInstance);
  end;
  Result := FInstance;
end;

{ TAutomobile }

constructor TAutomobile.Create(Marca, Modello: string; AnnoImmatricolazione: Integer);
begin
  inherited Create;
  Self.Marca := Marca;
  Self.Modello := Modello;
  Self.AnnoImmatricolazione := AnnoImmatricolazione;
end;

destructor TAutomobile.Destroy;
begin

  inherited;
end;

constructor TAutomobile.Create;
begin
  inherited Create;
end;

procedure TAutomobile.SetAnnoImmatricolazione(const Value: Integer);
begin
  FAnnoImmatricolazione := Value;
end;

procedure TAutomobile.SetMarca(const Value: string);
begin
  FMarca := Value;
end;

procedure TAutomobile.SetModello(const Value: string);
begin
  FModello := Value;
end;

{ TContatti }

destructor TContatti.Destroy;
begin

  inherited;
end;

end.
