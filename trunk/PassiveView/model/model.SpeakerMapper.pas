unit model.SpeakerMapper;

interface

uses
  model.common;

type
  TSpeakerMapper = class(TInterfacedObject, ISpeakerMapper)
  public
    procedure Insert(ASpeaker: ISpeaker);
    procedure Update(ASpeaker: ISpeaker);
    procedure Delete(ASpeaker: ISpeaker); overload;
    procedure Delete(const GUID: string); overload;
    function GetByGUID(const GUID: string): ISpeaker;
    procedure DeleteAll;
    function Count: Cardinal;
  end;

implementation

uses
  model.persistence.factory, SQLiteTable3, model.guidcreator, SysUtils,
  model.Speaker;

{ TSpeakerMapper }

function TSpeakerMapper.Count: Cardinal;
begin
  Result := TDBFactory.Instance.GetTableValue('select count(*) from SPEAKERS');
end;

procedure TSpeakerMapper.Delete(ASpeaker: ISpeaker);
begin
  Delete(ASpeaker.GUID);
end;

procedure TSpeakerMapper.Delete(const GUID: string);
begin
  TDBFactory.Instance.ExecSQL(
    Format('DELETE FROM SPEAKERS WHERE GUID = ''%s''',
    [GUID])
    );
end;

procedure TSpeakerMapper.DeleteAll;
begin
  TDBFactory.Instance.ExecSQL('DELETE FROM SPEAKERS');
end;

function TSpeakerMapper.GetByGUID(const GUID: string): ISpeaker;
var
  tbl: TSQLiteTable;
begin
  tbl := TDBFactory.Instance.GetTable(
    Format('SELECT FIRST_NAME, LAST_NAME FROM SPEAKERS WHERE GUID = ''%s''',
    [GUID])
    );
  try
    if tbl.EOF then
    begin
      Result := nil;
    end
    else
    begin
      Result := TSpeaker.Create;
      Result.GUID := GUID;
      Result.FirstName := tbl.FieldByName['FIRST_NAME'];
      Result.LastName := tbl.FieldByName['LAST_NAME'];
    end;
  finally
    tbl.Free;
  end;
end;

procedure TSpeakerMapper.Insert(ASpeaker: ISpeaker);
begin
  ASpeaker.GUID := TGenerator.NewGUID;
  TDBFactory.Instance.ExecSQL(
    Format('INSERT INTO SPEAKERS (GUID, FIRST_NAME, LAST_NAME) VALUES (''%s'',''%s'',''%s'')',
    [ASpeaker.GUID, ASpeaker.FirstName, ASpeaker.LastName])
    );
end;

procedure TSpeakerMapper.Update(ASpeaker: ISpeaker);
begin
  TDBFactory.Instance.ExecSQL(
    Format('UPDATE SPEAKERS SET FIRST_NAME = ''%s'', LAST_NAME = ''%s'' where GUID = ''%s''',
    [ASpeaker.FirstName, ASpeaker.LastName, ASpeaker.GUID])
    );
end;

end.

