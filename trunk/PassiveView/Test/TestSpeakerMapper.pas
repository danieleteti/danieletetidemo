unit TestSpeakerMapper;
{

  Delphi DUnit Test Case
  ----------------------
  This unit contains a skeleton test case class generated by the Test Case Wizard.
  Modify the generated code to correctly setup and call the methods from the unit
  being tested.

}

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
  published
    procedure TestInsert;
    procedure TestUpdate;
    procedure TestDelete;
  end;

implementation

uses
  model.Speaker;

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

procedure TestTSpeakerMapper.TestUpdate;
var
  ASpeaker: ISpeaker;
  sp2: ISpeaker;
begin
  ASpeaker := TSpeaker.Create;
  ASpeaker.FirstName := 'Daniele';
  ASpeaker.LastName := 'Teti';
  FSpeakerMapper.Insert(ASpeaker);
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
  // TODO: Setup method call parameters
  FSpeakerMapper.Delete(ASpeaker);
  // TODO: Validate method results
end;

initialization
  // Register any test cases with the test runner
  RegisterTest(TestTSpeakerMapper.Suite);
end.

