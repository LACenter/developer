////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'mainimages', 'mainactions', 'mainmenu', 'toolbar',
     'statusbar', 'leftside', 'rightside', 'clienttabs', 'publishproject';

procedure createMainForm();
begin
    mainForm := TForm.CreateWithConstructor(nil, @MainForm_OnCreate);
    mainForm.SetAsMainForm;
end;

procedure MainForm_OnCreate(Sender: TForm);
var
    shape: TShape;
    enableTimer: TTimer;
    publishTimer: TTimer;
begin
    Compiler := TLACompiler.Create(Sender);
    Compiler.OnMessage := @doCompilerMessage;
    Compiler.OnStopped := @doCompilerMessage;
    Compiler.OnTerminated := @doCompilerMessage;
    Compiler.Name := 'Compiler';
        Account := TLAAccount.Create;
        Account.AutoWaitCursor := true;

    Sender.Caption := Application.Title;
    Sender.Width := Screen.Width -200;
    Sender.Height := Screen.Height -200;
    Sender.Left := (Screen.Width div 2) - (Sender.Width div 2);
    Sender.Top := (Screen.Height div 2) - (Sender.Height div 2);
    Sender.Color := clForm;
    Sender.OnCloseQuery := @mainform_CloseQuery;
    Sender.Font.Color := clWindowText;

    Focuser := TEdit.Create(Sender);
    Focuser.Parent := Sender;
    Focuser.Left := -200;
    Focuser.Name := 'Focuser';

    createMainImages(Sender);
    createMainActions(Sender);
    createMainMenu(Sender);
    createToolbar(Sender);
    createStatusBar(Sender);
    createLeftSide(Sender);
    createRightSide(Sender);
    createClientTabs(Sender);

    AfterCloseTimer := TTimer.Create(Sender);
    AfterCloseTimer.Enabled := false;
    AfterCloseTimer.Interval := 100;
    AfterCloseTimer.OnTimer := @mainform_AfterCloseTimer;
    AfterCloseTimer.Name := 'AfterCloseTimer';

    Sender.OnResize := @MainForm_OnResize;
    Sender.OnShow := @MainForm_OnShow;

    enableTimer := TTimer.Create(Sender);
    enableTimer.Enabled := false;
    enableTimer.Interval := 300;
    enableTimer.OnTimer := @mainform_EnableTimer;
    enableTimer.Enabled := true;

    publishTimer := TTimer.Create(Sender);
    publishTimer.Enabled := false;
    publishTimer.Interval := 500;
    publishTimer.Name := 'publishTimer';
    publishTimer.OnTimer := @mainform_PublishTimer;
end;

procedure mainform_PublishTimer(Sender: TTimer);
var
    pf: TForm;
begin
    Sender.Enabled := false;
    pf := createPublishProject(MainForm);
    pf.Show;
    Application.ProcessMessages;
    Compiler.PublishProject(Account, ActiveProject.Values['launcherid'], ActiveProjectFile);
    pf.Free;
end;

