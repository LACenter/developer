////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author	 : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

procedure createStatusBar(form: TForm);
var
	pan: TStatusPanel;
begin
	statusbar := TStatusBar.Create(form);
	statusbar.Parent := form;
	statusbar.Name := 'Statusbar';
	statusbar.SimplePanel := false;
	
	pan := statusbar.Panels.Add;
	pan.Alignment := taLeftJustify;
	pan.Text := 'Project: None';
	pan.Width := 400;
	pan.Bevel := pbLowered;
	
	pan := statusbar.Panels.Add;
	pan.Alignment := taCenter;
	pan.Text := 'Line/Column: 0/0';
	pan.Width := 90;
	pan.Bevel := pbLowered;
	
	pan := statusbar.Panels.Add;
	pan.Alignment := taCenter;
	pan.Text := 'Compiler: Idle';
	pan.Width := 90;
	pan.Bevel := pbLowered;
end;

//unit constructor
constructor begin end.
