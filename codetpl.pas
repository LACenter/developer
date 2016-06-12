////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createCodeTemplates(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @codetpl_OnCreate);
end;

procedure codetpl_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    Pages: TPageControl;
    tab: TTabSheet;
    memo: TMemo;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Code Templates';
    Sender.Width := 640;
    Sender.Height := 500;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @codetpl_OnClose;
    Sender.OnCloseQuery := @codetpl_OnCloseQuery;

    Pages := TPageControl.Create(Sender);
    Pages.Parent := Sender;
    Pages.Align := alClient;
    Pages.BorderSpacing.Top := 20;
    Pages.BorderSpacing.Left := 20;
    Pages.BorderSpacing.Right := 20;

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Basic Templates';

    memo := TMemo.Create(Sender);
    memo.Parent := tab;
    memo.Align := alClient;
    memo.BorderSpacing.Around := 3;
    memo.Font.Name := appsettings.Values['editor-FontName'];
    memo.Font.Size := 10;
    memo.Name := 'vbMemo';
    memo.ScrollBars := ssAutoBoth;
    memo.WordWrap := false;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb') then
        memo.Lines.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb');

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'C++ Templates';

    memo := TMemo.Create(Sender);
    memo.Parent := tab;
    memo.Align := alClient;
    memo.BorderSpacing.Around := 3;
    memo.Font.Name := appsettings.Values['editor-FontName'];
    memo.Font.Size := 10;
    memo.Name := 'cppMemo';
    memo.ScrollBars := ssAutoBoth;
    memo.WordWrap := false;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp') then
        memo.Lines.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp');

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'JScript Templates';

    memo := TMemo.Create(Sender);
    memo.Parent := tab;
    memo.Align := alClient;
    memo.BorderSpacing.Around := 3;
    memo.Font.Name := appsettings.Values['editor-FontName'];
    memo.Font.Size := 10;
    memo.Name := 'jsMemo';
    memo.ScrollBars := ssAutoBoth;
    memo.WordWrap := false;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js') then
        memo.Lines.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js');

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Pascal Templates';

    memo := TMemo.Create(Sender);
    memo.Parent := tab;
    memo.Align := alClient;
    memo.BorderSpacing.Around := 3;
    memo.Font.Name := appsettings.Values['editor-FontName'];
    memo.Font.Size := 10;
    memo.Name := 'pasMemo';
    memo.ScrollBars := ssAutoBoth;
    memo.WordWrap := false;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas') then
        memo.Lines.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas');

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Save';
end;

procedure codetpl_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure codetpl_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        TMemo(Sender.find('vbMemo')).Lines.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb');
        TMemo(Sender.find('cppMemo')).Lines.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp');
        TMemo(Sender.find('jsMemo')).Lines.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js');
        TMemo(Sender.find('pasMemo')).Lines.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas');
    end;
end;

//unit constructor
constructor begin end.
