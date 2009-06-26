unit TestSpeakerMapper;

interface

uses
  TestFramework, model.common, model.SpeakerMapper;

type
  // Test methods for class TSpeakerMapper

  TestTSpeakerMapper = class(TTestCase)
  strict private
    FSpeakerMapper: ISpeakerMapper;
  public
    procedure SetUp; override;
    procedure TearDown; override;
    function CreateSpeaker: ISpeaker;
  published
    procedure TestInsert;
    procedure TestUpdate;
    procedure TestDelete;
    procedure TestLoadAll;
  end;

implementation

uses
  model.Speaker, Classes;

function TestTSpeakerMapper.CreateSpeaker: ISpeaker;
begin
  Result := TSpeaker.Create;
  Result.FirstName := 'Daniele';
  Result.LastName := 'Teti';
  FSpeakerMapper.Insert(Result);
end;

procedure TestTSpeakerMapper.SetUp;
begin
  FSpeakerMapper := TSpeakerMapper.Create;
  FSpeakerMapper.DeleteAll;
end;

procedure TestTSpeakerMapper.TearDown;
begin
  FSpeakerMapper := nil;
end;

procedure TestTSpeakerMapper.TestInsert;
var
  ASpeaker: ISpeaker;
  sp2: ISpeaker;
begin
  ASpeaker := TSpeaker.Create;
  CheckTrue(ASpeaker.GUID = '');
  ASpeaker.FirstName := 'Daniele';
  ASpeaker.LastName := 'Teti';
  FSpeakerMapper.Insert(ASpeaker);
  CheckTrue(ASpeaker.GUID <> '');
  sp2 := FSpeakerMapper.GetByGUID(ASpeaker.GUID);
  CheckTrue(sp2 <> nil);
  CheckEquals('Daniele', sp2.FirstName);
  CheckEquals('Teti', sp2.LastName);     
end;

procedure TestTSpeakerMapper.TestLoadAll;
var
  intf: IInterfaceList;
  spk: TObject;
begin
  CreateSpeaker;
  CreateSpeaker;
  CreateSpeaker;
  CreateSpeaker;
  intf := FSpeakerMapper.LoadAll;
  CheckEquals(4,intf.Count);
end;

procedure TestTSpeakerMapper.TestUpdate;
var
  Sp2, ASpeaker: ISpeaker;
begin
  ASpeaker := CreateSpeaker;
  CheckTrue(ASpeaker.GUID <> '');
  ASpeaker.FirstName := 'Peter';
  ASpeaker.LastName := 'Parker';
  FSpeakerMapper.Update(ASpeaker);
  sp2 := FSpeakerMapper.GetByGUID(ASpeaker.GUID);
  CheckEquals('Peter', sp2.FirstName);
  CheckEquals('Parker', sp2.LastName);
end;

procedure TestTSpeakerMapper.TestDelete;
var
  ASpeaker: ISpeaker;
begin
  ASpeaker := CreateSpeaker;
  FSpeakerMapper.Delete(ASpeaker);
  CheckNull(FSpeakerMapper.GetByGUID(ASpeaker.GUID));
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTSpeakerMapper.Suite);
end.

