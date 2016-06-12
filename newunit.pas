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
    newUnitType: int;

function createNewUnitDialog(Owner: TForm; utype: int): TForm;
begin
    newUnitType := utype;
    result := TForm.CreateWithConstructor(Owner, @NewUnit_OnCreate);
end;

procedure NewUnit_OnCreate(Sender: TForm);
var
    image: TImage;
    lab: TLabel;
    bp: TButtonPanel;
    edit: TEdit;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    if newUnitType = _FORMPAGE then
    Sender.Caption := 'Create New Form'
    else if newUnitType = _FRAMEPAGE then
    Sender.Caption := 'Create New Frame'
    else if newUnitType = _REPORTPAGE then
    Sender.Caption := 'Create New Report'
    else if newUnitType = _MODULEPAGE then
    Sender.Caption := 'Create New Module'
    else
    Sender.Caption := 'Create New Unit';
    Sender.Width := 400;
    Sender.Height := 160;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @newunit_OnClose;
    Sender.OnCloseQuery := @newunit_OnCloseQuery;

    if newUnitType = _FORMPAGE then
    ResToFile('png_form', TempDir+'img.png')
    else if newUnitType = _FRAMEPAGE then
    ResToFile('png_frame', TempDir+'img.png')
    else if newUnitType = _REPORTPAGE then
    ResToFile('png_report', TempDir+'img.png')
    else if newUnitType = _MODULEPAGE then
    ResToFile('png_module', TempDir+'img.png')
    else
    ResToFile('png_code', TempDir+'img.png');

    image := TImage.Create(Sender);
    image.Parent := Sender;
    image.Left := 20;
    image.Top := 20;
    image.AutoSize := false;
    image.Width := 32;
    image.Height := 32;
    image.Picture.LoadFromFile(TempDir+'img.png');
    DeleteFile(TempDir+'img.png');

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    if newUnitType = _FORMPAGE then
    lab.Caption := 'Please enter name for the new Form'
    else if newUnitType = _FRAMEPAGE then
    lab.Caption := 'Please enter name for the new Frame'
    else if newUnitType = _REPORTPAGE then
    lab.Caption := 'Please enter name for the new Report'
    else if newUnitType = _MODULEPAGE then
    lab.Caption := 'Please enter name for the new Module'
    else
    lab.Caption := 'Please enter a name for the new Unit';
    lab.AutoSize := true;
    lab.Left := 60;
    lab.Top := 27;
    lab.Font.Style := fsBold;

    edit := TEdit.Create(Sender);
    edit.Parent := Sender;
    edit.Top := 65;
    edit.Left := 20;
    edit.Width := 360;
    edit.Name := 'unitName';
    edit.Text := '';
    edit.OnChange := @newunit_EditChange;

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

procedure newunit_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure newunit_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    uname: string;
    root: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        uname := TEdit(Sender.find('unitName')).Text;
        root := FilePathOf(ActiveProjectFile);
        if doValidateName(uname) then
        begin
            if FileExists(root+uname+'.vb') or
               FileExists(root+uname+'.c++') or
               FileExists(root+uname+'.js') or
               FileExists(root+uname+'.pas') then
            begin
                MsgError('Unit Exists', 'Given name is already used, please enter a new name.');
                CanClose := false;
            end
                else
            begin
                doResetAllPropEditors;

                //code unit -> clear props, events, and objects
                PropTree.Items.Clear;
                EventTree.Items.Clear;
                ObjectTree.Items.Clear;
                //call repaint to make sure the editor paint is removed
                PropTree.Repaint;
                EventTree.Repaint;
                ObjectTree.Repaint;

                //now we can create new item
                doCreateUnit(uname, newUnitType);
            end;
        end
        else
            CanClose := false;
    end;
end;

procedure newunit_EditChange(Sender: TEdit);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).
        OKBUtton.Enabled := (trim(Sender.Text) <> '');
end;

//unit constructor
constructor begin end.
