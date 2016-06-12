////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

program mainactions;

uses 'globals', 'newproject', 'codeunit', 'newunit', 'removeunit',
    'addunit', 'taborder', 'changeparent', 'finder', 'goto', 'login',
    'runparams', 'account', 'targets', 'todo', 'resman', 'proxy',
    'rename', 'projectoptions', 'envoptions', 'codetpl', 'quickref';

procedure createMainActions(form: TForm);
var
    act: TAction;
begin
    mainActions := TActionList.Create(form);
    mainActions.Images := mainImages;

    act := TAction.Create(form);
    act.Name := 'actNewProject';
    act.Caption := 'New Project';
    act.Hint := act.Caption;
    act.ImageIndex := 0;
    act.ShortCut := TextToShortCut('Ctrl+N');
    act.OnExecute := @mainaction_NewProject_Execute;

    act := TAction.Create(form);
    act.Name := 'actOpenProject';
    act.Caption := 'Open Project...';
    act.Hint := act.Caption;
    act.ImageIndex := 3;
    act.ShortCut := TextToShortCut('Ctrl+O');
    act.OnExecute := @mainaction_OpenProject_Execute;

    act := TAction.Create(form);
    act.Name := 'actNewUnit';
    act.Caption := 'Create Unit';
    act.Hint := act.Caption;
    act.ImageIndex := 28;
    //act.ShortCut := TextToShortCut('Ctrl+Shift+N');
    act.OnExecute := @mainaction_NewUnit_Execute;

    act := TAction.Create(form);
    act.Name := 'actAddUnit';
    act.Caption := 'Add Unit';
    act.Hint := act.Caption;
    act.ImageIndex := 29;
    act.ShortCut := TextToShortCut('Alt+A');
    act.OnExecute := @mainaction_AddUnit_Execute;

        act := TAction.Create(form);
        act.Name := 'actCreateUnit';
        act.Caption := 'Create New Unit';
        act.Hint := act.Caption;
        act.ImageIndex := 1;
        act.ShortCut := TextToShortCut('Alt+U');
        act.OnExecute := @mainaction_CreateUnit_Execute;

        act := TAction.Create(form);
        act.Name := 'actCreateForm';
        act.Caption := 'Create New Form';
        act.Hint := act.Caption;
        act.ImageIndex := 2;
        act.ShortCut := TextToShortCut('Alt+F');
        act.OnExecute := @mainaction_CreateForm_Execute;

    act := TAction.Create(form);
    act.Name := 'actRemoveUnit';
    act.Caption := 'Remove Unit';
    act.Hint := act.Caption;
    act.ImageIndex := 54;
    act.ShortCut := TextToShortCut('Shift+Alt+R');
    act.OnExecute := @mainaction_RemoveUnit_Execute;

    act := TAction.Create(form);
    act.Name := 'actEditUnit';
    act.Caption := 'Edit Unit';
    act.Hint := act.Caption;
    act.ImageIndex := 55;
    act.ShortCut := TextToShortCut('Alt+E');
    act.OnExecute := @mainaction_EditUnit_Execute;

    act := TAction.Create(form);
    act.Name := 'actRenameUnit';
    act.Caption := 'Rename Unit';
    act.Hint := act.Caption;
    act.ImageIndex := 89;
    act.ShortCut := TextToShortCut('Alt+N');
    act.OnExecute := @mainaction_Rename_Execute;

    act := TAction.Create(form);
    act.Name := 'actOpen';
    act.Caption := 'Open File...';
    act.Hint := act.Caption;
    act.ImageIndex := 22;
    act.ShortCut := TextToShortCut('Ctrl+Shift+O');
    act.OnExecute := @mainaction_Open_Execute;

    act := TAction.Create(form);
    act.Name := 'actSave';
    act.Caption := 'Save';
    act.Hint := act.Caption;
    act.ImageIndex := 4;
    act.ShortCut := TextToShortCut('Ctrl+S');
    act.OnExecute := @mainaction_Save_Execute;

    act := TAction.Create(form);
    act.Name := 'actSaveAll';
    act.Caption := 'Save All';
    act.Hint := act.Caption;
    act.ImageIndex := 5;
    act.ShortCut := TextToShortCut('Ctrl+Shift+S');
    act.OnExecute := @mainaction_SaveAll_Execute;

    act := TAction.Create(form);
    act.Name := 'actClose';
    act.Caption := 'Close Page';
    act.Hint := act.Caption;
    act.ImageIndex := 30;
    act.ShortCut := TextToShortCut('Ctrl+Q');
    act.OnExecute := @mainaction_Close_Execute;

    act := TAction.Create(form);
    act.Name := 'actCloseAll';
    act.Caption := 'Close Project';
    act.Hint := act.Caption;
    act.ImageIndex := 31;
    act.ShortCut := TextToShortCut('Ctrl+Shift+Q');
    act.OnExecute := @mainaction_CloseAll_Execute;

    act := TAction.Create(form);
    act.Name := 'actExit';
    act.Caption := 'Exit';
    act.Hint := act.Caption;
    act.ImageIndex := 32;
    act.ShortCut := TextToShortCut('Alt+F4');
    act.OnExecute := @mainaction_Exit_Execute;

    ////////////////////////////////////////////////////////////////////

    act := TAction.Create(form);
    act.Name := 'actUndo';
    act.Caption := 'Undo';
    act.Hint := act.Caption;
    act.ImageIndex := 6;
    act.ShortCut := TextToShortCut('Ctrl+Z');
    act.OnExecute := @mainaction_Undo_Execute;

    act := TAction.Create(form);
    act.Name := 'actRedo';
    act.Caption := 'Redo';
    act.Hint := act.Caption;
    act.ImageIndex := 7;
    act.ShortCut := TextToShortCut('Ctrl+Shift+Z');
    act.OnExecute := @mainaction_Redo_Execute;

    act := TAction.Create(form);
    act.Name := 'actCut';
    act.Caption := 'Cut';
    act.Hint := act.Caption;
    act.ImageIndex := 8;
    act.ShortCut := TextToShortCut('Ctrl+X');
    act.OnExecute := @mainaction_Cut_Execute;

    act := TAction.Create(form);
    act.Name := 'actCopy';
    act.Caption := 'Copy';
    act.Hint := act.Caption;
    act.ImageIndex := 9;
    act.ShortCut := TextToShortCut('Ctrl+C');
    act.OnExecute := @mainaction_Copy_Execute;

    act := TAction.Create(form);
    act.Name := 'actPaste';
    act.Caption := 'Paste';
    act.Hint := act.Caption;
    act.ImageIndex := 10;
    act.ShortCut := TextToShortCut('Ctrl+V');
    act.OnExecute := @mainaction_Paste_Execute;

    act := TAction.Create(form);
    act.Name := 'actSelectAll';
    act.Caption := 'Select All';
    act.Hint := act.Caption;
    act.ImageIndex := 88;
    act.ShortCut := TextToShortCut('Ctrl+A');
    act.OnExecute := @mainaction_SelectAll_Execute;

    act := TAction.Create(form);
    act.Name := 'actBringToFront';
    act.Caption := 'Bring To Front';
    act.Hint := act.Caption;
    act.ImageIndex := 33;
    act.OnExecute := @mainaction_BringToFront_Execute;

    act := TAction.Create(form);
    act.Name := 'actSendToBack';
    act.Caption := 'Send To Back';
    act.Hint := act.Caption;
    act.ImageIndex := 34;
    act.OnExecute := @mainaction_SendToBack_Execute;

    act := TAction.Create(form);
    act.Name := 'actAlignLeftSides';
    act.Caption := 'Align Left Sides';
    act.Hint := act.Caption;
    act.ImageIndex := 35;
    act.OnExecute := @mainaction_AlignLeftSides_Execute;

    act := TAction.Create(form);
    act.Name := 'actAlignRightSides';
    act.Caption := 'Align Right Sides';
    act.Hint := act.Caption;
    act.ImageIndex := 36;
    act.OnExecute := @mainaction_AlignRightSides_Execute;

    act := TAction.Create(form);
    act.Name := 'actAlignTopSides';
    act.Caption := 'Align Top Sides';
    act.Hint := act.Caption;
    act.ImageIndex := 37;
    act.OnExecute := @mainaction_AlignTopSides_Execute;

    act := TAction.Create(form);
    act.Name := 'actAlignBottomSides';
    act.Caption := 'Align Bottom Sides';
    act.Hint := act.Caption;
    act.ImageIndex := 38;
    act.OnExecute := @mainaction_AlignBottomSides_Execute;

    act := TAction.Create(form);
    act.Name := 'actCenterHorz';
    act.Caption := 'Center in Parent Horizontally';
    act.Hint := act.Caption;
    act.ImageIndex := 39;
    act.OnExecute := @mainaction_CenterHorz_Execute;

    act := TAction.Create(form);
    act.Name := 'actCenterVert';
    act.Caption := 'Center in Parent Vertically';
    act.Hint := act.Caption;
    act.ImageIndex := 40;
    act.OnExecute := @mainaction_CenterVert_Execute;

    act := TAction.Create(form);
    act.Name := 'actSizeControls';
    act.Caption := 'Size Controls';
    act.Hint := act.Caption;
    act.ImageIndex := 41;
    act.OnExecute := @mainaction_SizeControls_Execute;

    act := TAction.Create(form);
    act.Name := 'actMoveControls';
    act.Caption := 'Move Controls';
    act.Hint := act.Caption;
    act.ImageIndex := 81;
    act.OnExecute := @mainaction_MoveControls_Execute;

    act := TAction.Create(form);
    act.Name := 'actTabOrder';
    act.Caption := 'Manage Tab Order';
    act.Hint := act.Caption;
    act.ImageIndex := 42;
    act.OnExecute := @mainaction_TabOrder_Execute;

    act := TAction.Create(form);
    act.Name := 'actChangeParent';
    act.Caption := 'Change Control Parent';
    act.Hint := act.Caption;
    act.ImageIndex := 43;
    act.OnExecute := @mainaction_ChangeParent_Execute;

    act := TAction.Create(form);
    act.Name := 'actDelete';
    act.Caption := 'Delete';
    act.Hint := act.Caption;
    act.ImageIndex := 44;
    act.ShortCut := TextToShortCut('Ctrl+Del');
    act.OnExecute := @mainaction_Delete_Execute;

    act := TAction.Create(form);
    act.Name := 'actFind';
    act.Caption := 'Find';
    act.Hint := act.Caption;
    act.ImageIndex := 46;
    act.ShortCut := TextToShortCut('Ctrl+F');
    act.OnExecute := @mainaction_Find_Execute;

    act := TAction.Create(form);
    act.Name := 'actFindPrev';
    act.Caption := 'Find Previous';
    act.Hint := act.Caption;
    act.ImageIndex := 47;
    act.ShortCut := TextToShortCut('F2');
    act.OnExecute := @mainaction_FindPrev_Execute;

    act := TAction.Create(form);
    act.Name := 'actFindNext';
    act.Caption := 'Find Next';
    act.Hint := act.Caption;
    act.ImageIndex := 48;
    act.ShortCut := TextToShortCut('F4');
    act.OnExecute := @mainaction_FindNext_Execute;

    act := TAction.Create(form);
    act.Name := 'actFindInProject';
    act.Caption := 'Find in Project';
    act.Hint := act.Caption;
    act.ImageIndex := 49;
    act.ShortCut := TextToShortCut('Ctrl+F3');
    act.OnExecute := @mainaction_FindInProject_Execute;
    act.Visible := false; //CURRENTLY NOT USED

    act := TAction.Create(form);
    act.Name := 'actFindObject';
    act.Caption := 'Find Object';
    act.Hint := act.Caption;
    act.ImageIndex := 50;
    act.ShortCut := TextToShortCut('Shift+F3');
    act.OnExecute := @mainaction_FindObject_Execute;
    act.Visible := false; //CURRENTLY NOT USED

    act := TAction.Create(form);
    act.Name := 'actReplace';
    act.Caption := 'Replace';
    act.Hint := act.Caption;
    act.ImageIndex := 51;
    act.ShortCut := TextToShortCut('Ctrl+R');
    act.OnExecute := @mainaction_Replace_Execute;

    act := TAction.Create(form);
    act.Name := 'actReplaceInProject';
    act.Caption := 'Replace in Project';
    act.Hint := act.Caption;
    act.ImageIndex := 52;
    act.ShortCut := TextToShortCut('Ctrl+F5');
    act.OnExecute := @mainaction_ReplaceInProject_Execute;
    act.Visible := false; //CURRENTLY NOT USED

    act := TAction.Create(form);
    act.Name := 'actGotoLine';
    act.Caption := 'Go to Line';
    act.Hint := act.Caption;
    act.ImageIndex := 45;
    act.ShortCut := TextToShortCut('F6');
    act.OnExecute := @mainaction_GotoLine_Execute;

    act := TAction.Create(form);
    act.Name := 'actRun';
    act.Caption := 'Run Project';
    act.Hint := act.Caption;
    act.ImageIndex := 23;
    act.ShortCut := TextToShortCut('Ctrl+F9');
    act.OnExecute := @mainaction_Run_Execute;

    act := TAction.Create(form);
    act.Name := 'actDebugRun';
    act.Caption := 'Debug Run Project';
    act.Hint := act.Caption;
    act.ImageIndex := 24;
    act.ShortCut := TextToShortCut('F9');
    act.OnExecute := @mainaction_DebugRun_Execute;

    act := TAction.Create(form);
    act.Name := 'actContinue';
    act.Caption := 'Continue Run';
    act.Hint := act.Caption;
    act.ImageIndex := 82;
    act.ShortCut := TextToShortCut('Shift+F9');
    act.OnExecute := @mainaction_Continue_Execute;

    act := TAction.Create(form);
    act.Name := 'actStep';
    act.Caption := 'Step Source';
    act.Hint := act.Caption;
    act.ImageIndex := 25;
    act.ShortCut := TextToShortCut('F8');
    act.OnExecute := @mainaction_Step_Execute;

    act := TAction.Create(form);
    act.Name := 'actCompile';
    act.Caption := 'Terminate Project';
    act.Hint := act.Caption;
    act.ImageIndex := 26;
    act.ShortCut := TextToShortCut('Ctrl+Shift+F9');
    act.OnExecute := @mainaction_Compile_Execute;

    act := TAction.Create(form);
    act.Name := 'actBuild';
    act.Caption := 'Build Project';
    act.Hint := act.Caption;
    act.ImageIndex := 27;
    act.ShortCut := TextToShortCut('F11');
    act.OnExecute := @mainaction_Build_Execute;

    act := TAction.Create(form);
    act.Name := 'actRunParams';
    act.Caption := 'Run Parameters';
    act.Hint := act.Caption;
    act.ImageIndex := 56;
    act.ShortCut := TextToShortCut('Ctrl+Alt+F9');
    act.OnExecute := @mainaction_RunParams_Execute;

    act := TAction.Create(form);
    act.Name := 'actProjectOptions';
    act.Caption := 'Project Options';
    act.Hint := act.Caption;
    act.ImageIndex := 57;
    act.OnExecute := @mainaction_ProjectOptions_Execute;

    act := TAction.Create(form);
    act.Name := 'actToggleBreak';
    act.Caption := 'Toggle Breakpoint';
    act.Hint := act.Caption;
    act.ImageIndex := 58;
    act.ShortCut := TextToShortCut('F7');
    act.OnExecute := @mainaction_ToggleBreak_Execute;

    act := TAction.Create(form);
    act.Name := 'actEnvironmentOptions';
    act.Caption := 'Environment Options';
    act.Hint := act.Caption;
    act.ImageIndex := 57;
    act.OnExecute := @mainaction_EnvironmentOptions_Execute;

    act := TAction.Create(form);
    act.Name := 'actCodeTemplates';
    act.Caption := 'Code Templates';
    act.Hint := act.Caption;
    act.ImageIndex := 59;
    act.ShortCut := TextToShortCut('Ctrl+K');
    act.OnExecute := @mainaction_CodeTemplates_Execute;

    act := TAction.Create(form);
    act.Name := 'actScriptManager';
    act.Caption := 'Script Manager';
    act.Hint := act.Caption;
    act.ImageIndex := 60;
    act.ShortCut := TextToShortCut('Ctrl+G');
    act.OnExecute := @mainaction_ScriptManager_Execute;
    act.Visible := false;

    act := TAction.Create(form);
    act.Name := 'actExecScript';
    act.Caption := 'Execute Script';
    act.Hint := act.Caption;
    act.ImageIndex := 61;
    act.OnExecute := @mainaction_ExecScript_Execute;
    act.Visible := false;

    act := TAction.Create(form);
    act.Name := 'actSQLDeveloper';
    act.Caption := 'LA.SQL Developer';
    act.Hint := act.Caption;
    act.ImageIndex := 62;
    act.ShortCut := TextToShortCut('Ctrl+Alt+D');
    act.OnExecute := @mainaction_SQLDeveloper_Execute;

    act := TAction.Create(form);
    act.Name := 'actSourceBrowser';
    act.Caption := 'LA.Source Browser';
    act.Hint := act.Caption;
    act.ImageIndex := 104;
    act.ShortCut := TextToShortCut('Ctrl+Alt+B');
    act.OnExecute := @mainaction_SourceBrowser_Execute;

    act := TAction.Create(form);
    act.Name := 'actLibsDownload';
    act.Caption := 'LA.Support Forum';
    act.Hint := act.Caption;
    act.ImageIndex := 105;
    act.ShortCut := TextToShortCut('Shift+F1');
    act.OnExecute := @mainaction_LibsDownload_Execute;

    {act := TAction.Create(form);
    act.Name := 'actStore';
    act.Caption := 'LA.Store';
    act.Hint := act.Caption;
    act.ImageIndex := 63;
    act.ShortCut := TextToShortCut('Ctrl+Alt+S');
    act.OnExecute := @mainaction_Store_Execute;}

    act := TAction.Create(form);
    act.Name := 'actText';
    act.Caption := 'LA.Notepad';
    act.Hint := act.Caption;
    act.ImageIndex := 64;
    act.ShortCut := TextToShortCut('Ctrl+Alt+T');
    act.OnExecute := @mainaction_Text_Execute;

    act := TAction.Create(form);
    act.Name := 'actExtTools';
    act.Caption := 'External Tools Manager';
    act.Hint := act.Caption;
    act.ImageIndex := 65;
    act.ShortCut := TextToShortCut('Ctrl+E');
    act.OnExecute := @mainaction_ExtTools_Execute;
    act.Visible := false;

    act := TAction.Create(form);
    act.Name := 'actExecTool';
    act.Caption := 'Execute Tool';
    act.Hint := act.Caption;
    act.ImageIndex := 66;
    act.OnExecute := @mainaction_ExecTool_Execute;
    act.Visible := false;

    act := TAction.Create(form);
    act.Name := 'actUserGuide';
    act.Caption := 'LA.Center Documentation';
    act.Hint := act.Caption;
    act.ImageIndex := 68;
    act.ShortCut := TextToShortCut('F1');
    act.OnExecute := @mainaction_UserGuide_Execute;

    act := TAction.Create(form);
    act.Name := 'actUserGuideDocs';
    act.Caption := 'Open Class Documentation';
    act.Hint := act.Caption;
    act.ImageIndex := 68;
    act.ShortCut := TextToShortCut('Ctrl+Shift+F1');
    act.OnExecute := @mainaction_UserGuideDocs_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRef';
    act.Caption := 'Quick Reference';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.OnExecute := @mainaction_QuickRef_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRefCLI';
    act.Caption := 'Quick Reference (CLI)';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.ShortCut := TextToShortCut('Alt+1');
    act.OnExecute := @mainaction_QuickRef_CLI_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRefCGI';
    act.Caption := 'Quick Reference (CGI)';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.ShortCut := TextToShortCut('Alt+2');
    act.OnExecute := @mainaction_QuickRef_CGI_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRefFCGI';
    act.Caption := 'Quick Reference (FCGI)';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.ShortCut := TextToShortCut('Alt+3');
    act.OnExecute := @mainaction_QuickRef_FCGI_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRefServer';
    act.Caption := 'Quick Reference (SERVER)';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.ShortCut := TextToShortCut('Alt+4');
    act.OnExecute := @mainaction_QuickRef_SERVER_Execute;

    act := TAction.Create(form);
    act.Name := 'actQuickRefUI';
    act.Caption := 'Quick Reference (UI)';
    act.Hint := act.Caption;
    act.ImageIndex := 67;
    act.ShortCut := TextToShortCut('Alt+5');
    act.OnExecute := @mainaction_QuickRef_UI_Execute;

    act := TAction.Create(form);
    act.Name := 'actSupport';
    act.Caption := 'LA.Support Tickets';
    act.Hint := act.Caption;
    act.ImageIndex := 69;
    act.ShortCut := TextToShortCut('Ctrl+F1');
    act.OnExecute := @mainaction_Support_Execute;

    act := TAction.Create(form);
    act.Name := 'actTodo';
    act.Caption := 'Todo List';
    act.Hint := act.Caption;
    act.ImageIndex := 70;
    act.ShortCut := TextToShortCut('F12');
    act.OnExecute := @mainaction_Todo_Execute;

    act := TAction.Create(form);
    act.Name := 'actTargets';
    act.Caption := 'Select Build Targets';
    act.Hint := act.Caption;
    act.ImageIndex := 71;
    act.ShortCut := TextToShortCut('Ctrl+F11');
    act.OnExecute := @mainaction_Target_Execute;

    act := TAction.Create(form);
    act.Name := 'actLiveApps';
    act.Caption := 'Login';
    act.Hint := act.Caption;
    act.ImageIndex := 72;
    act.ShortCut := TextToShortCut('Ctrl+L');
    act.OnExecute := @mainaction_LiveApps_Execute;
    act.Visible := false;

    act := TAction.Create(form);
    act.Name := 'actCreateFrame';
    act.Caption := 'Create New Frame';
    act.Hint := act.Caption;
    act.ImageIndex := 76;
    act.ShortCut := TextToShortCut('Alt+Shift+F');
    act.OnExecute := @mainaction_CreateFrame_Execute;

    act := TAction.Create(form);
    act.Name := 'actCreateReport';
    act.Caption := 'Create New Report';
    act.Hint := act.Caption;
    act.ImageIndex := 77;
    act.ShortCut := TextToShortCut('Alt+R');
    act.OnExecute := @mainaction_CreateReport_Execute;

    act := TAction.Create(form);
    act.Name := 'actCreateModule';
    act.Caption := 'Create New Module';
    act.Hint := act.Caption;
    act.ImageIndex := 78;
    act.ShortCut := TextToShortCut('Alt+M');
    act.OnExecute := @mainaction_CreateModule_Execute;

    act := TAction.Create(form);
    act.Name := 'actMoveControlsLeft';
    act.Caption := 'Move Controls Left';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Ctrl+Alt+Left')
    else
    act.ShortCut := TextToShortCut('Ctrl+Left');
    act.OnExecute := @mainaction_MoveLeft_Execute;

    act := TAction.Create(form);
    act.Name := 'actMoveControlsTop';
    act.Caption := 'Move Controls Up';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Ctrl+Alt+Up')
    else
    act.ShortCut := TextToShortCut('Ctrl+Up');
    act.OnExecute := @mainaction_MoveTop_Execute;

    act := TAction.Create(form);
    act.Name := 'actMoveControlsRight';
    act.Caption := 'Move Controls Right';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Ctrl+Alt+Right')
    else
    act.ShortCut := TextToShortCut('Ctrl+Right');
    act.OnExecute := @mainaction_MoveRight_Execute;

    act := TAction.Create(form);
    act.Name := 'actMoveControlsBottom';
    act.Caption := 'Move Controls Down';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Ctrl+Alt+Down')
    else
    act.ShortCut := TextToShortCut('Ctrl+Down');
    act.OnExecute := @mainaction_MoveBottom_Execute;

    act := TAction.Create(form);
    act.Name := 'actSizeControlsLeft';
    act.Caption := 'Size Controls Left';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Shift+Alt+Left')
    else
    act.ShortCut := TextToShortCut('Shift+Left');
    act.OnExecute := @mainaction_SizeLeft_Execute;

    act := TAction.Create(form);
    act.Name := 'actSizeControlsTop';
    act.Caption := 'Size Controls Up';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Shift+Alt+Up')
    else
    act.ShortCut := TextToShortCut('Shift+Up');
    act.OnExecute := @mainaction_SizeTop_Execute;

    act := TAction.Create(form);
    act.Name := 'actSizeControlsRight';
    act.Caption := 'Size Controls Right';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Shift+Alt+Right')
    else
    act.ShortCut := TextToShortCut('Shift+Right');
    act.OnExecute := @mainaction_SizeRight_Execute;

    act := TAction.Create(form);
    act.Name := 'actSizeControlsBottom';
    act.Caption := 'Size Controls Down';
    act.Hint := act.Caption;
    if OSX then
    act.ShortCut := TextToShortCut('Shift+Alt+Down')
    else
    act.ShortCut := TextToShortCut('Shift+Down');
    act.OnExecute := @mainaction_SizeBottom_Execute;

    act := TAction.Create(form);
    act.Name := 'actAccount';
    act.Caption := _APP_NAME+' Account';
    act.Hint := act.Caption;
    act.ShortCut := TextToShortCut('Ctrl+Shift+L');
    act.ImageIndex := 85;
    act.OnExecute := @mainaction_Account_Execute;

    act := TAction.Create(form);
    act.Name := 'actResources';
    act.Caption := 'Resource Manager';
    act.Hint := act.Caption;
    act.ShortCut := TextToShortCut('F10');
    act.ImageIndex := 87;
    act.OnExecute := @mainaction_ResourceManager_Execute;

    act := TAction.Create(form);
    act.Name := 'actSelectContainer';
    act.Caption := 'Select Container';
    act.Hint := act.Caption;
    act.ImageIndex := 80;
    act.ShortCut := TextToShortCut('Ctrl+Shift+A');
    act.OnExecute := @mainaction_SelectContainer_Execute;

    act := TAction.Create(form);
    act.Name := 'actProxySetup';
    act.Caption := 'Setup Proxy Server';
    act.Hint := act.Caption;
    act.OnExecute := @mainaction_ProxySetup_Execute;

    act := TAction.Create(form);
    act.Name := 'actPublishProject';
    act.Caption := 'Publish Project';
    act.Hint := act.Caption;
    act.ImageIndex := 96;
    act.ShortCut := TextToShortCut('Shift+F11');
    act.OnExecute := @mainaction_Publish_Execute;
