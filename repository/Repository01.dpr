program Repository01;
{$APPTYPE CONSOLE}

uses
  SysUtils,
  Repositories in 'Repositories.pas',
  BO in 'BO.pas',
  Generics.collections,
  MemoryStrategy in 'MemoryStrategy.pas',
  Strategies in 'Strategies.pas',
  func in '..\Functional\func.pas';

var
  rep: IPersonaRepository;
  Persona: TPersona;
  persone: TObjectList<TPersona>;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    rep := TPersonaRepository.Create(TRepositoryMemoryStrategyPersona.Create) as IPersonaRepository;
    Persona := rep.Get(5);
    Persona.Nome := 'Silvio Berlusconi';
    Persona.Eta := 15;
    rep.Save(Persona);

//    Questa logica è dentro il repository
    persone := rep.FindMaggiorenni;
    try
      WriteLn('Maggiorenni');
      Functional.Map<TPersona>(Persone,
        procedure (var item: TPersona)
        begin
          Writeln(item.ToString);
        end);
    finally
      persone.Free;
    end;

//    Questa logica NON è dentro il repository SBAGLIATO!!!
    persone := rep.FindUltraQuarantenni;
    try
      WriteLn('UltraQuarantenni');
      Functional.Map<TPersona>(Persone,
        procedure (var item: TPersona)
        begin
          Writeln(item.ToString);
        end);
    finally
      persone.Free;
    end;

    persone := rep.GetAll;
    try
      WriteLn('Tutto il repository');
      Functional.Map<TPersona>(Persone,
        procedure (var item: TPersona)
        begin
          Writeln(item.ToString);
        end);
    finally
      persone.Free;
    end;

    rep.Remove(rep.Get(1));
    persone := rep.GetAll;
    try
      WriteLn('Dopo la cancellazione');
      Functional.Map<TPersona>(Persone,
        procedure (var item: TPersona)
        begin
          Writeln(item.ToString);
        end);
    finally
      Persone.Free;
    end;

    rep.Remove(rep.Get(2));
    persone := rep.GetAll;
    try
      WriteLn('Dopo l''altra cancellazione');
      Functional.Map<TPersona>(Persone,
        procedure (var item: TPersona)
        begin
          Writeln(item.ToString);
        end);
    finally
      persone.Free;
    end;

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.message);
  end;
  Readln;
end.
