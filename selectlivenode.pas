////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createSelectLiveNode(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @selectlivenode_OnCreate);
end;

procedure selectlivenode_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TComboBox;
    str: TStringList;
    i: int;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Select Live Code Node';
    Sender.Width := 400;
    Sender.Height := 140;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @selectlivenode_OnClose;
    Sender.OnCloseQuery := @selectlivenode_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please select a Live Code Node';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TComboBox.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eName';
    edit.Style := csDropDownList;
    Account.LiveCodeManager.ListLiveNodes(edit.Items);
    edit.OnChange := @selectlivenode_EditChange;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Select';
    bp.OKButton.Enabled := false;
end;

procedure selectlivenode_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure selectlivenode_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin

    end;
end;

procedure selectlivenode_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('eName')).Text) <> '');
end;

//unit constructor
constructor begin end.
