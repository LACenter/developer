////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'newlivenode', 'addlivefiles';

function createAccountLiveCode(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @acntlivecode_OnCreate);
end;

procedure acntlivecode_OnCreate(Sender: TForm);
var
    leftList: TListView;
    rightList: TListView;
    splitter: TSplitter;
    col: TListColumn;
    pan: TPanel;
    sb: TSpeedButton;
    act: TSimpleAction;
begin
    Sender.Color := clForm;

    pan := TPanel.Create(Sender);
    pan.Parent := Sender;
    pan.Align := alTop;
    pan.Height := 32;
    pan.BevelOuter := bvNone;
    pan.BorderSpacing.Top := 5;
    pan.BorderSpacing.Bottom := 2;
    pan.ShowHint := true;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 5;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_newnode');
    sb.Hint := 'Create Live Node';
    sb.OnClick := @acntlivecode_OnCreateNodeClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 35;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete Live Node';
    sb.Name := 'bDelNode';
    sb.Enabled := false;
    sb.OnClick := @acntlivecode_OnDelNodeClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 85;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_addfiles');
    sb.Hint := 'Add Files';
    sb.Name := 'bAddFiles';
    sb.Enabled := false;
    sb.OnClick := @acntlivecode_OnAddFilesClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 115;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_dlfiles');
    sb.Hint := 'Download Files';
    sb.Name := 'bDLFiles';
    sb.Enabled := false;
    sb.OnClick := @acntlivecode_OnDLFilesClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 145;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete Files';
    sb.Name := 'bDelFiles';
    sb.Enabled := false;
    sb.OnClick := @acntlivecode_OnDelFilesClick;

    ///

    leftList := TListView.Create(Sender);
    leftList.Parent := Sender;
    leftList.Align := alLeft;
    leftList.BorderSpacing.Left := 5;
    leftList.BorderSpacing.Bottom := 5;
    leftList.Width := 220;
    leftList.ScrollBars := ssAutoBoth;
    leftList.SmallImages := MainImages;
    leftList.ViewStyle := vsReport;
    leftList.RowSelect := true;
    leftList.ReadOnly := true;
    leftList.OnClick := @acntlivecode_OnLeftChange;
    leftList.Name := 'leftList';

    col := leftList.Columns.Add;
    col.Caption := 'Live Nodes';
    col.Width := 200;

    ///

    splitter := TSplitter.Create(Sender);
    splitter.Parent := Sender;
    splitter.Left := 225;

    ///

    rightList := TListView.Create(Sender);
    rightList.Parent := Sender;
    rightList.Align := alClient;
    rightList.BorderSpacing.Right := 5;
    rightList.BorderSpacing.Bottom := 5;
    rightList.ScrollBars := ssAutoBoth;
    rightList.SmallImages := MainImages;
    rightList.ViewStyle := vsReport;
    rightList.RowSelect := true;
    rightList.ReadOnly := true;
    rightList.OnClick := @acntlivecode_OnRightChange;
    rightList.Name := 'rightList';
    rightList.OnDblClick := @acntlivecode_OnRightDblClick;

    col := rightList.Columns.Add;
    col.Caption := 'File Name';
    col.Width := 390;

    act := TSimpleAction.Create(Sender);
    act.Name := 'actPopulateLiveNodes';
    act.OnExecute := @acntlivecode_PopulateLiveNodes;
end;

procedure acntlivecode_PopulateLiveNodes(Sender: TComponent);
var
    list: TListView;
    str: TStringList;
    item: TListItem;
    i: int;
begin
    TSpeedButton(Sender.Owner.find('bDelNode')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bAddFiles')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bDelFiles')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bDLFiles')).Enabled := false;

    list := TListView(Sender.Owner.find('rightList'));
    list.Items.BeginUpdate;
    list.Items.Clear;
    list.Items.EndUpdate;

    list := TListView(Sender.Owner.find('leftList'));
    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;
    Account.LiveCodeManager.ListLiveNodes(str);
    for i := 0 to str.Count -1 do
    begin
        item := list.Items.Add;
        item.Caption := str.Strings[i];
        item.ImageIndex := 93;
    end;
    str.Free;

    list.Items.EndUpdate;
    acntlivecode_OnRightChange(list);
