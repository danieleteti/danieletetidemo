unit view.common;

interface

uses
  model.common;

type
  IGridAdapter = interface;

  IMainView = interface
    ['{3AE0E135-0162-4F51-84BA-09F0B9665C04}']
    procedure SetFirstName(const Value: String);
    procedure SetLastName(const Value: String);
    function GetFirstName: String;
    function GetLastName: String;
    procedure SetGUID(const Value: String);
    function GetGrid: IGridAdapter;
  end;


  IGridAdapter = interface
    ['{A4D7E03D-1BCF-481D-B3D0-08458DD8E756}']
    procedure BeginUpdate;
    procedure EndUpdate;
    procedure ClearHeader;
    procedure ClearRow;
    procedure AddObject(ASpeaker: ISpeaker);
    procedure AddHeader(ACaption: String; AWidth: Cardinal = 100);
    function SelectedSpeaker: ISpeaker;
  end;

implementation

end.
