////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'selectlivenode';

var
    liveAppDef: TLAAppDefinition;
    liveStoreID: int;

function createNewApp(Owner: TForm; appdef: TLAAppDefinition; storeID: int): TForm;
begin
    liveAppDef := appdef;
    liveStoreID := storeID;
    result := TForm.CreateWithConstructor(Owner, @newapp_OnCreate);
end;

procedure newapp_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    fileedit: TFileNameEdit;
    combo: TComboBox;
    editbutton: TEditButton;
    calc: TCalcEdit;
    memo: TMemo;
    chk: TCheckBox;
    gr: TGroupBox;
    progress: TProgressBar;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Live Application';
    Sender.Width := 720;
    Sender.Height := 580;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @newapp_OnClose;
    Sender.OnCloseQuery := @newapp_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a name for your Live Application';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eName';
    if liveAppDef <> nil then
    edit.Text := liveAppDef.AppName
    else
    edit.Text := '';
    edit.OnChange := @newapp_EditChange;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    if liveAppDef <> nil then
    begin
        lab.Caption := 'Application Icon (leave blank if not changed)';
        //lab.Font.Style := fsBold;
    end
    else
    lab.Caption := 'Please select an Application Icon (optional)';
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
    fileedit.Name := 'eIcon';
    fileedit.Text := '';
    fileedit.DirectInput := false;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please select how your application is launched';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 130; //top

    combo := TComboBox.Create(Sender);
    combo.Parent := Sender;
    combo.Top := 150; //top
    combo.Left := 20;
    combo.Width := 360;
    combo.Name := 'eAppType';
    combo.Items.Add('Live Code Launch');
    combo.Items.Add('Live XAP Launch');
    combo.Items.Add('Installer');
    combo.Items.Add('Download');
    combo.Style := csDropDownList;
    if liveAppDef <> nil then
    combo.ItemIndex := liveAppDef.AppType
    else
    combo.ItemIndex := 0;


    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    if liveAppDef <> nil then
    begin
        lab.Caption := 'Application Package/Reference (leave blank if not changed)';
        //lab.Font.Style := fsBold;
    end
    else
    lab.Caption := 'Please select an Application Package/Reference';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 185; //top

    editbutton := TEditButton.Create(Sender);
    editbutton.Parent := Sender;
    editbutton.Top := 205; //top
    editbutton.Left := 20;
    editbutton.Width := 360;
    editbutton.Name := 'eAppLauncher';
    if liveAppDef <> nil then
    editbutton.Text := liveAppDef.AppLauncher
    else
    editbutton.Text := '';
    editbutton.Button.Caption := '...';
    editbutton.DirectInput := false;
    editbutton.OnButtonClick := @newapp_AppLauncherClick;

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please select the Price Type';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 240; //top

    combo := TComboBox.Create(Sender);
    combo.Parent := Sender;
    combo.Top := 260; //top
    combo.Left := 20;
    combo.Width := 360;
    combo.Name := 'ePriceType';
    combo.Items.Add('Free');
    combo.Items.Add('Per Month');
    combo.Items.Add('Per User / Per Month');
    combo.Items.Add('Per Year');
    combo.Items.Add('Per User / Per Year');
    combo.Items.Add('One Time Payment');
    combo.Style := csDropDownList;
    if liveAppDef <> nil then
    combo.ItemIndex := liveAppDef.PriceType
    else
    combo.ItemIndex := 0;
    combo.OnChange := @newapp_OnPriceType;


    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter the Price';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 295; //top
    lab.Name := 'lPrice';
    lab.Enabled := (combo.ItemIndex <> 0);

    calc := TCalcEdit.Create(Sender);
    calc.Parent := Sender;
    calc.Top := 315; //top
    calc.Left := 20;
    calc.Width := 360;
    calc.Name := 'ePrice';
    if liveAppDef <> nil then
    calc.Text := DoubleToStr(liveAppDef.Price)
    else
    calc.Text := '0.00';
    calc.Enabled := (combo.ItemIndex <> 0);

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Buy Url or Stripe Key or (leave blank for Live Payment)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 350; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 370; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eBuyUrl';
    if liveAppDef <> nil then
    edit.Text := liveAppDef.BuyUrl
    else
    edit.Text := '';

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a Support Web Site (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 405; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 425; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eWeb';
    if liveAppDef <> nil then
    edit.Text := liveAppDef.SupportWebsite
    else
    edit.Text := '';

    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a Support Email (optional)';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 460; //top

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 480; //top
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eEmail';
    if liveAppDef <> nil then
    edit.Text := liveAppDef.SupportEmail
    else
    edit.Text := '';


    ///

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a Description for your Live Application';
    lab.AutoSize := true;
    lab.Left := 390;
    lab.Top := 20; //top

    memo := TMemo.Create(Sender);
    memo.Parent := Sender;
    memo.Top := 40; //top
    memo.Left := 390;
    memo.Width := 310;
    memo.Height := 300;
    memo.Name := 'eMemo';
    if liveAppDef <> nil then
    memo.Lines.Text := liveAppDef.AppDescription
    else
    memo.Lines.Text := '';
    memo.ScrollBars := ssAutoVertical;
    memo.WordWrap := true;
    memo.WantTabs := false;
    memo.OnChange := @newapp_EditChange;

    if liveAppDef <> nil then
    begin
        memo.Height := 240;
        lab := TLabel.Create(Sender);
        lab.Parent := Sender;
        lab.Left := 390;
        lab.Top := 290;
        lab.Caption := 'Launcher ID';
        lab.AutoSize := true;
        lab.Font.Style := fsBold;

        edit := TEdit.Create(Sender);
        edit.Parent := Sender;
        edit.Left := 390;
        edit.Top := 310;
        edit.Width := 310;
        edit.Text := liveAppDef.LauncherID;
        edit.ReadOnly := true;
    end;

    ///

    gr := TGroupBox.Create(Sender);
    gr.Parent := Sender;
    gr.Caption := 'App-Store Listing';
    gr.Left := 390;
    gr.Top := 350;
    gr.Height := 160;
    gr.Width := 310;

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Linux PI';
    chk.Left := 10;
    chk.Top := 10;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableLinuxPI;
    chk.Name := 'liPI';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Linux 32';
    chk.Left := 155;
    chk.Top := 10;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableLinux32;
    chk.Name := 'li32';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Linux 64';
    chk.Left := 10;
    chk.Top := 35;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableLinux64;
    chk.Name := 'li64';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable FreeBSD 32';
    chk.Left := 155;
    chk.Top := 35;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableFreeBSD32;
    chk.Name := 'fb32';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable FreeBSD 64';
    chk.Left := 10;
    chk.Top := 60;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableFreeBSD64;
    chk.Name := 'fb64';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Mac OSX';
    chk.Left := 155;
    chk.Top := 60;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableMacOSX;
    chk.Name := 'mac';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Windows CE';
    chk.Left := 10;
    chk.Top := 85;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableWindowsCE;
    chk.Name := 'wice';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Windows 32';
    chk.Left := 155;
    chk.Top := 85;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableWindows32;
    chk.Name := 'wi32';

    chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Windows 64';
    chk.Left := 10;
    chk.Top := 110;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableWindows64;
    chk.Name := 'wi64';

    {chk := TCheckBox.Create(Sender);
    chk.Parent := gr;
    chk.Caption := 'Disable Android';
    chk.Left := 155;
    chk.Top := 110;
    if liveAppDef <> nil then
    chk.Checked := liveAppDef.DisableAndroid;
    chk.Enabled := false;
    chk.Name := 'droid';}


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    if liveAppDef <> nil then
    bp.OKButton.Caption := 'Update'
    else
    begin
        bp.OKButton.Caption := 'Add';
        bp.OKButton.Enabled := false;
    end;

    progress := TProgressBar.Create(Sender);
    progress.Parent := Sender;
    progress.Left := 20;
    progress.Top := 540;
    progress.Height := 20;
    progress.Width := 360;
    progress.Color := clNone;
    progress.Name := 'aProgress';
    progress.Style := pbstMarquee;
    progress.Visible := false;
    progress.Smooth := true;

    accountProgress := progress;
end;

procedure newapp_AppLauncherClick(Sender: TEditButton);
var
    dlg: TOpenDialog;
    sf: TForm;
begin
    if TComboBox(Sender.Owner.find('eAppType')).ItemIndex = 0 then
    begin
        sf := createSelectLiveNode(MainForm);
        if sf.ShowModal = mrOK then
            Sender.Text := TComboBox(sf.find('eName')).Text;
    end;
    if TComboBox(Sender.Owner.find('eAppType')).ItemIndex = 1 then
    begin
        dlg := TOpenDialog.Create(MainForm);
        dlg.Title := 'Please select XAP Package';
        dlg.Filter := 'XAP Packages (*.xap)|*.xap';
        if dlg.Execute then
            Sender.Text := dlg.FileName;
        dlg.Free;
    end;
    if TComboBox(Sender.Owner.find('eAppType')).ItemIndex in [2,3] then
    begin
        dlg := TOpenDialog.Create(MainForm);
        dlg.Title := 'Please select Archive';
        dlg.Filter := 'Zip Files (*.zip)|*.zip';
        if dlg.Execute then
            Sender.Text := dlg.FileName;
        dlg.Free;
    end;
end;

procedure newapp_OnPriceType(Sender: TComboBox);
begin
    TLabel(Sender.Owner.find('lPrice')).Enabled := (Sender.ItemIndex <> 0);
    TCalcEdit(Sender.Owner.find('ePrice')).Enabled := (Sender.ItemIndex <> 0);

    if Sender.ItemIndex = 0 then
        TCalcEdit(Sender.Owner.find('ePrice')).Text := '0.00';
end;

procedure newapp_EditChange(Sender: TComponent);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('eName')).Text) <> '') and
        (Trim(TMemo(Sender.Owner.find('eMemo')).Lines.Text) <> '');
