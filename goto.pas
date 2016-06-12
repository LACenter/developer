////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createGoto(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @goto_OnCreate);
end;

procedure goto_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    lab: TLabel;
    edit: TCalcEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Go to Line';
    Sender.Width := 300;
    Sender.Height := 150;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poScreenCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @goto_OnClose;
    Sender.OnCloseQuery := @goto_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.AutoSize := true;
    lab.Caption := 'Please enter a line number.';
    lab.Left := 20;
    lab.Top := 20;

    edit := TCalcEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Name := 'edit';
    edit.Left := 20;
    edit.Top := 40;
    edit.Width := 260;
    edit.ButtonWidth := 0;
    edit.OnKeyDown := @goto_OnKeyDown;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Go';
end;

procedure goto_OnKeyDown(Sender: TComponent; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 13 then //enter key
    TForm(Sender.Owner).ModalResult := mrOK;
    if Key = 27 then //escape key
    TForm(Sender.Owner).ModalResult := mrCancel;
end;

procedure goto_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure goto_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        if doGetActiveDesigner <> nil then
        begin
            doSetAtivePageTab(0);
            doGetActiveCodeEditor.CaretX := 0;
            doGetActiveCodeEditor.CaretY :=
                TCalcEdit(Sender.find('edit')).asInteger;
            doGetActiveCodeEditor.SetFocus;
        end;
    end;
end;

//unit constructor
constructor begin end.