end;

procedure mainaction_ProxySetup_Execute(Sender: TObject);
begin
    createProxy(MainForm).ShowModalDimmed;
end;

procedure mainaction_NewProject_Execute(Sender: TObject);
var
    CanCreate: bool;
begin
    if ActiveProjectFile <> '' then
    begin
        if doMsgQuestion(MainForm, 'Close Project', 'You are about to close current project, continue?') = mrYes then
        CanCreate := doCloseProject
        else
        CanCreate := false;
    end
        else
        CanCreate := true;

    if CanCreate then
    begin
        TAction(MainForm.find('actCompile')).Execute;
        createNewProjectDialog(mainForm).ShowModalDimmed;
    end;
end;

procedure mainaction_OpenProject_Execute(Sender: TObject);
var
    dlg: TOpenDialog;
    CanOpen: bool = false;
begin
    if ActiveProjectFile <> '' then
    begin
        if doMsgQuestion(MainForm, 'Close Project', 'You are about to close current project, continue?') = mrYes then
        CanOpen := doCloseProject
    end
        else
        CanOpen := true;

    if CanOpen then
    begin
        TAction(MainForm.find('actCompile')).Execute;

        dlg := TOpenDialog.Create(mainForm);
        dlg.Filter := _APP_NAME+' Project (*.la-project)|*.la-project';
        dlg.Title := 'Open '+_APP_NAME+' Project';
        if dlg.ExecuteDimmed then
            doOpenProject(dlg.FileName);
        dlg.Free;
    end;
