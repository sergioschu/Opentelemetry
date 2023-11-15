unit uPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, SCS_Telemetry_Condensed;

type
  TForm1 = class(TForm)
    btInit: TButton;
    btFinish: TButton;
    procedure btInitClick(Sender: TObject);
    procedure btFinishClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  initParams : scs_telemetry_init_params_v100_t;

const
  CPP_CLASS_LIB = 'Telemetry.dll';

  function scs_telemetry_init(version: scs_u32_t; params: p_scs_telemetry_init_params_t): scs_result_t;  stdcall; external CPP_CLASS_LIB;
  procedure scs_telemetry_shutdown stdcall; external CPP_CLASS_LIB;

implementation

{$R *.dfm}

procedure log(const aType: scs_log_type_t; const aMessage: scs_string_t); stdcall;
begin
  ShowMessage(AnsiString(aMessage));
end;

procedure eventCallback(event: scs_event_t; event_info: Pointer; context: scs_context_t); stdcall;
begin
  event := event;
end;

procedure channelCallback(name: scs_string_t; index: scs_u32_t; value: p_scs_value_t; context: scs_context_t); stdcall;
begin

end;

Function register_for_event(event: scs_event_t; callback: scs_telemetry_event_callback_t; context: scs_context_t): scs_result_t; stdcall;
begin
  callback := eventCallback;
  Result := SCS_RESULT_ok;
end;

Function unregister_from_event(event: scs_event_t): scs_result_t; stdcall;
begin
  event := event;
  Result := SCS_RESULT_ok;
end;

Function register_for_channel(name: scs_string_t; index: scs_u32_t; _type: scs_value_type_t; flags: scs_u32_t; callback: scs_telemetry_channel_callback_t; context: scs_context_t): scs_result_t; stdcall;
begin
  name := name;
  callback := channelCallback;
  Result := SCS_RESULT_ok;
end;

Function unregister_from_channel(name: scs_string_t; index: scs_u32_t; _type: scs_value_type_t): scs_result_t; stdcall;
begin
  name := name;
  Result := SCS_RESULT_ok;
end;

procedure TForm1.btFinishClick(Sender: TObject);
begin
  scs_telemetry_shutdown;
end;

procedure TForm1.btInitClick(Sender: TObject);
var
  ret : scs_s32_t;
  gameName : AnsiString;
  common: scs_sdk_init_params_v100_t;
  gameID : AnsiString;
begin

  gameName := AnsiString('Game Name');
  gameID := AnsiString(SCS_GAME_ID_EUT2);

  common.game_name := scs_string_t(gameName);
  common.game_id := scs_string_t(gameID);
  common.game_version := 65536;
  common.log := log;

  initParams.register_for_event := @register_for_event;
  initParams.unregister_from_event := unregister_from_event;
  initParams.register_for_channel := @register_for_channel;
  initParams.unregister_from_channel := unregister_from_channel;

  initParams.common := common;

  ret := scs_telemetry_init(65536, @initParams);
  try
    ShowMessage(ret.ToString);
  finally
  end;
end;

end.
