////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createEnvDesigner(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @envdesigner_OnCreate);
end;

procedure envdesigner_OnCreate(Sender: TFrame);
var
    color: TColorButton;
    lab: TLabel;
    calc: TCalcEdit;
    chk: TCheckBox;
    scroll: TScrollBox;
begin
    Sender.Color := clWindow;

    scroll := TScrollBox.Create(Sender);
    scroll.Parent :=  Sender;
    scroll.Align := alClient;
    scroll.BorderStyle := bsNone;
    scroll.Color := clWindow;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Selector Color:';
    lab.Left := 10;
    lab.Top := 10;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 10;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-SelectorColor']);
    color.Hint := 'designer-SelectorColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Selector Border Color:';
    lab.Left := 10;
    lab.Top := 40;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 40;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-SelectorBorderColor']);
    color.Hint := 'designer-SelectorBorderColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Grid Color:';
    lab.Left := 10;
    lab.Top := 70;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 70;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-GridColor']);
    color.Hint := 'designer-GridColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Margin Color:';
    lab.Left := 10;
    lab.Top := 100;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 100;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-MarginColor']);
    color.Hint := 'designer-MarginColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Split Color:';
    lab.Left := 10;
    lab.Top := 130;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 130;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-SplitColor']);
    color.Hint := 'designer-SplitColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Locked Color:';
    lab.Left := 10;
    lab.Top := 160;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 160;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-LockedColor']);
    color.Hint := 'designer-LockedColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Object Properties Color:';
    lab.Left := 10;
    lab.Top := 190;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 190;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-PropertiesColor']);
    color.Hint := 'designer-PropertiesColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Dark Contrast Color:';
    lab.Left := 10;
    lab.Top := 220;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 220;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-DarkContrastColor']);
    color.Hint := 'designer-DarkContrastColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Half Space Margin Color:';
    lab.Left := 10;
    lab.Top := 250;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 250;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-HalfSpaceMarginColor']);
    color.Hint := 'designer-HalfSpaceMarginColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Full Space Margin Color:';
    lab.Left := 10;
    lab.Top := 280;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 280;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-FullSpaceMarginColor']);
    color.Hint := 'designer-FullSpaceMarginColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Left Guide Line Color:';
    lab.Left := 10;
    lab.Top := 310;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 310;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-GuideLineColorLeft']);
    color.Hint := 'designer-GuideLineColorLeft';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Top Guide Line Color:';
    lab.Left := 10;
    lab.Top := 340;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 340;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-GuideLineColorTop']);
    color.Hint := 'designer-GuideLineColorTop';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Right Guide Line Color:';
    lab.Left := 10;
    lab.Top := 370;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 370;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-GuideLineColorRight']);
    color.Hint := 'designer-GuideLineColorRight';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Bottom Guide Line Color:';
    lab.Left := 10;
    lab.Top := 400;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 400;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-GuideLineColorBottom']);
    color.Hint := 'designer-GuideLineColorBottom';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Handle Color:';
    lab.Left := 10;
    lab.Top := 430;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 430;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['designer-HandleColor']);
    color.Hint := 'designer-HandleColor';
    lab.Height := color.Height;
    color.OnColorChanged := @envdesigner_OnColorChange;


    /////////////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Grid Size:';
    lab.Left := 10;
    lab.Top := 470;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 470;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-GridSize'], 0);
    calc.Hint := 'designer-GridSize';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Split Count:';
    lab.Left := 10;
    lab.Top := 505;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 505;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-Split'], 0);
    calc.Hint := 'designer-Split';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Grid Line X Size:';
    lab.Left := 10;
    lab.Top := 540;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 540;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-GridXLineSize'], 0);
    calc.Hint := 'designer-GridXLineSize';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Grid Line Y Size:';
    lab.Left := 10;
    lab.Top := 575;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 575;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-GridYLineSize'], 0);
    calc.Hint := 'designer-GridYLineSize';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Left Margin:';
    lab.Left := 10;
    lab.Top := 610;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 610;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-MarginLeft'], 0);
    calc.Hint := 'designer-MarginLeft';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Top Margin:';
    lab.Left := 10;
    lab.Top := 645;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 645;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-MarginTop'], 0);
    calc.Hint := 'designer-MarginTop';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Right Margin:';
    lab.Left := 10;
    lab.Top := 680;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 680;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-MarginRight'], 0);
    calc.Hint := 'designer-MarginRight';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Bottom Margin:';
    lab.Left := 10;
    lab.Top := 715;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 715;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-MarginBottom'], 0);
    calc.Hint := 'designer-MarginBottom';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Designer Handle Size:';
    lab.Left := 10;
    lab.Top := 750;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 750;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['designer-HandleSize'], 0);
    calc.Hint := 'designer-HandleSize';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @envdesigner_OnCalcChange;


    //////////



    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 790;
    chk.Width := 190;
    chk.Caption := 'Allow Half Step Move/Size';
    chk.Checked := (appSettings.Values['designer-AllowHalfStep'] = '1');
    chk.Hint := 'designer-AllowHalfStep';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 790;
    chk.Width := 190;
    chk.Caption := 'Enable Dark Contrast Color';
    chk.Checked := (appSettings.Values['designer-ApplyDarkContrastColor'] = '1');
    chk.Hint := 'designer-ApplyDarkContrastColor';
    chk.OnChange := @envdesigner_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 820;
    chk.Width := 190;
    chk.Caption := 'Show Drop Marker';
    chk.Checked := (appSettings.Values['designer-ShowDropMarker'] = '1');
    chk.Hint := 'designer-ShowDropMarker';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 820;
    chk.Width := 190;
    chk.Caption := 'Show Grid';
    chk.Checked := (appSettings.Values['designer-ShowGrid'] = '1');
    chk.Hint := 'designer-ShowGrid';
    chk.OnChange := @envdesigner_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 850;
    chk.Width := 190;
    chk.Caption := 'Show Component Hints';
    chk.Checked := (appSettings.Values['designer-ShowComponentHint'] = '1');
    chk.Hint := 'designer-ShowComponentHint';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 850;
    chk.Width := 190;
    chk.Caption := 'Snap to Grid';
    chk.Checked := (appSettings.Values['designer-SnapToGrid'] = '1');
    chk.Hint := 'designer-SnapToGrid';
    chk.OnChange := @envdesigner_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 880;
    chk.Width := 190;
    chk.Caption := 'Show Grid Lines';
    chk.Checked := (appSettings.Values['designer-ShowGridLines'] = '1');
    chk.Hint := 'designer-ShowGridLines';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 880;
    chk.Width := 190;
    chk.Caption := 'Show Designer Margins';
    chk.Checked := (appSettings.Values['designer-ShowMargin'] = '1');
    chk.Hint := 'designer-ShowMargin';
    chk.OnChange := @envdesigner_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 910;
    chk.Width := 190;
    chk.Caption := 'Show Designer Splits';
    chk.Checked := (appSettings.Values['designer-ShowSplits'] = '1');
    chk.Hint := 'designer-ShowSplits';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 910;
    chk.Width := 190;
    chk.Caption := 'Show Space Guides';
    chk.Checked := (appSettings.Values['designer-ShowSpaceGuide'] = '1');
    chk.Hint := 'designer-ShowSpaceGuide';
    chk.OnChange := @envdesigner_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 940;
    chk.Width := 140;
    chk.Caption := 'Show Designer Guide Lines';
    chk.Checked := (appSettings.Values['designer-ShowGuideLines'] = '1');
    chk.Hint := 'designer-ShowGuideLines';
    chk.OnChange := @envdesigner_OnCheckChange;
end;

procedure envdesigner_OnColorChange(Sender: TColorButton);
begin
    appSettings.Values[Sender.Hint] := ColorToString(Sender.ButtonColor);
end;

procedure envdesigner_OnCalcChange(Sender: TCalcEdit);
begin
    appSettings.Values[Sender.Hint] := IntToStr(Sender.asInteger);
end;

procedure envdesigner_OnCheckChange(Sender: TCheckBox);
begin
    if Sender.Checked then
    appSettings.Values[Sender.Hint] := '1'
    else
    appSettings.Values[Sender.Hint] := '0';
end;

//unit constructor
constructor begin end.
