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

procedure Main;
var
  LPeopleRepos: IPersonaRepository;
  Persona: TPersona;
  persone: TObjectList<TPersona>;
begin
  LPeopleRepos := TPersonaRepository.Create(TRepositoryMemoryStrategyPersona.Create)
    as IPersonaRepository;
  Persona := LPeopleRepos.Get(5);
  Persona.Nome := 'Daniele Teti';
  Persona.Eta := 35;
  LPeopleRepos.Save(Persona);

  // Questa logica è dentro il repository
  persone := LPeopleRepos.FindMaggiorenni;
  try
    WriteLn('Maggiorenni');
    Functional.Map<TPersona>(persone,
      procedure(var item: TPersona)
      begin
        WriteLn(item.ToString);
      end);
  finally
    persone.Free;
  end;

  // Questa logica NON è dentro il repository SBAGLIATO!!!
  persone := LPeopleRepos.FindUltraQuarantenni;
  try
    WriteLn('UltraQuarantenni');
    Functional.Map<TPersona>(persone,
      procedure(var item: TPersona)
      begin
        WriteLn(item.ToString);
      end);
  finally
    persone.Free;
  end;

  persone := LPeopleRepos.GetAll;
  try
    WriteLn('Tutto il repository');
    Functional.Map<TPersona>(persone,
      procedure(var item: TPersona)
      begin
        WriteLn(item.ToString);
      end);
  finally
    persone.Free;
  end;

  LPeopleRepos.Remove(LPeopleRepos.Get(1));
  persone := LPeopleRepos.GetAll;
  try
    WriteLn('Dopo la cancellazione');
    Functional.Map<TPersona>(persone,
      procedure(var item: TPersona)
      begin
        WriteLn(item.ToString);
      end);
  finally
    persone.Free;
  end;

  LPeopleRepos.Remove(LPeopleRepos.Get(2));
  persone := LPeopleRepos.GetAll;
  try
    WriteLn('Dopo l''altra cancellazione');
    Functional.Map<TPersona>(persone,
      procedure(var item: TPersona)
      begin
        WriteLn(item.ToString);
      end);
  finally
    persone.Free;
  end;
end;

begin
  ReportMemoryLeaksOnShutdown := True;

  try
    Main;
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.message);
  end;
  Readln;

end.
