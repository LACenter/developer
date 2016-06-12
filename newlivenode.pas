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
    nodeCodeManager: TLALiveCodeManager;
    nodeResManager: TLALiveResourceManager;
    nodeFileManager: TLALiveFileManager;

function createNewLiveNode(Owner: TForm; codeMan: TLALiveCodeManager; resMan: TLALiveResourceManager; fileMan: TLALiveFileManager): TForm;
begin
    nodeCodeManager := codeMan;
    nodeResManager := resMan;
    nodeFileManager := fileMan;
    result := TForm.CreateWithConstructor(Owner, @newlivenode_OnCreate);
end;

procedure newlivenode_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Add Live Node';
    Sender.Width := 400;
    Sender.Height := 140;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @newlivenode_OnClose;
    Sender.OnCloseQuery := @newlivenode_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a name for your Live Node';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 40;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'eName';
    edit.Text := '';
    edit.OnChange := @newlivenode_EditChange;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Add';
    bp.OKButton.Enabled := false;
end;

procedure newlivenode_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newlivenode_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        try
            if nodeCodeManager <> nil then
            nodeCodeManager.AddLiveNode(TEdit(Sender.find('eName')).Text);
            if nodeResManager <> nil then
            nodeResManager.AddLiveNode(TEdit(Sender.find('eName')).Text);
            if nodeFileManager <> nil then
            nodeFileManager.AddLiveNode(TEdit(Sender.find('eName')).Text);
        except
            canClose := false;
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure newlivenode_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('eName')).Text) <> '');
end;

//unit constructor
constructor begin end.
