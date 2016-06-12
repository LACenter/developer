////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createEnvGeneral(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @envgeneral_OnCreate);
end;

procedure envgeneral_OnCreate(Sender: TFrame);
var
    lab: TLabel;
    edit: TEdit;
    chk: TCheckBox;
begin
    Sender.Color := clWindow;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Author Name / Company Name:';
    lab.Left := 10;
    lab.Top := 10;
    lab.Width := 200;
    lab.Alignment := taLeftJustify;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 220;
    edit.Top := 10;
    edit.Width := 200;
    lab.Height := edit.Height;
    edit.Text := appSettings.Values['author'];
    edit.Hint := 'author';
    edit.OnChange := @evngeneral_OnEditChange;


    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Date Format:';
    lab.Left := 10;
    lab.Top := 45;
    lab.Width := 200;
    lab.Alignment := taLeftJustify;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 220;
    edit.Top := 45;
    edit.Width := 200;
    lab.Height := edit.Height;
    edit.Text := appSettings.Values['dateformat'];
    edit.Hint := 'dateformat';
    edit.OnChange := @evngeneral_OnEditChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 80;
    chk.Width := 190;
    chk.Caption := 'Show Scrollbars on Views';
    chk.Checked := (appSettings.Values['show-scrollbar'] = '1');
    chk.Hint := 'show-scrollbar';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 80;
    chk.Width := 190;
    chk.Caption := 'Show Toolbar';
    chk.Checked := (appSettings.Values['show-toolbar'] = '1');
    chk.Hint := 'show-toolbar';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 110;
    chk.Width := 190;
    chk.Caption := 'Show Design Toolbar';
    chk.Checked := (appSettings.Values['show-designtoolbar'] = '1');
    chk.Hint := 'show-designtoolbar';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 110;
    chk.Width := 190;
    chk.Caption := 'Show Statusbar';
    chk.Checked := (appSettings.Values['show-statusbar'] = '1');
    chk.Hint := 'show-statusbar';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 140;
    chk.Width := 190;
    chk.Caption := 'Show Project View';
    chk.Checked := (appSettings.Values['show-projectpane'] = '1');
    chk.Hint := 'show-projectpane';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 140;
    chk.Width := 190;
    chk.Caption := 'Show Toolbox View';
    chk.Checked := (appSettings.Values['show-toolboxpane'] = '1');
    chk.Hint := 'show-toolboxpane';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 170;
    chk.Width := 190;
    chk.Caption := 'Show Objects View';
    chk.Checked := (appSettings.Values['show-objectspane'] = '1');
    chk.Hint := 'show-objectspane';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 170;
    chk.Width := 190;
    chk.Caption := 'Show Inspector View';
    chk.Checked := (appSettings.Values['show-inspectorpane'] = '1');
    chk.Hint := 'show-inspectorpane';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 200;
    chk.Width := 190;
    chk.Caption := 'Object Properties as Keywords';
    chk.Checked := (appSettings.Values['props-as-keys'] = '1');
    chk.Hint := 'props-as-keys';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 200;
    chk.Width := 190;
    chk.Caption := 'Object Events as Keywords';
    chk.Checked := (appSettings.Values['events-as-keys'] = '1');
    chk.Hint := 'events-as-keys';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 230;
    chk.Width := 190;
    chk.Caption := 'Object Methods as Keywords';
    chk.Checked := (appSettings.Values['methods-as-keys'] = '1');
    chk.Hint := 'methods-as-keys';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 230;
    chk.Width := 190;
    chk.Caption := 'Create TObject Events';
    chk.Checked := (appSettings.Values['create-TObject-events'] = '1');
    chk.Hint := 'create-TObject-events';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 260;
    chk.Width := 190;
    chk.Caption := 'Save on Run/Debug/Build';
    chk.Checked := (appSettings.Values['save-oncompile'] = '1');
    chk.Hint := 'save-oncompile';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 260;
    chk.Width := 190;
    chk.Caption := 'Show Output only on Error';
    chk.Checked := (appSettings.Values['show-output-onlyon-error'] = '1');
    chk.Hint := 'show-output-onlyon-error';
    chk.OnChange := @evngeneral_OnCheckChange;


    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 10;
    chk.Top := 290;
    chk.Width := 190;
    chk.Caption := 'Warn on Delete';
    chk.Checked := (appSettings.Values['warn-before-delete'] = '1');
    chk.Hint := 'warn-before-delete';
    chk.OnChange := @evngeneral_OnCheckChange;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 210;
    chk.Top := 290;
    chk.Width := 190;
    chk.Caption := 'Remember LA.Account Login';
    chk.Checked := (appSettings.Values['remember-login'] = '1');
    chk.Hint := 'remember-login';
    chk.OnChange := @evngeneral_OnCheckChange;
end;

procedure evngeneral_OnEditChange(Sender: TEdit);
begin
    appSettings.Values[Sender.Hint] := Sender.Text;
end;

procedure evngeneral_OnCheckChange(Sender: TCheckBox);
begin
    if Sender.Checked then
    appSettings.Values[Sender.Hint] := '1'
    else
    appSettings.Values[Sender.Hint] := '0';

    if Sender.Hint = 'show-toolbar' then
    begin
        TMenuItem(MainForm.find('mToolbarCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mToolbarCheck')).Click;
    end;

    if Sender.Hint = 'show-designtoolbar' then
    begin
        TMenuItem(MainForm.find('mDesignerToolbarCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mDesignerToolbarCheck')).Click;
    end;

    if Sender.Hint = 'show-statusbar' then
    begin
        TMenuItem(MainForm.find('mStatusbarCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mStatusbarCheck')).Click;
    end;

    if Sender.Hint = 'show-projectpane' then
    begin
        TMenuItem(MainForm.find('mProjectPaneCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mProjectPaneCheck')).Click;
    end;

    if Sender.Hint = 'show-toolboxpane' then
    begin
        TMenuItem(MainForm.find('mToolboxPaneCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mToolboxPaneCheck')).Click;
    end;

    if Sender.Hint = 'show-objectspane' then
    begin
        TMenuItem(MainForm.find('mObjectsPaneCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mObjectsPaneCheck')).Click;
    end;

    if Sender.Hint = 'show-inspectorpane' then
    begin
        TMenuItem(MainForm.find('mInspectorPaneCheck')).Checked := not Sender.Checked;
        TMenuItem(MainForm.find('mInspectorPaneCheck')).Click;
    end;
end;

//unit constructor
constructor begin end.
