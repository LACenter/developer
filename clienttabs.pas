////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'codeunit';

procedure createClientTabs(form: TForm);
var
    client, pane, sub, top: TPanel;
    splitter: TSplitter;
    closeB: TSpeedButton;
    img: TImage;
    lab: TBGRALabelFX;
    ll: TLabel;
    link: TUrlLink;
    RecentList: TListView;
    col: TListColumn;
    popup: TPopupMenu;
    menu: TMenuItem;
    bu: TButton;
begin
    client := TPanel.Create(form);
    client.Parent := form;
    client.Name := 'clientPanel';
    client.Align := alClient;
    client.BevelOuter := bvNone;
    client.ParentColor := true;
    client.Caption := '';

    pane := TPanel.Create(form);
    pane.Parent := client;
    pane.Name := 'bottomPanel';
    pane.Align := alBottom;
    pane.BevelOuter := bvNone;
    pane.ParentColor := true;
    pane.height := 80;
    pane.Caption := '';
    pane.BorderSpacing.Bottom := 2;
    pane.Visible := false;
    outputPanel := pane;

    splitter := TSplitter.Create(form);
    splitter.Parent := client;
    splitter.Name := 'bottomSplitter';
    splitter.Align := alBottom;
    splitter.Top := pane.Top;
    splitter.Visible := false;
    bottomOutSplitter := splitter;

    Pages := TATTabs.Create(form);
    Pages.Parent := client;
    Pages.Top := -5;
    Pages.Left := 0;
    Pages.Width := pane.Width;
    Pages.Anchors := akLeft + akTop + akRight;
    Pages.Height := 30;
    Pages.ColorBG := clForm;
    Pages.ColorTabActive := clWindow;
    Pages.ColorTabPassive := clBtnFace;
    Pages.ColorTabOver := clWindow;
    Pages.ColorBorderActive := clSilver;
    Pages.ColorBorderPassive := clSilver;
    Pages.Font.Color := clWindowText;
    Pages.TabShowPlus := false;
    Pages.TabAngle := 5;
    Pages.Images := MainImages;
    Pages.Name := 'Pages';
    Pages.OnTabClick := @clienttabs_TabClick;
    Pages.OnTabClose := @clienttabs_TabClose;
    Pages.Font.Assign(form.Font);
    Pages.TabIndentText := form.Canvas.TextHeight('|') div 4;
    Pages.TabDragEnabled := false;
    Pages.TabDragOutEnabled := false;
    Pages.TabDoubleClickClose := false;

    sub := TPanel.Create(form);
    sub.Parent := pane;
    sub.Align := alClient;
    sub.Name := 'MessagesPanel';
    sub.BevelOuter := bvNone;
    sub.ParentColor := true;
    sub.Caption := '';

    top := TPanel.Create(form);
    top.Parent := sub;
    top.Align := alTop;
    top.Height := form.Canvas.TextHeight('|') + 8;
    top.Alignment := taLeftJustify;
    top.BevelOuter := bvNone;
    top.Name := 'OutputTreePanel';
    top.Caption := ' Output';
    top.Font.Style := fsBold;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := top;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose');
    CloseB.Name := 'OutputTreeClose';
    CloseB.Flat := true;
    CloseB.Hint := 'Close';
    closeB.ShowHint := true;
    closeB.BorderSpacing.Bottom := 2;
    closeB.Width := form.Canvas.TextHeight('|') + 8;
    closeB.OnClick := @clienttabs_OutputPaneCloseClick;

    OutputTree := TTreeView.Create(form);
    OutputTree.Parent := sub;
    OutputTree.Align := alClient;
    OutputTree.ScrollBars := ssAutoBoth;
    OutputTree.Name := 'OutputTree';
    OutputTree.ReadOnly := true;
    OutputTree.RowSelect := true;
    OutputTree.RightClickSelect := true;
    OutputTree.BorderStyle := bsNone;
    OutputTree.ShowRoot := false;
    OutputTree.Images := MainImages;
    OutputTree.OnCustomDrawItem := @clienttabs_OutputTree_OnCustomDrawItem;
    OutputTree.OnDblClick := @clienttabs_OutputTree_OnDblClick;

    clientHost := TPanel.Create(form);
    clientHost.Parent := client;
    clientHost.Name := 'clientHost';
    clientHost.Align := alClient;
    clientHost.BevelOuter := bvNone;
    clientHost.BorderSpacing.Top := 25;
    clientHost.Color := clWindow;
    clientHost.Caption := '';

    ll := TLabel.Create(form);
    ll.Parent := clientHost;
    ll.AutoSize := false;
    ll.Transparent := true;
    ll.Width := 300;
    ll.Height := 25;
    ll.Top := 20;
    ll.Left := clientHost.Width - 325;
    ll.Anchors := akTop + akRight;
    ll.Caption := _APP_NAME+' Account';
    ll.Alignment := taRightJustify;
    ll.Font.Style := fsBold;
    ll.Name := 'LoginLabel';

    bu := TButton.Create(form);
    bu.Parent := clientHost;
    bu.Width := 100;
    bu.Left := clientHost.Width - 125;
    bu.Top := 45;
    bu.Caption := 'Login';
    bu.Name := 'LoginButton';
    bu.Anchors := akRight + akTop;
    bu.Action := TAction(form.find('actLiveApps'));
    bu.Show;

    ResToFile('biglogo', TempDir+'app.png');
    img := TImage.Create(form);
    img.Parent := clientHost;
    img.Picture.LoadFromFile(TempDir+'app.png');
    img.width := 400;
    img.Height := 51;
    img.Stretch := true;
    img.Center := true;
    img.Left := 30;
    img.Top := 20;
    DeleteFile(TempDir+'app.png');

    link := TUrlLink.Create(form);
    link.Parent := clientHost;
    link.Top := 80;
    link.Left := 30;
    link.Caption := _APP_COPYRIGHT+' - '+_APP_WEBSITE;
    link.Link := _APP_WEBSITE;
    link.LinkType := eltWWW;

    link := TUrlLink.Create(form);
    link.Parent := clientHost;
    link.Top := 97;
    link.Left := 30;
    link.Caption := '@: '+_APP_SUPPORT;
    link.Link := _APP_SUPPORT;
    link.LinkType := eltMail;

    ll := TLabel.Create(form);
    ll.Parent := clientHost;
    ll.AutoSize := true;
    ll.Top := 130;
    ll.Left := 30;
    ll.Caption := 'Recent Projects';
    ll.Font.Style := fsBold;
    ll.Font.Size := 14;

    RecentList := TListView.Create(form);
    RecentList.Parent := clientHost;
    RecentList.Align := alClient;
    RecentList.BorderSpacing.Top := 163;
    RecentList.BorderSpacing.Left := 30;
    RecentList.BorderSpacing.Right := 30;
    RecentList.BorderSpacing.Bottom := 30;
    RecentList.ScrollBars := ssAutoBoth;
    RecentList.LargeImages := MainImages32;
    RecentList.SmallImages := MainImages32;
    RecentList.ReadOnly := true;
    RecentList.Name := 'RecentList';
    RecentList.RowSelect := true;
    RecentList.ViewStyle := vsReport;
    RecentList.ColumnClick := false;
    RecentList.ScrollBars := ssAutoVertical;
    RecentList.OnDblClick := @clienttabs_RecentList_DblClick;
    RecentList.OnKeyDown := @clienttabs_RecentList_KeyDown;

    col := RecentList.Columns.Add;
    col.Caption := 'Project Name';
    col.Width := 200;

    col := RecentList.Columns.Add;
    col.Caption := 'Project Type';

    popup := TPopupMenu.Create(form);
    popup.Name := 'RecentPop';
    popup.OnPopup := @clienttabs_OnPopup;

    menu := TMenuItem.Create(form);
    menu.Caption := 'Open Project';
    menu.Name := 'mRecentOpenProject';
    menu.Default := true;
    menu.OnClick := @clienttabs_OpenClick;
    popup.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Caption := '-';
    popup.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Caption := 'Remove from Recent Projects';
    menu.Name := 'mRecentRemoveProject';
    menu.OnClick := @clienttabs_RemoveClick;
    popup.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Caption := 'Clear Recent Projects';
    menu.OnClick := @clienttabs_ClearClick;
    popup.Items.Add(menu);

    RecentList.PopupMenu := popup;
