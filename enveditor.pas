////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createEnvEditor(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @enveditor_OnCreate);
end;

procedure enveditor_OnCreate(Sender: TFrame);
var
    lab: TLabel;
    combo: TComboBox;
    calc: TCalcEdit;
    color: TColorButton;
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
    lab.Caption := 'Editor Font Name:';
    lab.Left := 10;
    lab.Top := 10;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    combo := TComboBox.Create(Sender);
    combo.Parent := scroll;
    combo.Left := 280;
    combo.Top := 10;
    combo.Width := 130;
    combo.Style := csDropDownList;
    combo.Items.Assign(Screen.Fonts);
    combo.ItemIndex := combo.Items.IndexOf(appSettings.Values['editor-FontName']);
    combo.Hint := 'editor-FontName';
    lab.Height := combo.Height;
    combo.OnChange := @enveditor_OnComboChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Font Size:';
    lab.Left := 10;
    lab.Top := 45;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 45;
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-FontSize'], 0);
    calc.Hint := 'editor-FontSize';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;



    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Error Fore Color:';
    lab.Left := 10;
    lab.Top := 90;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 90;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopErrorForeColor']);
    color.Hint := 'editor-StopErrorForeColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Error Back Color:';
    lab.Left := 10;
    lab.Top := 120;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 120;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopErrorBackColor']);
    color.Hint := 'editor-StopErrorBackColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Stop Fore Color:';
    lab.Left := 10;
    lab.Top := 150;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 150;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopForeColor']);
    color.Hint := 'editor-StopForeColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Stop Back Color:';
    lab.Left := 10;
    lab.Top := 180;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 180;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopBackColor']);
    color.Hint := 'editor-StopBackColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Break Fore Color:';
    lab.Left := 10;
    lab.Top := 210;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 210;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopBreakForeColor']);
    color.Hint := 'editor-StopBreakForeColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Compiler Break Back Color:';
    lab.Left := 10;
    lab.Top := 240;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 240;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StopBreakBackColor']);
    color.Hint := 'editor-StopBreakBackColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Active Line Color:';
    lab.Left := 10;
    lab.Top := 270;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 270;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-ActiveLineColor']);
    color.Hint := 'editor-ActiveLineColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Selected Color:';
    lab.Left := 10;
    lab.Top := 300;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 300;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SelectedColor']);
    color.Hint := 'editor-SelectedColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Selected Text Color:';
    lab.Left := 10;
    lab.Top := 330;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 330;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SelectedTextColor']);
    color.Hint := 'editor-SelectedTextColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Bracket Match Color:';
    lab.Left := 10;
    lab.Top := 360;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 360;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-BracketMatchColor']);
    color.Hint := 'editor-BracketMatchColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Bracket Match Text Color:';
    lab.Left := 10;
    lab.Top := 390;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 390;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-BracketMatchTextColor']);
    color.Hint := 'editor-BracketMatchTextColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Mouse Link Color:';
    lab.Left := 10;
    lab.Top := 420;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 420;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-MouseLinkColor']);
    color.Hint := 'editor-MouseLinkColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Mouse Link Text Color:';
    lab.Left := 10;
    lab.Top := 450;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 450;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-MouseLinkTextColor']);
    color.Hint := 'editor-MouseLinkTextColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Color:';
    lab.Left := 10;
    lab.Top := 480;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 480;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-Color']);
    color.Hint := 'editor-Color';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Gutter Color:';
    lab.Left := 10;
    lab.Top := 510;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 510;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-GutterColor']);
    color.Hint := 'editor-GutterColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Gutter Text Color:';
    lab.Left := 10;
    lab.Top := 540;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 540;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-GutterTextColor']);
    color.Hint := 'editor-GutterTextColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Gutter Border Color:';
    lab.Left := 10;
    lab.Top := 570;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 570;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-GutterBorderColor']);
    color.Hint := 'editor-GutterBorderColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Gutter Modified Color:';
    lab.Left := 10;
    lab.Top := 600;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 600;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-GutterModifiedColor']);
    color.Hint := 'editor-GutterModifiedColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Gutter Saved Color:';
    lab.Left := 10;
    lab.Top := 630;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 630;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-GutterSavedColor']);
    color.Hint := 'editor-GutterSavedColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Right Edge Color:';
    lab.Left := 10;
    lab.Top := 660;
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 660;
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-RightEdgeColor']);
    color.Hint := 'editor-RightEdgeColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Comment Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 700; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 700; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-CommentAttributes-BackgroundColor']);
    color.Hint := 'editor-CommentAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Comment Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 730; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 730; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-CommentAttributes-ForegroundColor']);
    color.Hint := 'editor-CommentAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Comment Attributes Style:';
    lab.Left := 10;
    lab.Top := 760; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 760; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-CommentAttributes-Bold'] = '1');
    chk.Hint := 'editor-CommentAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 760; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-CommentAttributes-Italic'] = '1');
    chk.Hint := 'editor-CommentAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Identifier Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 790; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 790; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-IdentifierAttributes-BackgroundColor']);
    color.Hint := 'editor-IdentifierAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Identifier Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 820; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 820; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-IdentifierAttributes-ForegroundColor']);
    color.Hint := 'editor-IdentifierAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Identifier Attributes Style:';
    lab.Left := 10;
    lab.Top := 850; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 850; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-IdentifierAttributes-Bold'] = '1');
    chk.Hint := 'editor-IdentifierAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 850; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-IdentifierAttributes-Italic'] = '1');
    chk.Hint := 'editor-IdentifierAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Keyword Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 880; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 880; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-KeywordAttributes-BackgroundColor']);
    color.Hint := 'editor-KeywordAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Keyword Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 910; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 910; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-KeywordAttributes-ForegroundColor']);
    color.Hint := 'editor-KeywordAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Keyword Attributes Style:';
    lab.Left := 10;
    lab.Top := 940; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 940; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-KeywordAttributes-Bold'] = '1');
    chk.Hint := 'editor-KeywordAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 940; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-KeywordAttributes-Italic'] = '1');
    chk.Hint := 'editor-KeywordAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Method Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 970; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 970; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-ConstantAttributes-BackgroundColor']);
    color.Hint := 'editor-ConstantAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Method Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1000; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1000; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-ConstantAttributes-ForegroundColor']);
    color.Hint := 'editor-ConstantAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Method Attributes Style:';
    lab.Left := 10;
    lab.Top := 1030; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1030; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-ConstantAttributes-Bold'] = '1');
    chk.Hint := 'editor-ConstantAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1030; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-ConstantAttributes-Italic'] = '1');
    chk.Hint := 'editor-ConstantAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Class Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 1060; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1060; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-ClassAttributes-BackgroundColor']);
    color.Hint := 'editor-ClassAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Class Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1090; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1090; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-ClassAttributes-ForegroundColor']);
    color.Hint := 'editor-ClassAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Class Attributes Style:';
    lab.Left := 10;
    lab.Top := 1120; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1120; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-ClassAttributes-Bold'] = '1');
    chk.Hint := 'editor-ClassAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1120; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-ClassAttributes-Italic'] = '1');
    chk.Hint := 'editor-ClassAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Number Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 1150; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1150; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-NumberAttributes-BackgroundColor']);
    color.Hint := 'editor-NumberAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Number Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1180; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1180; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-NumberAttributes-ForegroundColor']);
    color.Hint := 'editor-NumberAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Number Attributes Style:';
    lab.Left := 10;
    lab.Top := 1210; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1210; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-NumberAttributes-Bold'] = '1');
    chk.Hint := 'editor-NumberAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1210; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-NumberAttributes-Italic'] = '1');
    chk.Hint := 'editor-NumberAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Symbol Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 1240; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1240; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SymbolAttributes-BackgroundColor']);
    color.Hint := 'editor-SymbolAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Symbol Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1270; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1270; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SymbolAttributes-ForegroundColor']);
    color.Hint := 'editor-SymbolAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Symbol Attributes Style:';
    lab.Left := 10;
    lab.Top := 1300; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1300; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-SymbolAttributes-Bold'] = '1');
    chk.Hint := 'editor-SymbolAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1300; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-SymbolAttributes-Italic'] = '1');
    chk.Hint := 'editor-SymbolAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'String Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 1330; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1330; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StringAttributes-BackgroundColor']);
    color.Hint := 'editor-StringAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'String Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1360; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1360; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-StringAttributes-ForegroundColor']);
    color.Hint := 'editor-StringAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'String Attributes Style:';
    lab.Left := 10;
    lab.Top := 1390; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1390; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-StringAttributes-Bold'] = '1');
    chk.Hint := 'editor-StringAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1390; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-StringAttributes-Italic'] = '1');
    chk.Hint := 'editor-StringAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///////////


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Space Attributes Back Color:';
    lab.Left := 10;
    lab.Top := 1420; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1420; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SpaceAttributes-BackgroundColor']);
    color.Hint := 'editor-SpaceAttributes-BackgroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Space Attributes Fore Color:';
    lab.Left := 10;
    lab.Top := 1450; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    color := TColorButton.Create(Sender);
    color.Parent := scroll;
    color.Left := 280;
    color.Top := 1450; //top
    color.Width := 130;
    color.ButtonColor := StringToColor(appSettings.Values['editor-SpaceAttributes-ForegroundColor']);
    color.Hint := 'editor-SpaceAttributes-ForegroundColor';
    lab.Height := color.Height;
    color.OnColorChanged := @enveditor_OnColorChange;

    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Space Attributes Style:';
    lab.Left := 10;
    lab.Top := 1480; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 280;
    chk.Top := 1480; //top
    chk.Width := 140;
    chk.Caption := 'Bold';
    chk.Checked := (appSettings.Values['editor-SpaceAttributes-Bold'] = '1');
    chk.Hint := 'editor-SpaceAttributes-Bold';
    chk.OnChange := @enveditor_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 350;
    chk.Top := 1480; //top
    chk.Width := 140;
    chk.Caption := 'Italic';
    chk.Checked := (appSettings.Values['editor-SpaceAttributes-Italic'] = '1');
    chk.Hint := 'editor-SpaceAttributes-Italic';
    chk.OnChange := @enveditor_OnCheckChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Right Edge:';
    lab.Left := 10;
    lab.Top := 1520; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1520; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-RightEdge'], 0);
    calc.Hint := 'editor-RightEdge';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Tab Width:';
    lab.Left := 10;
    lab.Top := 1555; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1555; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-TabWidth'], 0);
    calc.Hint := 'editor-TabWidth';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Block Indent:';
    lab.Left := 10;
    lab.Top := 1590; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1590; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-BlockIndent'], 0);
    calc.Hint := 'editor-BlockIndent';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Block Tab Indent:';
    lab.Left := 10;
    lab.Top := 1625; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1625; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-BlockTabIndent'], 0);
    calc.Hint := 'editor-BlockTabIndent';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Extra Char Spacing:';
    lab.Left := 10;
    lab.Top := 1660; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1660; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-ExtraCharSpacing'], 0);
    calc.Hint := 'editor-ExtraCharSpacing';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;


    ///


    lab := TLabel.Create(Sender);
    lab.Parent := scroll;
    lab.Caption := 'Editor Extra Line Spacing:';
    lab.Left := 10;
    lab.Top := 1695; //top
    lab.Width := 260;
    lab.Alignment := taLeftJustify;

    calc := TCalcEdit.Create(Sender);
    calc.Parent := scroll;
    calc.Left := 280;
    calc.Top := 1695; //top
    calc.Width := 130;
    calc.AsInteger := StrToIntDef(appSettings.Values['editor-ExtraLineSpacing'], 0);
    calc.Hint := 'editor-ExtraLineSpacing';
    calc.ButtonWidth := 0;
    lab.Height := calc.Height;
    calc.OnChange := @enveditor_OnCalcChange;



    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1735; //top
    chk.Width := 190;
    chk.Caption := 'Automatic Code Completion';
    chk.Checked := (appSettings.Values['autocompletion'] = '1');
    chk.Hint := 'autocompletion';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1735; //top
    chk.Width := 190;
    chk.Caption := 'Automatic Code Assistant';
    chk.Checked := (appSettings.Values['autoassistant'] = '1');
    chk.Hint := 'autoassistant';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1765; //top
    chk.Width := 190;
    chk.Caption := 'Show Editor Gutter';
    chk.Checked := (appSettings.Values['editor-GutterVisible'] = '1');
    chk.Hint := 'editor-GutterVisible';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1765; //top
    chk.Width := 190;
    chk.Caption := 'Enable Auto Indent';
    chk.Checked := (appSettings.Values['editor-HasAutoIndent'] = '1');
    chk.Hint := 'editor-HasAutoIndent';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1795; //top
    chk.Width := 190;
    chk.Caption := 'Highlight Brackets';
    chk.Checked := (appSettings.Values['editor-HasBracketHighlight'] = '1');
    chk.Hint := 'editor-HasBracketHighlight';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1795; //top
    chk.Width := 190;
    chk.Caption := 'Enable Enhanced Home Key';
    chk.Checked := (appSettings.Values['editor-HasEnhanceHomeKey'] = '1');
    chk.Hint := 'editor-HasEnhanceHomeKey';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1825; //top
    chk.Width := 190;
    chk.Caption := 'Enable Group Undo';
    chk.Checked := (appSettings.Values['editor-HasGroupUndo'] = '1');
    chk.Hint := 'editor-HasGroupUndo';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1825; //top
    chk.Width := 190;
    chk.Caption := 'Enable Half Page Scroll';
    chk.Checked := (appSettings.Values['editor-HasHalfPageScroll'] = '1');
    chk.Hint := 'editor-HasHalfPageScroll';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1855; //top
    chk.Width := 190;
    chk.Caption := 'Hide Right Margin';
    chk.Checked := (appSettings.Values['editor-HasHideRightMargin'] = '1');
    chk.Hint := 'editor-HasHideRightMargin';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1855; //top
    chk.Width := 190;
    chk.Caption := 'Keep Caret X Position';
    chk.Checked := (appSettings.Values['editor-HasKeepCaretX'] = '1');
    chk.Hint := 'editor-HasKeepCaretX';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1885; //top
    chk.Width := 190;
    chk.Caption := 'Scroll Past EOF';
    chk.Checked := (appSettings.Values['editor-HasScrollPastEof'] = '1');
    chk.Hint := 'editor-HasScrollPastEof';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1885; //top
    chk.Width := 190;
    chk.Caption := 'Scroll Past EOL';
    chk.Checked := (appSettings.Values['editor-HasScrollPastEol'] = '1');
    chk.Hint := 'editor-HasScrollPastEol';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1915; //top
    chk.Width := 190;
    chk.Caption := 'Show Special Chars';
    chk.Checked := (appSettings.Values['editor-HasShowSpecialChars'] = '1');
    chk.Hint := 'editor-HasShowSpecialChars';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1915; //top
    chk.Width := 190;
    chk.Caption := 'Enable Smart Tabs';
    chk.Checked := (appSettings.Values['editor-HasSmartTabs'] = '1');
    chk.Hint := 'editor-HasSmartTabs';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1945; //top
    chk.Width := 190;
    chk.Caption := 'Enable Tab Indent';
    chk.Checked := (appSettings.Values['editor-HasTabIndent'] = '1');
    chk.Hint := 'editor-HasTabIndent';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1945; //top
    chk.Width := 190;
    chk.Caption := 'Enable Tabs to Spaces';
    chk.Checked := (appSettings.Values['editor-HasTabsToSpaces'] = '1');
    chk.Hint := 'editor-HasTabsToSpaces';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 1975; //top
    chk.Width := 190;
    chk.Caption := 'Trim Trailing Spaces';
    chk.Checked := (appSettings.Values['editor-HasTrimTrailingSpaces'] = '1');
    chk.Hint := 'editor-HasTrimTrailingSpaces';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 1975; //top
    chk.Width := 190;
    chk.Caption := 'Caret Skips Selection';
    chk.Checked := (appSettings.Values['editor-HasCaretSkipsSelection'] = '1');
    chk.Hint := 'editor-HasCaretSkipsSelection';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2005; //top
    chk.Width := 190;
    chk.Caption := 'Caret Skips Tab';
    chk.Checked := (appSettings.Values['editor-HasCaretSkipTab'] = '1');
    chk.Hint := 'editor-HasCaretSkipTab';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2005; //top
    chk.Width := 190;
    chk.Caption := 'Caret Always Visible';
    chk.Checked := (appSettings.Values['editor-HasAlwaysVisibleCaret'] = '1');
    chk.Hint := 'editor-HasAlwaysVisibleCaret';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2035; //top
    chk.Width := 190;
    chk.Caption := 'Enable Enhanced End Key';
    chk.Checked := (appSettings.Values['editor-HasEnhanceEndKey'] = '1');
    chk.Hint := 'editor-HasEnhanceEndKey';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2035; //top
    chk.Width := 190;
    chk.Caption := 'Enable Persistent Block';
    chk.Checked := (appSettings.Values['editor-HasPersistentBlock'] = '1');
    chk.Hint := 'editor-HasPersistentBlock';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2065; //top
    chk.Width := 190;
    chk.Caption := 'Enable Overwrite Block';
    chk.Checked := (appSettings.Values['editor-HasOverwriteBlock'] = '1');
    chk.Hint := 'editor-HasOverwriteBlock';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2065; //top
    chk.Width := 190;
    chk.Caption := 'Auto Hide Cursor';
    chk.Checked := (appSettings.Values['editor-HasAutoHideCursor'] = '1');
    chk.Hint := 'editor-HasAutoHideCursor';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2095; //top
    chk.Width := 190;
    chk.Caption := 'Alt Enables Column Mode';
    chk.Checked := (appSettings.Values['editor-HasAltSetsColumnMode'] = '1');
    chk.Hint := 'editor-HasAltSetsColumnMode';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2095; //top
    chk.Width := 190;
    chk.Caption := 'Enable Drag-Drop Editing';
    chk.Checked := (appSettings.Values['editor-HasDragDropEditing'] = '1');
    chk.Hint := 'editor-HasDragDropEditing';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2125; //top
    chk.Width := 190;
    chk.Caption := 'Right Click Moves Cursor';
    chk.Checked := (appSettings.Values['editor-HasRightMouseMovesCursor'] = '1');
    chk.Hint := 'editor-HasRightMouseMovesCursor';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2125; //top
    chk.Width := 190;
    chk.Caption := 'Double Click Selects Line';
    chk.Checked := (appSettings.Values['editor-HasDoubleClickSelectsLine'] = '1');
    chk.Hint := 'editor-HasDoubleClickSelectsLine';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2155; //top
    chk.Width := 190;
    chk.Caption := 'Ctrl Shows Mouse Links';
    chk.Checked := (appSettings.Values['editor-HasShowCtrlMouseLinks'] = '1');
    chk.Hint := 'editor-HasShowCtrlMouseLinks';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2155; //top
    chk.Width := 190;
    chk.Caption := 'Enable Ctrl+Wheel Zoom';
    chk.Checked := (appSettings.Values['editor-HasCtrlWheelZoom'] = '1');
    chk.Hint := 'editor-HasCtrlWheelZoom';
    chk.OnChange := @envdesigner_OnCheckChange;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 10;
    chk.Top := 2185; //top
    chk.Width := 190;
    chk.Caption := 'Frame Words at Cursor';
    chk.Checked := (appSettings.Values['editor-HighlightWordsAtCursor'] = '1');
    chk.Hint := 'editor-HighlightWordsAtCursor';
    chk.OnChange := @envdesigner_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := scroll;
    chk.Left := 210;
    chk.Top := 2185; //top
    chk.Width := 190;
    chk.Caption := 'Auto Close Brackets';
    chk.Checked := (appSettings.Values['editor-autoclose-brackets'] = '1');
    chk.Hint := 'editor-autoclose-brackets';
    chk.OnChange := @envdesigner_OnCheckChange;
end;

procedure enveditor_OnComboChange(Sender: TComboBox);
begin
    appSettings.Values[Sender.Hint] := Sender.Text;
end;

procedure enveditor_OnCalcChange(Sender: TCalcEdit);
begin
    appSettings.Values[Sender.Hint] := IntToStr(Sender.asInteger);
end;

procedure enveditor_OnColorChange(Sender: TColorButton);
begin
    appSettings.Values[Sender.Hint] := ColorToString(Sender.ButtonColor);
end;

procedure enveditor_OnCheckChange(Sender: TCheckBox);
begin
    if Sender.Checked then
    appSettings.Values[Sender.Hint] := '1'
    else
    appSettings.Values[Sender.Hint] := '0';
end;

//unit constructor
constructor begin end.
