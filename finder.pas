////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

var
    finderIsAllFiles: bool;
    finderIsReplace: bool;

function createFinder(Owner: TForm; allFiles: bool; isReplace: bool): TForm;
begin
    finderIsAllFiles := allFiles;
    finderIsReplace := isReplace;
    result := TForm.CreateWithConstructor(Owner, @finder_OnCreate);
end;

procedure finder_OnCreate(Sender: TForm);
var
    findName: string;
    lab: TLabel;
    edit: TComboBox;
    gr: TGroupBox;
    bt: TButton;
    chk: TCheckBox;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;

    if finderIsReplace then
    findName := 'Replace'
    else
    findName := 'Find';

    if finderIsAllFiles then
    findName := findName+' in Project'
    else
    findName := findName+' in Unit';

    Sender.Caption := findName;
    Sender.Width := 400;
    if not finderIsReplace then
    Sender.Height := 250
    else
    Sender.Height := 300;
    Sender.ShowInTaskBar := stAlways;
    Sender.Left := Screen.Width - Sender.Width - 50;
    Sender.Top := 50;
    Sender.FormStyle := fsStayOnTop;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @finder_OnClose;
    Sender.OnCloseQuery := @finder_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 20;
    lab.Caption := 'Search for';
    lab.AutoSize := true;

    edit := TComboBox.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 20;
    edit.Top := 40;
    edit.Width := 280;
    edit.Name := 'editFind';
    edit.Text := '';
    edit.Items.Assign(finderFindMRU);
    edit.AutoComplete := true;
    edit.OnKeyDown := @finder_Find_KeyDown;
    if doGetActiveCodeEditor <> nil then
    begin
        if doGetActiveCodeEditor.SelText <> '' then
        edit.Text := doGetActiveCodeEditor.SelText
        else if doGetActiveCodeEditor.GetWordAtRowCol(doGetActiveCodeEditor.CaretX, doGetActiveCodeEditor.CaretY) <> '' then
        edit.Text := doGetActiveCodeEditor.GetWordAtRowCol(doGetActiveCodeEditor.CaretX, doGetActiveCodeEditor.CaretY);
    end;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 70;
    lab.Caption := 'Replace with';
    lab.AutoSize := true;
    lab.Visible := finderIsReplace;

    edit := TComboBox.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 20;
    edit.Top := 90;
    edit.Width := 280;
    edit.Visible := finderIsReplace;
    edit.Name := 'editReplace';
    edit.Text := '';
    edit.Items.Assign(finderReplaceMRU);
    edit.AutoComplete := true;
    edit.OnKeyDown := @finder_Replace_KeyDown;

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Left := 20;
    if not finderIsReplace then
    gr.Top := 80
    else
    gr.Top := 130;
    gr.Width := 280;
    gr.Height := 150;
    gr.Caption := 'Options';

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 40;
    bt.Width := 70;
    bt.Height := 25;
    bt.Caption := 'Find';
    bt.Visible := not finderIsReplace;
    bt.OnClick := @finder_FindClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 90;
    bt.Width := 70;
    bt.Height := 25;
    bt.Caption := 'Replace';
    bt.Visible := finderIsReplace;
    bt.OnClick := @finder_ReplaceClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    if not finderIsReplace then
    bt.Top := 205
    else
    bt.Top := 255;
    bt.Width := 70;
    bt.Height := 25;
    bt.Caption := 'Close';
    bt.Cancel := true;
    bt.OnClick := @finder_CloseClick;

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Left := 20;
    chk.Top := 10;
    chk.Width := 200;
    chk.Caption := 'Search Case Sensitive';
    chk.Name := 'chkMatch';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Left := 20;
    chk.Top := 35;
    chk.Width := 200;
    chk.Caption := 'Whole Words Only';
    chk.Name := 'chkWhole';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Left := 20;
    chk.Top := 60;
    chk.Width := 200;
    chk.Caption := 'Search Backwards';
    chk.Name := 'chkBack';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Left := 20;
    chk.Top := 85;
    chk.Width := 200;
    chk.Caption := 'Replace All Matches';
    chk.Visible := finderIsReplace;
    chk.Name := 'chkAll';
end;

procedure finder_FindClick(Sender: TComponent);
begin
    doGetActiveCodeEditor.SearchFor(
        TComboBox(Sender.Owner.find('editFind')).Text,
        TCheckBox(Sender.Owner.find('chkMatch')).Checked,
        TCheckBox(Sender.Owner.find('chkWhole')).Checked,
        TCheckBox(Sender.Owner.find('chkBack')).Checked
    );

    if trim(TComboBox(Sender.Owner.find('editFind')).Text) <> '' then
    begin
        if finderFindMRU.indexOf(TComboBox(Sender.Owner.find('editFind')).Text) = -1 then
            finderFindMRU.Add(TComboBox(Sender.Owner.find('editFind')).Text);
        TComboBox(Sender.Owner.find('editFind')).Items.Assign(finderFindMRU);
    end;
end;

procedure finder_ReplaceClick(Sender: TComponent);
begin
    doGetActiveCodeEditor.ReplaceWith(
        TComboBox(Sender.Owner.find('editFind')).Text,
        TComboBox(Sender.Owner.find('editReplace')).Text,
        TCheckBox(Sender.Owner.find('chkMatch')).Checked,
        TCheckBox(Sender.Owner.find('chkWhole')).Checked,
        TCheckBox(Sender.Owner.find('chkBack')).Checked,
        TCheckBox(Sender.Owner.find('chkAll')).Checked
    );

    if trim(TComboBox(Sender.Owner.find('editFind')).Text) <> '' then
    begin
        if finderFindMRU.indexOf(TComboBox(Sender.Owner.find('editFind')).Text) = -1 then
            finderFindMRU.Add(TComboBox(Sender.Owner.find('editFind')).Text);
        TComboBox(Sender.Owner.find('editFind')).Items.Assign(finderFindMRU);
    end;

    if trim(TComboBox(Sender.Owner.find('editReplace')).Text) <> '' then
    begin
        if finderReplaceMRU.indexOf(TComboBox(Sender.Owner.find('editReplace')).Text) = -1 then
            finderReplaceMRU.Add(TComboBox(Sender.Owner.find('editReplace')).Text);
        TComboBox(Sender.Owner.find('editReplace')).Items.Assign(finderReplaceMRU);
    end;
end;

procedure finder_CloseClick(Sender: TButton);
begin
    TForm(Sender.Owner).Close;
end;

procedure finder_Find_KeyDown(Sender: TComponent; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 13 then
        finder_FindClick(Sender);

    if (Key = 67) and //C
       (keyInfo.hasCtrl) then
    TEdit(Sender).CopyToClipboard;

    if (Key = 88) and //X
       (keyInfo.hasCtrl) then
    TEdit(Sender).CutToClipboard;

    if (Key = 86) and //V
       (keyInfo.hasCtrl) then
    TEdit(Sender).PasteFromClipboard;
end;

procedure finder_Replace_KeyDown(Sender: TComponent; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 13 then
        finder_ReplaceClick(Sender);

    if (Key = 67) and //C
       (keyInfo.hasCtrl) then
    TEdit(Sender).CopyToClipboard;

    if (Key = 88) and //X
       (keyInfo.hasCtrl) then
    TEdit(Sender).CutToClipboard;

    if (Key = 86) and //V
       (keyInfo.hasCtrl) then
    TEdit(Sender).PasteFromClipboard;
end;

procedure finder_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure finder_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin

end;

//unit constructor
constructor begin end.
