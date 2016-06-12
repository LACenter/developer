////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'about';

procedure createMainMenu(form: TForm);
var
    MainMenu: TMainMenu;
    root, menu, sub: TMenuItem;
begin
    MainMenu := TMainMenu.Create(form);
    MainMenu.Images := MainImages;

    root := TMenuItem.Create(form);
    root.Caption := 'File';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actNewProject'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actOpenProject'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        {menu := TMenuItem.Create(form);
        menu.Caption := 'Recent Projects';
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);}

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actNewUnit'));
        root.Add(menu);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actCreateUnit'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actCreateForm'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actCreateFrame'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actCreateModule'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actCreateReport'));
            menu.Add(sub);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAddUnit'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actEditUnit'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actRenameUnit'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actRemoveUnit'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        //we won't need open for now
        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actOpen'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSave'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSaveAll'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actClose'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCloseAll'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actExit'));
        root.Add(menu);



    root := TMenuItem.Create(form);
    root.Caption := 'Edit';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actUndo'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actRedo'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCut'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCopy'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actPaste'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSelectAll'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSelectContainer'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actBringToFront'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSendToBack'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAlignLeftSides'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAlignRightSides'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAlignTopSides'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAlignBottomSides'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCenterHorz'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCenterVert'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSizeControls'));
        root.Add(menu);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actSizeControlsLeft'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actSizeControlsTop'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actSizeControlsRight'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actSizeControlsBottom'));
            menu.Add(sub);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actMoveControls'));
        root.Add(menu);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actMoveControlsLeft'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actMoveControlsTop'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actMoveControlsRight'));
            menu.Add(sub);

            sub := TMenuItem.Create(form);
            sub.Action := TAction(form.Find('actMoveControlsBottom'));
            menu.Add(sub);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actTabOrder'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actChangeParent'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actDelete'));
        root.Add(menu);



    root := TMenuItem.Create(form);
    root.Caption := 'Search';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actFind'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actFindPrev'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actFindNext'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        {menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actFindInProject'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actFindObject'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);}

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actReplace'));
        root.Add(menu);

        {menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actReplaceInProject'));
        root.Add(menu);}

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actGotoLine'));
        root.Add(menu);


    root := TMenuItem.Create(form);
    root.Caption := 'View';
    root.OnClick := @mainmenu_PopulateSelectUnit;
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Toolbar';
        menu.Checked := true;
        menu.Name := 'mToolbarCheck';
        menu.OnClick := @mainmenu_Toolbar_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+1');
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Designer Toolbar';
        menu.Checked := true;
        menu.Name := 'mDesignerToolbarCheck';
        menu.OnClick := @mainmenu_DesignerToolbar_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+2');
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Statusbar';
        menu.Checked := true;
        menu.Name := 'mStatusbarCheck';
        menu.OnClick := @mainmenu_Statusbar_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+3');
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Project View';
        menu.Checked := true;
        menu.Name := 'mProjectPaneCheck';
        menu.OnClick := @mainmenu_ProjectPane_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+6');
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Toolbox View';
        menu.Checked := true;
        menu.Name := 'mToolboxPaneCheck';
        menu.OnClick := @mainmenu_ToolboxPane_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+7');
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Objects View';
        menu.Checked := true;
        menu.Name := 'mObjectsPaneCheck';
        menu.OnClick := @mainmenu_ObjectsPane_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+8');
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Inspector View';
        menu.Checked := true;
        menu.Name := 'mInspectorPaneCheck';
        menu.OnClick := @mainmenu_InspectorPane_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+9');
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Output Pane';
        menu.Name := 'mOutputPaneCheck';
        menu.OnClick := @mainmenu_OutputPane_Click;
        menu.Shortcut := TextToShortcut('Alt+Shift+0');
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Select Unit';
        menu.Name := 'mSelectUnit';
        root.Add(menu);



    root := TMenuItem.Create(form);
    root.Caption := 'Project';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actRun'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actRunParams'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actDebugRun'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actContinue'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actStep'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCompile'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actToggleBreak'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actResources'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actBuild'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actTargets'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actPublishProject'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actTodo'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actProjectOptions'));
        root.Add(menu);

    root := TMenuItem.Create(form);
    root.Caption := 'Tools';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actEnvironmentOptions'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCodeTemplates'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        {menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actScriptManager'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actExecScript'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actExtTools'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actExecTool'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);}

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSourceBrowser'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSQLDeveloper'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actText'));
        root.Add(menu);

        {menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actStore'));
        root.Add(menu);}

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actLiveApps'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actAccount'));
        root.Add(menu);



    root := TMenuItem.Create(form);
    root.Caption := 'Help';
    MainMenu.Items.Add(root);

        menu := TMenuItem.Create(form);
        menu.Caption := 'Get a LA.Developer Plan';
        menu.onClick := @mainmenu_Subscribe;
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := '-';
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actUserGuide'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actUserGuideDocs'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := '-';
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actQuickRef'));
        root.Add(menu);

                sub := TMenuItem.Create(form);
                sub.Action := TAction(form.Find('actQuickRefCLI'));
                menu.Add(sub);

                sub := TMenuItem.Create(form);
                sub.Action := TAction(form.Find('actQuickRefCGI'));
                menu.Add(sub);

                sub := TMenuItem.Create(form);
                sub.Action := TAction(form.Find('actQuickRefFCGI'));
                menu.Add(sub);

                sub := TMenuItem.Create(form);
                sub.Action := TAction(form.Find('actQuickRefServer'));
                menu.Add(sub);

                sub := TMenuItem.Create(form);
                sub.Action := TAction(form.Find('actQuickRefUI'));
                menu.Add(sub);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);


        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actSupport'));
        root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actLibsDownload'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actProxySetup'));
        root.Add(menu);

            menu := TMenuItem.Create(form); menu.Caption := '-'; root.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Caption := 'About';
        menu.OnClick := @mainmenu_About_Click;
        root.Add(menu);

