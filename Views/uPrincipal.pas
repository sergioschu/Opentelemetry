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
    procedure pLog(const aType: scs_log_type_t; const aMessage: scs_string_t);
    { Public declarations }
  end;

var
  Form1: TForm1;

const
  CPP_CLASS_LIB = 'Telemetry.dll';

  function scs_telemetry_init(version: scs_u32_t; params: p_scs_telemetry_init_params_t): scs_result_t;  stdcall; external CPP_CLASS_LIB;
  procedure scs_telemetry_shutdown stdcall; external CPP_CLASS_LIB;

implementation

{$R *.dfm}

procedure TForm1.btFinishClick(Sender: TObject);
begin
  scs_telemetry_shutdown;
end;

procedure TForm1.btInitClick(Sender: TObject);
var
  ret : scs_s32_t;
  yy : scs_string_t;
  texto : UTF8Char;
  common: scs_sdk_init_params_v100_t;
  initParams : p_scs_telemetry_init_params_t;
begin
  texto := UTF8Char('a');

  common.game_name := @texto;
  common.game_id := AnsiChar(10);
  common.game_version := 0;
  //common.log := pLog;

  initParams.common:= common;

  ret := scs_telemetry_init(65536, initParams);
  try

    ShowMessage(ret.ToString);
  finally
  end;
end;

procedure TForm1.pLog(const aType: scs_log_type_t; const aMessage: scs_string_t);
begin
  //
end;

end.
