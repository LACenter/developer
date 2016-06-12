////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createRenameUnit(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @rename_OnCreate);
end;

procedure rename_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Rename Unit';
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
    Sender.OnClose := @rename_OnClose;
    Sender.OnCloseQuery := @rename_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please enter a new name';
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
    edit.OnChange := @rename_EditChange;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Rename';
    bp.OKButton.Enabled := false;
end;

procedure rename_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure rename_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    oldName, oldS: string;
    ext: string;
    newName, newS: string;
    newFileName: string;
    str: TStringList;
begin
    if Sender.ModalResult = mrOK then
    begin
        oldName := FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text;
        ext := FileExtOf(ProjectTree.Selected.Text);
        newName := FilePathOf(ActiveProjectFile)+Trim(TEdit(Sender.find('eName')).Text)+ext;
        newFileName := newName;

        if doValidateName(TEdit(Sender.find('eName')).Text) then
        begin
            if FileExists(newName) then
            begin
                MsgError('Error', 'Unit already exists, please enter a new name');
                CanClose := false;
                exit;
            end;

            RenameFile(oldName, newName);
            RenameFile(oldName+'.des', newName+'.des');
            RenameFile(oldName+'.frm', newName+'.frm');
            oldName := FileNameOf(oldName);
            newName := FileNameOf(newName);
            ActiveProject.Text := ReplaceOnce(ActiveProject.Text, oldName, newName);
            ProjectTree.Selected.Text := newName;
            ActiveProject.SaveToFile(ActiveProjectFile);

            oldS := copy(oldName, 0, Pos('.', oldName) -1);
            newS := copy(newName, 0, Pos('.', newName) -1);

            str := TStringList.Create;
            str.LoadFromFile(FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile']);
            str.Text := ReplaceOnce(str.Text, oldName+'.frm', newName+'.frm');
            str.Text := ReplaceOnce(str.Text, oldS+'=', newS+'=');
            str.SaveToFile(FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile']);
            str.Free;

            str := TStringList.Create;
            str.LoadFromFile(newFileName);
            str.Text := ReplaceAll(str.Text, oldS, newS);
            str.SaveToFile(newFileName);
            str.Free;
        end
            else
        begin
            CanClose := false;
        end;
    end;
end;

procedure rename_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Trim(TEdit(Sender.Owner.find('eName')).Text) <> '');
end;

//unit constructor
constructor begin end.
