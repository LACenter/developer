////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

//globals is included from toolstoolbar
uses 'toolstoolbar', 'addcontrol', 'quickref';

var
    codeUnitFile: string;
    codeUnitType: int;

function createCodeUnit(Owner: TForm; parent: TWinControl; fileName: string = ''; unitType: int): TForm;
begin
    codeUnitType := unitType;
    codeUnitFile := fileName;
    result := TForm.CreateWithConstructor(Owner, @CodeUnit_OnCreate);
    result.BorderStyle := fbsNone; //important! form will be used as control
    result.Color := clWindow;
    result.Parent := parent;
    result.Align := alClient;
    result.BorderSpacing.Top := 8;
    result.Show;
end;

procedure CodeUnit_OnCreate(Sender: TForm);
var
    //code editor
    CodeEdit: TSyntaxMemo;
    //form designer
    RealForm: TComponent;
    Designer: TDesigner;
    scroll: TScrollBox;
    hostPanel: TPanel;
    formTop, formLeft, formRight, formBottom, min, max, close, menuPanel: TPanel;
    formCap: TLabel;
    tools: TPanel;
    //rest
    i: int;
    tabs: TATTabs;
    fname: string;
    vars: TVars; //form variables
    imgBook: TImageList;
    focusTimer: TTimer;
    AddUndoTimer: TTimer;
    DesignerError: TTimer;
    DesignerPop: TPopupMenu;
    EditorPop: TPopupMenu;
    menu: TMenuItem;
    CodeCompTimer: TTimer;
    CodeAssistTimer: TTimer;