end;

procedure mainaction_Open_Execute(Sender: TObject);
var
    dlg: TOpenDialog;
begin
    dlg := TOpenDialog.Create(mainForm);
    dlg.Title := 'Open File';
    dlg.Filter := 'Supported Files (*.txt;*.sql)|*.txt;*.sql|Text Files (*.txt)|*.txt|SQL Files (*.sql)|*.sql';
    if dlg.ExecuteDimmed then
        doOpenFile(dlg.FileName);
    dlg.Free;
end;

procedure mainaction_NewUnit_Execute(Sender: TObject);
begin
    //dummy event to enable action - dropDownMenu attached
end;

procedure mainaction_AddUnit_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createAddUnit(MainForm).ShowModalDimmed;
end;

procedure mainaction_CreateUnit_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createNewUnitDialog(MainForm, _CODEPAGE).ShowModalDimmed;
end;

procedure mainaction_CreateForm_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createNewUnitDialog(MainForm, _FORMPAGE).ShowModalDimmed;
end;

procedure mainaction_CreateFrame_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createNewUnitDialog(MainForm, _FRAMEPAGE).ShowModalDimmed;
end;

procedure mainaction_CreateReport_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createNewUnitDialog(MainForm, _REPORTPAGE).ShowModalDimmed;
end;

