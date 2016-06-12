////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'createdb', 'dbuser';

function createAccountLiveDB(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @acntlivedb_OnCreate);
end;

procedure acntlivedb_OnCreate(Sender: TForm);
var
    leftList: TListView;
    rightList: TListView;
    splitter: TSplitter;
    col: TListColumn;
    pan: TPanel;
    sb: TSpeedButton;
    act: TSimpleAction;
begin
    Sender.Color := clForm;

    pan := TPanel.Create(Sender);
    pan.Parent := Sender;
    pan.Align := alTop;
    pan.Height := 32;
    pan.BevelOuter := bvNone;
    pan.BorderSpacing.Top := 5;
    pan.BorderSpacing.Bottom := 2;
    pan.ShowHint := true;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 5;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_newdb');
    sb.Hint := 'Create Database';
    sb.OnClick := @acntlivedb_OnCreateDBClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 35;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete Database';
    sb.Name := 'bDelDB';
    sb.Enabled := false;
    sb.OnClick := @acntlivedb_OnDelDBClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 85;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_newuser');
    sb.Hint := 'Add User';
    sb.Name := 'bAddUser';
    sb.Enabled := false;
    sb.OnClick := @acntlivedb_OnAddUserClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 115;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_edituser');
    sb.Hint := 'Edit User';
    sb.Name := 'bEditUser';
    sb.Enabled := false;
    sb.OnClick := @acntlivedb_OnEditUserClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 145;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete User';
    sb.Name := 'bDelUser';
    sb.Enabled := false;
    sb.OnClick := @acntlivedb_OnDelUserClick;

    ///

    leftList := TListView.Create(Sender);
    leftList.Parent := Sender;
    leftList.Align := alLeft;
    leftList.BorderSpacing.Left := 5;
    leftList.BorderSpacing.Bottom := 5;
    leftList.Width := 220;
    leftList.ScrollBars := ssAutoBoth;
    leftList.SmallImages := MainImages;
    leftList.ViewStyle := vsReport;
    leftList.RowSelect := true;
    leftList.ReadOnly := true;
    leftList.OnClick := @acntlivedb_OnLeftChange;
    leftList.Name := 'leftList';

    col := leftList.Columns.Add;
    col.Caption := 'Databases';
    col.Width := 200;

    ///

    splitter := TSplitter.Create(Sender);
    splitter.Parent := Sender;
    splitter.Left := 225;

    ///

    rightList := TListView.Create(Sender);
    rightList.Parent := Sender;
    rightList.Align := alClient;
    rightList.BorderSpacing.Right := 5;
    rightList.BorderSpacing.Bottom := 5;
    rightList.ScrollBars := ssAutoBoth;
    rightList.SmallImages := MainImages;
    rightList.ViewStyle := vsReport;
    rightList.RowSelect := true;
    rightList.ReadOnly := true;
    rightList.OnClick := @acntlivedb_OnRightChange;
    rightList.OnDblClick := @acntlivedb_OnRightDblClick;
    rightList.Name := 'rightList';

    col := rightList.Columns.Add;
    col.Caption := 'User Name';
    col.Width := 130;

    col := rightList.Columns.Add;
    col.Caption := 'First Name';
    col.Width := 130;

    col := rightList.Columns.Add;
    col.Caption := 'Last Name';
    col.Width := 130;

    act := TSimpleAction.Create(Sender);
    act.Name := 'actPopulateDatabases';
    act.OnExecute := @acntlivedb_PopulateDatabases;
end;

procedure acntlivedb_PopulateDatabases(Sender: TComponent);
var
    list: TListView;
    str: TStringList;
    item: TListItem;
    i: int;
