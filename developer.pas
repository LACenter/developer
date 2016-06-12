////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'res', 'globals', 'mainform';

procedure AppException(Sender: TObject; E: Exception);
begin
    MsgError('Uncaught Exception', E.Message);
end;

//unit constructor / application main entry point
constructor
begin
    Application.Initialize;
    Application.Icon.LoadFromResource('appicon');
    Application.Title := _APP_NAME+' '+_APP_VERSION;

    createMainForm;

    Application.Run;
end.