procedure mainaction_CreateModule_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    createNewUnitDialog(MainForm, _MODULEPAGE).ShowModalDimmed;
end;

procedure mainaction_Save_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    doSave;
end;

procedure mainaction_SaveAll_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    doSaveAll;
end;

procedure mainaction_Close_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    doClose;
end;

procedure mainaction_CloseAll_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    doCloseProject;
end;

procedure mainaction_Exit_Execute(Sender: TObject);
begin
    MainForm.Close;
end;

procedure mainaction_RemoveUnit_Execute(Sender: TObject);
begin
    if ActiveProjectFile <> '' then
    begin
        if ProjectTree.Selected <> nil then
        begin
            if ProjectTree.Selected.Level = 1 then
            begin
                createRemoveUnit(MainForm).ShowModalDimmed;
            end;
        end;
    end;
end;

procedure mainaction_Rename_Execute(Sender: TObject);
begin
    if ProjectTree.Selected <> nil then
    begin
        if ProjectTree.Selected.Level = 1 then
        begin
            if not isUnitOpen(FilePathOf(ActiveProjectFile)+ProjectTree.Selected.Text) then
            begin
                createRenameUnit(MainForm).ShowModalDimmed;
            end
                else
                doMsgError(MainForm, 'Unit is open', 'Can not rename a unit that is open. Please close the unit first.');
        end;
    end;
