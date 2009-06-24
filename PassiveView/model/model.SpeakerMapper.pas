unit model.SpeakerMapper;

interface

uses
  model.common;

type
  TSpeakerMapper = class(TInterfacedObject, ISpeakerMapper)
  public
    procedure Insert(ASpeaker: ISpeaker);
    procedure Update(ASpeaker: ISpeaker);
    procedure Delete(ASpeaker: ISpeaker);
  end;

implementation

{ TSpeakerMapper }

procedure TSpeakerMapper.Delete(ASpeaker: ISpeaker);
begin

end;

procedure TSpeakerMapper.Insert(ASpeaker: ISpeaker);
begin

end;

procedure TSpeakerMapper.Update(ASpeaker: ISpeaker);
begin

end;

end.
