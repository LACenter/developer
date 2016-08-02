////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

procedure createRightSide(form: TForm);
var
    pane, sub, top: TPanel;
    splitter: TSplitter;
    closeB: TSpeedButton;
    editButton: TEditButton;
    treeHeight: TImageList;  //dummy to set tree node item height
begin
    pane := TPanel.Create(form);
    pane.Parent := form;
    pane.Name := 'rightPanel';
    pane.Align := alRight;
    pane.Width := 220;
    pane.BevelOuter := bvNone;
    pane.ParentColor := true;
    pane.Caption := '';
    pane.BorderSpacing.Right := 5;
    pane.BorderSpacing.Bottom := 2;
    rightPanel := pane;

    treeHeight := TImageList.Create(form);
    treeHeight.Width := 8;
    treeHeight.Height := form.Canvas.TextHeight('|') + 8;

    splitter := TSplitter.Create(form);
    splitter.Parent := form;
    splitter.Name := 'rightSplitter';
    splitter.Align := alRight;
    splitter.Left := pane.Left;
    rightOutSplitter := splitter;

    sub := TPanel.Create(form);
    sub.Parent := pane;
    sub.Align := alTop;
    sub.Name := 'ObjectTreePanel';
    sub.BevelOuter := bvNone;
    sub.ParentColor := true;
    sub.Height := 200;
    sub.Caption := '';
    rightTopPanel := sub;

    top := TPanel.Create(form);
    top.Parent := sub;
    top.Align := alTop;
    top.Height := form.Canvas.TextHeight('|') + 8;
    top.Alignment := taLeftJustify;
    top.BevelOuter := bvNone;
    top.Name := 'ObjectTreePanelTop';
    top.Caption := ' Objects';
    top.Font.Style := fsBold;

    editButton := TEditButton.Create(form);
    editButton.Parent := top;
    editButton.Align := alRight;
    editButton.Width := 90;
    editButton.Button.Flat := true;
    editButton.BorderStyle := bsNone;
    editButton.Name := 'ObjectSearch';
    editButton.Hint := 'Search Objects';
    editButton.Button.Hint := 'Clear Search';
    editButton.Button.Glyph.LoadFromResource('bmp_delfilter');
    editButton.ShowHint := true;
    editButton.Font.Style := 0;
    editButton.Text := '<search>';
    editButton.Font.Color := clGrayText;
    editButton.TabStop := false;
    editButton.BorderSpacing.Bottom := 2;
    editButton.Color := top.Color;
    editButton.BackColor := top.Color;
    editButton.ButtonWidth := form.Canvas.TextHeight('|') + 8;
    editButton.OnEnter := @pane_Search_Enter;
    editButton.OnExit := @pane_Search_Exit;
    editButton.OnButtonClick := @pane_Search_ButtonClick;
    editButton.OnChange := @rightside_ObjectSearch;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := top;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose');
    CloseB.Name := 'ObjectTreePanelClose';
    CloseB.Flat := true;
    CloseB.Hint := 'Close';
    CloseB.Left := top.Width;
    closeB.ShowHint := true;
    closeB.BorderSpacing.Bottom := 2;
    closeB.Width := form.Canvas.TextHeight('|') + 8;
    closeB.OnClick := @rightside_ObjectPaneCloseClick;

    ObjectTree := TTreeView.Create(form);
    ObjectTree.Parent := sub;
    ObjectTree.Align := alClient;
    if appSettings.Values['show-scrollbar'] = '1' then
    ObjectTree.ScrollBars := ssAutoVertical
    else
    ObjectTree.ScrollBars := ssNone;
    ObjectTree.Name := 'ObjectTree';
    ObjectTree.ReadOnly := true;
    ObjectTree.RowSelect := true;
    ObjectTree.RightClickSelect := true;
    ObjectTree.BorderStyle := bsNone;
    ObjectTree.Images := MainImages;
    ObjectTree.ShowLines := false;

    splitter := TSplitter.Create(form);
    splitter.Parent := pane;
    splitter.Align := alTop;
    splitter.Top := sub.Height;
    splitter.Name := 'RightInSplitter';
    rightInSplitter := splitter;

    sub := TPanel.Create(form);
    sub.Parent := pane;
    sub.Align := alClient;
    sub.Name := 'PropertiesPanel';
    sub.BevelOuter := bvNone;
    sub.ParentColor := true;
    sub.Height := 240;
    sub.Caption := '';
    rightBottomPanel := sub;

    top := TPanel.Create(form);
    top.Parent := sub;
    top.Align := alTop;
    top.Height := form.Canvas.TextHeight('|') + 8;
    top.Alignment := taLeftJustify;
    top.BevelOuter := bvNone;
    top.Name := 'PropertiesPanelTop';
    top.Caption := ' Inspector';
    top.Font.Style := fsBold;

    editButton := TEditButton.Create(form);
    editButton.Parent := top;
    editButton.Align := alRight;
    editButton.Width := 90;
    editButton.Button.Flat := true;
    editButton.BorderStyle := bsNone;
    editButton.Name := 'InspectorSearch';
    editButton.Hint := 'Search Inspector';
    editButton.Button.Hint := 'Clear Search';
    editButton.Button.Glyph.LoadFromResource('bmp_delfilter');
    editButton.ShowHint := true;
    editButton.Font.Style := 0;
    editButton.Text := '<search>';
    editButton.Font.Color := clGrayText;
    editButton.TabStop := false;
    editButton.BorderSpacing.Bottom := 2;
    editButton.Color := top.Color;
    editButton.BackColor := top.Color;
    editButton.ButtonWidth := form.Canvas.TextHeight('|') + 8;
    editButton.OnEnter := @pane_Search_Enter;
    editButton.OnExit := @pane_Search_Exit;
    editButton.OnButtonClick := @pane_Search_ButtonClick;
    editButton.OnChange := @rightside_InspectorChange;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := top;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose');
    CloseB.Name := 'PropertiesPanelClose';
    CloseB.Flat := true;
    CloseB.Hint := 'Close';
    CloseB.Left := top.Width;
    closeB.ShowHint := true;
    closeB.BorderSpacing.Bottom := 2;
    closeB.Width := form.Canvas.TextHeight('|') + 8;
    closeB.OnClick := @rightside_InspectorPaneCloseClick;

    PropTabs := TATTabs.Create(form);
    PropTabs.Parent := sub;
    PropTabs.Align := alTop;
    PropTabs.Top := 40;
    PropTabs.Left := 0;
    PropTabs.Width := sub.Width;
    PropTabs.Anchors := akLeft + akTop + akRight;
    PropTabs.Height := 30;
    PropTabs.ColorBG := clForm;
    PropTabs.ColorTabActive := clWindow;
    PropTabs.ColorTabPassive := clBtnFace;
    PropTabs.ColorTabOver := clWindow;
    PropTabs.ColorBorderActive := clSilver;
    PropTabs.ColorBorderPassive := clSilver;
    PropTabs.Font.Color := clWindowText;
    PropTabs.TabShowPlus := false;
    PropTabs.TabShowMenu := false;
    PropTabs.TabIndentInit := 0;
    PropTabs.Images := MainImages;
    PropTabs.TabShowClose := tbShowNone;
    PropTabs.TabAngle := 5;
    PropTabs.Font.Assign(form.Font);
    PropTabs.TabIndentText := form.Canvas.TextHeight('|') div 4;
    PropTabs.OnTabClick := @rightside_TabClick;
    PropTabs.TabDragEnabled := false;
    PropTabs.TabDragOutEnabled := false;
    top.BringToFront;

    EventTree := TTreeView.Create(form);
    EventTree.Options := tvoAutoItemHeight or tvoHideSelection;
    EventTree.Parent := sub;
    EventTree.Align := alClient;
    if appSettings.Values['show-scrollbar'] = '1' then
    EventTree.ScrollBars := ssAutoVertical
    else
    EventTree.ScrollBars := ssNone;
    EventTree.Name := 'EventTree';
    EventTree.ReadOnly := true;
    EventTree.RowSelect := true;
    EventTree.RightClickSelect := true;
    EventTree.BorderStyle := bsNone;
    EventTree.Images := MainImages;
    EventTree.ShowLines := false;
    EventTree.Images := treeHeight;
    EventTree.ShowRoot := false;
    EventTree.DoubleBuffered := true;
    EventTree.Visible := false;
    EventTree.ShowHint := false;

    PropTree := TTreeView.Create(form);
    PropTree.Options := tvoAutoItemHeight or tvoHideSelection;
    PropTree.Parent := sub;
    PropTree.Align := alClient;
    if appSettings.Values['show-scrollbar'] = '1' then
    PropTree.ScrollBars := ssAutoVertical
    else
    PropTree.ScrollBars := ssNone;
    PropTree.Name := 'PropTree';
    PropTree.ReadOnly := true;
    PropTree.RowSelect := true;
    PropTree.RightClickSelect := true;
    PropTree.BorderStyle := bsNone;
    PropTree.Images := MainImages;
    PropTree.ShowLines := false;
    PropTree.Images := treeHeight;
    PropTree.ShowRoot := false;
    PropTree.DoubleBuffered := true;
    PropTree.ShowHint := false;

    PropTabs.AddTab(0, 'Properties', PropTree, 11);
    PropTabs.AddTab(1, 'Events', EventTree, 12);