end;

procedure clienttabs_OutputTree_OnDblClick(Sender: TTreeView);
begin
    if Sender.Selected <> nil then
    begin
        if Pos('unit [', Lower(Sender.Selected.Text)) > 0 then
            doCompilerMessage(nil, Sender.Selected.Text);
    end;
end;

procedure clienttabs_OutputTree_OnCustomDrawItem(Sender: TTreeView; Node: TTreeNode;
                    DrawInfo: TCustomDrawInfo; var DefaultDraw: bool);
begin
    if Node <> nil then
    begin
        if Pos('GC-ERROR', Node.Text) > 0 then
        Sender.Canvas.Font.Style := fsBold
        else
        Sender.Canvas.Font.Style := 0;
    end;
end;

procedure clienttabs_OutputPaneCloseClick(Sender: TObject);
begin
    TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
end;

procedure clienttabs_OnPopup(Sender: TPopupMenu);
begin
    TMenuItem(Sender.Owner.find('mRecentOpenProject')).Enabled :=
        (TListView(Sender.Owner.find('RecentList')).SelCount <> 0);
    TMenuItem(Sender.Owner.find('mRecentRemoveProject')).Enabled :=
        (TListView(Sender.Owner.find('RecentList')).SelCount <> 0);
end;

procedure clienttabs_RecentList_KeyDown(Sender: TListView; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 13 then
        if Sender.SelCount <> 0 then
            clienttabs_RecentList_DblClick(Sender);
end;

procedure clienttabs_OpenClick(Sender: TMenuItem);
begin
    clienttabs_RecentList_DblClick(TListView(Sender.Owner.find('RecentList')));
end;

procedure clienttabs_RemoveClick(Sender: TMenuItem);
var
    str: TStringList;
    fname: string;
    i: int;
begin
    str := TStringList.Create;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects') then
        str.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');

    if TListView(Sender.Owner.find('RecentList')).SelCount <> 0 then
        fname := TListView(Sender.Owner.find('RecentList')).Selected.SubItems.Strings[1];

    if fname <> '' then
    begin
        for i := 0 to str.Count - 1 do
        begin
            if str.Strings[i] = fname then
            begin
                str.Delete(i);
                TListView(Sender.Owner.find('RecentList')).Selected.Delete;
                break;
            end;
        end;
    end;

    str.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');
    str.Free;
end;

procedure clienttabs_ClearClick(Sender: TMenuItem);
var
    str: TStringList;
begin
    if doMsgQuestion(MainForm, 'Please Confirm', 'You are about to clear your Recent Projects, continue?') = mrYes then
    begin
        str := TStringList.Create;
        if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects') then
            str.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');

        str.Clear;
        TListView(Sender.Owner.find('RecentList')).Items.Clear;

        str.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');
        str.Free;
    end;
end;

procedure clienttabs_TabClick(Sender: TATTabs);
var
    data: TATTabData;
begin
    data := Sender.GetTabData(Sender.TabIndex);
    TWinControl(data.TabObject).BringToFront;
    TTimer(TForm(data.TabObject).find('focusTimer')).Enabled := true;
    case data.TabImageIndex of
        _CODEPAGE, _MAINPAGE:
            begin
                doResetAllPropEditors;
                TTimer(MainForm.find('AfterCloseTimer')).Enabled := true;
            end;
        _FORMPAGE, _FRAMEPAGE, _REPORTPAGE, _MODULEPAGE:
            begin
                doResetAllPropEditors;
                //form unit -> repopulate props, events and objects
                if doGetActiveDesigner <> nil then
                begin
                    //get filter
                    doGetActiveDesigner.PropertiesFilter := TEditButton(MainForm.find('InspectorSearch')).Text;
                    //populate
                    doGetActiveDesigner.PopulateProperties;
                end;
            end;
    end;
end;

procedure clienttabs_TabClose(Sender: TATTabs; TabIndex: int; var CanClose: bool);
var
    data: TATTabData;
begin
    data := Sender.GetTabData(TabIndex);
    CanClose := codeUnitSave(TForm(data.TabObject), true);
    if CanClose then
    begin
        TForm(data.TabObject).Free;
        TTimer(MainForm.find('AfterCloseTimer')).Enabled := true;
    end;
end;

procedure clienttabs_RecentList_DblClick(Sender: TListView);
var
    CanOpen: bool = false;
begin
    if Sender.SelCount <> 0 then
    begin
        if ActiveProjectFile <> '' then
        begin
            if doMsgQuestion(Mainform, 'Close Project', 'You are about to close current project, continue?') = mrYes then
            CanOpen := doCloseProject
        end
            else
            CanOpen := true;

        if CanOpen then
        begin
            TAction(MainForm.find('actCompile')).Execute;
            doOpenProject(Sender.Selected.SubItems.Strings[1]);
        end;
    end;
end;

//unit constructor
constructor begin end.
