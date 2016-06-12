////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'newstore', 'newapp';

function createStoreManager(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @storemanager_OnCreate);
end;

procedure storemanager_OnCreate(Sender: TForm);
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
    sb.Glyph.LoadFromResource('bmp_newstore');
    sb.Hint := 'Create App-Store';
    sb.OnClick := @storemanager_OnCreateStoreClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 35;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete Store';
    sb.Name := 'bDelStore';
    sb.Enabled := false;
    sb.OnClick := @storemanager_OnDelStoreClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 85;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_newapp');
    sb.Hint := 'Add Application';
    sb.Name := 'bAddApp';
    sb.Enabled := false;
    sb.OnClick := @storemanager_OnAddAppClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 115;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_editapp');
    sb.Hint := 'Edit Application';
    sb.Name := 'bEditApp';
    sb.Enabled := false;
    sb.OnClick := @storemanager_OnEditAppClick;

    sb := TSpeedButton.Create(Sender);
    sb.Parent := pan;
    sb.Width := 30;
    sb.Height := 30;
    sb.Left := 145;
    sb.Top := 1;
    sb.Flat := true;
    sb.Glyph.LoadFromResource('bmp_delete');
    sb.Hint := 'Delete Application';
    sb.Name := 'bDelApp';
    sb.Enabled := false;
    sb.OnClick := @storemanager_OnDelAppClick;

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
    leftList.OnClick := @storemanager_OnLeftChange;
    leftList.Name := 'leftList';

    col := leftList.Columns.Add;
    col.Caption := 'App-Stores';
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
    rightList.OnClick := @storemanager_OnRightChange;
    rightList.Name := 'rightList';
    rightList.OnDblClick := @storemanager_OnRightDblClick;

    col := rightList.Columns.Add;
    col.Caption := 'Application Name';
    col.Width := 390;

    act := TSimpleAction.Create(Sender);
    act.Name := 'actPopulateStore';
    act.OnExecute := @storemanager_PopulateStore;
end;

procedure storemanager_PopulateStore(Sender: TComponent);
var
    list: TListView;
    str: TStringList;
    item: TListItem;
    i: int;
begin
    TSpeedButton(Sender.Owner.find('bDelStore')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bAddApp')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bDelApp')).Enabled := false;
    TSpeedButton(Sender.Owner.find('bEditApp')).Enabled := false;

    list := TListView(Sender.Owner.find('rightList'));
    list.Items.BeginUpdate;
    list.Items.Clear;
    list.Items.EndUpdate;

    list := TListView(Sender.Owner.find('leftList'));
    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;
    Account.AppStoreManager.ListStores(str);
    for i := 0 to str.Count -1 do
    begin
        item := list.Items.Add;
        item.Caption := str.ValueByIndex(i);
        item.SubItems.Insert(0, str.Names[i]);
        item.ImageIndex := 90;
    end;
    str.Free;

    list.Items.EndUpdate;
    storemanager_OnRightChange(list);
end;

procedure storemanager_OnCreateStoreClick(Sender: TSpeedButton);
begin
    if createNewStore(MainForm).ShowModal = mrOK then
        storemanager_PopulateStore(Sender);
end;

procedure storemanager_OnDelStoreClick(Sender: TSpeedButton);
var
    list: TListView;
begin
    list := TListView(Sender.Owner.find('leftList'));
    if MsgWarning('Warning', 'You are about to delete a store, continue?') then
    begin
        try
            Account.AppStoreManager.DeleteStore(StrToInt(list.Selected.SubItems.Strings[0]));
            storemanager_PopulateStore(Sender);
        except
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure storemanager_OnAddAppClick(Sender: TSpeedButton);
var
    list: TListView;
    sID: int;
begin
    list := TListView(Sender.Owner.find('leftList'));
    sID := StrToInt(list.Selected.SubItems.Strings[0]);
    if createNewApp(MainForm, nil, sID).ShowModal = mrOK then
        populateStoreItems(TListView(Sender.Owner.find('rightList')), list);
end;

procedure storemanager_OnEditAppClick(Sender: TComponent);
var
    list: TListView;
    sID: int;
    appDef: TLAAppDefinition;
begin
    list := TListView(Sender.Owner.find('rightList'));
    sID := StrToInt(list.Selected.SubItems.Strings[0]);
    appDef := TLAAppDefinition.Create;
    Account.AppStoreManager.GetApplication(sID, appDef);
    if createNewApp(MainForm, appDef, -1).ShowModal = mrOK then
        populateStoreItems(list, TListView(Sender.Owner.find('leftList')))
    else
        //since not posted appdef is not freed at this point so we have to free it
        appDef.Free;
end;

procedure storemanager_OnRightDblClick(Sender: TListView);
begin
    if Sender.Selected <> nil then
        storemanager_OnEditAppClick(Sender);
end;

procedure storemanager_OnDelAppClick(Sender: TSpeedButton);
var
    list: TListView;
begin
    list := TListView(Sender.Owner.find('rightList'));
    if MsgWarning('Warning', 'You are about to delete an application, continue?') then
    begin
        try
            Account.AppStoreManager.DeleteApplication(StrToInt(list.Selected.SubItems.Strings[0]));
            populateStoreItems(list, TListView(Sender.Owner.find('leftList')));
        except
            MsgError('Error', ExceptionMessage);
        end;
    end;
end;

procedure populateStoreItems(list: TListView; leftList: TListView);
var
    i: int;
    str: TStringList;
    item: TListItem;
    sID: int;
begin
    if list.Hint = leftList.Selected.Caption then exit;

    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;

    sID := StrToInt(leftList.Selected.SubItems.Strings[0]);
    Account.AppStoreManager.ListApplications(sID, str);
    for i := 0 to str.Count -1 do
    begin
        item := list.Items.Add;
        item.Caption := str.ValueByIndex(i);
        item.SubItems.Insert(0, str.Names[i]);
        item.ImageIndex := 95;
    end;

    str.Free;

    list.Items.EndUpdate;
end;

procedure storemanager_OnLeftChange(Sender: TListView);//; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelStore')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
    TSpeedButton(Sender.Owner.find('bAddApp')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);

    if (Sender.Selected <> nil) and (Sender.Selected.Selected) {and Selected} then
    begin
        populateStoreItems(TListView(Sender.Owner.find('rightList')), Sender);
        Sender.Hint := Sender.Selected.Caption;
    end;
end;

procedure storemanager_OnRightChange(Sender: TListView);//; Item: TListItem; const Selected: bool);
begin
    TSpeedButton(Sender.Owner.find('bDelApp')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
    TSpeedButton(Sender.Owner.find('bEditApp')).Enabled := (Sender.Selected <> nil) and (Sender.Selected.Selected);
end;

//unit constructor
constructor begin end.