end;

procedure mainaction_EditUnit_Execute(Sender: TObject);
var
    ut: int;
    root: string;
begin
    if ProjectTree.Selected <> nil then
    begin
        Screen.Cursor := crHourGlass;
        Application.ProcessMessages;

        if ProjectTree.Selected.ImageIndex in [_CODEPAGE, _MAINPAGE, _FORMPAGE, _FRAMEPAGE, _REPORTPAGE, _MODULEPAGE] then
        begin
            root := FilePathOf(ActiveProjectFile);
            if not isUnitOpen(root+ProjectTree.Selected.Text) then
            begin
                if ProjectTree.Selected.ImageIndex in [_CODEPAGE, _MAINPAGE] then
                createCodeUnit(mainForm, clientHost, root+ProjectTree.Selected.Text, _CODEPAGE)
                else if ProjectTree.Selected.ImageIndex = _FORMPAGE then
                createCodeUnit(mainForm, clientHost, root+ProjectTree.Selected.Text, _FORMPAGE)
                else if ProjectTree.Selected.ImageIndex = _FRAMEPAGE then
                createCodeUnit(mainForm, clientHost, root+ProjectTree.Selected.Text, _FRAMEPAGE)
                else if ProjectTree.Selected.ImageIndex = _REPORTPAGE then
                createCodeUnit(mainForm, clientHost, root+ProjectTree.Selected.Text, _REPORTPAGE)
                else if ProjectTree.Selected.ImageIndex = _MODULEPAGE then
                createCodeUnit(mainForm, clientHost, root+ProjectTree.Selected.Text, _MODULEPAGE)
            end;
        end;

        Screen.Cursor := crDefault;
        Application.ProcessMessages;
    end;
