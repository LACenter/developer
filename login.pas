////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createLogin(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @login_OnCreate);
end;

procedure login_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    chk: TCheckBox;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := _APP_NAME+' Account Login';
    Sender.Width := 400;
    Sender.Height := 220;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @login_OnClose;
    Sender.OnCloseQuery := @login_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter your email address';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'email';
    edit.Text := appSettings.Values['login-email'];
    edit.OnChange := @login_EditChange;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter your password';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 95;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'pass';
    edit.PasswordChar := 'X';
    edit.OnChange := @login_EditChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 20;
    chk.Top := 130;
    chk.Width := 360;
    chk.Name := 'chk';
    chk.Caption := 'Remember Password';
    chk.Checked := (appSettings.Values['remember-login'] = '1');


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Login';
    bp.OKButton.Enabled := false;

    edit.Text := appSettings.Values['login-pass'];
end;

procedure login_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure login_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;

        Compiler.EmailAddress := TEdit(Sender.find('email')).Text;
        Compiler.Password := TEdit(Sender.find('pass')).Text;
        if Compiler.Login then
        begin
            if Account.ConnectToCompiler(Compiler) then
            begin
                CanClose := true;
                TLabel(MainForm.find('LoginLabel')).Caption := 'Welcome '+compiler.DisplayName;
                TButton(MainForm.find('LoginButton')).Caption := 'Logout';
                TAction(MainForm.find('actLiveApps')).Caption := 'Logout';
                appSettings.Values['login-email'] := TEdit(Sender.find('email')).Text;
                if TCheckBox(Sender.find('chk')).Checked then
                begin
                    appSettings.Values['login-pass'] := TEdit(Sender.find('pass')).Text;
                    appSettings.Values['remember-login'] := '1';
                end
                    else
                begin
                    appSettings.Values['login-pass'] := '';
                    appSettings.Values['remember-login'] := '0';
                end;
                doSaveAppSettings;
            end
                else
            begin
                CanClose := false;
                MsgError('Error', 'Could not connect to account, please try again');
                Compiler.Logout;
                Account.Disconnect;
            end;
        end
        else
        begin
            TLabel(MainForm.find('LoginLabel')).Caption := _APP_NAME+' Account';
            TButton(MainForm.find('LoginButton')).Caption := 'Login';
            TAction(MainForm.find('actLiveApps')).Caption := 'Login';
            CanClose := false;
            MsgError('Error', 'Your email address or password did not match, please try again.');
        end;

        Screen.Cursor := crDefault;
        Application.ProcessMessages;
    end;
end;

procedure login_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('email')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.find('pass')).Text) <> '');
end;

//unit constructor
constructor begin end.
