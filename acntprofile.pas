////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createAccountProfile(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @acntprofile_OnCreate);
end;

procedure acntprofile_OnEditClick(Sender: TButton);
begin
    if Sender.Caption = 'Cancel' then
    begin
        TLabel(Sender.Owner.find('lEmail')).Enabled := false;
        TEdit(Sender.Owner.find('eEmail')).Enabled := false;
        TLabel(Sender.Owner.find('lPass')).Enabled := false;
        TEdit(Sender.Owner.find('ePass')).Enabled := false;
        TLabel(Sender.Owner.find('lFName')).Enabled := false;
        TEdit(Sender.Owner.find('eFName')).Enabled := false;
        TLabel(Sender.Owner.find('lLName')).Enabled := false;
        TEdit(Sender.Owner.find('eLName')).Enabled := false;
        TLabel(Sender.Owner.find('lDName')).Enabled := false;
        TEdit(Sender.Owner.find('eDName')).Enabled := false;

        TEdit(Sender.Owner.find('eEmail')).Text := Account.AccountEmail;
        TEdit(Sender.Owner.find('ePass')).Text := Account.AccountPassword;
        TEdit(Sender.Owner.find('eFName')).Text := Account.AccountFirstName;
        TEdit(Sender.Owner.find('eLName')).Text := Account.AccountLastName;
        TEdit(Sender.Owner.find('eDName')).Text := Account.AccountDisplayName;

        TEdit(Sender.Owner.find('ePass')).PasswordChar := 'X';
        TButton(Sender.Owner.find('bUpdate')).Hide;

        Sender.Caption := 'Edit Profile';
    end
        else
    begin
        if PasswordBox('Password', 'Please enter your current password') = Account.AccountPassword then
        begin
            TLabel(Sender.Owner.find('lEmail')).Enabled := true;
            TEdit(Sender.Owner.find('eEmail')).Enabled := true;
            TLabel(Sender.Owner.find('lPass')).Enabled := true;
            TEdit(Sender.Owner.find('ePass')).Enabled := true;
            TLabel(Sender.Owner.find('lFName')).Enabled := true;
            TEdit(Sender.Owner.find('eFName')).Enabled := true;
            TLabel(Sender.Owner.find('lLName')).Enabled := true;
            TEdit(Sender.Owner.find('eLName')).Enabled := true;
            TLabel(Sender.Owner.find('lDName')).Enabled := true;
            TEdit(Sender.Owner.find('eDName')).Enabled := true;

            TEdit(Sender.Owner.find('ePass')).PasswordChar := #0;
            TButton(Sender.Owner.find('bUpdate')).Show;

            Sender.Caption := 'Cancel';
        end;
    end;
end;

procedure acntprofile_OnUpdateClick(Sender: TButton);
begin
    try
        Account.UpdateAccountDetails(
            TEdit(Sender.Owner.find('eEmail')).Text,
            TEdit(Sender.Owner.find('ePass')).Text,
            TEdit(Sender.Owner.find('eFName')).Text,
            TEdit(Sender.Owner.find('eLName')).Text,
            TEdit(Sender.Owner.find('eDName')).Text
            );

        Account.AccountEmail := TEdit(Sender.Owner.find('eEmail')).Text;
        Account.AccountPassword := TEdit(Sender.Owner.find('ePass')).Text;
        Account.AccountFirstName := TEdit(Sender.Owner.find('eFName')).Text;
        Account.AccountLastName := TEdit(Sender.Owner.find('eLName')).Text;
        Account.AccountDisplayName := TEdit(Sender.Owner.find('eDName')).Text;

        acntprofile_OnEditClick(TButton(Sender.Owner.find('bEdit')));
    except
        MsgError('Error', ExceptionMessage);
    end;
end;

procedure acntprofile_OnCreate(Sender: TForm);
var
    lab: TLabel;
    edit: TEdit;
    gr: TGroupBox;
    bu: TButton;
    memo: TMemo;