end;

procedure mainaction_Undo_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.Undo;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        begin
            doGetActiveDesigner.Undo;
            //we need to set document to modified
            codeunit_CodeChange(doGetActiveDesigner);
        end;
        //ignore TEbEdit and TEdit
    end;
end;

procedure mainaction_Redo_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.Redo;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        begin
            doGetActiveDesigner.Redo;
            //we need to set document to modified
            codeunit_CodeChange(doGetActiveDesigner);
        end;
    end;
end;

procedure mainaction_Cut_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.CutToClipboard;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.Cut;
        if MainForm.ActiveControl.ClassName = 'TEbEdit' then
        TEbEdit(MainForm.ActiveControl).CutToClipboard;
        if MainForm.ActiveControl.ClassName = 'TEdit' then
        TEdit(MainForm.ActiveControl).CutToClipboard;
    end;
end;

procedure mainaction_Copy_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.CopyToClipboard;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.Copy;
        if MainForm.ActiveControl.ClassName = 'TEbEdit' then
        TEbEdit(MainForm.ActiveControl).CopyToClipboard;
        if MainForm.ActiveControl.ClassName = 'TEdit' then
        TEdit(MainForm.ActiveControl).CopyToClipboard;
    end;
end;

procedure mainaction_Paste_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.PasteFromClipboard;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.Paste;
        if MainForm.ActiveControl.ClassName = 'TEbEdit' then
        TEbEdit(MainForm.ActiveControl).PasteFromClipboard;
        if MainForm.ActiveControl.ClassName = 'TEdit' then
        TEdit(MainForm.ActiveControl).PasteFromClipboard;
    end;
end;

procedure mainaction_SelectAll_Execute(Sender: TObject);
begin
    if Screen.ActiveForm <> MainForm then exit;

    if MainForm.ActiveControl <> nil then
    begin
        if MainForm.ActiveControl.ClassName = 'TSyntaxMemo' then
        begin
            doGetActiveCodeEditor.SelectAll;
            TTimer(doGetActiveDesigner.Owner.find('CodeCompTimer')).Enabled := false;
            TTimer(doGetActiveDesigner.Owner.find('CodeAssistTimer')).Enabled := false;
        end;
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SelectAllControls;
        if MainForm.ActiveControl.ClassName = 'TEbEdit' then
        TEbEdit(MainForm.ActiveControl).SelectAll;
        if MainForm.ActiveControl.ClassName = 'TEdit' then
        TEdit(MainForm.ActiveControl).SelectAll;
    end;
end;

procedure mainaction_BringToFront_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.BringToFront;
    end;
end;

procedure mainaction_SendToBack_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SendToBack;
    end;
end;

procedure mainaction_AlignLeftSides_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.AlignLeftSides;
    end;
end;

procedure mainaction_AlignRightSides_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.AlignRightSides;
    end;
end;

procedure mainaction_AlignTopSides_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.AlignTopSides;
    end;
end;

procedure mainaction_AlignBottomSides_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.AlignBottomSides;
    end;
end;

procedure mainaction_CenterHorz_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.CenterControlsHorz;
    end;
end;

procedure mainaction_CenterVert_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.CenterControlsVert;
    end;
end;

procedure mainaction_SizeControls_Execute(Sender: TObject);
begin
    //DUMMY
end;

procedure mainaction_MoveControls_Execute(Sender: TObject);
begin
    //DUMMY
end;

procedure mainaction_TabOrder_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    createTabOrder(MainForm, doGetActiveDesigner).ShowModalDimmed;
end;

procedure mainaction_ChangeParent_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    createChangeParent(MainForm, doGetActiveDesigner).ShowModalDimmed;
end;

procedure mainaction_Delete_Execute(Sender: TObject);
var
    canDelete: bool = false;
begin
    if MainForm.ActiveControl <> nil then
    begin
        if appSettings.Values['warn-before-delete'] = '1' then
        begin
            if doMsgWarning(MainForm, 'Warning', 'You are about to delete components, continue?') = mrYes then
            canDelete := true;
        end
            else
            canDelete := true;

        if canDelete then
        begin
            if doGetActiveDesigner <> nil then
                doGetActiveDesigner.DeleteControls;
        end;
    end;
end;

procedure mainaction_Find_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    createFinder(MainForm, false, false).Show;
end;

procedure mainaction_FindPrev_Execute(Sender: TComponent);
begin
    if doGetActiveDesigner <> nil then
    begin
        if (TEditButton(Sender.Owner.find('UnitSearch')).Text <> '') and
           (TEditButton(Sender.Owner.find('UnitSearch')).Text <> '<search>') then
        doGetActiveCodeEditor.SearchFor(
            TEditButton(Sender.Owner.find('UnitSearch')).Text,
            false,
            false,
            true);
    end;
end;

procedure mainaction_FindNext_Execute(Sender: TComponent);
begin
    if doGetActiveDesigner <> nil then
    begin
        if (TEditButton(Sender.Owner.find('UnitSearch')).Text <> '') and
           (TEditButton(Sender.Owner.find('UnitSearch')).Text <> '<search>') then
        doGetActiveCodeEditor.SearchFor(
            TEditButton(Sender.Owner.find('UnitSearch')).Text,
            false,
            false,
            false);
    end;
end;

procedure mainaction_FindInProject_Execute(Sender: TObject);
begin
    //createFinder(MainForm, true, false).Show;
end;

procedure mainaction_FindObject_Execute(Sender: TObject);
begin
    //ShowMessage('mainaction_FindObject_Execute');
end;

procedure mainaction_Replace_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    createFinder(MainForm, false, true).Show;
end;

procedure mainaction_ReplaceInProject_Execute(Sender: TObject);
begin
    //createFinder(MainForm, true, true).Show;
end;

procedure mainaction_GotoLine_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    createGoto(MainForm).ShowModalDimmed;
end;

function selectCompilerLibrary(): TLALibrary;
begin
    if Pos('CLI (', ActiveProject.Values['type']) > 0 then
    result := laCLI
    else if Pos('FCGI (', ActiveProject.Values['type']) > 0 then
    result := laFCGI
    else if Pos('CGI (', ActiveProject.Values['type']) > 0 then
    result := laCGI
    else if Pos('SERVER (', ActiveProject.Values['type']) > 0 then
    result := laSERVER
    else if Pos('UI (Android', ActiveProject.Values['type']) > 0 then
    result := laAndroid
    else if Pos('UI (', ActiveProject.Values['type']) > 0 then
    result := laUI;
