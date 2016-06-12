////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createProxy(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @proxy_OnCreate);
end;

procedure proxy_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Proxy Server Setup';
    Sender.Width := 400;
    Sender.Height := 310;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @proxy_OnClose;
    Sender.OnCloseQuery := @proxy_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Proxy Server Host/IP';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'host';
    edit.Text := appsettings.Values['proxy-host'];

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Proxy Server Port';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 95;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'port';
    edit.Text := appsettings.Values['proxy-port'];

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Proxy Server User';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 130;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 150;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'user';
    edit.Text := appsettings.Values['proxy-user'];

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Proxy Server Password';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 185;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 205;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'pass';
    edit.Text := appsettings.Values['proxy-pass'];



    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Apply';
end;

procedure proxy_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure proxy_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        clearProxy;
        setProxyHost(TEdit(Sender.find('host')).Text);
        setProxyPort(TEdit(Sender.find('port')).Text);
        setProxyUser(TEdit(Sender.find('user')).Text);
        setProxyPass(TEdit(Sender.find('pass')).Text);
        appsettings.Values['proxy-host'] := TEdit(Sender.find('host')).Text;
        appsettings.Values['proxy-port'] := TEdit(Sender.find('port')).Text;
        appsettings.Values['proxy-user'] := TEdit(Sender.find('user')).Text;
        appsettings.Values['proxy-pass'] := TEdit(Sender.find('pass')).Text;
        doSaveAppSettings;
    end;
end;

//unit constructor
constructor begin end.
