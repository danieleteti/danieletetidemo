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
  rep: IRepository<TPersona>;
  Persona: TPersona;
  persone: TObjectList<TPersona>;

begin
  try
    rep := TPersonaRepository.Create(TRepositoryMemoryStrategyPersona.Create) as IRepository<TPersona>;
    Persona := rep.Get(5);
    Persona.Nome := 'Daniele Teti';
    rep.Save(Persona);

    persone := rep.GetAll;
    try
      rep.Remove(rep.Get(1));
      rep.Remove(rep.Get(2));
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
  Readln; ;

end.