end;

procedure mainaction_Run_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if not Compiler.isRunning then
    begin
        if appSettings.Values['show-output-onlyon-error'] = '1' then
        begin
            if TMenuItem(MainForm.find('mOutputPaneCheck')).Checked then
                TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
        end;

        stopUnit := '';
        stopError := false;

        if doGetActiveCodeEditor <> nil then
            doGetActiveCodeEditor.setRunLine(-1);

        if appSettings.Values['save-oncompile'] = '1' then
            TAction(MainForm.find('actSaveAll')).Execute;

        TStatusBar(MainForm.find('Statusbar')).Panels.Items[2].Text := 'Compiler: Run';
        OutputTree.Items.Clear;
        Compiler.RunParams := ActiveProject.Values['runparams'];
        Compiler.UseLibrary := selectCompilerLibrary;
        Compiler.Project := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
        Compiler.Targets := ActiveProject.Values['targets'];
        Compiler.Run;
    end;
end;

procedure mainaction_DebugRun_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if not Compiler.isRunning then
    begin
        if appSettings.Values['show-output-onlyon-error'] = '1' then
        begin
            if TMenuItem(MainForm.find('mOutputPaneCheck')).Checked then
                TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
        end;

        stopUnit := '';
        stopError := false;

        if doGetActiveCodeEditor <> nil then
            doGetActiveCodeEditor.setRunLine(-1);

        if appSettings.Values['save-oncompile'] = '1' then
            TAction(MainForm.find('actSaveAll')).Execute;

        TStatusBar(MainForm.find('Statusbar')).Panels.Items[2].Text := 'Compiler: Debug';
        OutputTree.Items.Clear;
        Compiler.RunParams := ActiveProject.Values['runparams'];
        Compiler.UseLibrary := selectCompilerLibrary;
        Compiler.Project := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
        Compiler.Breakpoints := _Breakpoints.CommaText;
        Compiler.Targets := ActiveProject.Values['targets'];
        Compiler.DebugRun;
    end;
end;

procedure mainaction_Step_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Compiler.isRunning and
       Compiler.DebugMode then
    begin
        stopUnit := '';
        stopError := false;

        if doGetActiveCodeEditor <> nil then
            doGetActiveCodeEditor.setRunLine(-1);

        OutputTree.Items.Clear;
        Compiler.Step;
    end;
end;

procedure mainaction_Continue_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Compiler.isRunning and
       Compiler.DebugMode then
    begin
        stopUnit := '';
        stopError := false;

        if doGetActiveCodeEditor <> nil then
            doGetActiveCodeEditor.setRunLine(-1);

        OutputTree.Items.Clear;
        Compiler.Go;
    end;
end;

procedure mainaction_Compile_Execute(Sender: TObject);
begin
    stopUnit := '';
    stopError := false;

    OutputTree.Items.Clear;

    if doGetActiveCodeEditor <> nil then
            doGetActiveCodeEditor.setRunLine(-1);

    if doGetActiveCodeEditor <> nil then
        doGetActiveCodeEditor.Invalidate;

    if ActiveProjectFile = '' then exit;

    if Compiler.isRunning then
        Compiler.Terminate;
end;

procedure mainaction_Build_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Compiler.Connected then
    begin
        if not Compiler.isRunning then
        begin
            if appSettings.Values['show-output-onlyon-error'] = '1' then
            begin
                if TMenuItem(MainForm.find('mOutputPaneCheck')).Checked then
                    TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
            end;

            stopUnit := '';
            stopError := false;

            if doGetActiveCodeEditor <> nil then
                doGetActiveCodeEditor.setRunLine(-1);

            if appSettings.Values['save-oncompile'] = '1' then
                TAction(MainForm.find('actSaveAll')).Execute;

            TStatusBar(MainForm.find('Statusbar')).Panels.Items[2].Text := 'Compiler: Build';
            OutputTree.Items.Clear;
            Compiler.UseLibrary := selectCompilerLibrary;
            Compiler.Project := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
            Compiler.Targets := ActiveProject.Values['targets'];
            Compiler.Make;
        end;
    end
        else
    begin
        if doMsgQuestion(MainForm, 'Please Confirm', 'You need to login to your '+_APP_NAME+' Account to build your project. Would you like to login now?') = mrYes then
        createLogin(MainForm).ShowModalDimmed;
    end;
end;

procedure mainaction_RunParams_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    createRunParams(MainForm).ShowModalDimmed;
end;

procedure mainaction_ProjectOptions_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    createProjectOptions(MainForm).ShowModalDimmed;
end;

procedure mainaction_ToggleBreak_Execute(Sender: TObject);
begin
    if doGetActiveCodeEditor <> nil then
        CodeUnit_OnGutterClick(doGetActiveCodeEditor, 0, 0, doGetActiveCodeEditor.CaretY);
end;

procedure mainaction_EnvironmentOptions_Execute(Sender: TObject);
begin
    createEnvOptions(MainForm).ShowModalDimmed;
end;

procedure mainaction_CodeTemplates_Execute(Sender: TObject);
begin
    createCodeTemplates(MainForm).ShowModalDimmed;
end;

procedure mainaction_ScriptManager_Execute(Sender: TObject);
begin
    ShowMessage('mainaction_ScriptManager_Execute');
    //Compiler.PublishProject(Account, ActiveProject.Values['launcherid'], ActiveProjectFile);
end;

procedure mainaction_ExecScript_Execute(Sender: TObject);
begin
    //dummy for sub menu
end;

procedure mainaction_LibsDownload_Execute(Sender: TObject);
begin
    if Compiler.Connected then
    begin
        QueMessage('userguide', 'forum|'+Account.SecretKey+'|'+Account.AccountPlan);
        LaunchLiveApplication('LA-8107631057367247193576039', 'Launching LA.Support Forum, please wait...');
    end
        else
    begin
        if doMsgQuestion(MainForm, 'Please Confirm', 'You need to login to your '+_APP_NAME+' Account to select targets for your project. Would you like to login now?') = mrYes then
        createLogin(MainForm).ShowModalDimmed;
    end;
end;

procedure mainaction_SourceBrowser_Execute(Sender: TObject);
begin
    //This will launch LA.Source Browser which is a Live XAP Package App
    LaunchLiveApplication('LA-661447718685525986785557', 'Launching LA.Source Browser, please wait...');
end;