end;

procedure acntlivecode_OnCreateNodeClick(Sender: TSpeedButton);
begin
    if createNewLiveNode(MainForm, Account.LiveCodeManager,
            nil,
            nil).ShowModal = mrOK then
        acntlivecode_PopulateLiveNodes(Sender);
end;

procedure acntlivecode_OnDelNodeClick(Sender: TSpeedButton);
begin
    if MsgWarning('Warning', 'You are about to delete a Live Node, continue?') then
    begin
        if Account.LiveCodeManager.DeleteLiveNode(TListView(Sender.Owner.find('leftList')).Selected.Caption) then
            acntlivecode_PopulateLiveNodes(Sender);
    end;
end;

procedure acntlivecode_OnAddFilesClick(Sender: TSpeedButton);
begin
    if createAddLiveFiles(MainForm,
            TListView(Sender.Owner.find('leftList')).Selected.Caption,
            'Basic Files (*.vb)|*.vb|C++ Files (*.c++)|*.c++|'+
            'JScript Files (*.js)|*.js|Pascal Files (*.pas)|*.pas',
            Account.LiveCodeManager,
            nil,
            nil).ShowModal = mrOK then
        populateLiveCodeItems(TListView(Sender.Owner.find('rightList')),
                              TListView(Sender.Owner.find('leftList')).Selected.Caption);
end;

procedure acntlivecode_OnDLFilesClick(Sender: TComponent);
var
    dlg: TSaveDialog;
    ext: string;
begin
    ext := FileExtOf(TListView(Sender.Owner.find('rightList')).Selected.Caption);
    dlg := TSaveDialog.Create(MainForm);
    dlg.DefaultExt := ext;
    dlg.Filter := 'Files (*'+ext+')|*'+ext;
    dlg.setProp('Options', 'ofOverwritePrompt,ofEnableSizing,ofViewDetail');
    if dlg.Execute then
        Account.LiveCodeManager.DownloadLiveItem(
            TListView(Sender.Owner.find('leftList')).Selected.Caption,
            TListView(Sender.Owner.find('rightList')).Selected.Caption,
            dlg.FileName);
    dlg.Free;
end;

procedure acntlivecode_OnRightDblClick(Sender: TListView);
begin
    if Sender.Selected <> nil then
        acntlivecode_OnDLFilesClick(Sender);
end;

procedure acntlivecode_OnDelFilesClick(Sender: TSpeedButton);
begin
    if MsgWarning('Warning', 'You are about to delete a Live Node Item, continue?') then
    begin
        if Account.LiveCodeManager.DeleteLiveItem(
            TListView(Sender.Owner.find('leftList')).Selected.Caption,
            TListView(Sender.Owner.find('rightList')).Selected.Caption) then
        TListView(Sender.Owner.find('rightList')).Selected.Delete;
    end;
end;

procedure populateLiveCodeItems(list: TListView; NodeName: string);
var
    i: int;
    str: TStringList;
    item: TListItem;
begin
    if list.Hint = NodeName then exit;

    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;

    Account.LiveCodeManager.ListLiveItems(NodeName, str);
    for i := 0 to str.Count -1 do
    begin
        item := list.Items.Add;
        item.Caption := str.Strings[i];
        item.ImageIndex := 94;
    end;

    str.Free;

    list.Items.EndUpdate;
end;

procedure acntlivecode_OnLeftChange(Sender: TListView);//; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelNode')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
    TSpeedButton(Sender.Owner.find('bAddFiles')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);

    if (Sender.Selected <> nil) and (Sender.Selected.Selected) {and Selected} then
    begin
        populateLiveCodeItems(TListView(Sender.Owner.find('rightList')), Sender.Selected.Caption);
        Sender.Hint := Sender.Selected.Caption;
    end;
end;

procedure acntlivecode_OnRightChange(Sender: TListView);//; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelFiles')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
    TSpeedButton(Sender.Owner.find('bDLFiles')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
end;

//unit constructor
constructor begin end.