begin
    vars := TVars.Create(Sender);
    vars.Name := 'Vars';

    imgBook := TImageList.Create(Sender);
    imgBook.Name := 'imgBookmarks';
    imgBook.AddFromResource('b0', clBlack);
    imgBook.AddFromResource('b1', clBlack);
    imgBook.AddFromResource('b2', clBlack);
    imgBook.AddFromResource('b3', clBlack);
    imgBook.AddFromResource('b4', clBlack);
    imgBook.AddFromResource('b5', clBlack);
    imgBook.AddFromResource('b6', clBlack);
    imgBook.AddFromResource('b7', clBlack);
    imgBook.AddFromResource('b8', clBlack);
    imgBook.AddFromResource('b9', clBlack);
    imgBook.AddFromResource('break', clBlack);
    imgBook.AddFromResource('step2', clFuchsia);

    focusTimer := TTimer.Create(Sender);
    focusTimer.Enabled := false;
    focusTimer.Interval := 200;
    focusTimer.OnTimer := @codeunit_FocusTimer;
    focusTimer.Enabled := true;
    focusTimer.Name := 'focusTimer';

    AddUndoTimer := TTimer.Create(Sender);
    AddUndoTimer.Enabled := false;
    AddUndoTimer.Interval := 2500;
    AddUndoTimer.OnTimer := @codeunit_AddUndoTimer;
    AddUndoTimer.Name := 'AddUndoTimer';

    DesignerError := TTimer.Create(Sender);
    DesignerError.Enabled := false;
    DesignerError.Interval := 250;
    DesignerError.OnTimer := @codeunit_DesignerError;
    DesignerError.Name := 'DesignerError';

    CodeCompTimer := TTimer.Create(Sender);
    CodeCompTimer.Enabled := false;
    CodeCompTimer.Interval := StrToIntDef(appsettings.Values['editor-CodeCompletionTimer'], 1000);
    CodeCompTimer.OnTimer := @codeunit_OnCodeCompleteTimer;
    CodeCompTimer.Enabled := false;
    CodeCompTimer.Name := 'CodeCompTimer';

    CodeAssistTimer := TTimer.Create(Sender);
    CodeAssistTimer.Enabled := false;
    CodeAssistTimer.Interval := StrToIntDef(appsettings.Values['editor-CodeAssistantTimer'], 1000);
    CodeAssistTimer.OnTimer := @codeunit_OnCodeAssistTimer;
    CodeAssistTimer.Enabled := false;
    CodeAssistTimer.Name := 'CodeAssistTimer';

    CodeEdit := TSyntaxMemo.Create(Sender);
    CodeEdit.Parent := Sender;
    CodeEdit.Align := alClient;
    CodeEdit.BorderStyle := bsNone;
    CodeEdit.Name := 'Editor';
    CodeEdit.Text := '';
    CodeEdit.BorderSpacing.Left := 8;
    CodeEdit.BorderSpacing.Right := 8;
    CodeEdit.BorderSpacing.Bottom := 4;
    CodeEdit.onChange := @codeunit_CodeChange;
    //CodeEdit.OnKeyUp := @CodeUnit_OnKeyUp;
    CodeEdit.OnKeyDown := @CodeUnit_OnKeyDown;
    CodeEdit.OnSpecialLineColors := @CodeUnit_OnSpecialLineColors;
    CodeEdit.OnMouseDown := @CodeUnit_OnMouseDown;
    CodeEdit.OnGutterClick := @CodeUnit_OnGutterClick;
    CodeEdit.OnKeyPress := @codeUnit_OnKeyPress;
    CodeEdit.OnDragOver := @codeunit_DragOver;
    CodeEdit.OnDragDrop := @codeunit_DragDrop;
    CodeEdit.setBookmarkImages(imgBook);
    CodeEdit.setCodeLibrary(_LIB);      //needed for code assistant
    CodeEdit.OnMouseLink := @codeedit_OnMouseLink;
    CodeEdit.OnClickLink := @codeedit_OnClickLink;

    scroll := TScrollBox.Create(Sender);
    scroll.Parent := Sender;
    scroll.Align := alClient;
    scroll.BorderStyle := bsNone;
    scroll.Color := clWindow;
    scroll.Name := 'Scroll';
    scroll.visible := false;
    scroll.BorderSpacing.Left := 8;
    scroll.BorderSpacing.Right := 8;
    scroll.BorderSpacing.Bottom := 4;

    tools := TPanel.Create(Sender);
    tools.Parent := scroll;
    tools.Align := alTop;
    tools.Height := 28;
    tools.BevelOuter := bvNone;
    tools.ParentColor := true;

    hostPanel := TPanel.Create(Sender);
    hostPanel.Parent := scroll;
    hostPanel.Top := 32;
    hostPanel.Left := 0;
    hostPanel.Width := 301;
    hostPanel.Height := 251;
    hostPanel.BevelOuter := bvNone;
    hostPanel.Color := clForm;
    hostPanel.Name := 'HostPanel';
    hostPanel.Caption := '';

    CreateToolsToolbar(Sender, tools);

    formTop := TPanel.Create(Sender);
    formTop.Parent := hostPanel;
    formTop.Align := alTop;
    formTop.BevelOuter := bvNone;
    formTop.Color := $555555;
    formTop.Height := 30;
    formTop.OnClick := @codeunit_formFocusClick;
    formTop.Name := 'formTop'; //IMPORTANT - do not change name used by Designer to adjust Form Height
    formTop.Caption := '';

    formCap := TLabel.Create(Sender);
    formCap.Parent := formTop;
    formCap.Align := alLeft;
    formCap.BorderSpacing.Left := 10;
    formCap.Layout := tlCenter;
    formCap.Name := 'formCap';
    formCap.Transparent := true;
    formCap.AutoSize := true;
    formCap.Caption := '';
    formCap.Font.Color := clWhite;
    formCap.Font.Style := fsBold;
    formCap.OnClick := @codeunit_formFocusClick;

    menuPanel := TPanel.Create(Sender);
    menuPanel.Parent := hostPanel;
    menuPanel.Align := alTop;
    menuPanel.Height := GetSystemMetrics(15) -2;
    menuPanel.BevelOuter := bvNone;
    menuPanel.Color := clMenuBar;
    menuPanel.Visible := false;
    menuPanel.Top := 40;
    menuPanel.Caption := 'Click here to edit MainMenu...';
    menuPanel.Name := 'menuPanel';
    menuPanel.Cursor := crHandPoint;
    menuPanel.Font.Color := clGrayText;
    menuPanel.OnClick := @codeunit_OnMenuPanelClick;

    formLeft := TPanel.Create(Sender);
    formLeft.Parent := menuPanel;
    formLeft.Align := alLeft;
    formLeft.BevelOuter := bvNone;
    formLeft.Color := $555555;
    formLeft.Width := 3;

    formRight := TPanel.Create(Sender);
    formRight.Parent := menuPanel;
    formRight.Align := alRight;
    formRight.BevelOuter := bvNone;
    formRight.Color := $555555;
    formRight.Width := 3;

    formLeft := TPanel.Create(Sender);
    formLeft.Parent := hostPanel;
    formLeft.Align := alLeft;
    formLeft.BevelOuter := bvNone;
    formLeft.Color := $555555;
    formLeft.Width := 3;
    formLeft.OnClick := @codeunit_formFocusClick;

    formRight := TPanel.Create(Sender);
    formRight.Parent := hostPanel;
    formRight.Align := alRight;
    formRight.BevelOuter := bvNone;
    formRight.Color := $555555;
    formRight.Width := 3;
    formRight.OnClick := @codeunit_formFocusClick;

    formBottom := TPanel.Create(Sender);
    formBottom.Parent := hostPanel;
    formBottom.Align := alBottom;
    formBottom.BevelOuter := bvNone;
    formBottom.Color := $555555;
    formBottom.Height := 3;
    formBottom.OnClick := @codeunit_formFocusClick;

    min := TPanel.Create(Sender);
    min.Parent := formTop;
    min.BevelOuter := bvNone;
    min.Align := alRight;
    min.Caption := '_';
    min.Color := $cccccc;
    min.Font.Color := clWhite;
    min.Font.Style := fsBold;
    min.Width := 45;
    min.BorderSpacing.Top := 3;
    min.BorderSpacing.Bottom := 3;
    min.BorderSpacing.Left := 3;
    min.OnClick := @codeunit_formFocusClick;
    min.name := 'formmin';

    max := TPanel.Create(Sender);
    max.Parent := formTop;
    max.BevelOuter := bvNone;
    max.Align := alRight;
    max.Caption := '□';
    max.Color := $cccccc;
    max.Font.Color := clWhite;
    max.Font.Style := fsBold;
    max.Width := 45;
    max.BorderSpacing.Top := 3;
    max.BorderSpacing.Bottom := 3;
    max.BorderSpacing.Left := 3;
    max.OnClick := @codeunit_formFocusClick;
    max.name := 'formmax';

    close := TPanel.Create(Sender);
    close.Parent := formTop;
    close.BevelOuter := bvNone;
    close.Align := alRight;
    close.BorderSpacing.Around := 3;
    close.Caption := 'X';
    close.Color := $5555ff;
    close.Font.Color := clWhite;
    close.Font.Style := fsBold;
    close.Width := 45;
    close.OnClick := @codeunit_formFocusClick;
    close.name := 'formclose';

    tabs := TATTabs.Create(Sender);
    tabs.Parent := Sender;
    tabs.Align := alBottom;
    tabs.Height := 30;
    tabs.TabBottom := true;
    tabs.ColorBG := clForm;
    tabs.ColorTabActive := clWindow;
    tabs.ColorTabPassive := clBtnFace;
    tabs.ColorTabOver := clWindow;
    tabs.ColorBorderActive := clSilver;
    tabs.ColorBorderPassive := clSilver;
    tabs.Font.Color := clWindowText;
    tabs.TabShowPlus := false;
    tabs.TabAngle := 5;
    tabs.TabShowMenu := false;
    tabs.Images := MainImages;
    tabs.TabShowClose := tbShowNone;
    tabs.TabWidthMax := 100;
    tabs.Name := 'CodePage';
    tabs.OnTabClick := @codeUnit_TabClick;
    tabs.Font.Assign(MainForm.Font);
    tabs.TabIndentText := MainForm.Canvas.TextHeight('|') div 4;
    tabs.TabDragEnabled := false;
    tabs.TabDoubleClickClose := false;

    //this is the real form
    if (codeUnitType = _FORMPAGE) and (Pos('(Android', ActiveProject.Values['type']) > 0) then
    begin
        RealForm := TAForm.Create(Sender);
        hostPanel.Width := 306;
        hostPanel.Height := 406;
        TAForm(RealForm).Width := 300;
        TAForm(RealForm).Height := 400;
        max.Hide;
        min.Hide;
        close.Hide;
        formCap.Hide;
        formTop.Height := 3;
    end
    else if codeUnitType = _FORMPAGE then
    begin
        RealForm := TForm.Create(Sender);
        TForm(RealForm).Color := clForm;
        TForm(RealForm).Width := hostPanel.Width - formLeft.Width - formRight.Width;
        TForm(RealForm).Height := hostPanel.Height - formTop.Height - formBottom.Height;
        TForm(RealForm).Caption := 'FORM';
        TForm(RealForm).Position := poScreenCenter;
    end
    else if codeUnitType = _FRAMEPAGE then
    begin
        RealForm := TFrame.Create(Sender);
        TFrame(RealForm).Color := clForm;
        TFrame(RealForm).Width := hostPanel.Width - formLeft.Width - formRight.Width;
        TFrame(RealForm).Height := hostPanel.Height - formTop.Height - formBottom.Height;
        TFrame(RealForm).Caption := 'FRAME';
        max.Hide;
        min.Hide;
        close.Hide;
        formCap.Hide;
        formTop.Height := 3;
    end
    else if codeUnitType = _REPORTPAGE then
    begin
        RealForm := TReport.Create(Sender);
        TReport(RealForm).Color := clWhite;
        max.Hide;
        min.Hide;
        close.Hide;
        formCap.Hide;
        formTop.Height := 3;
    end
    else if codeUnitType = _MODULEPAGE then
    begin
        RealForm := TDataModule.Create(Sender);
        max.Hide;
        min.Hide;
        close.Hide;
        formCap.Hide;
        formTop.Height := 3;
    end
        else
        RealForm := TDataModule.Create(Sender);

    Designer := TDesigner.Create(Sender);       //designer control
    Designer.Parent := hostPanel;
    Designer.Align := alClient;
    Designer.ScrollBox := scroll;
    Designer.HostPanel := hostPanel;
    Designer.Color := clForm;
    Designer.RealForm := RealForm;              //important! link RealForm
    Designer.ToolboxTree := ToolboxTree;        //important! link Toolbox Tree
    Designer.SetClipboard(DesClip);             //important! link Clipborad
    Designer.PropertiesTree := PropTree;        //important! link Properties Tree
    Designer.EventsTree := EventTree;           //important! link Events Tree
    Designer.ObjectsTree := ObjectTree;         //important! link Objects Tree
    Designer.ControlImgIndex := _CONTROLIMG;    //important! set image index for controls
    Designer.ObjectImgIndex := _OBJECTIMG;      //important! set image index for objects
    Designer.setLibrary(_LIB);                  //important! link Library
    Designer.PropertiesFilter := '';
    Designer.PropertiesFilterEmptyString := '<search>';     //important!
    Designer.ObjectsFilterEmptyString := '<search>';    //important!
    Designer.OnToolboxDragOver := @codeunit_OnToolboxDragOver;
    Designer.OnToolboxDragDrop := @codeunit_OnToolboxDragDrop;
    Designer.OnToolboxClick := @codeunit_OnToolboxDragDrop;
    Designer.OnSelectionChanged := @codeunit_OnSelectionChanged;
    Designer.OnModified := @codeunit_OnModified;
    Designer.OnEventDeclared := @codeunit_OnEventDeclared;
    Designer.OnPopulateProperty := @codeunit_OnPopulateProperty;
    Designer.OnSelectEditor := @codeunit_OnSelectEditor;
    Designer.OnPaste := @codeunit_OnPaste;
    Designer.OnCanPaste := @codeunit_OnCanPaste;
    Designer.OnRenameComponent := @codeunit_OnRenameComponent;
    Designer.OnRightClick := @codeunit_OnRightClick;
    Designer.OnCreateEvent := @codeunit_OnCreateEvent;
    Designer.Name := 'Designer';
    Designer.Caption := '';
    Designer.CreateTObjectEvents := (appSettings.Values['create-TObject-events'] = '1');
    Designer.CacheDir := UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'Cache';

    DesignerPop := TPopupMenu.Create(Sender);
    DesignerPop.Name := 'DesignerPop';
    DesignerPop.Images := MainImages;

    if codeUnitType = _MODULEPAGE then
    begin
        Designer.Color := clWhite;
        hostPanel.Width := 251;
        hostPanel.Height := 251;
    end;

    //variables for the live time of the form
    fname := FileNameOf(codeUnitFile);
    fname := copy(fname, 0, Pos(FileExtOf(fname), fname) -1);
    vars.SetVar('fullfilename', codeUnitFile);
    vars.SetVar('pagetype', codeUnitType);
    vars.SetVar('fileext', FileExtOf(codeUnitFile));
    vars.SetVar('filename', fname);
    CodeEdit.Hint := FilePathOf(codeUnitFile);

    RealForm.Name := fname+'_'+DateFormat('yyyymmddhhnnsszzz', now);

    //load code and designer
    if FileExists(codeUnitFile) then
        codeEdit.Lines.LoadFromFile(codeUnitFile);
    if FileExists(codeUnitFile+'.des') and
       FileExists(codeUnitFile+'.frm') then
    begin
        Designer.LoadFromFile(codeUnitFile); //load designer
        //make sure to name the designer after loading it
        Designer.Name := 'Designer';    //important! do not rename
        Designer.Caption := '';
    end
        else
    begin
        if codeUnitType in [_FORMPAGE, _FRAMEPAGE, _REPORTPAGE, _MODULEPAGE] then
        begin
            Designer.CacheDir := '';
            Designer.SaveToFile(codeUnitFile);  //save designer
            Designer.LoadFromFile(codeUnitFile); //re-load designer - !important
            Designer.CacheDir := UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'Cache';
            //make sure to name the designer after loading it
            Designer.Name := 'Designer';    //important! do not rename
            Designer.Caption := '';
        end;
    end;

    if Designer.RealForm.ClassName = 'TForm' then
    begin
        min.Visible := ((biMinimize and TForm(Designer.RealForm).BorderIcons) <> 0);
        max.Visible := ((biMaximize and TForm(Designer.RealForm).BorderIcons) <> 0);
        close.Visible := ((biSystemMenu and TForm(Designer.RealForm).BorderIcons) <> 0);
        formCap.Caption := TForm(Designer.RealForm).Caption;
    end;

    //link custompaint controls
    for i := 0 to Designer.ComponentCount -1 do
    begin
        if Designer.Components[i].ClassName = 'TDesignerControl' then
        begin
            if (TDesignerControl(Designer.Components[i]).RealClassName = 'TDTAnalogClock') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TDTThemedClock') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TDTThemedGauge') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TBubbleShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TCircleProgress') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TCircleShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TEllipseShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'THexagonShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TOctagonShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TParallelShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TPentagonShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRectShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRectangleShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRoundRectShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRoundSquareShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TShapeProgress') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TSquareShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TStarShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TTrapezShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TTriangleShape') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TArrow') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TATTabs') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TECProgressBar') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TECSlider') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TECRuler') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TECSwitch') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TCalendar') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TDBCalendar') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TBarCode') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TDBBarCode') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRLBarcode') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TAAnalogClock') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TASwitchButton') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TARatingBar') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TADigitalClock') or
               (TDesignerControl(Designer.Components[i]).RealClassName = 'TRLDBBarcode') then
            begin
                TDesignerControl(Designer.Components[i]).OnCustomPaint := @doCustomControlPaint;
            end;
        end;
    end;

    doLoadEditorSettings(CodeEdit);
    doLoadDesignerSettings(Designer);

    if codeUnitType = _REPORTPAGE then
    begin
        hostPanel.Width := TReport(RealForm).Report.Width + 6;
        hostPanel.Height := TReport(RealForm).Report.Height + 6;
        hostPanel.Color := $f9f9f9;
        Designer.GridColor := $cccccc;
        Designer.Color := TReport(RealForm).Report.Color;
        //set the page margins
        Designer.BorderSpacing.Left := Round(TReport(RealForm).Report.Margins.LeftMargin) * 4 +
                                       Round(TReport(RealForm).Report.InsideMargins.LeftMargin) * 4;
        Designer.BorderSpacing.Top := Round(TReport(RealForm).Report.Margins.TopMargin) * 4 +
                                      Round(TReport(RealForm).Report.InsideMargins.TopMargin) * 4;
        Designer.BorderSpacing.Right := Round(TReport(RealForm).Report.Margins.RightMargin) * 4 +
                                        Round(TReport(RealForm).Report.InsideMargins.RightMargin) * 4;
        Designer.BorderSpacing.Bottom := Round(TReport(RealForm).Report.Margins.BottomMargin) * 4  +
                                         Round(TReport(RealForm).Report.InsideMargins.BottomMargin) * 4;
        Designer.MarginColor := clBlue;
        Designer.GridXLineSize := 40;
        Designer.GridYLineSize := 40;
        Designer.ShowGridLines := true;
        Designer.ShowMargin := true;
        Designer.MarginLeft := 0;
        Designer.MarginTop := 0;
        Designer.MarginRight := 0;
        Designer.MarginBottom := 0;
    end;

    //activate designer
    Designer.DesignerActive := true;

    if Designer.RealForm.ClassName = 'TForm' then
        menuPanel.Visible := (TForm(Designer.RealForm).Menu <> nil);

    //set Author and Date
    if fname <> 'codeunit' then
    begin
        CodeEdit.Text := ReplaceAll(CodeEdit.Text, '[AUTHOR]', appSettings.Values['author']);
        CodeEdit.Text := ReplaceAll(CodeEdit.Text, '[DATE]', DateFormat(appSettings.Values['dateformat'], Now));
        CodeEdit.Text := ReplaceAll(CodeEdit.Text, '[UNIT]', fname);
    end;

    if CodeEdit.Lines.Count <> 0 then
    begin
        if (Lower(vars.asString('fileext')) = '.pas') or
           (Pos('dialect pascal', Lower(CodeEdit.Lines.Strings[0])) > 0) then
        begin
            codeEdit.SyntaxStyle := stsPascal;
            CodeEdit.TemplateList.Assign(pasCodeTemplates);
            codeEdit.CompletionList.AddStrings(pasCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.c++') or
           (Pos('dialect c++', Lower(CodeEdit.Lines.Strings[0])) > 0) then
        begin
            codeEdit.SyntaxStyle := stsCPP;
            CodeEdit.TemplateList.Assign(cppCodeTemplates);
            codeEdit.CompletionList.AddStrings(cppCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.js') or
           (Pos('dialect jscript', Lower(CodeEdit.Lines.Strings[0])) > 0) then
        begin
            codeEdit.SyntaxStyle := stsJScript;
            CodeEdit.TemplateList.Assign(jsCodeTemplates);
            codeEdit.CompletionList.AddStrings(jsCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.vb') or
           (Pos('dialect basic', Lower(CodeEdit.Lines.Strings[0])) > 0) then
        begin
            codeEdit.SyntaxStyle := stsBasic;
            CodeEdit.TemplateList.Assign(vbCodeTemplates);
            codeEdit.CompletionList.AddStrings(vbCodeTemplates);
        end;
    end
        else
    begin
        if (Lower(vars.asString('fileext')) = '.pas') then
        begin
            codeEdit.SyntaxStyle := stsPascal;
            CodeEdit.TemplateList.Assign(pasCodeTemplates);
            codeEdit.CompletionList.AddStrings(pasCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.c++') then
        begin
            codeEdit.SyntaxStyle := stsCPP;
            CodeEdit.TemplateList.Assign(cppCodeTemplates);
            codeEdit.CompletionList.AddStrings(cppCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.js') then
        begin
            codeEdit.SyntaxStyle := stsJScript;
            CodeEdit.TemplateList.Assign(jsCodeTemplates);
            codeEdit.CompletionList.AddStrings(jsCodeTemplates);
        end else
        if (Lower(vars.asString('fileext')) = '.vb') then
        begin
            codeEdit.SyntaxStyle := stsBasic;
            CodeEdit.TemplateList.Assign(vbCodeTemplates);
            codeEdit.CompletionList.AddStrings(vbCodeTemplates);
        end;
    end;

    CodeEdit.Lines.SaveToFile(codeUnitFile);
    vars.SetVar('modified', false);

    //Highlight Words
    codeEdit.Highlighter.Classes.Text := Upper(libClassList.Text);
    codeEdit.Highlighter.Constants.Text := Upper(libMethodList.Text);

    //Completion
    //keywords are added when the SyntaxStyle changes
    //add classlist
    codeEdit.CompletionList.AddStrings(libClassList);
    //add methodlist
    codeEdit.CompletionList.AddStrings(libMethodList);

    tabs.AddTab(0, 'Code', CodeEdit, _CODEPAGE);        //code editor
    if codeUnitType in [_FORMPAGE, _FRAMEPAGE, _MODULEPAGE, _REPORTPAGE] then
        tabs.AddTab(1, 'Designer', Scroll, codeUnitType);   //form designer

    if codeUnitFile = '' then
        Pages.AddTab(Pages.TabCount, 'Untitled', Sender, codeUnitType)
    else
        Pages.AddTab(Pages.TabCount, fname, Sender, codeUnitType);
    Pages.TabIndex := Pages.TabCount -1;

    AddUndoTimer.Enabled := true;

    for i := 0 to _Breakpoints.Count -1 do
    begin
        if Pos(fname+'@', _Breakpoints.Strings[i]) > 0 then
        CodeEdit.AddBreakPoint(
            StrToIntDef(
                copy(_Breakpoints.Strings[i],
                     Pos('@', _Breakpoints.Strings[i]) +1, 100), 0));
    end;

    EditorPop := TPopupMenu.Create(Sender);
    EditorPop.Images := MainImages;

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actUndo'));
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actRedo'));
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := '-';
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actCut'));
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actCopy'));
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actPaste'));
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Caption := '-';
    EditorPop.Items.Add(menu);

    menu := TMenuItem.Create(Sender);
    menu.Action := TAction(MainForm.find('actSelectAll'));
    EditorPop.Items.Add(menu);

    CodeEdit.PopupMenu := EditorPop;

    //eveything is setup now we can populate props
    if codeUnitType in [_FORMPAGE, _FRAMEPAGE, _MODULEPAGE, _REPORTPAGE] then
        Designer.PopulateProperties;
end;

procedure codeunit_OnCodeCompleteTimer(Sender: TTimer);
var
    curWord: string;
    curLine: int;
begin
    Sender.Enabled := false;
    curWord := TSyntaxMemo(Sender.Owner.find('Editor')).
                    GetWordAtRowCol(
                        TSyntaxMemo(Sender.Owner.find('Editor')).CaretX -1,
                        TSyntaxMemo(Sender.Owner.find('Editor')).CaretY);

    curLine := TSyntaxMemo(Sender.Owner.find('Editor')).CaretY -1;

    //launch Assistant
    TSyntaxMemo(Sender.Owner.find('Editor')).
        ExecuteAssistant(TSyntaxMemo(Sender.Owner.find('Editor')).getCodeClassName(curWord, curLine), curWord);
end;

procedure codeunit_OnCodeAssistTimer(Sender: TTimer);
begin
    Sender.Enabled := false;
    TSyntaxMemo(Sender.Owner.find('Editor')).
        ExecuteCompletion(
            TSyntaxMemo(Sender.Owner.find('Editor')).
                GetWordAtRowCol(
                    TSyntaxMemo(Sender.Owner.find('Editor')).CaretX -1,
                    TSyntaxMemo(Sender.Owner.find('Editor')).CaretY));
end;

procedure codeedit_OnClickLink(Sender: TSyntaxMemo; Button: TMouseButton; keyInfo: TKeyInfo; X, Y: int);
var
    curWord: string;
begin
    Sender.setMouseToCaret(X, Y);
    curWord := Sender.GetWordAtRowCol(Sender.CaretX, Sender.CaretY);
    createQuickRef(MainForm, libUIAdv, curWord).Show;
end;

procedure codeedit_OnMouseLink(Sender: TSyntaxMemo; X, Y: int; var AllowMouseLink: bool);
var
    curWord: string;
begin
    curWord := Sender.GetWordAtRowCol(X, Y);

    if Len(curWord) <> 0 then
    begin
        if curWord[1] = 'T' then
        AllowMouseLink := (libClassList.IndexOf(curWord) <> -1)
        else if libMethodList.IndexOf(curWord) <> -1 then
        AllowMouseLink := true
        else
        AllowMouseLink := false;
    end
        else
        AllowMouseLink := false;
end;

procedure codeunit_OnCreateEvent(Sender: TObject; objectName, objectClass, eventName, eventDecl: string; Params: TStrings);
var
    i: int;
    foundEvent: bool = false;
    buildDecl: string;
    varparam: string;
    epos, ipos: int;
    efind: string;
    code: string;
    event: string;
begin
    if doGetActiveCodeEditor <> nil then
    begin
        if objectName = 'Container' then
        begin
            efind := '</events-bind>';
            epos := 0;
        end
            else
        begin
            efind := '<events-bind>';
            epos := 1;
        end;

        event := ReplaceAll(eventDecl, 'Container_', activePageCaption+'_');

        ipos := 0;
        for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
        begin
            if Pos(efind, doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
            begin
                ipos := i;
                break;
            end;
        end;

        if iPos = 0 then
        begin
            doMsgError(MainForm, 'Error', 'Could not locate events bind tag.');
            exit;
        end;

        ipos := 0;
        for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
        begin
            if Pos('<events-code>', doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
            begin
                ipos := i;
                break;
            end;
        end;

        if iPos = 0 then
        begin
            doMsgError(MainForm, 'Error', 'Could not locate events code tag.');
            exit;
        end;

        for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
        begin
            if (Pos('sub '+event+'(', doGetActiveCodeEditor.Lines.Strings[i]) > 0) or
               (Pos('procedure '+event+'(', doGetActiveCodeEditor.Lines.Strings[i]) > 0) or
               (Pos('function '+event+'(', doGetActiveCodeEditor.Lines.Strings[i]) > 0) or
               (Pos('void '+event+'(', doGetActiveCodeEditor.Lines.Strings[i]) > 0) then
            begin
                foundEvent := true;
                break;
            end;
        end;

        doSetAtivePageTab(0);

        if foundEvent then
        begin
            doGetActiveCodeEditor.CaretY := i+1;
            doGetActiveCodeEditor.CaretX := 1;
        end
            else
        begin
            if ActiveProject.Values['language'] = 'Basic' then
            begin
                buildDecl := 'sub '+event+'(';
                for i := 0 to Params.Count -1 do
                begin
                    if Pos('*', Params.Strings[i]) > 0 then
                    varparam := 'ByRef '
                    else
                    varparam := '';
                    Params.Strings[i] := ReplaceAll(Params.Strings[i], '*', '');
                    buildDecl := buildDecl+', '+varparam+Params.ValueByIndex(i)+' as '+Params.Names[i];
                end;
                buildDecl := buildDecl+')';
                buildDecl := ReplaceAll(buildDecl, '(, ', '(');

                //we need to bind the event here
                for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
                begin
                    if Pos(efind, doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
                    begin
                        if objectName = 'Container' then
                        code := '    Sender.'+eventName+' = addressof '+event
                        else
                        code := '    '+objectClass+'(Sender.find("'+ObjectName+'")).'+eventName+' = addressof '+event;
                        doGetActiveCodeEditor.Lines.Insert(i + epos, code);
                        break;
                    end;
                end;

                doGetActiveCodeEditor.Lines.Insert(ipos, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +1, buildDecl);
                doGetActiveCodeEditor.Lines.Insert(ipos +2, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +3, 'end sub');
                doGetActiveCodeEditor.CaretY := ipos +3;
                doGetActiveCodeEditor.CaretX := 1;
                codeunit_CodeChange(doGetActiveCodeEditor);
            end;

            if ActiveProject.Values['language'] = 'C++' then
            begin
                buildDecl := 'void '+event+'(';
                for i := 0 to Params.Count -1 do
                begin
                    if Pos('*', Params.Strings[i]) > 0 then
                    varparam := '&'
                    else
                    varparam := '';
                    Params.Strings[i] := ReplaceAll(Params.Strings[i], '*', '');
                    buildDecl := buildDecl+', '+Params.Names[i]+' '+varparam+Params.ValueByIndex(i);
                end;
                buildDecl := buildDecl+')';
                buildDecl := ReplaceAll(buildDecl, '(, ', '(');
                buildDecl := buildDecl+' {';

                //we need to bind the event here
                for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
                begin
                    if Pos(efind, doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
                    begin
                        if objectName = 'Container' then
                        code := '    Sender.'+eventName+' = &'+event+';'
                        else
                        code := '    '+objectClass+'(Sender.find("'+ObjectName+'")).'+eventName+' = &'+event+';';
                        doGetActiveCodeEditor.Lines.Insert(i + epos, code);
                        break;
                    end;
                end;

                doGetActiveCodeEditor.Lines.Insert(ipos, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +1, buildDecl);
                doGetActiveCodeEditor.Lines.Insert(ipos +2, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +3, '}');
                doGetActiveCodeEditor.CaretY := ipos +3;
                doGetActiveCodeEditor.CaretX := 1;
                codeunit_CodeChange(doGetActiveCodeEditor);
            end;

            if ActiveProject.Values['language'] = 'JScript' then
            begin
                buildDecl := 'function '+event+'(';
                for i := 0 to Params.Count -1 do
                begin
                    if Pos('*', Params.Strings[i]) > 0 then
                    varparam := '&'
                    else
                    varparam := '';
                    Params.Strings[i] := ReplaceAll(Params.Strings[i], '*', '');
                    buildDecl := buildDecl+', '+varparam+Params.ValueByIndex(i);
                end;
                buildDecl := buildDecl+')';
                buildDecl := ReplaceAll(buildDecl, '(, ', '(');
                buildDecl := buildDecl+' {';

                //we need to bind the event here
                for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
                begin
                    if Pos(efind, doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
                    begin
                        if objectName = 'Container' then
                        code := '    Sender.'+eventName+' = &'+event+';'
                        else
                        code := '    '+objectClass+'(Sender.find("'+ObjectName+'")).'+eventName+' = &'+event+';';
                        doGetActiveCodeEditor.Lines.Insert(i + epos, code);
                        break;
                    end;
                end;

                doGetActiveCodeEditor.Lines.Insert(ipos, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +1, buildDecl);
                doGetActiveCodeEditor.Lines.Insert(ipos +2, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +3, '}');
                doGetActiveCodeEditor.CaretY := ipos +3;
                doGetActiveCodeEditor.CaretX := 1;
                codeunit_CodeChange(doGetActiveCodeEditor);
            end;

            if ActiveProject.Values['language'] = 'Pascal' then
            begin
                buildDecl := 'procedure '+event+'(';
                for i := 0 to Params.Count -1 do
                begin
                    if Pos('*', Params.Strings[i]) > 0 then
                    varparam := 'var '
                    else
                    varparam := '';
                    Params.Strings[i] := ReplaceAll(Params.Strings[i], '*', '');
                    buildDecl := buildDecl+'; '+varparam+Params.ValueByIndex(i)+': '+Params.Names[i];
                end;
                buildDecl := buildDecl+')';
                buildDecl := ReplaceAll(buildDecl, '(; ', '(');
                buildDecl := buildDecl+';';

                //we need to bind the event here
                for i := 0 to doGetActiveCodeEditor.Lines.Count -1 do
                begin
                    if Pos(efind, doGetActiveCodeEditor.Lines.Strings[i]) > 0 then
                    begin
                        if objectName = 'Container' then
                        code := '    Sender.'+eventName+' := @'+event+';'
                        else
                        code := '    '+objectClass+'(Sender.find('''+ObjectName+''')).'+eventName+' := @'+event+';';
                        doGetActiveCodeEditor.Lines.Insert(i + epos, code);
                        break;
                    end;
                end;

                doGetActiveCodeEditor.Lines.Insert(ipos, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +1, buildDecl);
                doGetActiveCodeEditor.Lines.Insert(ipos +2, 'begin');
                doGetActiveCodeEditor.Lines.Insert(ipos +3, '');
                doGetActiveCodeEditor.Lines.Insert(ipos +4, 'end;');
                doGetActiveCodeEditor.CaretY := ipos +4;
                doGetActiveCodeEditor.CaretX := 1;
                codeunit_CodeChange(doGetActiveCodeEditor);
            end;
        end;
    end;
end;

procedure codeunit_OnMenuPanelClick(Sender: TComponent);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.SelectAndEditMainmenu;
end;

procedure codeunit_OnEditActionListClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditActionList;
end;

procedure codeunit_OnEditImageListClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditImageList;
end;

procedure codeunit_OnEditPopupMenuClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditPopupMenu;
end;

procedure codeunit_OnEditMainMenuClick(Sender: TComponent);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditMainMenu;
end;

procedure codeunit_OnEditTreeNodesClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditTreeNodes;
end;

procedure codeunit_OnEditListColumnsClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditListColumns;
end;

procedure codeunit_OnEditListItemsClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditListItems;
end;

procedure codeunit_OnAddTabSheetClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.AddTabSheet(Sender.Hint);
end;

procedure codeunit_OnSelectTabSheetClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.SelectTabSheet(Sender.Hint, Sender.Tag);
end;

procedure codeunit_OnAddToolButtonClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.AddToolButton(Sender.Hint);
end;

procedure codeunit_OnAddToolSeperatorClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.AddToolButton(Sender.Hint, true);
end;

procedure codeunit_OnEditStatusPanelsClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditStatusPanels;
end;

procedure codeunit_OnPreviewClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        TReport(doGetActiveDesigner.RealForm).Preview;
end;

procedure codeunit_RLBorderClick(Sender: TMenuItem);
begin
    if doGetActiveDesigner <> nil then
        doGetActiveDesigner.EditRLBorders;
end;

procedure codeunit_OnRightClick(Sender: TDesigner; objName, objClassName: string);
var
    menu, submenu: TMenuItem;
    pop: TPopupMenu;
    i: int;
begin
    pop := TPopupMenu(Sender.Owner.find('DesignerPop'));
    pop.Items.Clear;

    if ObjName = 'Container' then
    begin
        if objClassName = 'TReport' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Preview Report';
            menu.OnClick := @codeunit_OnPreviewClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
    end;

    //only add extra menu when 1 component is selected
    if Sender.SelControls.Count = 1 then
    begin
        if Pos('TRL', objClassName) > 0 then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Border Options';
            menu.OnClick := @codeunit_RLBorderClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;

        if objClassName = 'TActionList' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit ActionList ...';
            menu.OnClick := @codeunit_OnEditActionListClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TImageList' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit ImageList ...';
            menu.OnClick := @codeunit_OnEditImageListClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TPopupMenu' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit PopupMenu ...';
            menu.OnClick := @codeunit_OnEditPopupMenuClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TMainMenu' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit MainMenu ...';
            menu.OnClick := @codeunit_OnEditMainMenuClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TTreeView' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit TreeNodes ...';
            menu.OnClick := @codeunit_OnEditTreeNodesClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TToolBar' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Add ToolButton';
            menu.Hint := objName;
            menu.OnClick := @codeunit_OnAddToolButtonClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Add Seperator';
            menu.Hint := objName;
            menu.OnClick := @codeunit_OnAddToolSeperatorClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TStatusBar' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit StatusPanels ...';
            menu.OnClick := @codeunit_OnEditStatusPanelsClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TListView' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit ListColumns ...';
            menu.OnClick := @codeunit_OnEditListColumnsClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Edit ListItems ...';
            menu.OnClick := @codeunit_OnEditListItemsClick;
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
        if objClassName = 'TPageControl' then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Add TabSheet';
            menu.Hint := objName;
            menu.OnClick := @codeunit_OnAddTabSheetClick;
            pop.Items.Add(menu);

            if Sender.getTabSheetCount(objName) <> 0 then
            begin
                menu := TMenuItem.Create(Sender.Owner);
                menu.Caption := 'Select TabSheet';
                pop.Items.Add(menu);

                for i := 0 to Sender.getTabSheetCount(objName) -1 do
                begin
                    submenu := TMenuItem.Create(Sender.Owner);
                    submenu.Caption := 'TabSheet '+IntToStr(i);
                    submenu.Hint := objName;
                    submenu.setTag(i);
                    submenu.OnClick := @codeunit_OnSelectTabSheetClick;
                    menu.Add(submenu);
                end;
            end;

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
    end;

    menu := TMenuItem.Create(Sender.Owner);
    menu.Action := TAction(MainForm.find('actUndo'));
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender.Owner);
    menu.Action := TAction(MainForm.find('actRedo'));
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender.Owner);
    menu.Caption := '-';
    pop.Items.Add(menu);

    if objName <> 'Container' then
    begin
        menu := TMenuItem.Create(Sender.Owner);
        menu.Action := TAction(MainForm.find('actCut'));
        pop.Items.Add(menu);

        menu := TMenuItem.Create(Sender.Owner);
        menu.Action := TAction(MainForm.find('actCopy'));
        pop.Items.Add(menu);

        menu := TMenuItem.Create(Sender.Owner);
        menu.Action := TAction(MainForm.find('actPaste'));
        pop.Items.Add(menu);

        menu := TMenuItem.Create(Sender.Owner);
        menu.Caption := '-';
        pop.Items.Add(menu);
    end
        else
    begin
        if DesClip.Count <> 0 then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Action := TAction(MainForm.find('actPaste'));
            pop.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            pop.Items.Add(menu);
        end;
    end;

    menu := TMenuItem.Create(Sender.Owner);
    menu.Action := TAction(MainForm.find('actSelectAll'));
    pop.Items.Add(menu);

    menu := TMenuItem.Create(Sender.Owner);
    menu.Action := TAction(MainForm.find('actSelectContainer'));
    pop.Items.Add(menu);

    if objName <> 'Container' then
    begin
        menu := TMenuItem.Create(Sender.Owner);
        menu.Caption := '-';
        pop.Items.Add(menu);

        menu := TMenuItem.Create(Sender.Owner);
        menu.Action := TAction(MainForm.find('actDelete'));
        pop.Items.Add(menu);
    end;

    pop.Popup;
end;

procedure codeunit_OnRenameComponent(Sender: TDesigner; oldName, newName: string);
var
    x,y: int;
begin
    if doGetActiveCodeEditor <> nil then
    begin
        x := doGetActiveCodeEditor.CaretX;
        y := doGetActiveCodeEditor.CaretY;
        doGetActiveCodeEditor.Text := ReplaceAll(doGetActiveCodeEditor.Text, oldName, newName, true);
        doGetActiveCodeEditor.CaretX := x;
        doGetActiveCodeEditor.CaretY := y;
    end;

    Sender.PopulateObjects;
    Sender.PopulateProperties;
end;

procedure codeunit_OnCanPaste(Sender: TDesigner; classType: TClassGroup; var canPaste: boolean);
begin
    if activePageImg in [_FORMPAGE, _FRAMEPAGE] then
    canPaste := (classType in [cgControl, cgComponent]);

    if activePageImg = _REPORTPAGE then
    canPaste := (classType in [cgReport, cgComponent]);

    if activePageImg = _MODULEPAGE then
    canPaste := (classType in [cgComponent]);
end;

procedure codeunit_OnPaste(Sender: TDesigner; desObject: TDesignerControl);
begin
    if (desObject.RealClassName = 'TDTAnalogClock') or
       (desObject.RealClassName = 'TDTThemedClock') or
       (desObject.RealClassName = 'TDTThemedGauge') or
       (desObject.RealClassName = 'TBubbleShape') or
       (desObject.RealClassName = 'TCircleProgress') or
       (desObject.RealClassName = 'TCircleShape') or
       (desObject.RealClassName = 'TEllipseShape') or
       (desObject.RealClassName = 'THexagonShape') or
       (desObject.RealClassName = 'TOctagonShape') or
       (desObject.RealClassName = 'TParallelShape') or
       (desObject.RealClassName = 'TPentagonShape') or
       (desObject.RealClassName = 'TRectShape') or
       (desObject.RealClassName = 'TRectangleShape') or
       (desObject.RealClassName = 'TRoundRectShape') or
       (desObject.RealClassName = 'TRoundSquareShape') or
       (desObject.RealClassName = 'TShape') or
       (desObject.RealClassName = 'TShapeProgress') or
       (desObject.RealClassName = 'TSquareShape') or
       (desObject.RealClassName = 'TStarShape') or
       (desObject.RealClassName = 'TTrapezShape') or
       (desObject.RealClassName = 'TTriangleShape') or
       (desObject.RealClassName = 'TArrow') or
       (desObject.RealClassName = 'TATTabs') or
       (desObject.RealClassName = 'TECProgressBar') or
       (desObject.RealClassName = 'TECSlider') or
       (desObject.RealClassName = 'TECRuler') or
       (desObject.RealClassName = 'TECSwitch') or
       (desObject.RealClassName = 'TCalendar') or
       (desObject.RealClassName = 'TDBCalendar') or
       (desObject.RealClassName = 'TBarCode') or
       (desObject.RealClassName = 'TDBBarCode') or
       (desObject.RealClassName = 'TRLBarcode') or
       (desObject.RealClassName = 'TAAnalogClock') or
       (desObject.RealClassName = 'TASwitchButton') or
       (desObject.RealClassName = 'TARatingBar') or
       (desObject.RealClassName = 'TADigitalClock') or
       (desObject.RealClassName = 'TRLDBBarcode') then
    begin
        desObject.OnCustomPaint := @doCustomControlPaint;
    end;
end;

procedure CodeUnit_OnGutterClick(Sender: TSyntaxMemo; X, Y, Line: int);
begin
    if Sender.IsBreakPoint(Line) then
    begin
        Sender.RemoveBreakPoint(Line);
        if _Breakpoints.IndexOf(activePageCaption+'@'+IntToStr(Line)) <> -1 then
        _Breakpoints.Delete(_Breakpoints.IndexOf(activePageCaption+'@'+IntToStr(Line)));
    end
        else
    begin
        Sender.AddBreakPoint(Line);
        if _Breakpoints.IndexOf(activePageCaption+'@'+IntToStr(Line)) = -1 then
        _Breakpoints.Add(activePageCaption+'@'+IntToStr(Line));
    end;
    Sender.Invalidate;
end;

procedure CodeUnit_OnMouseDown(Sender: TSyntaxMemo; Button: TMouseButton; keyInfo: TKeyInfo; X, Y: int);
begin
    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);

    Sender.Invalidate;
end;

procedure CodeUnit_OnSpecialLineColors(Sender: TSyntaxMemo; Line: int; var Special: bool; var FG, BG: int);
begin
    if (doGetActiveCodeEditor <> nil) and
       (stopUnit = activePageCaption) and
       (stopLine = Line) then
    begin
        if stopError then
        begin
            FG := StringToColorDef(appsettings.Values['editor-StopErrorForeColor'], clWhite);
            BG := StringToColorDef(appsettings.Values['editor-StopErrorBackColor'], clMaroon);
        end
            else
        begin
            FG := StringToColorDef(appsettings.Values['editor-StopForeColor'], clWhite);
            BG := StringToColorDef(appsettings.Values['editor-StopBackColor'], clGreen);
        end;
        Special := true;
    end
    else if Sender.isBreakPoint(Line) then
    begin
        FG := StringToColorDef(appsettings.Values['editor-StopBreakForeColor'], clWhite);
        BG := StringToColorDef(appsettings.Values['editor-StopBreakBackColor'], clRed);
        Special := true;
    end
    else
    begin
        if Line = Sender.CaretY then
        begin
            FG := clNone;
            BG := StringToColorDef(appsettings.Values['editor-ActiveLineColor'], $efefef);
            Special := true;
        end;
    end;
end;

procedure CodeUnit_OnKeyUp(Sender: TSyntaxMemo; var Key: int; keyInfo: TKeyInfo);
var
    caAuto: bool;
begin
    {TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := false;
    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := false;

    //custom code assistant
    caAuto := (appSettings.Values['autoassistant'] = '1');
    if not caAuto then
    caAuto := keyInfo.hasCtrl;
    if caAuto then
    begin
        if key = 190 then
        begin
            TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := true;
        end;
    end;

    //code completion - Geany Style
    //auto launch code completion when x number of chars are written 1 = 2 chars, 2 = 3 chars ...
    if appSettings.Values['autocompletion'] = '1' then
    begin
        if not keyInfo.hasShift and not keyInfo.hasCtrl then
        begin
            if key in [65..90,95] then //possible token chars we want to invoke upon
                if Len(Sender.GetWordAtRowCol(Sender.CaretX -1, Sender.CaretY)) >
                    StrToIntDef(appSettings.Values['autocompletion-chars'], 3) then
                    //launch completion
                    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := true;
        end;
    end;

    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);

    //invalidate to make current line paiting move faster
    Sender.Invalidate;}
end;

procedure CodeUnit_OnKeyDown(Sender: TSyntaxMemo; var Key: int; keyInfo: TKeyInfo);
//var
//    caAuto: bool;
begin
    {TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := false;
    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := false;

    //custom code assistant
    caAuto := (appSettings.Values['autoassistant'] = '1');
    if not caAuto then
    caAuto := keyInfo.hasCtrl;
    if caAuto then
    begin
        if key = 190 then
        begin
            TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := true;
        end;
    end;

    //code completion - Geany Style
    //auto launch code completion when x number of chars are written 1 = 2 chars, 2 = 3 chars ...
    if appSettings.Values['autocompletion'] = '1' then
    begin
        if not keyInfo.hasShift and not keyInfo.hasCtrl then
        begin
            if key in [65..90,95] then //possible token chars we want to invoke upon
                if Len(Sender.GetWordAtRowCol(Sender.CaretX, Sender.CaretY)) >
                    StrToIntDef(appSettings.Values['autocompletion-chars'], 1) then
                    //launch completion
                    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := true;
        end;
    end;

    //invalidate to make current line paiting move faster
    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);

    Sender.Invalidate;}
end;

procedure codeUnit_OnKeyPress(Sender: TSyntaxMemo; var Key: Char);
var
    X: int;
    Line: string;
    caAuto: bool;
begin
    TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := false;
    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := false;

    //custom code assistant
    caAuto := (appSettings.Values['autoassistant'] = '1');
    //if not caAuto then
    //caAuto := keyInfo.hasCtrl;
    if caAuto then
    begin
        if key = '.' then
        begin
            TTimer(Sender.Owner.find('CodeCompTimer')).Enabled := true;
        end;
    end;

    //code completion - Geany Style
    //auto launch code completion when x number of chars are written 1 = 2 chars, 2 = 3 chars ...
    if appSettings.Values['autocompletion'] = '1' then
    begin
        //if not keyInfo.hasShift and not keyInfo.hasCtrl then
        //begin
            if key in ['A'..'Z', 'a'..'z', '_'] then //possible token chars we want to invoke upon
                if Len(Sender.GetWordAtRowCol(Sender.CaretX, Sender.CaretY)) =
                    StrToIntDef(appSettings.Values['autocompletion-chars'], 1) then
                    //launch completion
                    TTimer(Sender.Owner.find('CodeAssistTimer')).Enabled := true;
        //end;
    end;

    //invalidate to make current line paiting move faster
    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);

    Sender.Invalidate;

    //auto clode brackets feature
    if appSettings.Values['editor-autoclose-brackets'] = '1' then
    begin
        if Key = '[' then
            begin
                Sender.InsertTextAtCaret(']', scamIgnore);
                application.ProcessMessages;
                Sender.CaretX := Sender.CaretX;
            end;

        if Key = '(' then
            begin
                Sender.InsertTextAtCaret(')', scamIgnore);
                application.ProcessMessages;
                Sender.CaretX := Sender.CaretX;
            end;

        if Key = '{' then
            begin
                Sender.InsertTextAtCaret('}', scamIgnore);
                application.ProcessMessages;
                Sender.CaretX := Sender.CaretX;
            end;

        if Key = '''' then
            begin
                Sender.InsertTextAtCaret('''', scamIgnore);
                application.ProcessMessages;
                Sender.CaretX := Sender.CaretX;
            end;

        if Key = '"' then
            begin
                Sender.InsertTextAtCaret('"', scamIgnore);
                application.ProcessMessages;
                Sender.CaretX := Sender.CaretX;
            end;
    end;
end;

procedure codeUnit_TabClick(Sender: TATTabs);
begin
    case Sender.TabIndex of
        0:  begin
                TWinControl(Sender.Owner.find('Scroll')).Hide;
                TWinControl(Sender.Owner.find('Editor')).Show;
                TSyntaxMemo(Sender.Owner.find('Editor')).SetFocus;
            end;
        1:  begin
                TWinControl(Sender.Owner.find('Editor')).Hide;
                TWinControl(Sender.Owner.find('Scroll')).Show;
                TDesigner(Sender.Owner.find('Designer')).SetFocus;
            end;
    end;
end;

function codeUnitSave(Sender: TComponent; ask: bool = false): bool;
var
    chk, i: int;
    data: TATTabData;
begin
    result := true;
    if ask then
    begin
        if TVars(Sender.find('Vars')).AsBool('modified') then
        begin
            chk := doMsgQuestionCancel(MainForm, 'Save Changes', 'Would you like to save the changes in this unit?');

            if chk = mrNo then //no save - can close
                exit;

            if chk = mrCancel then //no save - can not close
            begin
                result := false;
                exit;
            end;
        end;
    end;

    if result then
    begin
        if TVars(Sender.find('Vars')).AsBool('modified') then
        begin
            TSyntaxMemo(Sender.find('Editor')).Lines.
                SaveToFile(TVars(Sender.find('Vars')).AsString('fullfilename'));
            if TVars(Sender.find('Vars')).AsInt('pagetype') in [_FORMPAGE, _FRAMEPAGE, _REPORTPAGE, _MODULEPAGE] then
            begin
                TDesigner(Sender.find('Designer')).CacheDir := '';
                TDesigner(Sender.find('Designer')).SaveToFile(TVars(Sender.find('Vars')).AsString('fullfilename'));
                TDesigner(Sender.find('Designer')).CacheDir := UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'Cache';
            end;
            TVars(Sender.find('Vars')).SetVar('modified', false);

            for i := 0 to Pages.TabCount -1 do
            begin
                data := Pages.GetTabData(i);
                if data.TabCaption = TVars(Sender.find('Vars')).asString('filename') then
                    data.TabColor := clNone;
            end;
            Pages.Invalidate;
        end;
    end;
end;

procedure codeunit_CodeChange(Sender: TComponent);
var
    data: TATTabData;
    i: int;
    s: string;
begin
    if Sender.ClassName = 'TSyntaxMemo' then
    begin
        if TSyntaxMemo(Sender).Lines.Count <> 0 then
        begin
            s := Lower(TSyntaxMemo(Sender).Lines.Strings[0]);
            if Pos('dialect pascal', s) > 0 then
                TSyntaxMemo(Sender).SyntaxStyle := stsPascal;
            if Pos('dialect c++', s) > 0 then
                TSyntaxMemo(Sender).SyntaxStyle := stscPP;
            if Pos('dialect jscript', s) > 0 then
                TSyntaxMemo(Sender).SyntaxStyle := stsJScript;
            if Pos('dialect basic', s) > 0 then
                TSyntaxMemo(Sender).SyntaxStyle := stsBasic;
        end;
    end;

    for i := 0 to Pages.TabCount -1 do
    begin
        data := Pages.GetTabData(i);
        if data.TabCaption = TVars(Sender.Owner.find('Vars')).asString('filename') then
            data.TabColor := $00aaff;
    end;
    Pages.Invalidate;
    TVars(Sender.Owner.find('Vars')).SetVar('modified', true);

    stopError := false;
    stopUnit := '';
    doGetActiveCodeEditor.Invalidate;
end;

procedure codeunit_FocusTimer(Sender: TComponent);
begin
    TTimer(Sender).Enabled := false;
    if TATTabs(Sender.Owner.find('CodePage')).TabIndex = 0 then
    TSyntaxMemo(Sender.Owner.find('Editor')).SetFocus
    else
    TDesigner(Sender.Owner.find('Designer')).SetFocus;

    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);
end;

procedure codeunit_OnToolboxDragOver(Sender: TDesigner; ImageIndex: int; CompName: string; var Accept: bool);
begin
    Accept := ImageIndex > 2;

    if Pos('(Android', ActiveProject.Values['type']) = 0 then
    begin
        if activePageImg in [_FORMPAGE, _FRAMEPAGE] then
            Accept := not (ImageIndex in [39..42,134..150]);
        if activePageImg = _REPORTPAGE then
            Accept := ImageIndex in [39..42,134..150];
        if activePageImg = _MODULEPAGE then
            Accept := ImageIndex in [3..53];
    end
        else
    begin
        //Android
        if activePageImg = _FORMPAGE then
            Accept := (ImageIndex in [3..201]);
        if activePageImg = _MODULEPAGE then
            Accept := ImageIndex in [3..53];
    end;
end;

procedure codeunit_OnToolboxDragDrop(Sender: TDesigner; Parent: TComponent; ImageIndex: int; CompName: string; X, Y: int);
var
    component: TDesignerComponent;
    control: TDesignerControl;
    container: TDesignerContainer;
    Accept: bool;
    insertparent: TWinControl;
begin
    if ImageIndex > 2 then
    begin
        Accept := true;
        if Pos('(Android', ActiveProject.Values['type']) = 0 then
        begin
            if activePageImg in [_FORMPAGE, _FRAMEPAGE] then
                Accept := not (ImageIndex in [39..42,134..145,147..150]);
            if activePageImg = _REPORTPAGE then
                Accept := ImageIndex in [3..53,134..145,147..150];
            if activePageImg = _MODULEPAGE then
                Accept := ImageIndex in [3..53];

            if not Accept then
            begin
                ToolboxTree.Items.Item[0].Selected := true;
                TTimer(Sender.Owner.find('DesignerError')).Enabled := true;
                exit;
            end;

            if ImageIndex in [3..53,132,176,186] then   //Components
            begin
                component := createDesignerComponent(Sender, ImageIndex, CompName);
                if component <> nil then
                Sender.AddControl(component, X, Y); //parent is always designer
            end;

            if (ImageIndex in [54..185]) and
               (ImageIndex <> 132) and
               (ImageIndex <> 176) then     //Controls
            begin
                if (Parent.ClassName = 'TDesignerContainer') then
                insertparent := TWinControl(Parent)
                else if TDesignerObject(Parent).RealClassName = 'TRLBand' then
                insertparent := TWinControl(Parent)
                else if TDesignerObject(Parent).RealClassName = 'TRLSubDetail' then
                insertparent := TWinControl(Parent)
                else
                insertparent := Sender;

                if ImageIndex in [60,84,116,129,159] then
                begin
                    container := createDesignerContainer(Sender, ImageIndex, CompName, insertparent);
                    if container <> nil then
                    Sender.AddControl(container, X, Y); //parent may be a container
                end
                    else
                begin
                    control := createDesignerControl(Sender, ImageIndex, CompName, insertparent);
                    if control <> nil then
                    Sender.AddControl(control, X, Y); //parent may be a container
                end;
            end;

            codeunit_OnModified(Sender);
        end
            else
        begin
            //Android

            if activePageImg = _FORMPAGE then
                Accept := ImageIndex in [3..201];
            if activePageImg = _MODULEPAGE then
                Accept := ImageIndex in [3..53];

            if not Accept then
            begin
                ToolboxTree.Items.Item[0].Selected := true;
                TTimer(Sender.Owner.find('DesignerError')).Enabled := true;
                exit;
            end;

            if ImageIndex in [3..54,62,63,97,132,176,182,186,187,188,192,193,194,196,197,198,199,200,201] then
            begin
                //components
                component := createDesignerComponent(Sender, ImageIndex, CompName);
                if component <> nil then
                Sender.AddControl(component, X, Y); //parent is always designer
            end
                else
            begin
                //controls
                if (Parent.ClassName = 'TDesignerContainer') then
                insertparent := TWinControl(Parent)
                else
                insertparent := Sender;

                if ImageIndex in [129,189] then
                begin
                    container := createDesignerContainer(Sender, ImageIndex, CompName, insertparent);
                    if container <> nil then
                    Sender.AddControl(container, X, Y); //parent may be a container
                end
                    else
                begin
                    control := createDesignerControl(Sender, ImageIndex, CompName, insertparent);
                    if control <> nil then
                    Sender.AddControl(control, X, Y); //parent may be a container
                end;
            end;

            codeunit_OnModified(Sender);
        end;
    end;

    ToolboxTree.Items.Item[0].Selected := true;
    Sender.SetFocus; //IMPORTANT! set the focus back to the designer
end;

procedure codeunit_OnSelectionChanged(Sender: TDesigner);
var
    editButton: TEditButton;
begin
    editButton := TEditButton(MainForm.find('InspectorSearch'));
    Sender.PropertiesFilter := editButton.Text;

    if Sender.RealForm.ClassName = 'TForm' then
    begin
        if TForm(Sender.RealForm).Menu <> nil then
        TPanel(Sender.Owner.find('menuPanel')).Show
        else
        TPanel(Sender.Owner.find('menuPanel')).Hide;
        Sender.DesignerWidth := TPanel(Sender.Owner.find('HostPanel')).Width;
        Sender.DesignerHeight := TPanel(Sender.Owner.find('HostPanel')).Height;
    end;
end;

procedure codeunit_OnModified(Sender: TDesigner);
begin
    codeunit_CodeChange(Sender);

    TTimer(Sender.Owner.find('AddUndoTimer')).Enabled := false;
    TTimer(Sender.Owner.find('AddUndoTimer')).Enabled := true;

    if Sender.RealForm.ClassName = 'TForm' then
    begin
        TPanel(Sender.Owner.find('formmin')).Visible := ((biMinimize and TForm(Sender.RealForm).BorderIcons) <> 0);
        TPanel(Sender.Owner.find('formmax')).Visible := ((biMaximize and TForm(Sender.RealForm).BorderIcons) <> 0);
        TPanel(Sender.Owner.find('formclose')).Visible := ((biSystemMenu and TForm(Sender.RealForm).BorderIcons) <> 0);
        TLabel(Sender.Owner.find('formCap')).Caption := TForm(Sender.RealForm).Caption;
        //realign form buttons
        if (TPanel(Sender.Owner.find('formclose')).Left < TPanel(Sender.Owner.find('formmax')).Left) or
           (TPanel(Sender.Owner.find('formclose')).Left < TPanel(Sender.Owner.find('formmin')).Left) or
           (TPanel(Sender.Owner.find('formmax')).Left < TPanel(Sender.Owner.find('formmin')).Left) then
        begin
            TPanel(Sender.Owner.find('formclose')).Left := 250;
            TPanel(Sender.Owner.find('formmax')).Left := 100;
            TPanel(Sender.Owner.find('formmin')).Left := 10;
        end;
    end;
end;

procedure codeunit_DragOver(Sender, Source: TComponent; X,Y: int; State: TDragState; var Accept: bool);
begin
    Accept := false;
    if Source = ToolboxTree then
    begin
        if ToolboxTree.Selected <> nil then
        begin
            if ToolboxTree.Selected.ImageIndex > 2 then
            begin
                TSyntaxMemo(Sender).setMouseToCaret(X, Y);
                TSyntaxMemo(Sender).setFocus;
                Accept := true;
            end;
        end;
    end;
end;

procedure codeunit_DragDrop(Sender, Source: TComponent; X,Y: int);
begin
    TSyntaxMemo(Sender).setMouseToCaret(X, Y);

    //todo: Show Insert Dialog
    TSyntaxMemo(Sender).InsertTextAtCaret('T' + ToolboxTree.Selected.Text, scamIgnore);

    ToolboxTree.Items.Item[0].Selected := true;

    TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
        'Line/Column: '+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretY)+
        '/'+IntToStr(TSyntaxMemo(Sender.Owner.find('Editor')).CaretX);
end;

procedure codeunit_OnEventDeclared(Sender: TObject; ObjName, EventName: string; var hasEvent: bool);
begin
    //check if event is declared
    if doGetActiveCodeEditor <> nil then
    begin
        if ObjName = 'Container' then
        hasEvent := (Pos(activePageCaption+'_'+EventName, doGetActiveCodeEditor.Lines.Text) > 0)
        else
        hasEvent := (Pos(activePageCaption+'_'+ObjName+'_'+EventName, doGetActiveCodeEditor.Lines.Text) > 0);
    end
        else
        hasEvent := false;
end;

procedure codeunit_OnPopulateProperty(Sender: TObject; ObjectName, ObjectClass, PropertyName, PropertyType: string; var canPopulate: bool);
begin
    //here we can filter out some properties and/or events
    //that don't have an editor

    if (ObjectClass = 'TForm') or
       (ObjectClass = 'TAForm') or
       (ObjectClass = 'TFrame') or
       (ObjectClass = 'TReport') or
       (ObjectClass = 'TDataModule') then
    begin
        //hide props that are not needed of containers
        if (PropertyName = 'Name') or
           (PropertyName = 'Action') or
           (PropertyName = 'Align') or
           (PropertyName = 'ClientWidth') or
           (PropertyName = 'ClientHeight') or
           (PropertyName = 'Tag') or
           (PropertyName = 'Left') or
           (PropertyName = 'Top') or
           (PropertyName = 'Anchors') or
           (PropertyName = 'Position') or
           (PropertyName = 'Visible') or
           (PropertyName = 'Enabled') then
        begin
            canPopulate := false;
            exit;
        end;
        //hide TBorderStyle -> TForm uses TFormBorderStyle
        if PropertyType = 'TBorderStyle' then
        begin
            canPopulate := false;
            exit;
        end;
    end;

    //note: hide readonly props
    if (ObjectClass = 'TProcess') or
       (ObjectClass = 'TProcessUTF8') or
       (ObjectClass = 'TAsyncProcess') then
    begin
        if (PropertyName = 'Active') or
           (PropertyName = 'Running') or
           (PropertyName = 'Tag') or
           (PropertyName = 'FillAttribute') then
        canPopulate := false;
        exit;
    end;

    //note: hide readonly props
    if (ObjectClass = 'TIBAdmin') then
    begin
        if (PropertyName = 'ErrorCode') or
           (PropertyName = 'ErrorMsg') or
           (PropertyName = 'Tag') or
           (PropertyName = 'Output') then
        canPopulate := false;
        exit;
    end;

    if (ObjectClass = 'TSimpleAction') then
    begin
        if (PropertyName = 'OnUpdate') or
           (PropertyName = 'Tag') then
        canPopulate := false;
        exit;
    end;

    //note: Adjust Toolbar in designtime in later version
    if (ObjectClass = 'TToolBar') then
    begin
        if (PropertyName = 'AutoSize') or
           (PropertyName = 'ButtonWidth') or
           (PropertyName = 'ButtonHeight') or
           (PropertyName = 'ShowCaptions') or
           (PropertyName = 'List') or
           (Pos('AnchorSide', PropertyName) > 0) or
           (Pos('ChildSizing', PropertyName) > 0) or
           (Pos('BorderSpacing', PropertyName) > 0) or
           (Pos('Constraints', PropertyName) > 0) or
           (PropertyName = 'Tag') then
        canPopulate := false;
        exit;
    end;

    //note: Adjust Toolbar in designtime in later version
    if (ObjectClass = 'TToolButton') or
       (ObjectClass = 'TTabSheet') then
    begin
        if (PropertyName = 'AutoSize') or
           (PropertyName = 'ButtonWidth') or
           (PropertyName = 'ButtonHeight') or
           (PropertyName = 'ShowCaption') or
           (PropertyName = 'Width') or
           (PropertyName = 'Height') or
           (PropertyName = 'Left') or
           (PropertyName = 'Top') or
           (PropertyName = 'Align') or
           (Pos('AnchorSide', PropertyName) > 0) or
           (Pos('ChildSizing', PropertyName) > 0) or
           (Pos('BorderSpacing', PropertyName) > 0) or
           (Pos('Constraints', PropertyName) > 0) or
           (PropertyName = 'Tag') then
        canPopulate := false;
        exit;
    end;

    //note: create editors in later version
    if (Pos('AnchorSide', PropertyName) > 0) or
       (Pos('ChildSizing', PropertyName) > 0) or
       (Pos('BorderSpacing', PropertyName) > 0) or
       (Pos('Constraints', PropertyName) > 0) or
       (Pos('HorzScrollBar', PropertyName) > 0) or
       (Pos('VertScrollBar', PropertyName) > 0) or
       (Pos('FieldDefs', PropertyName) > 0) or
       (Pos('IndexDefs', PropertyName) > 0) or
       (Pos('ServerIndexDefs', PropertyName) > 0) or
       (Pos('Params', PropertyName) > 0) or
       (Pos('Sequence', PropertyName) > 0) or
       (Pos('SessionProperties', PropertyName) > 0) or
       (Pos('PopupParent', PropertyName) > 0) or
       (Pos('BodyNormal', PropertyName) > 0) or
       (Pos('BodyClicked', PropertyName) > 0) or
       (Pos('CancelButton', PropertyName) > 0) or
       (Pos('ModalResult', PropertyName) > 0) or
       (Pos('OKButton', PropertyName) > 0) or
       (Pos('CloseButton', PropertyName) > 0) or
       (Pos('WorkbookSource', PropertyName) > 0) or
       (Pos('HelpButton', PropertyName) > 0) or
       (Pos('BodyHover', PropertyName) > 0) or
       (PropertyName = 'ClientWidth') or
       (PropertyName = 'PasswordChar') or
       (PropertyName = 'Step') or
       (PropertyName = 'ClientHeight') or
       (Pos('Tag', PropertyName) > 0) then
    canPopulate := false
    else
    canPopulate := true;

    //unsupported properties
    if (PropertyName = 'Date') or
       (PropertyName = 'Rtf') or
       (PropertyName = 'Time') then
    canPopulate := false;

    //note: create editors in later version
    if (PropertyType = 'TBGRABorderStyleOptions') or
       (PropertyType = 'TBGRATextEffectOutline') or
       (PropertyType = 'TBGRATextEffectShadow') or
       (PropertyType = 'TBCGradient') or
       (PropertyType = 'TBrush') or
       (PropertyType = 'TPen') or
       (PropertyType = 'TLeftRight') or
       (PropertyType = 'TChromiumFontOptions') or
       (PropertyType = 'TChromiumOptions') or
       (PropertyType = 'TDTPointerSettings') or
       (PropertyType = 'TDTPointerCapSettings') or
       (PropertyType = 'TDTScaleSettings') or
       (PropertyType = 'TDTFaceSettings') or
       (PropertyType = 'TList') or
       (PropertyType = 'TIconOptions') or
       (PropertyType = 'TDBGridColumns') or
       (PropertyType = 'TFontOptions') or
       (PropertyType = 'TECScale') or
       (PropertyType = 'TVideoOutput') or
       (PropertyType = 'TAudioOutput') or
       (PropertyType = 'TECRulerScale') or
       (PropertyType = 'TECSliderKnob') or
       (PropertyType = 'TECSwitchKnob') or
       (PropertyType = 'THeaderSections') or
       (PropertyType = 'TGridColumns') or
       (PropertyName = 'Degrade') or
       (PropertyName = 'NextReport') or
       (PropertyType = 'TRLMargins') or
       (PropertyType = 'TRLBackground') or
       (PropertyType = 'TRLPageSetup') or
       (PropertyType = 'TRLPreviewOptions') or
       (PropertyType = 'TRLRealBounds') or
       (PropertyType = 'TBGRABackground') then
    canPopulate := false;

    if ObjectClass = 'TReport' then
    begin
        if (PropertyName = 'Width') or
           (PropertyName = 'Height') or
           (Pos('On', PropertyName) > 0) then
        canPopulate := false;
    end;

    if (ObjectClass = 'TRLBand') or
       (ObjectClass = 'TRLSubDetail') then
    begin
        if (PropertyName = 'Left') or
           (PropertyName = 'Top') or
           (PropertyName = 'Width') or
           (PropertyName = 'AlignToBottom') or
           (PropertyName = 'AutoExpand') or
           (PropertyName = 'AutoSize') or
           (PropertyName = 'CarbonCopies') or
           (PropertyName = 'Completion') or
           (PropertyName = 'Visible') or
           (PropertyName = 'Computable') or
           (Pos('On', PropertyName) > 0) then
        canPopulate := false;
    end;

    if (ObjectClass = 'TRLLabel') or
       (ObjectClass = 'TRLAngleLabel') or
       (ObjectClass = 'TRLBarcode') or
       (ObjectClass = 'TRLDBBarcode') or
       (ObjectClass = 'TRLDBImage') or
       (ObjectClass = 'TRLDBMemo') or
       (ObjectClass = 'TRLDBResult') or
       (ObjectClass = 'TRLDBRichText') or
       (ObjectClass = 'TRLRichText') or
       (ObjectClass = 'TRLDBText') or
       (ObjectClass = 'TRLImage') or
       (ObjectClass = 'TRLMemo') or
       (ObjectClass = 'TRLSystemInfo') then
    begin
        if (PropertyName = 'Align') or
           (PropertyName = 'Anchors') or
           (PropertyName = 'AutoSize') or
           (PropertyName = 'Holder') or
           (PropertyName = 'Layout') or
           (PropertyName = 'HolderStyle') or
           (PropertyName = 'HoldStyle') or
           (PropertyName = 'SecondHolder') or
           (PropertyName = 'SecondHoldStyle') or
           (Pos('On', PropertyName) > 0)  then
        canPopulate := false;
    end;
end;

procedure codeunit_OnSelectEditor(Sender: TObject; ObjectName, ObjectClass, PropertyName, PropertyType: string; var Editor: TControl);
begin
    //here we can assign custom editors
    //pass editor := nil to select build in editors

    //uncomment for testing
    {if customPropEdit = nil then
    customPropEdit := TEdit.Create(MainForm);

    customPropEdit.Font.Color := clWindowText;
    Editor := customEdit;}

    editor := nil;
end;

procedure codeunit_DesignerError(Sender: TTimer);
begin
    Sender.Enabled := false;
    doMsgError(MainForm, 'Error', 'Form-Component incopatibility, can not add this component.');
end;

procedure codeunit_formFocusClick(Sender: TObject);
begin
    if doGetActiveDesigner <> nil then
    begin
        doGetActiveDesigner.SelectForm;
        doGetActiveDesigner.SetFocus;
    end;
end;

procedure codeunit_AddUndoTimer(Sender: TTimer);
begin
    //after 2.5 sec of "OnModifiy IDLE" an Undo item will be added
    //this is to prevent from having 1000's of undo steps
    Sender.Enabled := false;
    TDesigner(Sender.Owner.find('Designer')).AddUndo;
end;


//unit constructor
constructor begin end.
