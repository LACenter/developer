////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createNewProjectDialog(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @NewProject_OnCreate);
end;

procedure NewProject_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    langTree, proTree: TTreeView;
    lab: TLabel;
    edit: TEdit;
    editButton: TEditButton;
    root: TTreeNode;
    pop: TPopupMenu;
    menu: TMenuItem;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'New Project';
    Sender.Width := 550;
    Sender.Height := 480;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @newproject_OnClose;
    Sender.OnCloseQuery := @newproject_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Top := 20;
    lab.Left := 20;
    lab.AutoSize := true;
    lab.Caption := 'Language Dialect';

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Top := 20;
    lab.Left := 230;
    lab.AutoSize := true;
    lab.Caption := 'Project Type';

    langTree := TTreeView.Create(Sender);
    langTree.Parent := Sender;
    langTree.ScrollBars := ssAutoBoth;
    langTree.Left := 20;
    langTree.Top := 40;
    langTree.Width := 200;
    langTree.Height := 260;
    langTree.Name := 'LangTree';
    langTree.ReadOnly := true;
    langTree.RowSelect := true;
    langTree.Images := MainImages32;
    langTree.ShowRoot := false;

    proTree := TTreeView.Create(Sender);
    proTree.Parent := Sender;
    proTree.ScrollBars := ssAutoBoth;
    proTree.Left := 230;
    proTree.Top := 40;
    proTree.Width := 300;
    proTree.Height := 260;
    proTree.Name := 'ProTree';
    proTree.ReadOnly := true;
    proTree.RowSelect := true;
    proTree.Images := MainImages32;
    proTree.ShowRoot := false;



    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Top := 310;
    lab.Left := 20;
    lab.AutoSize := true;
    lab.Caption := 'Enter Project Name';

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 330;
    edit.Left := 20;
    edit.Width := 510;
    edit.Name := 'editProjectName';
    edit.Text := '';
    edit.OnChange := @validateNewProject;



    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Top := 365;
    lab.Left := 20;
    lab.AutoSize := true;
    lab.Caption := 'Enter Project Location';

    editButton := TEditButton.Create(Sender);
    editButton.Parent := Sender;
    editButton.Top := 385;
    editButton.Left := 20;
    editButton.Width := 510;
    editButton.ButtonCaption := '...';
    editButton.Name := 'editLocation';

    if trim(appsettings.Values['default-location']) <> '' then
    editButton.Text := appsettings.Values['default-location']
    else
    editButton.Text := DefaultProjectLocation;

    editButton.DirectInput := false;
    editButton.OnButtonClick := @newproject_EditButtonOnClick;
    editButton.OnChange := @validateNewProject;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Create';
    bp.OKButton.Enabled := false;


    root := langTree.Items.Add('Basic');
    root.ImageIndex := 7;
    root.SelectedIndex := root.ImageIndex;
    root.Selected := true;

    root := langTree.Items.Add('C++');
    root.ImageIndex := 8;
    root.SelectedIndex := root.ImageIndex;

    root := langTree.Items.Add('JScript');
    root.ImageIndex := 9;
    root.SelectedIndex := root.ImageIndex;

    root := langTree.Items.Add('Pascal');
    root.ImageIndex := 10;
    root.SelectedIndex := root.ImageIndex;


    root := ProTree.Items.Add(' CLI (Command Line Interface)');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;
    root.Selected := true;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'cli') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' CGI (Common Gateway Interface)');
    root.ImageIndex := 1;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'cgi') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' FCGI (Fast Common Gateway Interface)');
    root.ImageIndex := 2;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'fcgi') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' SERVER (HTTP Server Interface)');
    root.ImageIndex := 3;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'server') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' UI (Android User Interface)');
    root.ImageIndex := 5;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'ui') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' UI (Android-WR User Interface)');
    root.ImageIndex := 5;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'ui') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' UI (Standard User Interface)');
    root.ImageIndex := 4;
    root.SelectedIndex := root.ImageIndex;

    root := ProTree.Items.Add(' UI (Standard-WR User Interface)');
    root.ImageIndex := 4;
    root.SelectedIndex := root.ImageIndex;

    root := ProTree.Items.Add(' UI (Advanced User Interface)');
    root.ImageIndex := 4;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'ui') then
    root.OverlayIndex := 11;

    root := ProTree.Items.Add(' UI (Advanced-WR User Interface)');
    root.ImageIndex := 4;
    root.SelectedIndex := root.ImageIndex;
    if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'ui') then
    root.OverlayIndex := 11;

    {root := ProTree.Items.Add(' UI (Markup User Interface)');
    root.ImageIndex := 6;
    root.SelectedIndex := root.ImageIndex;}

    pop := TPopupMenu.Create(Sender);
    pop.Name := 'LocationPop';

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Select New Location';
    menu.OnClick := @newproject_SelectNewLocation;
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := 'Select Default Location';
    menu.OnClick := @newproject_SelectDefaultLocation;
    pop.Items.Add(menu);
