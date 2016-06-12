////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createProjectOptions(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @projectoptions_OnCreate);
end;

procedure projectoptions_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    chk: TCheckBox;
    fileedit: TFileNameEdit;
    pan: TPanel;
    img: TImage;
    bu: TButton;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Project Options';
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
    Sender.OnClose := @projectoptions_OnClose;
    Sender.OnCloseQuery := @projectoptions_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 20;
    lab.Caption := 'Publish Options';
    lab.Font.Style := fsBold;
    lab.AutoSize := true;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 40;
    chk.Top := 40;
    chk.Width := 320;
    chk.Caption := 'Publish Application after successful build';
    chk.Name := 'cPublish';


    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 40;
    lab.Top := 70;
    lab.Caption := 'Please enter your Application Launcher ID';
    lab.AutoSize := true;
    lab.Name := 'lPublish';

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 40;
    edit.Top := 90;
    edit.Width := 320;
    edit.Name := 'ePublish';
    edit.Text := ActiveProject.Values['launcherid'];

    chk.Checked := (ActiveProject.Values['publish-oncompile'] = '1');




    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 130;
    lab.Caption := 'Mac OSX Options';
    lab.Font.Style := fsBold;
    lab.AutoSize := true;
    lab.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 40;
    chk.Top := 150;
    chk.Width := 320;
    chk.Caption := 'Create Application Bundle after successful build';
    chk.OnChange := @projectoptions_OnBundleChange;
    chk.Name := 'cBundle';
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 40;
    lab.Top := 180;
    lab.Caption := 'Please select an application icon for the bundle';
    lab.AutoSize := true;
    lab.Enabled := false;
    lab.Name := 'lBundle';
    lab.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);

    fileedit := TFileNameEdit.Create(Sender);
    fileedit.Parent := Sender;
    fileedit.Left := 40;
    fileedit.Top := 200;
    fileedit.Width := 320;
    fileedit.Enabled := false;
    fileedit.Name := 'eBundle';
    fileedit.Text := ActiveProject.Values['macbundle-icon'];
    fileedit.DirectInput := false;
    fileedit.Filter := 'Icons (*.icns)|*.icns';
    fileedit.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);

    chk.Checked := (ActiveProject.Values['macbundle'] = '1');




    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 240;
    lab.Caption := 'Application Icon';
    lab.Font.Style := fsBold;
    lab.AutoSize := true;
    lab.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);

    pan := TPanel.Create(Sender);
    pan.Parent := Sender;
    pan.BevelInner := bvLowered;
    pan.Left := 40;
    pan.Top := 270;
    pan.Width := 48;
    pan.Height := 48;

    img := TImage.Create(Sender);
    img.Parent := pan;
    img.Align := alClient;
    img.Center := true;
    img.Stretch := true;
    if FileExists(FilePathOf(ActiveProjectFile)+'resources/app.ico') then
    img.Picture.LoadFromFile(FilePathOf(ActiveProjectFile)+'resources/app.ico');
    img.Name := 'Img';

    bu := TButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := 95;
    bu.Top := 282;
    bu.Width := 100;
    bu.Caption := 'Change Icon';
    bu.OnClick := @projectoptions_OnIconClick;
    bu.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if Pos('-WR', ActiveProject.Values['type']) > 0 then
    bu.Enabled := false;



    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Apply';
end;

procedure projectoptions_OnBundleChange(Sender: TCheckBox);
begin
    TLabel(Sender.Owner.find('lBundle')).Enabled := Sender.Checked;
    TFileNameEdit(Sender.Owner.find('eBundle')).Enabled := Sender.Checked;
end;

procedure projectoptions_OnIconClick(Sender: TButton);
var
    dlg: TOpenPictureDialog;
begin
    dlg := TOpenPictureDialog.Create(MainForm);
    dlg.Filter := 'Icons (*.ico)|*.ico';
    if dlg.Execute then
        TImage(Sender.Owner.find('img')).Picture.LoadFromFile(dlg.FileName);
    dlg.Free;
end;

procedure projectoptions_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure projectoptions_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        if TCheckBox(Sender.find('cPublish')).Checked then
        begin
            if Trim(TEdit(Sender.find('ePublish')).Text) = '' then
            begin
                MsgError('Error', 'Please enter Application Launcher ID');
                CanClose := false;
                exit;
            end;
        end;

        if TCheckBox(Sender.find('cBundle')).Checked then
        begin
            if Trim(TFileNameEdit(Sender.find('eBundle')).Text) = '' then
            begin
                MsgError('Error', 'Please enter Bundle Icon');
                CanClose := false;
                exit;
            end;
        end;

        try
          TImage(Sender.find('img')).Picture.Icon.SaveToFile(FilePathOf(ActiveProjectFile)+'resources/app.ico');
        except end;

        if TCheckBox(Sender.find('cPublish')).Checked then
        ActiveProject.Values['publish-oncompile'] := '1'
        else
        ActiveProject.Values['publish-oncompile'] := '0';

        if TCheckBox(Sender.find('cBundle')).Checked then
        ActiveProject.Values['macbundle'] := '1'
        else
        ActiveProject.Values['macbundle'] := '0';

        ActiveProject.Values['launcherid'] := TEdit(Sender.find('ePublish')).Text;
        ActiveProject.Values['macbundle-icon'] := TFileNameEdit(Sender.find('eBundle')).Text;
        ActiveProject.SaveToFile(ActiveProjectFile);
    end;
end;

//unit constructor
constructor begin end.
