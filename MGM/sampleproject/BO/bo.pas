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
    FModello: String;
    FMarca: String;
    procedure SetAnnoImmatricolazione(const Value: Integer);
    procedure SetMarca(const Value: String);
    procedure SetModello(const Value: String);
  public
    constructor Create; overload;
    constructor Create(Marca, Modello: String; AnnoImmatricolazione: Integer); overload;
    property Marca: String read FMarca write SetMarca;
    property Modello: String read FModello write SetModello;
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
    constructor Create(Tipo, Valore: String); overload; virtual;
    property Tipo: string read FTipo write SetTipo;
    property Valore: string read FValore write SetValore;
  end;

  TContatti = class(TSubjectList<TContatto>)
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
  FContatti := TContatti.Create;
  FAutomobile := TAutomobile.Create;
  Nome := '<insert your name>';
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

constructor TContatto.Create(Tipo, Valore: String);
begin
  inherited create;
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

constructor TAutomobile.Create(Marca, Modello: String;
  AnnoImmatricolazione: Integer);
begin
  inherited Create;
  Self.Marca := Marca;
  Self.Modello := Modello;
  Self.AnnoImmatricolazione := AnnoImmatricolazione;
end;

constructor TAutomobile.Create;
begin
  inherited Create;
end;

procedure TAutomobile.SetAnnoImmatricolazione(const Value: Integer);
begin
  FAnnoImmatricolazione := Value;
end;

procedure TAutomobile.SetMarca(const Value: String);
begin
  FMarca := Value;
end;

procedure TAutomobile.SetModello(const Value: String);
begin
  FModello := Value;
end;

end.