procedure mainform_EnableTimer(Sender: TTimer);
begin
    //had to add if statements because in Windows the Menu was Flickering

    if TSpeedButton(MainForm.find('CloseButton')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TSpeedButton(MainForm.find('CloseButton')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actNewUnit')).Enabled <> (ActiveProjectFile <> '') then
        TAction(MainForm.find('actNewUnit')).Enabled := (ActiveProjectFile <> '');

    if TAction(MainForm.find('actAddUnit')).Enabled <> (ActiveProjectFile <> '') then
        TAction(MainForm.find('actAddUnit')).Enabled := (ActiveProjectFile <> '');

    if TAction(MainForm.find('actCreateUnit')).Enabled <> (ActiveProjectFile <> '') then
        TAction(MainForm.find('actCreateUnit')).Enabled := (ActiveProjectFile <> '');

    if TAction(MainForm.find('actCreateForm')).Enabled <> ((ActiveProjectFile <> '') and (Pos('UI (', ActiveProject.Values['type']) > 0)) then
        TAction(MainForm.find('actCreateForm')).Enabled := (ActiveProjectFile <> '') and (Pos('UI (', ActiveProject.Values['type']) > 0);

    if TAction(MainForm.find('actCreateFrame')).Enabled <> ((ActiveProjectFile <> '') and (Pos('UI (', ActiveProject.Values['type']) > 0) and (Pos('(Android', ActiveProject.Values['type']) = 0)) then
        TAction(MainForm.find('actCreateFrame')).Enabled := (ActiveProjectFile <> '') and (Pos('UI (', ActiveProject.Values['type']) > 0) and (Pos('(Android', ActiveProject.Values['type']) = 0);

    if TAction(MainForm.find('actCreateReport')).Enabled <> ((ActiveProjectFile <> '') and (Pos('UI (Advanced', ActiveProject.Values['type']) > 0)) then
        TAction(MainForm.find('actCreateReport')).Enabled := (ActiveProjectFile <> '') and (Pos('UI (Advanced', ActiveProject.Values['type']) > 0);

    if TAction(MainForm.find('actCreateModule')).Enabled <> (ActiveProjectFile <> '') then
        TAction(MainForm.find('actCreateModule')).Enabled := (ActiveProjectFile <> '');

    if TAction(MainForm.find('actRemoveUnit')).Enabled <> ((ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1)) then
        TAction(MainForm.find('actRemoveUnit')).Enabled := (ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1);

    if TAction(MainForm.find('actEditUnit')).Enabled <> ((ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1)) then
        TAction(MainForm.find('actEditUnit')).Enabled := (ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1);

    if TAction(MainForm.find('actRenameUnit')).Enabled <> ((ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1)) then
        TAction(MainForm.find('actRenameUnit')).Enabled := (ActiveProjectFile <> '') and (ProjectTree.Selected <> nil) and (ProjectTree.Selected.Level = 1);

    if TAction(MainForm.find('actSave')).Enabled <> ((ActiveProjectFile <> '') and (Pages.TabCount <> 0) and doIsModified) then
        TAction(MainForm.find('actSave')).Enabled := (ActiveProjectFile <> '') and (Pages.TabCount <> 0) and doIsModified;

    if TAction(MainForm.find('actSaveAll')).Enabled <> ((ActiveProjectFile <> '') and (Pages.TabCount <> 0) and doHasChanges) then
        TAction(MainForm.find('actSaveAll')).Enabled := (ActiveProjectFile <> '') and (Pages.TabCount <> 0) and doHasChanges;

    if TAction(MainForm.find('actClose')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actClose')).Enabled := (Pages.TabCount <> 0);

    if TAction(MainForm.find('actCloseAll')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actCloseAll')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actSelectAll')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actSelectAll')).Enabled := (Pages.TabCount <> 0);

    if TAction(MainForm.find('actBringToFront')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actBringToFront')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actSendToBack')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actSendToBack')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actAlignLeftSides')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1)) then
        TAction(MainForm.find('actAlignLeftSides')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1);

    if TAction(MainForm.find('actAlignRightSides')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1)) then
        TAction(MainForm.find('actAlignRightSides')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1);

    if TAction(MainForm.find('actAlignTopSides')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1)) then
        TAction(MainForm.find('actAlignTopSides')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1);

    if TAction(MainForm.find('actAlignBottomSides')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1)) then
        TAction(MainForm.find('actAlignBottomSides')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count > 1);

    if TAction(MainForm.find('actCenterHorz')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actCenterHorz')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actCenterVert')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actCenterVert')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actSizeControls')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSizeControls')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actMoveControls')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actMoveControls')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actTabOrder')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actTabOrder')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actChangeParent')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actChangeParent')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actDelete')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actDelete')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actSelectContainer')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSelectContainer')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actMoveControlsLeft')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actMoveControlsLeft')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actMoveControlsTop')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actMoveControlsTop')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actMoveControlsRight')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actMoveControlsRight')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actMoveControlsBottom')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0)) then
        TAction(MainForm.find('actMoveControlsBottom')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1) and (doGetActiveDesigner.SelControls.Count <> 0);

    if TAction(MainForm.find('actSizeControlsLeft')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSizeControlsLeft')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actSizeControlsTop')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSizeControlsTop')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actSizeControlsRight')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSizeControlsRight')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actSizeControlsBottom')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1)) then
        TAction(MainForm.find('actSizeControlsBottom')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 1);

    if TAction(MainForm.find('actFind')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actFind')).Enabled := (Pages.TabCount <> 0);

    if TAction(MainForm.find('actFindPrev')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actFindPrev')).Enabled := (Pages.TabCount <> 0);

    if TAction(MainForm.find('actFindNext')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actFindNext')).Enabled := (Pages.TabCount <> 0);

    TAction(MainForm.find('actFindInProject')).Enabled := false;
    TAction(MainForm.find('actFindObject')).Enabled := false;

    if TAction(MainForm.find('actReplace')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actReplace')).Enabled := (Pages.TabCount <> 0);

    TAction(MainForm.find('actReplaceInProject')).Enabled := false;

    if TAction(MainForm.find('actGotoLine')).Enabled <> (Pages.TabCount <> 0) then
        TAction(MainForm.find('actGotoLine')).Enabled := (Pages.TabCount <> 0);

    if TAction(MainForm.find('actRun')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actRun')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actDebugRun')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actDebugRun')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actContinue')).Enabled <> ((ActiveProjectFile <> '') and (Compiler.isRunning) and (stopUnit <> '')) then
        TAction(MainForm.find('actContinue')).Enabled := (ActiveProjectFile <> '') and (Compiler.isRunning) and (stopUnit <> '');

    if TAction(MainForm.find('actStep')).Enabled <> ((ActiveProjectFile <> '') and (Compiler.isRunning) and (stopUnit <> '')) then
        TAction(MainForm.find('actStep')).Enabled := (ActiveProjectFile <> '') and (Compiler.isRunning) and (stopUnit <> '');

    if TAction(MainForm.find('actCompile')).Enabled <> ((ActiveProjectFile <> '') and (Compiler.isRunning)) then
        TAction(MainForm.find('actCompile')).Enabled := (ActiveProjectFile <> '') and (Compiler.isRunning);

    if TAction(MainForm.find('actBuild')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actBuild')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actPublishProject')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actPublishProject')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actRunParams')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actRunParams')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actToggleBreak')).Enabled <> ((Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 0)) then
        TAction(MainForm.find('actToggleBreak')).Enabled := (Pages.TabCount <> 0) and (doGetActiveDesignerActivePage = 0);

    if TAction(MainForm.find('actTodo')).Enabled <> (ActiveProjectFile <> '') then
        TAction(MainForm.find('actTodo')).Enabled := (ActiveProjectFile <> '');

    if TAction(MainForm.find('actTargets')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actTargets')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actResources')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actResources')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if TAction(MainForm.find('actProjectOptions')).Enabled <> ((ActiveProjectFile <> '') and not (Compiler.isRunning)) then
        TAction(MainForm.find('actProjectOptions')).Enabled := (ActiveProjectFile <> '') and not (Compiler.isRunning);

    if (ActiveProjectFile <> '') and (Pages.TabCount <> 0) then
    begin
        if doGetActiveDesignerActivePage = 0 then
        begin
            if TAction(MainForm.find('actUndo')).Enabled <> doGetActiveCodeEditor.CanUndo then
                TAction(MainForm.find('actUndo')).Enabled := doGetActiveCodeEditor.CanUndo;

            if TAction(MainForm.find('actRedo')).Enabled <> doGetActiveCodeEditor.CanRedo then
                TAction(MainForm.find('actRedo')).Enabled := doGetActiveCodeEditor.CanRedo;

            if TAction(MainForm.find('actCut')).Enabled <> (doGetActiveCodeEditor.SelText <> '') then
                TAction(MainForm.find('actCut')).Enabled := (doGetActiveCodeEditor.SelText <> '');

            if TAction(MainForm.find('actCopy')).Enabled <> (doGetActiveCodeEditor.SelText <> '') then
                TAction(MainForm.find('actCopy')).Enabled := (doGetActiveCodeEditor.SelText <> '');

            if TAction(MainForm.find('actPaste')).Enabled <> doGetActiveCodeEditor.canPaste then
                TAction(MainForm.find('actPaste')).Enabled := doGetActiveCodeEditor.canPaste;
        end;
        if doGetActiveDesignerActivePage = 1 then
        begin
            if TAction(MainForm.find('actUndo')).Enabled <> doGetActiveDesigner.CanUndo then
                TAction(MainForm.find('actUndo')).Enabled := doGetActiveDesigner.CanUndo;

            if TAction(MainForm.find('actRedo')).Enabled <> doGetActiveDesigner.CanRedo then
                TAction(MainForm.find('actRedo')).Enabled := doGetActiveDesigner.CanRedo;

            if TAction(MainForm.find('actCut')).Enabled <> (doGetActiveDesigner.SelControls.Count <> 0) then
                TAction(MainForm.find('actCut')).Enabled := (doGetActiveDesigner.SelControls.Count <> 0);

            if TAction(MainForm.find('actCopy')).Enabled <> (doGetActiveDesigner.SelControls.Count <> 0) then
                TAction(MainForm.find('actCopy')).Enabled := (doGetActiveDesigner.SelControls.Count <> 0);

            if TAction(MainForm.find('actPaste')).Enabled <> (DesClip.Count <> 0) then
                TAction(MainForm.find('actPaste')).Enabled := (DesClip.Count <> 0);
        end;
    end
        else
    begin
        if TAction(MainForm.find('actUndo')).Enabled <> false then
            TAction(MainForm.find('actUndo')).Enabled := false;

        if TAction(MainForm.find('actRedo')).Enabled <> false then
            TAction(MainForm.find('actRedo')).Enabled := false;

        if TAction(MainForm.find('actCut')).Enabled <> false then
            TAction(MainForm.find('actCut')).Enabled := false;

        if TAction(MainForm.find('actCopy')).Enabled <> false then
            TAction(MainForm.find('actCopy')).Enabled := false;

        if TAction(MainForm.find('actPaste')).Enabled <> false then
            TAction(MainForm.find('actPaste')).Enabled := false;
    end;

    if TProgressBar(MainForm.find('progress')).Visible <> Compiler.isRunning then
        TProgressBar(MainForm.find('progress')).Visible := Compiler.isRunning;