begin
    Sender.Color := clForm;

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Left := 10;
    gr.Top := 10;
    gr.Caption := 'Login Profile';
    gr.Width := 300;
    gr.Height := 490;

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 10;
    lab.Caption := 'Login Email';
    lab.AutoSize := true;
    lab.Name := 'lEmail';
    lab.Enabled := false;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 30;
    edit.Width := 275;
    edit.Name := 'eEmail';
    edit.Text := Account.AccountEmail;
    edit.Enabled := false;

    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 70;
    lab.Caption := 'Login Password';
    lab.AutoSize := true;
    lab.Name := 'lPass';
    lab.Enabled := false;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 90;
    edit.Width := 275;
    edit.Name := 'ePass';
    edit.Text := Account.AccountPassword;
    edit.PasswordChar := 'X';
    edit.Enabled := false;

    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 130; //top
    lab.Caption := 'First Name';
    lab.AutoSize := true;
    lab.Name := 'lFName';
    lab.Enabled := false;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 150; //top
    edit.Width := 275;
    edit.Name := 'eFName';
    edit.Text := Account.AccountFirstName;
    edit.Enabled := false;

    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 190; //top
    lab.Caption := 'Last Name';
    lab.AutoSize := true;
    lab.Name := 'lLName';
    lab.Enabled := false;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 210; //top
    edit.Width := 275;
    edit.Name := 'eLName';
    edit.Text := Account.AccountLastName;
    edit.Enabled := false;

    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 250; //top
    lab.Caption := 'Display Name';
    lab.AutoSize := true;
    lab.Name := 'lDName';
    lab.Enabled := false;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 270; //top
    edit.Width := 275;
    edit.Name := 'eDName';
    edit.Text := Account.AccountDisplayName;
    edit.Enabled := false;

    ///

    bu := TButton.Create(Sender);
    bu.Parent := gr;
    bu.Left := 185;
    bu.Width := 100;
    bu.Top := 310; //top
    bu.Caption := 'Edit Profile';
    bu.Name := 'bEdit';
    bu.OnClick := @acntprofile_OnEditClick;

    ///

    bu := TButton.Create(Sender);
    bu.Parent := gr;
    bu.Left := 10;
    bu.Width := 100;
    bu.Top := 310; //top
    bu.Caption := 'Update';
    bu.Name := 'bUpdate';
    bu.Visible := false;
    bu.OnClick := @acntprofile_OnUpdateClick;


    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 350; //top
    lab.Caption := 'Your Public Key';
    lab.AutoSize := true;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 370; //top
    edit.Width := 275;
    edit.Name := 'ePK';
    edit.Text := '';
    edit.ReadOnly := true;
    edit.Text := Compiler.getPublicKey;
    //edit.EchoMode := emPassword;


    ///

    lab := TLabel.Create(Sender);
    lab.parent := gr;
    lab.Left := 10;
    lab.Top := 410; //top
    lab.Caption := 'Your Secret Key (DO NOT SHARE)';
    lab.AutoSize := true;

    edit := TEdit.Create(Sender);
    edit.Parent := gr;
    edit.Left := 10;
    edit.Top := 430; //top
    edit.Width := 275;
    edit.Name := 'eSK';
    edit.Text := '';
    edit.ReadOnly := true;
    edit.Text := Compiler.getSecretKey;
    //edit.EchoMode := emPassword;


    ///

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Caption := 'Account Plan';
    gr.Left := 320;
    gr.Top := 10;
    gr.Width := 355;
    gr.Height := 60;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Align := alClient;
    lab.Font.Size := 12;
    lab.Font.Style := fsBold;
    lab.Alignment := taCenter;
    lab.Caption := Account.AccountPlan+' Plan';

    ///

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Caption := 'Account Storage';
    gr.Left := 320;
    gr.Top := 80;
    gr.Width := 355;
    gr.Height := 60;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Align := alClient;
    lab.Alignment := taCenter;
    lab.Font.Style := fsBold;
    if Account.TotalSpace = 0 then
    lab.Caption := DoubleFormat('#,##0.00', Account.UsedSpace / 1024 / 1024)+' Mb Used / Total ∞ Mb'
    else
    lab.Caption := DoubleFormat('#,##0.00', Account.UsedSpace / 1024 / 1024)+' Mb Used / Total '+
                   DoubleFormat('#,##0.00', Account.TotalSpace / 1024 / 1024)+' Mb';

    ///

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Caption := 'Library Access';
    gr.Left := 320;
    gr.Top := 150;
    gr.Width := 355;
    gr.Height := 160;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Caption := 'CLI Library';
    lab.Top := 10;
    lab.Left := 10;
    lab.AutoSize := true;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Caption := 'CGI Library';
    lab.Top := 30;
    lab.Left := 10;
    lab.AutoSize := true;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Caption := 'FCGI Library';
    lab.Top := 50;
    lab.Left := 10;
    lab.AutoSize := true;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Caption := 'SERVER Library';
    lab.Top := 70;
    lab.Left := 10;
    lab.AutoSize := true;

    if POS('lastore', ArgumentByIndex(0)) > 0 then
    begin
        lab := TLabel.Create(Sender);
        lab.Parent := gr;
        lab.Caption := 'UI (Standard) Library';
        lab.Top := 90;
        lab.Left := 10;
        lab.AutoSize := true;

        lab := TLabel.Create(Sender);
        lab.Parent := gr;
        lab.Caption := 'UI (Advanced) Library';
        lab.Top := 110;
        lab.Left := 10;
        lab.AutoSize := true;
    end
        else
    begin
        lab := TLabel.Create(Sender);
        lab.Parent := gr;
        lab.Caption := 'UI Library';
        lab.Top := 90;
        lab.Left := 10;
        lab.AutoSize := true;

        lab := TLabel.Create(Sender);
        lab.Parent := gr;
        lab.Caption := 'ANDROID Library';
        lab.Top := 110;
        lab.Left := 10;
        lab.AutoSize := true;
    end;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    if Account.AccountCLI then
    lab.Caption := 'YES'
    else
    lab.Caption := 'NO';
    lab.Top := 10;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    if Account.AccountCGI then
    lab.Caption := 'YES'
    else
    lab.Caption := 'NO';
    lab.Top := 30;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    if Account.AccountFCGI then
    lab.Caption := 'YES'
    else
    lab.Caption := 'NO';
    lab.Top := 50;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    if Account.AccountSERVER then
    lab.Caption := 'YES'
    else
    lab.Caption := 'NO';
    lab.Top := 70;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    lab.Caption := 'YES';
    lab.Top := 90;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    lab := TLabel.Create(Sender);
    lab.Parent := gr;
    if Account.AccountUI then
    lab.Caption := 'YES'
    else
    lab.Caption := 'NO';
    lab.Top := 110;
    lab.Left := 300;
    lab.AutoSize := true;
    lab.Font.Style := fsBold;

    ///

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Caption := 'Native Compiler Targets';
    gr.Left := 320;
    gr.Top := 320;
    gr.Width := 355;
    gr.Height := 180;

    memo := TMemo.Create(Sender);
    memo.Parent := gr;
    memo.Align := alClient;
    if Account.AccountTargets = '' then
    memo.Lines.Text := 'XAP-CloudOS'
    else
    memo.Lines.CommaText := 'XAP-CloudOS,'+Account.AccountTargets;
    memo.Font.Style := fsBold;
    memo.ScrollBars := ssVertical;
    memo.Color := Sender.Color;
    memo.ReadOnly := true;
    memo.BorderSpacing.Around := 10;
    memo.BorderStyle := bsNone;
end;

//unit constructor
constructor begin end.
