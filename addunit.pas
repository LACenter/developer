////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createAddUnit(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @addunit_OnCreate);
end;

procedure addunit_OnCreate(Sender: TForm);
var
    img: TImage;
    pan: TPanel;
    lab: TLabel;
    chk: TCheckBox;
    bp: TButtonPanel;
    edit: TEditButton;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Add Unit';
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
    Sender.OnClose := @addunit_OnClose;
    Sender.OnCloseQuery := @addunit_OnCloseQuery;

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
    ResToFile('addunits', TempDir+'tmp.png');
    img.Picture.LoadFromFile(TempDir+'tmp.png');
    DeleteFile(TempDir+'tmp.png');

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.AutoSize := true;
    lab.Top := 185;
    lab.Left := 20;
    lab.Name := 'label';
    lab.Caption := 'Select below the unit you would like to add to the project.';
    lab.Font.Style := fsBold;

    edit := TEditButton.Create(Sender);
    edit.Parent := Sender;
    edit.Left := 20;
    edit.Top := 210;
    edit.Width := 360;
    edit.Button.Caption := '...';
    edit.DirectInput := false;
    edit.Name := 'filename';
    edit.Text := '';
    edit.OnButtonClick := @addunit_ButtonClick;
    edit.OnChange := @addunit_EditChange;

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

procedure addunit_ButtonClick(Sender: TEditButton);
var
    dlg: TOpenDialog;
    filter: string;
begin
    if ActiveProject.Values['language'] = 'C++' then
    filter := 'Source Files (*.c++)|*.c++'
    else if ActiveProject.Values['language'] = 'Basic' then
    filter := 'Source Files (*.vb)|*.vb'
    else if ActiveProject.Values['language'] = 'JScript' then
    filter := 'Source Files (*.js)|*.js'
    else if ActiveProject.Values['language'] = 'Pascal' then
    filter := 'Source Files (*.pas)|*.pas';

    dlg := TOpenDialog.Create(MainForm);
    dlg.Title := 'Select Unit';
    dlg.Filter := filter;
    if dlg.Execute then
        Sender.Text := dlg.FileName;
    dlg.Free;
end;

procedure addunit_EditChange(Sender: TEditButton);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).
        OKButton.Enabled := (trim(Sender.Text) <> '');
end;

procedure addunit_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure addunit_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    fname: string;
    fullname: string;
    str: TStringList;
    ftype: int;
begin
    if Sender.ModalResult = mrOK then
    begin
        fullname := TEditButton(Sender.find('filename')).Text;
        fname := FileNameOf(TEditButton(Sender.find('filename')).Text);

        if FilePathOf(ActiveProjectFile)+fname = fullname then
        begin
            MsgError('Error', 'Can not add a source file that is already in the project.');
            CanClose := false;
            exit;
        end;

        if FileExists(FilePathOf(ActiveProjectFile)+fname) then
        begin
            MsgError('Error', 'Unit already exists, please rename source file and all associated designer/form files.');
            CanClose := false;
            exit;
        end;

        //we need to find out what type of file we are adding
        ftype := _CODEPAGE;
        str := TStringList.Create;
        if FileExists(fullname+'.des') and
           FileExists(fullname+'.frm') then
        begin
            str.LoadFromFile(fullname+'.frm');
            if Pos('TForm', str.Text) > 0 then
            ftype := _FORMPAGE;
            if Pos('TFrame', str.Text) > 0 then
            ftype := _FRAMEPAGE;
            if Pos('TDataModule', str.Text) > 0 then
            ftype := _MODULEPAGE;
            if Pos('TReport', str.Text) > 0 then
            ftype := _REPORTPAGE;
            CopyFile(fullname+'.des', FilePathOf(ActiveProjectFile)+fname+'.des');
            CopyFile(fullname+'.frm', FilePathOf(ActiveProjectFile)+fname+'.frm');

            doAddFormResource(fname+'.frm');
        end;
        str.Free;
        CopyFile(fullname, FilePathOf(ActiveProjectFile)+fname);
        ActiveProject.Add(IntToStr(ftype)+'file='+fname);
        ActiveProject.SaveToFile(ActiveProjectFile);
        doPopulateProjectTree;
    end;
end;

//unit constructor
constructor begin end.