end;

procedure mainform_AfterCloseTimer(Sender: TTimer);
begin
    Sender.Enabled := false;

    doResetAllPropEditors;

    if (Pages.TabCount = 0) or
       (activePageImg = _CODEPAGE) then
    begin
        //code unit -> clear props, events, and objects
        PropTree.Items.Clear;
        EventTree.Items.Clear;
        ObjectTree.Items.Clear;
        //call repaint to make sure the editor paint is removed
        PropTree.Refresh;
        EventTree.Refresh;
        ObjectTree.Refresh;
        TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text := 'Line/Column: 0/0';
    end;
end;

procedure MainForm_OnResize(Sender: TForm);
var
    statusbar: TStatusBar;
    list: TListView;
begin
    statusbar := TStatusBar(Sender.find('Statusbar'));
    statusbar.Panels.Items[0].Width := Sender.Width - 300;
    statusbar.Panels.Items[1].Width := 150;
    statusbar.Panels.Items[2].Width := 150;

    list := TListView(Sender.find('RecentList'));
    list.Columns[1].Width := list.Width - 230;
end;

procedure MainForm_OnShow(Sender: TForm);
begin
    if appsettings.Values['is-maximized'] = '1' then
        Sender.WindowState := wsMaximized;

    doPopulateRecentList;
end;

procedure mainform_CloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Compiler.isRunning then
        Compiler.Terminate;

    if ActiveProjectFile <> '' then
    begin
        if doHasChanges then
        CanClose := doCloseProject
        else
        CanClose := true;
    end
        else
        CanClose := true;

    if CanClose then
    begin
        if Sender.WindowState = wsMaximized then
            appsettings.Values['is-maximized'] := '1'
        else
            appsettings.Values['is-maximized'] := '0';
        doSaveAppSettings;
    end;
end;

//unit constructor
constructor begin end.
