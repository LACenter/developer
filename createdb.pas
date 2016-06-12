////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createCreateDB(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @createdb_OnCreate);
end;

procedure createdb_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Create Database';
    Sender.Width := 400;
    Sender.Height := 190;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @createdb_OnClose;
    Sender.OnCloseQuery := @createdb_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a Database Name';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'dbname';
    edit.Text := '';
    edit.OnChange := @createdb_EditChange;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a password for the Admin User';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 95;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'pass';
    edit.Text := '';
    edit.OnChange := @createdb_EditChange;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Create';
    bp.OKButton.Enabled := false;
end;

procedure createdb_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure createdb_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            Account.LiveDBManager.CreateDatabase(
                TEdit(Sender.find('dbname')).Text,
                TEdit(Sender.find('pass')).Text);
        except
            canClose := false;
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure createdb_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('dbname')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.find('pass')).Text) <> '');
end;

//unit constructor
constructor begin end.
