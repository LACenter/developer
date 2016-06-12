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
    liveFileList: TStringList;
    liveNodeName: string;
    liveFilter: string;
    liveCodeManager: TLALiveCodeManager;
    liveResManager: TLALiveResourceManager;
    liveFileManager: TLALiveFileManager;

function createAddLiveFiles(Owner: TForm; nodeName, filter: string; codeMan: TLALiveCodeManager; resMan: TLALiveResourceManager; fileMan: TLALiveFileManager): TForm;
begin
    liveNodeName := nodeName;
    liveFilter := filter;
    liveCodeManager := codeMan;
    liveResManager := resMan;
    liveFileManager := fileMan;
    result := TForm.CreateWithConstructor(Owner, @addlivefiles_OnCreate);
end;

procedure addlivefiles_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bu: TButton;
    list: TListBox;
    cpr: TCircleProgress;
    bp: TButtonPanel;
begin
    liveFileList := TStringList.Create;

    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Add Live Items';
    Sender.Width := 400;
    Sender.Height := 350;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @addlivefiles_OnClose;
    Sender.OnCloseQuery := @addlivefiles_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Left := 20;
    lab.Top := 20;
    lab.Caption := 'Please add files to upload';
    lab.AutoSize := true;

    list := TListBox.Create(Sender);
    list.Parent := Sender;
    list.Left := 20;
    list.Top := 40;
    list.Width := 275;
    list.Height := 240;
    list.Name := 'list';
    list.OnSelectionChange := @addlivefiles_OnListChange;

    bu := TButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := 305;
    bu.Top := 40;
    bu.Width := 75;
    bu.Caption := 'Add';
    bu.Name := 'bAdd';
    bu.OnClick := @addlivefiles_OnAddClick;

    bu := TButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := 305;
    bu.Top := 70;
    bu.Width := 75;
    bu.Caption := 'Remove';
    bu.Name := 'bDel';
    bu.Enabled := false;
    bu.OnClick := @addlivefiles_OnDelClick;


    cpr := TCircleProgress.Create(Sender);
    cpr.Parent := Sender;
    cpr.Left := 305;
    cpr.Width := 75;
    cpr.Height := 75;
    cpr.Top := 205;
    cpr.Color := clForm;
    cpr.ColorInner := clWhite;
    cpr.ColorDoneMin := $0066ff;
    cpr.ColorDoneMax := $0066ff;
    cpr.ColorRemain := clGray;
    cpr.Position := 0;
    cpr.Visible := false;
    cpr.Name := 'progress';


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Upload';
    bp.OKButton.Enabled := false;
end;

procedure addlivefiles_OnListChange(Sender: TListBox; User: boolean);
begin
    TButton(Sender.Owner.find('bDel')).Enabled := (Sender.ItemIndex <> -1);
end;

procedure addlivefiles_OnAddClick(Sender: TButton);
var
    dlg: TOpenDialog;
    i: int;
    list: TListBox;
begin
    list := TListBox(Sender.Owner.find('list'));
    dlg := TOpenDialog.Create(MainForm);
    dlg.Filter := liveFilter;
    dlg.setProp('Options', 'ofAllowMultiSelect,ofEnableSizing,ofViewDetail');
    if dlg.Execute then
    begin
        liveFileList.Assign(dlg.Files);
        for i := 0 to liveFileList.Count -1 do
        begin
            if list.Items.IndexOf(FileNameOf(liveFileList.Strings[i])) = -1 then
                list.Items.Add(FileNameOf(liveFileList.Strings[i]));
        end;
    end;
    dlg.Free;
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled := (list.Items.Count <> 0);
end;

procedure addlivefiles_OnDelClick(Sender: TButton);
var
    i: int;
    list: TListBox;
begin
    list := TListBox(Sender.Owner.find('list'));
    for i := list.Items.Count -1 downto 0 do
    begin
        if list.Selected[i] then
        begin
            list.Items.Delete(i);
            liveFileList.Delete(i);
        end;
    end;
    addlivefiles_OnListChange(list, false);
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled := (list.Items.Count <> 0);
end;

procedure addlivefiles_OnClose(Sender: TForm; Action: TCloseAction);
begin
    liveFileList.Free;
    Action := caFree;
end;

procedure addlivefiles_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    progress: TCircleProgress;
    i: int;
begin
    if Sender.ModalResult = mrOK then
    begin
        progress := TCircleProgress(Sender.find('progress'));
        try
            progress.Show;
            progress.Max := liveFileList.Count;
            for i := 0 to liveFileList.Count -1 do
            begin
                progress.Position := progress.Position + 1;
                progress.Update;
                if liveCodeManager <> nil then
                liveCodeManager.AddLiveItem(liveNodeName, liveFileList.Strings[i]);
                if liveResManager <> nil then
                liveResManager.AddLiveItem(liveNodeName, liveFileList.Strings[i]);
                if liveFileManager <> nil then
                liveFileManager.AddLiveItem(liveNodeName, liveFileList.Strings[i]);
            end;
        except
            progress.Hide;
            CanClose := false;
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

//unit constructor
constructor begin end.
