{*******************************************************}
{                                                       }
{           ZeroMQ adapter for Embarcadero Delphi       }
{                                                       }
{           Copyright (c) 2009-2009 Daniele Teti        }
{                                                       }
{                                                       }
{           WebSite: www.danieleteti.it                 }
{           email:d.teti@bittime.it                     }
{           VERSION: 1.0                                }
{*******************************************************}
// $Author$
// $Date$
// $Id$
// $Revision$


unit ZMQ;

interface

uses
  Windows;

type
  UINT32_T = Cardinal;
  INT64_T = int64;
  UINT64_T = int64;

const
  ZMQ_SCOPE_LOCAL = 1;
const
  ZMQ_SCOPE_PROCESS = 2;
const
  ZMQ_SCOPE_GLOBAL = 3;

const
  ZMQ_MESSAGE_DATA = 1;
const
  ZMQ_MESSAGE_GAP = 2;

const
  ZMQ_STYLE_DATA_DISTRIBUTION = 1;
const
  ZMQ_STYLE_LOAD_BALANCING = 2;

const
  ZMQ_NO_LIMIT = -1;
const
  ZMQ_NO_SWAP = 0;

const
  ZMQ_TRUE = 1;
const
  ZMQ_FALSE = 0;

var
  zmq_create: function(const host_: PAnsiChar): Pointer; cdecl;

var
  zmq_destroy: procedure(object_: Pointer) ;cdecl;

var
  zmq_mask: procedure(object_: Pointer; 
                      notifications_: UINT32_T) ;cdecl;

var
  zmq_create_exchange: function(object_: Pointer;
                                const name_: PAnsiChar;
                                scope_: Integer; 
                                const location_: PAnsiChar;
                                style_: Integer): Integer ;cdecl;

var
  zmq_create_queue: function(object_: Pointer; 
                             const name_: PAnsiChar;
                             scope_: Integer; 
                             const location_: PAnsiChar;
                             hwm_: INT64_T;
                             lwm_: INT64_T; 
                             swap_: INT64_T): Integer ;cdecl;

var
  zmq_bind: procedure(object_: Pointer; 
                      const exchange_name_: PAnsiChar;
                      const queue_name_: PAnsiChar;
                      const exchange_options_: PAnsiChar;
                      const queue_options_: PAnsiChar) ;cdecl;

var
  zmq_send: function(object_: Pointer; 
                     exchange_: Integer;
                     const data_: Pointer;
                     size_: UINT64_T;
                     block_: Integer): Integer ;cdecl;

var
  zmq_receive: function(object_: Pointer; 
                        var data_: PAnsiChar;
                        var size_: UINT64_T; 
                        var type_: UINT32_T; 
                        block_: Integer): Integer ;cdecl;

var
  zmq_free: procedure(data_: Pointer) ;cdecl;

{$IFDEF __cplusplus}
{$ENDIF}

var
  DLLLoaded: Boolean { is DLL (dynamically) loaded already? }
    {$IFDEF WIN32} = False; {$ENDIF}

implementation

var
  SaveExit: pointer;
  DLLHandle: THandle;
{$IFNDEF MSDOS}
  ErrorMode: Integer;
{$ENDIF}

  procedure NewExit;
  begin
    ExitProc := SaveExit;
    FreeLibrary(DLLHandle)
  end {NewExit};

procedure LoadDLL;
begin
  if DLLLoaded then Exit;
{$IFNDEF MSDOS}
  ErrorMode := SetErrorMode($8000{SEM_NoOpenFileErrorBox});
{$ENDIF}
  DLLHandle := LoadLibrary('libczmq.DLL');
  if DLLHandle >= 32 then
  begin
    DLLLoaded := True;
    SaveExit := ExitProc;
    ExitProc := @NewExit;
    @zmq_create := GetProcAddress(DLLHandle,'zmq_create');
  {$IFDEF WIN32}
    Assert(@zmq_create <> nil);
  {$ENDIF}
    @zmq_destroy := GetProcAddress(DLLHandle,'zmq_destroy');
  {$IFDEF WIN32}
    Assert(@zmq_destroy <> nil);
  {$ENDIF}
    @zmq_mask := GetProcAddress(DLLHandle,'zmq_mask');
  {$IFDEF WIN32}
    Assert(@zmq_mask <> nil);
  {$ENDIF}
    @zmq_create_exchange := GetProcAddress(DLLHandle,'zmq_create_exchange');
  {$IFDEF WIN32}
    Assert(@zmq_create_exchange <> nil);
  {$ENDIF}
    @zmq_create_queue := GetProcAddress(DLLHandle,'zmq_create_queue');
  {$IFDEF WIN32}
    Assert(@zmq_create_queue <> nil);
  {$ENDIF}
    @zmq_bind := GetProcAddress(DLLHandle,'zmq_bind');
  {$IFDEF WIN32}
    Assert(@zmq_bind <> nil);
  {$ENDIF}
    @zmq_send := GetProcAddress(DLLHandle,'zmq_send');
  {$IFDEF WIN32}
    Assert(@zmq_send <> nil);
  {$ENDIF}
    @zmq_receive := GetProcAddress(DLLHandle,'zmq_receive');
  {$IFDEF WIN32}
    Assert(@zmq_receive <> nil);
  {$ENDIF}
    @zmq_free := GetProcAddress(DLLHandle,'zmq_free');
  {$IFDEF WIN32}
    Assert(@zmq_free <> nil);
  {$ENDIF}
  end
  else
  begin
    DLLLoaded := False;
    { Error: ZMQ.DLL could not be loaded !! }
  end;
{$IFNDEF MSDOS}
  SetErrorMode(ErrorMode)
{$ENDIF}
end {LoadDLL};

begin
  LoadDLL;
end.
