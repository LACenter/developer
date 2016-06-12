////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createRemoveUnit(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @removeunit_OnCreate);
end;

procedure removeunit_OnCreate(Sender: TForm);
var
    img: TImage;
    pan: TPanel;
    lab: TLabel;
    chk: TCheckBox;
    bp: TButtonPanel;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Remove Unit';
    Sender.Width := 400;
    Sender.Height := 300;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @removeunit_OnClose;
    Sender.OnCloseQuery := @removeunit_OnCloseQuery;

    pan := TPanel.Create(Sender);
    pan.Parent := Sender;
    pan.BevelOuter := bvNone;
    pan.Color := clWhite;
    pan.Align := alTop;
    pan.Name := 'panel';
    pan.Caption := '';
    pan.Height := 175;

    img := TImage.Create(Sender);
    img.Parent := pan;
    img.Align := alClient;
    img.Stretch := true;
    ResToFile('bigwarn', TempDir+'tmp.png');
    img.Picture.LoadFromFile(TempDir+'tmp.png');
    DeleteFile(TempDir+'tmp.png');

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.AutoSize := true;
    lab.Top := 185;
    lab.Left := 20;
    lab.Name := 'label';
    lab.Caption := 'You are about to remove a unit, continue?';
    lab.Font.Style := fsBold;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.Left := 20;
    chk.Top := 210;
    chk.Caption := 'Delete physically from disk';
    chk.Name := 'chkdelete';
    chk.Checked := false;
    chk.OnChange := @removeunit_OnCheck;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Remove';
end;

procedure removeunit_OnCheck(Sender: TCheckBox);
begin
    if Sender.Checked then
    begin
        TLabel(Sender.Owner.find('label')).Caption := 'You are about to delete a unit, continue?';
        TPanel(Sender.Owner.find('panel')).Color := $0033ff;
        TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Caption := 'Delete';
    end
        else
    begin
        TLabel(Sender.Owner.find('label')).Caption := 'You are about to remove a unit, continue?';
        TPanel(Sender.Owner.find('panel')).Color := clWhite;
        TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Caption := 'Remove';
    end;
end;

procedure removeunit_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure removeunit_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    i, j: int;
    str: TStringList;
    pfile: string;
begin
    if Sender.ModalResult = mrOK then
    begin
        if isUnitOpen(FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text) then
        begin
            CanClose := false;
            MsgError('Error', 'Can not remove an open unit, please close it first.');
            exit;
        end;

        for i := 0 to ActiveProject.Count -1 do
        begin
            if pos('file='+ProjectTree.Selected.Text, ActiveProject.Strings[i]) > 0 then
            begin
                str := TStringList.Create;
                pfile := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
                if FileExists(pfile) then
                begin
                    str.LoadFromFile(pFile);
                    for j := str.Count -1 downto 0 do
                    begin
                        if Pos(ProjectTree.Selected.Text+'.frm', str.strings[j]) > 0 then
                        begin
                            str.Delete(j);
                            break;
                        end;
                    end;
                    str.SaveToFile(pFile);
                end;
                str.Free;

                ActiveProject.Delete(i);
                ActiveProject.SaveToFile(ActiveProjectFile);
                if TCheckBox(Sender.find('chkdelete')).Checked then
                begin
                    DeleteFile(FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text);
                    DeleteFile(FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text+'.des');
                    DeleteFile(FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text+'.frm');
                end;
                ProjectTree.Selected.Delete;
            end;
        end;
    end;
end;

//unit constructor
constructor begin end.
