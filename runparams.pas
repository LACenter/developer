////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createRunParams(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @runparams_OnCreate);
end;

procedure runparams_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    memo: TMemo;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Project Run Parameters';
    Sender.Width := 500;
    Sender.Height := 350;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @runparams_OnClose;
    Sender.OnCloseQuery := @runparams_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 20;
    lab.AutoSize := true;
    lab.Caption := 'Each line will be passed as a parameter';

    memo := TMemo.Create(Sender);
    memo.Parent := Sender;
    memo.Left := 20;
    memo.Top := 45;
    memo.Width := 460;
    memo.Height := 235;
    memo.WordWrap := false;
    memo.ScrollBars := ssAutoBoth;
    memo.Name := 'memo';
    memo.Lines.CommaText := ActiveProject.Values['runparams'];

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
end;

procedure runparams_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure runparams_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        ActiveProject.Values['runparams'] :=
            TMemo(Sender.find('memo')).Lines.CommaText;
        ActiveProject.SaveToFile(ActiveProjectFile);
    end;
end;

//unit constructor
constructor begin end.