procedure mainaction_SQLDeveloper_Execute(Sender: TObject);
begin
    //This will launch LA.SQL Developer which is a Live XAP Package App
    LaunchLiveApplication('LA-5779545179252997420827008', 'Launching LA.SQL Developer, please wait...');
end;

{procedure mainaction_Store_Execute(Sender: TObject);
begin
    LaunchLiveApplication('LA-77276707399956749708244', 'Launching LA.Store, please wait...');
end;}

procedure mainaction_Text_Execute(Sender: TObject);
begin
    //This will launch LA.Notepad which is a Live Code App
    LaunchLiveApplication('LA-193139295745909146361979', 'Launching LA.Notepad, please wait...');
end;

procedure mainaction_ExtTools_Execute(Sender: TObject);
begin
    ShowMessage('mainaction_ExtTools_Execute');
end;

procedure mainaction_ExecTool_Execute(Sender: TObject);
begin
    //dummy for sub menu
end;

procedure mainaction_QuickRef_Execute(Sender: TObject);
begin
    //dummy for sub menu
end;

procedure mainaction_UserGuide_Execute(Sender: TObject);
begin
    //LaunchLiveApplication('LA-8107631057367247193576039', 'Launching LA.Developer Guide, please wait...');
    ShellOpen('https://liveapps.center/docs/docs.php');
end;

procedure mainaction_UserGuideDocs_Execute(Sender: TObject);
var
    c: string = '';
begin
    if ObjectTree.Selected <> nil then
    begin
        c := TObject(ObjectTree.Selected.Data).ClassName;
    end;

    if c <> '' then
    ShellOpen('https://liveapps.center/docs/'+Lower(c))
    else
    ShellOpen('https://liveapps.center/docs/docs.php');
end;

procedure mainaction_QuickRef_CLI_Execute(Sender: TObject);
begin
    createQuickRef(MainForm, libCLI).Show;
end;

procedure mainaction_QuickRef_CGI_Execute(Sender: TObject);
begin
    createQuickRef(MainForm, libCGI).Show;
end;

procedure mainaction_QuickRef_FCGI_Execute(Sender: TObject);
begin
    createQuickRef(MainForm, libFCGI).Show;
end;

procedure mainaction_QuickRef_SERVER_Execute(Sender: TObject);
begin
    createQuickRef(MainForm, libSERVER).Show;
end;

procedure mainaction_QuickRef_UI_Execute(Sender: TObject);
begin
    createQuickRef(MainForm, libUIAdv).Show;
end;

procedure mainaction_Support_Execute(Sender: TObject);
begin
    if Compiler.Connected then
    begin
        QueMessage('userguide', 'support|'+Account.SecretKey+'|'+Account.AccountPlan);
        LaunchLiveApplication('LA-8107631057367247193576039', 'Launching LA.Support Tickets, please wait...');
    end
        else
    begin
        if doMsgQuestion(MainForm, 'Please Confirm', 'You need to login to your '+_APP_NAME+' Account to select targets for your project. Would you like to login now?') = mrYes then
        createLogin(MainForm).ShowModalDimmed;
    end;
end;

procedure mainaction_Todo_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if todoDialog = nil then
        todoDialog := createTodo(MainForm);
    todoDialog.Show;
end;

procedure mainaction_Target_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Compiler.Connected then
    begin
        createTargets(MainForm).ShowModalDimmed;
    end
        else
    begin
        if doMsgQuestion(MainForm, 'Please Confirm', 'You need to login to your '+_APP_NAME+' Account to select targets for your project. Would you like to login now?') = mrYes then
        createLogin(MainForm).ShowModalDimmed;
    end;
end;

procedure mainaction_LiveApps_Execute(Sender: TObject);
begin
    if Compiler.isRunning then
    begin
        doMsgError(MainForm, 'Error', 'Can not login while project is running or compiling.');
        exit;
    end;

    if Compiler.Connected then
    begin
        Compiler.Logout;
        Account.Disconnect;
        TAction(MainForm.find('actLiveApps')).Caption := 'Login';
        TLabel(MainForm.find('LoginLabel')).Caption := _APP_NAME+' Account';
        TButton(MainForm.find('LoginButton')).Caption := 'Login';
    end
        else
        createLogin(MainForm).ShowModalDimmed;
end;

procedure mainaction_Account_Execute(Sender: TObject);
begin
    if not Compiler.Connected then
        createLogin(MainForm).ShowModalDimmed;

    if Compiler.Connected then
        createAccountDialog(MainForm).ShowModalDimmed;
end;

procedure mainaction_MoveLeft_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.MoveControlsLeft;
    end;
end;

procedure mainaction_MoveTop_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.MoveControlsTop;
    end;
end;

procedure mainaction_MoveRight_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.MoveControlsRight;
    end;
end;

procedure mainaction_MoveBottom_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.MoveControlsBottom;
    end;
end;

procedure mainaction_SizeLeft_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SizeControlsLeft;
    end;
end;

procedure mainaction_SizeTop_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SizeControlsTop;
    end;
end;

procedure mainaction_SizeRight_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SizeControlsRight;
    end;
end;

procedure mainaction_SizeBottom_Execute(Sender: TObject);
begin
    if MainForm.ActiveControl <> nil then
    begin
        if (MainForm.ActiveControl.ClassName = 'TDesigner') or
           (MainForm.ActiveControl.Name = 'ObjectTree') then
        doGetActiveDesigner.SizeControlsBottom;
    end;
end;

procedure mainaction_ResourceManager_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Pos('-WR', ActiveProject.Values['type']) = 0 then
    createResMan(MainForm).ShowModalDimmed
    else
    doMsgError(MainForm, 'Error', 'Can not initialize Resource Manager in a WR (Without Resources) Project');
end;

procedure mainaction_SelectContainer_Execute(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.SelectForm;
end;

procedure mainaction_Publish_Execute(Sender: TObject);
begin
    if ActiveProjectFile = '' then exit;

    if Compiler.Connected then
    begin
        if Trim(ActiveProject.Values['launcherid']) <> '' then
        begin
            if doMsgQuestion(MainForm, 'Publish Project', 'You are about to publish your project, continue?') = mrYes then
                TTimer(MainForm.find('PublishTimer')).Enabled := true
        end
        else
            doMsgError(MainForm, 'Error', 'Please specify the Launcher ID in the Project Options dialog to publish this project.');
    end
        else
    begin
        if doMsgQuestion(MainForm, 'Please Confirm', 'You need to login to your '+_APP_NAME+' Account to publish your project. Would you like to login now?') = mrYes then
        createLogin(MainForm).ShowModalDimmed;
    end;
end;

//unit constructor
constructor begin end.
