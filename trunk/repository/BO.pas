unit BO;

interface

type
  TIDObject = class
  private
    FID: Int64;
  public
    property ID: Int64 read FID write FID;
  end;


  TPersona = class(TIDObject)
  private
    FEta: Integer;
    FNome: String;
    procedure SetEta(const Value: Integer);
    procedure SetNome(const Value: String);
  public
    class function CreateNew(id: Int64; Nome: String; Eta: Integer): TPersona;
    function ToString: String; override;
    property Nome: String read FNome write SetNome;
    property Eta: Integer read FEta write SetEta;
  end;

  TTelefono = class(TIDObject)
  private
    FValore: String;
    FTipo: String;
    procedure SetTipo(const Value: String);
    procedure SetValore(const Value: String);
  public
    property Valore: String read FValore write SetValore;
    property Tipo: String read FTipo write SetTipo;
  end;

implementation

uses
  SysUtils;

{ TTelefono }

procedure TTelefono.SetTipo(const Value: String);
begin
  FTipo := Value;
end;

procedure TTelefono.SetValore(const Value: String);
begin
  FValore := Value;
end;

{ TPersona }

class function TPersona.CreateNew(id: Int64; Nome: String; Eta: Integer): TPersona;
begin
  Result := TPersona.Create;
  Result.ID := id;
  Result.Nome := Nome;
  Result.Eta := Eta;
end;

procedure TPersona.SetEta(const Value: Integer);
begin
  FEta := Value;
end;

procedure TPersona.SetNome(const Value: String);
begin
  FNome := Value;
end;

function TPersona.ToString: String;
begin
  Result := IntToStr(ID) + ': ' + Nome + ', ' + IntToStr(Eta);
end;

end.