end;

procedure mainmenu_About_Click(Sender: TMenuItem);
begin
    createAboutDialog(MainForm).ShowModalDimmed;
end;

procedure mainmenu_Toolbar_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    TToolbar(MainForm.Find('ToolBar')).Visible := Sender.Checked;
    if Sender.Checked then
    appSettings.Values['show-toolbar'] := '1'
    else
    appSettings.Values['show-toolbar'] := '0';
end;

procedure mainmenu_DesignerToolbar_Click(Sender: TMenuItem);
var
    i: int;
    data: TATTabData;
begin
    Sender.Checked := not Sender.Checked;

    if Sender.Checked then
    appSettings.Values['show-designtoolbar'] := '1'
    else
    appSettings.Values['show-designtoolbar'] := '0';

    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        TToolbar(TForm(data.TabObject).find('ToolsToolBar')).Visible := Sender.Checked;
        if Sender.Checked then
        TPanel(TForm(data.TabObject).find('HostPanel')).Top := 32
        else
        TPanel(TForm(data.TabObject).find('HostPanel')).Top := 2;
    end;
end;

procedure mainmenu_Statusbar_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    TStatusBar(MainForm.Find('StatusBar')).Visible := Sender.Checked;
    if Sender.Checked then
    appSettings.Values['show-statusbar'] := '1'
    else
    appSettings.Values['show-statusbar'] := '0';
end;

procedure mainmenu_ProjectPane_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    toggleLeftSides;
    if Sender.Checked then
    appSettings.Values['show-projectpane'] := '1'
    else
    appSettings.Values['show-projectpane'] := '0';
end;

procedure mainmenu_ToolboxPane_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    toggleLeftSides;
    if Sender.Checked then
    appSettings.Values['show-toolboxpane'] := '1'
    else
    appSettings.Values['show-toolboxpane'] := '0';
end;

procedure mainmenu_ObjectsPane_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    toggleRightSides;
    if Sender.Checked then
    appSettings.Values['show-objectspane'] := '1'
    else
    appSettings.Values['show-objectspane'] := '0';
end;

procedure mainmenu_InspectorPane_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;
    toggleRightSides;
    if Sender.Checked then
    appSettings.Values['show-inpectorpane'] := '1'
    else
    appSettings.Values['show-inpectorpane'] := '0';
end;

procedure mainmenu_OutputPane_Click(Sender: TMenuItem);
begin
    Sender.Checked := not Sender.Checked;

    if Sender.Checked then
    begin
        outputPanel.Visible := true;
        bottomOutSplitter.Visible := true;
        bottomOutSplitter.Top := outputPanel.Top;
    end
        else
    begin
        outputPanel.Visible := false;
        bottomOutSplitter.Visible := false;
    end;
end;

procedure mainmenu_SelectUnit_OnClick(Sender: TMenuItem);
begin
    Pages.TabIndex := Sender.Tag;
    Sender.Checked := true;
end;

