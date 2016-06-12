////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createNewStore(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @newstore_OnCreate);
end;

procedure newstore_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    fileedit: TFileNameEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'New App-Store';
    Sender.Width := 400;
    Sender.Height := 470;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @newstore_OnClose;
    Sender.OnCloseQuery := @newstore_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a name for your App-Store';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eName';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please select a logo for your App-Store (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75; //top

    fileedit := TFileNameEdit.Create(Sender);
    fileedit.Parent := Sender;
    fileedit.DialogKind := dkPictureOpen;
    fileedit.Filter := 'PNG Files (*.png)|*.png';
    fileedit.Top := 95; //top
    fileedit.Left := 20;
    fileedit.Width := 360;
    fileedit.Name := 'elogo';
    fileedit.Text := '';
    fileedit.DirectInput := false;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter the Store Owner Name/Company';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 130; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 150; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eowner';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter the Owner Web Site (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 185; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 205; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eweb';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter the Owner Email (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 240; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 260; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eEmail';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter the Owner Phone (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 295; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 315; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'ePhone';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Store Password (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 350; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 370; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'ePass';
    edit.Text := '';
    edit.OnChange := @newstore_EditChange;




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

procedure newstore_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newstore_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    def: TLAStoreDefinition;
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            def := Account.AppStoreManager.AddStore;
            def.StoreName := TEdit(Sender.find('eName')).Text;
            def.StoreLogoFileName := TFileNameEdit(Sender.find('eLogo')).Text;
            def.OwnerName := TEdit(Sender.find('eOwner')).Text;
            def.OwnerWeb := TEdit(Sender.find('eWeb')).Text;
            def.OwnerEmail := TEdit(Sender.find('eEmail')).Text;
            def.OwnerPhone := TEdit(Sender.find('ePhone')).Text;
            def.Password := TEdit(Sender.find('ePass')).Text;
            Account.AppStoreManager.PostStoreChanges(def);
        except
            canClose := false;
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure newstore_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('eName')).Text) <> '') and
        (Trim(TEdit(Sender.Owner.find('eOwner')).Text) <> '');
end;

//unit constructor
constructor begin end.