end;

procedure newapp_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newapp_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    def: TLAAppDefinition;
begin
    if Sender.ModalResult = mrOK then
    begin
        accountTransferFile := TEditButton(Sender.find('eAppLauncher')).Text;

        TProgressBar(Sender.Find('aProgress')).Show;
        Application.ProcessMessages;

        try
            if liveAppDef = nil then
            begin
                if TEditButton(Sender.find('eAppLauncher')).Text = '' then
                begin
                    MsgError('Error', 'Please select an Application Package/Reference');
                    CanClose := false;
                    exit;
                end;
                if TComboBox(Sender.find('ePriceType')).ItemIndex <> 0 then
                begin
                    if TCalcEdit(Sender.find('ePrice')).AsFloat <= 0 then
                    begin
                        MsgError('Error', 'Please enter a valid price');
                        CanClose := false;
                        exit;
                    end;
                end;

                def := Account.AppStoreManager.AddApplication(liveStoreID);
                def.AppName := TEdit(Sender.find('eName')).Text;
                def.AppDescription := TMemo(Sender.find('eMemo')).Lines.Text;
                def.AppIconFileName := TFileNameEdit(Sender.find('eIcon')).Text;
                def.AppType := TComboBox(Sender.find('eAppType')).ItemIndex;
                def.AppLauncher := TEditButton(Sender.find('eAppLauncher')).Text;
                def.DisableLinuxPI := TCheckBox(Sender.find('liPI')).Checked;
                def.DisableLinux32 := TCheckBox(Sender.find('li32')).Checked;
                def.DisableLinux64 := TCheckBox(Sender.find('li64')).Checked;
                def.DisableFreeBSD32 := TCheckBox(Sender.find('fb32')).Checked;
                def.DisableFreeBSD64 := TCheckBox(Sender.find('fb64')).Checked;
                def.DisableMacOSX := TCheckBox(Sender.find('mac')).Checked;
                def.DisableWindowsCE := TCheckBox(Sender.find('wice')).Checked;
                def.DisableWindows32 := TCheckBox(Sender.find('wi32')).Checked;
                def.DisableWindows64 := TCheckBox(Sender.find('wi64')).Checked;
                def.PriceType := TComboBox(Sender.find('ePriceType')).ItemIndex;
                def.Price := TCalcEdit(Sender.find('ePrice')).AsFloat;
                def.BuyUrl := TEdit(Sender.find('eBuyUrl')).Text;
                def.SupportEmail := TEdit(Sender.find('eEmail')).Text;
                def.SupportWebsite := TEdit(Sender.find('eWeb')).Text;
                Account.AppStoreManager.PostApplicationChanges(def);
            end
                else
            begin
                liveAppDef.AppName := TEdit(Sender.find('eName')).Text;
                liveAppDef.AppDescription := TMemo(Sender.find('eMemo')).Lines.Text;
                liveAppDef.AppIconFileName := TFileNameEdit(Sender.find('eIcon')).Text;
                liveAppDef.AppType := TComboBox(Sender.find('eAppType')).ItemIndex;
                liveAppDef.AppLauncher := TEditButton(Sender.find('eAppLauncher')).Text;
                liveAppDef.DisableLinuxPI := TCheckBox(Sender.find('liPI')).Checked;
                liveAppDef.DisableLinux32 := TCheckBox(Sender.find('li32')).Checked;
                liveAppDef.DisableLinux64 := TCheckBox(Sender.find('li64')).Checked;
                liveAppDef.DisableFreeBSD32 := TCheckBox(Sender.find('fb32')).Checked;
                liveAppDef.DisableFreeBSD64 := TCheckBox(Sender.find('fb64')).Checked;
                liveAppDef.DisableMacOSX := TCheckBox(Sender.find('mac')).Checked;
                liveAppDef.DisableWindowsCE := TCheckBox(Sender.find('wice')).Checked;
                liveAppDef.DisableWindows32 := TCheckBox(Sender.find('wi32')).Checked;
                liveAppDef.DisableWindows64 := TCheckBox(Sender.find('wi64')).Checked;
                liveAppDef.PriceType := TComboBox(Sender.find('ePriceType')).ItemIndex;
                liveAppDef.Price := TCalcEdit(Sender.find('ePrice')).AsFloat;
                liveAppDef.BuyUrl := TEdit(Sender.find('eBuyUrl')).Text;
                liveAppDef.SupportEmail := TEdit(Sender.find('eEmail')).Text;
                liveAppDef.SupportWebsite := TEdit(Sender.find('eWeb')).Text;
                Account.AppStoreManager.PostApplicationChanges(liveAppDef);
            end;
        except
            TProgressBar(Sender.Find('aProgress')).Hide;
            canClose := false;
            MsgError('Error', ExceptionMessage);
        end;
        TProgressBar(Sender.Find('aProgress')).Position :=
            TProgressBar(Sender.Find('aProgress')).Max;
        Application.ProcessMessages;

        TProgressBar(Sender.Find('aProgress')).Hide;
        Application.ProcessMessages;

        accountProgress := nil;
    end;
end;


//unit constructor
constructor begin end.