end;

procedure rightside_TabClick(Sender: TATTabs);
begin
    case Sender.TabIndex of
        0:  begin
                PropTree.Visible := true;
                EventTree.Visible := false;
                PropTree.BringToFront;
                if doGetActiveDesigner <> nil then
                doGetActiveDesigner.UpdateEditor(false);
            end;
        1:  begin
                PropTree.Visible := false;
                EventTree.Visible := true;
                EventTree.BringToFront;
                if doGetActiveDesigner <> nil then
                doGetActiveDesigner.UpdateEditor(true);
            end;
    end;
end;

procedure rightside_InspectorChange(Sender: TEditButton);
begin
    if ActiveProjectFile <> '' then
    if doGetActiveDesigner <> nil then
    begin
        doGetActiveDesigner.PropertiesFilter := Sender.Text;
        doGetActiveDesigner.PopulateProperties;
    end;
end;

procedure rightside_ObjectSearch(Sender: TEditButton);
begin
    if ActiveProjectFile <> '' then
    if doGetActiveDesigner <> nil then
    begin
        doGetActiveDesigner.ObjectsFilter := Sender.Text;
        doGetActiveDesigner.PopulateObjects;
    end;
end;

procedure rightside_ObjectPaneCloseClick(Sender: TObject);
begin
    TMenuItem(MainForm.find('mObjectsPaneCheck')).Click;
end;

procedure rightside_InspectorPaneCloseClick(Sender: TObject);
begin
    TMenuItem(MainForm.find('mInspectorPaneCheck')).Click;
end;

//unit constructor
constructor begin end.