end;

procedure newproject_EditButtonOnClick(Sender: TEditButton);
var
    xx, yy: int;
begin
    xx := Sender.ClientToScreenX(0, 0);
    yy := Sender.ClientToScreenY(0, 0);
    xx := xx + Sender.Width - Sender.ButtonWidth;
    yy := yy + Sender.Height;
    TPopupMenu(Sender.Owner.find('LocationPop')).PopupAt(XX, YY);
end;

procedure newproject_SelectNewLocation(Sender: TMenuItem);
var
    dlg: TSelectDirectoryDialog;
    dir: string;
begin
    dlg := TSelectDirectoryDialog.Create(Sender.Owner);
    if dlg.Execute then
    begin
        dir := dlg.FileName;
        if not EndsWith(dir, DirSep) then
            dir := dir + DirSep;
        TEditButton(Sender.Owner.find('editLocation')).Text := dir;
    end;
    dlg.Free;
end;

procedure newproject_SelectDefaultLocation(Sender: TMenuItem);
begin
    TEditButton(Sender.Owner.find('editLocation')).Text := DefaultProjectLocation;
end;

function validateNewProject(Sender: TComponent): bool;
var
    pname, plocation: string;
    overlay: int;
begin
    pname := TEdit(Sender.Owner.find('editProjectName')).Text;
    plocation := TEditButton(Sender.Owner.find('editLocation')).Text;

    if TTreeView(Sender.Owner.Find('ProTree')).Selected <> nil then
    overlay := TTreeView(Sender.Owner.Find('ProTree')).Selected.OverlayIndex
    else
    overlay := 11;

    TButtonPanel(Sender.Owner.find('ButtonPanel')).
        OKBUtton.Enabled := (trim(pname) <> '') and
                            (overlay <> 11) and
                            (trim(plocation) <> '') and not
                            DirExists(plocation+pname);
end;

procedure newproject_OnClose(Sender: TForm; var Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newproject_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    pname, plocation, lang, protype: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        pname := TEdit(Sender.find('editProjectName')).Text;
        plocation := TEditButton(Sender.find('editLocation')).Text;
        lang := TTreeView(Sender.find('LangTree')).Selected.Text;
        protype := TTreeView(Sender.find('ProTree')).Selected.Text;

        if TTreeView(Sender.find('ProTree')).Selected.ImageIndex = 0 then
        begin
            if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'cli') then
            begin
                MsgError('Error', 'Could not access CLI SDK.');
                CanClose := false;
                exit;
            end;
        end;

        if TTreeView(Sender.find('ProTree')).Selected.ImageIndex = 1 then
        begin
            if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'cgi') then
            begin
                MsgError('Error', 'Could not access CGI SDK.');
                CanClose := false;
                exit;
            end;
        end;

        if TTreeView(Sender.find('ProTree')).Selected.ImageIndex = 2 then
        begin
            if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'fcgi') then
            begin
                MsgError('Error', 'Could not access FCGI SDK.');
                CanClose := false;
                exit;
            end;
        end;

        if TTreeView(Sender.find('ProTree')).Selected.ImageIndex = 3 then
        begin
            if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'server') then
            begin
                MsgError('Error', 'Could not access SERVER SDK.');
                CanClose := false;
                exit;
            end;
        end;

        if TTreeView(Sender.find('ProTree')).Selected.ImageIndex = 4 then
        begin
            if Pos('UI (Adv', TTreeView(Sender.find('ProTree')).Selected.Text) > 0 then
            begin
                if not DirExists(UserDir+_APP_NAME+DirSep+'sdk'+DirSep+'ui') then
                begin
                    MsgError('Error', 'Could not access UI (Advanced) SDK.');
                    CanClose := false;
                    exit;
                end;
            end;
        end;

        //validate name
        if doValidateName(pname) then
            doCreateNewProject(plocation, pname, lang, protype)
        else
            CanClose := false;
    end;
end;

//unit constructor
constructor begin end.
