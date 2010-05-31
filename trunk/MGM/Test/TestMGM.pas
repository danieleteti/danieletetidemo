unit TestMGM;

interface

uses
  TestFramework,
  Generics.Collections,
  MGM,
  RTTI, bo;

type
  // Test methods for class TSubject

  TestTSubject = class(TTestCase)
  private
    function BuildPersona: TPersona;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure TestCloneSimple;
    procedure TestCloneComplex;
    procedure TestCloneAndBack;
  end;

implementation

function TestTSubject.BuildPersona: TPersona;
begin
  Result := TPersona.Create;
  Result.Nome := 'Daniele';
  Result.Indirizzo := 'Via Roma';
  Result.Tipo := 'Amico';
  Result.Contatti.Add(TContatto.Create('Casa', '555-555-555'));
  Result.Contatti.Add(TContatto.Create('Ufficio', '0698989845'));
  Result.Contatti.Add(TContatto.Create('email', 'd.teti@bittime.it'));
  Result.Automobile.Marca := 'Ford';
  Result.Automobile.Modello := 'Focus';
  Result.Automobile.AnnoImmatricolazione := 2004;
end;

procedure TestTSubject.SetUp;
begin
end;

procedure TestTSubject.TearDown;
begin
end;

procedure TestTSubject.TestCloneAndBack;
var
  P: TPersona;
  P1: TPersona;
  P2: TPersona;
  item: TContatto;
  I: Integer;
begin
  P := BuildPersona;
  P1 := BuildPersona;
  P2 := BuildPersona;
  P.CopyTo(P1);
  P1.CopyTo(P2);

  CheckEquals(P.Nome, P2.Nome);
  CheckEquals(P.Indirizzo, P2.Indirizzo);
  CheckEquals(P.Tipo, P2.Tipo);

  CheckEquals(P.Automobile.Marca, P2.Automobile.Marca);
  CheckEquals(P.Automobile.Modello, P2.Automobile.Modello);
  CheckEquals(P.Automobile.AnnoImmatricolazione, P2.Automobile.AnnoImmatricolazione);

  CheckEquals(P.Contatti.Count, P2.Contatti.Count);
  for I:= 0 to P.Contatti.Count - 1 do
  begin
    CheckEquals(P.Contatti[I].Tipo, P2.Contatti[I].Tipo);
    CheckEquals(P.Contatti[I].Valore, P2.Contatti[I].Valore);
  end;
end;

procedure TestTSubject.TestCloneComplex;
var
  P, P1: TPersona;
begin
  P := BuildPersona;

  P1 := TPersona.Create;
  P.CopyTo(P1);

  CheckEquals(P.Nome, P1.Nome);
  CheckEquals(P.Indirizzo, P1.Indirizzo);
  CheckEquals(P.Tipo, P1.Tipo);

  CheckEquals(P.Automobile.Marca, P1.Automobile.Marca);
  CheckEquals(P.Automobile.Modello, P1.Automobile.Modello);
  CheckEquals(P.Automobile.AnnoImmatricolazione, P1.Automobile.AnnoImmatricolazione);

  CheckEquals(P.Contatti.Count, P1.Contatti.Count);
  CheckEquals('Casa', P1.Contatti[0].Tipo);
  CheckEquals('555-555-555', P1.Contatti[0].Valore);
  CheckEquals('Ufficio', P1.Contatti[1].Tipo);
  CheckEquals('0698989845', P1.Contatti[1].Valore);
  CheckEquals('email', P1.Contatti[2].Tipo);
  CheckEquals('d.teti@bittime.it', P1.Contatti[2].Valore);
end;

procedure TestTSubject.TestCloneSimple;
var
  P, P1: TPersona;
begin
  P := TPersona.Create;
  P.Nome := 'Daniele';
  P.Indirizzo := 'Via Roma';
  P.Tipo := 'Amico';

  P1 := TPersona.Create;
  P.CopyTo(P1);
  CheckEquals(P.Contatti.Count, P1.Contatti.Count);
  CheckEquals(P.Nome, P1.Nome);
  CheckEquals(P.Indirizzo, P1.Indirizzo);
  CheckEquals(P.Tipo, P1.Tipo);
end;

initialization

// Register any test cases with the test runner
RegisterTest(TestTSubject.Suite);

end.
