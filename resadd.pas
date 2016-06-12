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
    resaddList: TListView;
    resaddName: string;

function createResAdd(Owner: TForm; list: TListView; resName: string): TForm;
begin
    resaddList := list;
    resaddName := resName;
    result := TForm.CreateWithConstructor(Owner, @resadd_OnCreate);
end;

procedure resadd_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
    editButton: TEditButton;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    if resaddName = '' then
    Sender.Caption := 'Add Resource'
    else
    Sender.Caption := 'Replace Resource';
    Sender.Width := 400;
    Sender.Height := 200;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @resadd_OnClose;
    Sender.OnCloseQuery := @resadd_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    if resaddName = '' then
    lab.Caption := 'Please enter a resource name'
    else
    lab.Caption := 'Resource Name';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 45;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'edit1';
    edit.Text := resaddName;
    if resaddName <> '' then
    edit.Enabled := false;
    edit.OnChange := @resadd_EditChange;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please select a file';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 75;

    editButton := TEditButton.Create(Sender);
    editButton.Parent := Sender;
    editButton.Top := 100;
    editButton.Left := 20;
    editButton.Width := 360;
    editButton.Name := 'edit2';
    editButton.Text := '';
    editButton.DirectInput := false;
    editButton.Button.Caption := '...';
    editButton.OnChange := @resadd_EditChange;
    editButton.OnButtonClick := @resadd_EditClick;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    if resaddName <> '' then
    bp.OKButton.Caption := 'Replace'
    else
    bp.OKButton.Caption := 'Add';
    bp.OKButton.Enabled := false;
end;

procedure resadd_EditClick(Sender: TEditButton);
var
    dlg: TOpenDialog;
begin
    dlg := TOpenDialog.Create(Sender.Owner);
    if dlg.Execute then
        Sender.Text := dlg.FileName;
    dlg.Free;
end;

procedure resadd_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure resadd_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    i: int;
    canAdd: bool = true;
    item: TListItem;
begin
    if Sender.ModalResult = mrOK then
    begin
        for i := 0 to resaddList.Items.Count -1 do
        begin
            if (resaddList.Items.Item[i].Caption = Lower(TEdit(Sender.find('edit1')).Text)) and
               TEdit(Sender.find('edit1')).Enabled then
            begin
                canAdd := false;
                break;
            end;
        end;

        if not doValidateName(TEdit(Sender.find('edit1')).Text) then
        begin
            CanClose := false;
            exit;
        end;

        if canAdd then
        begin
            if TEdit(Sender.find('edit1')).Enabled then
            begin
                item := resaddList.Items.Add;
                item.Caption := Lower(TEdit(Sender.find('edit1')).Text);
                item.SubItems.Add(TEditButton(Sender.find('edit2')).Text);
                item.ImageIndex := 87;
            end
                else
            begin
                item := resaddList.Selected;
                item.SubItems.Strings[0] := TEditButton(Sender.find('edit2')).Text;
            end;
        end
            else
        begin
            CanClose := false;
            MsgError('Error', 'Duplicate resource name. Please enter a new name.');
        end;
    end;
end;

procedure resadd_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (trim(TEdit(Sender.Owner.find('edit1')).Text) <> '') and
        (trim(TEditButton(Sender.Owner.find('edit2')).Text) <> '');
end;

//unit constructor
constructor begin end.