begin
    TSpeedButton(Sender.Owner.find('bDelDB')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bAddUser')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bDelUser')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bEditUser')).Enabled := false;

    list := TListView(Sender.Owner.find('rightList'));
    list.Items.BeginUpdate;
    list.Items.Clear;
    list.Items.EndUpdate;

    list := TListView(Sender.Owner.find('leftList'));
    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;
    Account.LiveDBManager.ListDatabases(str);
    for i := 0 to str.Count -1 do
    begin
        item := list.Items.Add;
        item.Caption := str.Strings[i];
        item.ImageIndex := 91;
    end;
    str.Free;

    list.Items.EndUpdate;
    acntlivedb_OnRightChange(list);
end;

procedure acntlivedb_OnCreateDBClick(Sender: TSpeedButton);
begin
    if createCreateDB(mainForm).ShowModal = mrOK then
        acntlivedb_PopulateDatabases(Sender);
end;

procedure acntlivedb_OnDelDBClick(Sender: TSpeedButton);
begin
    if MsgWarning('Warning', 'You are about to delete a database, continue?') then
    begin
        Account.LiveDBManager.DropDatabase(
            TListView(Sender.Owner.find('leftList')).Selected.Caption);
        acntlivedb_PopulateDatabases(Sender);
    end;
end;

procedure acntlivedb_OnAddUserClick(Sender: TSpeedButton);
begin
    if createDBUser(MainForm, nil).ShowModal = mrOK then
        populateLiveDBUsers(
            TListView(Sender.Owner.find('rightList')),
            TListView(Sender.Owner.find('leftList')).Selected.Caption);
end;

procedure acntlivedb_OnEditUserClick(Sender: TSpeedButton);
begin
    if TListView(Sender.Owner.find('rightList')).Selected <> nil then
        acntlivedb_OnRightDblClick(TListView(Sender.Owner.find('rightList')));
end;

procedure acntlivedb_OnDelUserClick(Sender: TSpeedButton);
begin
    if MsgWarning('Warning', 'You are about to delete a database user, continue?') then
    begin
        if Account.LiveDBManager.DBUsers.DeleteUser(
            TListView(Sender.Owner.find('rightList')).Selected.Caption) then
                TListView(Sender.Owner.find('rightList')).Selected.Delete;
    end;
end;

procedure populateLiveDBUsers(list: TListView; dbName: string);
var
    i: int;
    item: TListItem;
begin
    if list.Hint = dbName then exit;

    list.Items.BeginUpdate;
    list.Items.Clear;

    Account.LiveDBManager.DBUsers.SelectDatabase(dbName);
    Account.LiveDBManager.DBUsers.ListUsers;
    for i := 0 to Account.LiveDBManager.DBUsers.UserCount -1 do
    begin
        item := list.Items.Add;
        item.Caption := Account.LiveDBManager.DBUsers.Users[i].UserName;
        item.SubItems.Insert(0, Account.LiveDBManager.DBUsers.Users[i].FirstName);
        item.SubItems.Insert(1, Account.LiveDBManager.DBUsers.Users[i].LastName);
        item.Data := Account.LiveDBManager.DBUsers.Users[i];
        item.ImageIndex := 92;
    end;

    list.Items.EndUpdate;
end;

procedure acntlivedb_OnLeftChange(Sender: TListView);//; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelDB')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
    TSpeedButton(Sender.Owner.find('bAddUser')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);

    if (Sender.Selected <> nil) and (Sender.Selected.Selected) {and Selected} then
    begin
        populateLiveDBUsers(TListView(Sender.Owner.find('rightList')), Sender.Selected.Caption);
        Sender.Hint := Sender.Selected.Caption;
    end;
end;

procedure acntlivedb_OnRightChange(Sender: TListView); //; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelUser')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected) and (Sender.Selected.Caption <> 'admin');
    TSpeedButton(Sender.Owner.find('bEditUser')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
end;

procedure acntlivedb_OnRightDblClick(Sender: TListView);
begin
    if Sender.Selected <> nil then
    begin
        if createDBUser(MainForm, TLALiveDBUSer(Sender.Selected.Data)).ShowModal = mrOK then
            populateLiveDBUsers(Sender,
                TListView(Sender.Owner.find('leftList')).Selected.Caption);
    end;
end;

//unit constructor
constructor begin end.