procedure toggleLeftSides();
begin
    if TMenuItem(MainForm.find('mProjectPaneCheck')).Checked and
       TMenuItem(MainForm.find('mToolBoxPaneCheck')).Checked then
    begin
        leftTopPanel.Visible := true;
        leftTopPanel.Align := alTop;
        leftTopPanel.Height := 200;
        leftInSplitter.Visible := true;
        leftInSplitter.Top := 200;
        leftBottomPanel.Visible := true;
        leftBottomPanel.Align := alClient;

        leftPanel.Visible := true;
        leftOutSplitter.Visible := true;
        leftOutSplitter.Left := leftPanel.Width;
    end;
    if TMenuItem(MainForm.find('mProjectPaneCheck')).Checked and
       not TMenuItem(MainForm.find('mToolBoxPaneCheck')).Checked then
    begin
        leftTopPanel.Visible := true;
        leftTopPanel.Align := alClient;
        leftInSplitter.Visible := false;
        leftBottomPanel.Visible := false;

        leftPanel.Visible := true;
        leftOutSplitter.Visible := true;
        leftOutSplitter.Left := leftPanel.Width;
    end;
    if not TMenuItem(MainForm.find('mProjectPaneCheck')).Checked and
       TMenuItem(MainForm.find('mToolBoxPaneCheck')).Checked then
    begin
        leftTopPanel.Visible := false;
        leftInSplitter.Visible := false;
        leftBottomPanel.Visible := true;
        leftBottomPanel.Align := alClient;

        leftPanel.Visible := true;
        leftOutSplitter.Visible := true;
        leftOutSplitter.Left := leftPanel.Width;
    end;
    if not TMenuItem(MainForm.find('mProjectPaneCheck')).Checked and
       not TMenuItem(MainForm.find('mToolBoxPaneCheck')).Checked then
    begin
        leftPanel.Visible := false;
        leftOutSplitter.Visible := false;
    end;
end;

procedure toggleRightSides();
begin
    if TMenuItem(MainForm.find('mObjectsPaneCheck')).Checked and
       TMenuItem(MainForm.find('mInspectorPaneCheck')).Checked then
    begin
        rightTopPanel.Visible := true;
        rightTopPanel.Align := alTop;
        rightTopPanel.Height := 200;
        rightInSplitter.Visible := true;
        rightInSplitter.Top := 200;
        rightBottomPanel.Visible := true;
        rightBottomPanel.Align := alClient;

        rightPanel.Visible := true;
        rightOutSplitter.Visible := true;
        rightOutSplitter.Left := rightPanel.Left;
    end;
    if TMenuItem(MainForm.find('mObjectsPaneCheck')).Checked and
       not TMenuItem(MainForm.find('mInspectorPaneCheck')).Checked then
    begin
        rightTopPanel.Visible := true;
        rightTopPanel.Align := alClient;
        rightInSplitter.Visible := false;
        rightBottomPanel.Visible := false;

        rightPanel.Visible := true;
        rightOutSplitter.Visible := true;
        rightOutSplitter.Left := rightPanel.Left;
    end;
    if not TMenuItem(MainForm.find('mObjectsPaneCheck')).Checked and
       TMenuItem(MainForm.find('mInspectorPaneCheck')).Checked then
    begin
        rightTopPanel.Visible := false;
        rightInSplitter.Visible := false;
        rightBottomPanel.Visible := true;
        rightBottomPanel.Align := alClient;

        rightPanel.Visible := true;
        rightOutSplitter.Visible := true;
        rightOutSplitter.Left := rightPanel.Left;
    end;
    if not TMenuItem(MainForm.find('mObjectsPaneCheck')).Checked and
       not TMenuItem(MainForm.find('mInspectorPaneCheck')).Checked then
    begin
        rightPanel.Visible := false;
        rightOutSplitter.Visible := false;
    end;
end;

procedure mainmenu_PopulateSelectUnit(Sender: TMenuItem);
var
    i: int;
    items, menu: TMenuItem;
    data: TATTabData;
begin
    items := TMenuItem(Sender.Owner.find('mSelectUnit'));
    items.Caption := 'Select Unit <no units open>';
    items.Enabled := false;
    items.Clear;

    for i := 0 to Pages.TabCount -1 do
    begin
        data := Pages.GetTabData(i);
        menu := TMenuItem.Create(MainForm);
        menu.Caption := data.TabCaption;
        menu.setTag(i);
        menu.RadioItem := true;
        menu.GroupIndex := 1;
        if activePageCaption = data.TabCaption then
        menu.Checked := true;
        menu.OnClick := @mainmenu_SelectUnit_OnClick;
        items.Add(menu);
    end;

    if items.Count > 0 then
    begin
        items.Caption := 'Select Unit';
        items.Enabled := true;
    end;
end;

procedure mainmenu_Subscribe(Sender: TMenuItem);
begin
    ShellOpen('https://liveapps.center/pricing/');
end;

//unit constructor
constructor begin end.
