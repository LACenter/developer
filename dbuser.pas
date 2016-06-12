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
    refLiveDBUser: TLALiveDBUser;

function createDBUser(Owner: TForm; user: TLALiveDBUser): TForm;
begin
    refLiveDBUser := user;
    result := TForm.CreateWithConstructor(Owner, @dbuser_OnCreate);
end;

procedure dbuser_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    chk: TCheckBox;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'LiveDB User';
    Sender.Width := 400;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @dbuser_OnClose;
    Sender.OnCloseQuery := @dbuser_OnCloseQuery;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'LiveDB User Name';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'uname';
    if refLiveDBUser <> nil then
    begin
        edit.Text := refLiveDBUser.UserName;
        edit.Enabled := false;
    end
        else
        edit.Text := '';
    edit.OnChange := @dbuser_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'LiveDB User Password';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 95;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'upass';
    if refLiveDBUser <> nil then
    edit.Text := refLiveDBUser.Password
    else
    edit.Text := '';
    edit.OnChange := @dbuser_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'First Name';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 130;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 150;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'fName';
    if refLiveDBUser <> nil then
    edit.Text := refLiveDBUser.FirstName
    else
    edit.Text := '';
    edit.OnChange := @dbuser_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Last Name';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 185;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 205;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'lName';
    if refLiveDBUser <> nil then
    edit.Text := refLiveDBUser.LastName
    else
    edit.Text := '';
    edit.OnChange := @dbuser_EditChange;

    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 20;
    chk.Top := 245;
    chk.Width := 360;
    chk.Name := 'chkCR';
    chk.Caption := 'ALTER/CREATE Permisson';
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanCreate;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 245;
    chk.Width := 360;
    chk.Name := 'chkDR';
    chk.Caption := 'DROP Permission';
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanDrop;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;

    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 20;
    chk.Top := 275;
    chk.Width := 360;
    chk.Name := 'chkSE';
    chk.Caption := 'SELECT Permission';
    chk.Checked := true;
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanSelect;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 275;
    chk.Width := 360;
    chk.Name := 'chkIN';
    chk.Caption := 'INSERT Permission';
    chk.Checked := true;
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanInsert;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;

    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 20;
    chk.Top := 305;
    chk.Width := 360;
    chk.Name := 'chkUP';
    chk.Caption := 'UPDATE Permission';
    chk.Checked := true;
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanUpdate;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 305;
    chk.Width := 360;
    chk.Name := 'chkDE';
    chk.Caption := 'DELETE Permission';
    chk.Checked := true;
    if refLiveDBUser <> nil then
    begin
        chk.Checked := refLiveDBUser.CanDelete;
        if refLiveDBUser.UserName = 'admin' then
        chk.Enabled := false;
    end;


    ///


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    if refLiveDBUser <> nil then
    bp.OKButton.Caption := 'Update'
    else
    begin
        bp.OKButton.Caption := 'Create';
        bp.OKButton.Enabled := false;
    end;
end;

procedure dbuser_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure dbuser_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            if refLiveDBUser = nil then
            begin
                Account.LiveDBManager.DBUsers.AddUser(
                    TEdit(Sender.find('uname')).Text,
                    TEdit(Sender.find('upass')).Text,
                    TEdit(Sender.find('fname')).Text,
                    TEdit(Sender.find('lname')).Text,
                    TCheckBox(Sender.find('chkCR')).Checked,
                    TCheckBox(Sender.find('chkDR')).Checked,
                    TCheckBox(Sender.find('chkSE')).Checked,
                    TCheckBox(Sender.find('chkIN')).Checked,
                    TCheckBox(Sender.find('chkUP')).Checked,
                    TCheckBox(Sender.find('chkDE')).Checked);
            end
                else
            begin
                refLiveDBUser.Password := TEdit(Sender.find('upass')).Text;
                refLiveDBUser.FirstName := TEdit(Sender.find('fname')).Text;
                refLiveDBUser.LastName := TEdit(Sender.find('lname')).Text;
                refLiveDBUser.CanCreate := TCheckBox(Sender.find('chkCR')).Checked;
                refLiveDBUser.CanDrop := TCheckBox(Sender.find('chkDR')).Checked;
                refLiveDBUser.CanSelect := TCheckBox(Sender.find('chkSE')).Checked;
                refLiveDBUser.CanInsert := TCheckBox(Sender.find('chkIN')).Checked;
                refLiveDBUser.CanUpdate := TCheckBox(Sender.find('chkUP')).Checked;
                refLiveDBUser.CanDelete := TCheckBox(Sender.find('chkDE')).Checked;
                refLiveDBUser.Update;
            end;
        except
            CanClose := false;
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure dbuser_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('uname')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.find('upass')).Text) <> '');
end;

//unit constructor
constructor begin end.
