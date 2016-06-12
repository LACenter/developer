////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

procedure createLeftSide(form: TForm);
var
    pane, sub, top: TPanel;
    splitter: TSplitter;
    closeB: TSpeedButton;
    editButton: TEditButton;
    ProjectTreePop: TPopupMenu;
    menu: TMenuItem;
begin
    pane := TPanel.Create(form);
    pane.Parent := form;
    pane.Name := 'leftPanel';
    pane.Align := alLeft;
    pane.Width := 220;
    pane.BevelOuter := bvNone;
    pane.ParentColor := true;
    pane.Caption := '';
    pane.BorderSpacing.Left := 5;
    pane.BorderSpacing.Bottom := 2;
    leftPanel := pane;

    splitter := TSplitter.Create(form);
    splitter.Parent := form;
    splitter.Name := 'leftSplitter';
    splitter.Align := alLeft;
    splitter.Left := 220;
    leftOutSplitter := splitter;

    sub := TPanel.Create(form);
    sub.Parent := pane;
    sub.Align := alTop;
    sub.Name := 'ProjectTreePanel';
    sub.BevelOuter := bvNone;
    sub.ParentColor := true;
    sub.Height := 200;
    sub.Caption := '';
    leftTopPanel := sub;

    top := TPanel.Create(form);
    top.Parent := sub;
    top.Align := alTop;
    top.Height := form.Canvas.TextHeight('|') + 8;
    top.Alignment := taLeftJustify;
    top.BevelOuter := bvNone;
    top.Name := 'ProjectTreePanelTop';
    top.Caption := ' Project';
    top.Font.Style := fsBold;

    editButton := TEditButton.Create(form);
    editButton.Parent := top;
    editButton.Align := alRight;
    editButton.Width := 90;
    editButton.Button.Flat := true;
    editButton.BorderStyle := bsNone;
    editButton.Name := 'ProjectSearch';
    editButton.Hint := 'Search Project';
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
    editButton.OnChange := @leftside_ProjectSearch;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := top;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose');
    CloseB.Name := 'ProjectTreePanelClose';
    CloseB.Flat := true;
    CloseB.Hint := 'Close';
    CloseB.Left := top.Width;
    closeB.ShowHint := true;
    closeB.BorderSpacing.Bottom := 2;
    closeB.Width := form.Canvas.TextHeight('|') + 8;
    closeB.OnClick := @leftside_ProjectPaneCloseClick;

    ProjectTree := TTreeView.Create(form);
    ProjectTree.Parent := sub;
    ProjectTree.Align := alClient;
    if appSettings.Values['show-scrollbar'] = '1' then
    ProjectTree.ScrollBars := ssAutoVertical
    else
    ProjectTree.ScrollBars := ssNone;
    ProjectTree.Name := 'ProjectTree';
    ProjectTree.ReadOnly := true;
    ProjectTree.RowSelect := true;
    ProjectTree.RightClickSelect := true;
    ProjectTree.BorderStyle := bsNone;
    ProjectTree.Images := MainImages;
    ProjectTree.ShowLines := false;
    ProjectTree.OnDblClick := @leftside_ProjectTreeDblClick;

    splitter := TSplitter.Create(form);
    splitter.Parent := pane;
    splitter.Align := alTop;
    splitter.Top := sub.Height;
    splitter.Name := 'leftInSplitter';
    leftInSplitter := splitter;

    sub := TPanel.Create(form);
    sub.Parent := pane;
    sub.Align := alClient;
    sub.Name := 'ToolboxPanel';
    sub.BevelOuter := bvNone;
    sub.ParentColor := true;
    sub.Height := 240;
    sub.Caption := '';
    leftBottomPanel := sub;

    top := TPanel.Create(form);
    top.Parent := sub;
    top.Align := alTop;
    top.Height := form.Canvas.TextHeight('|') + 8;
    top.Alignment := taLeftJustify;
    top.BevelOuter := bvNone;
    top.Name := 'ToolboxPanelTop';
    top.Caption := ' Toolbox';
    top.Font.Style := fsBold;

    editButton := TEditButton.Create(form);
    editButton.Parent := top;
    editButton.Align := alRight;
    editButton.Width := 90;
    editButton.Button.Flat := true;
    editButton.BorderStyle := bsNone;
    editButton.Name := 'ToolBoxSearch';
    editButton.Hint := 'Search Toolbox';
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
    editButton.OnChange := @pane_ToolboxSearch_Change;
    editButton.OnButtonClick := @pane_Search_ButtonClick;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := top;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose');
    CloseB.Name := 'ToolboxPanelClose';
    CloseB.Flat := true;
    CloseB.Hint := 'Close';
    closeB.Left := top.Width;
    closeB.ShowHint := true;
    closeB.BorderSpacing.Bottom := 2;
    closeB.Width := form.Canvas.TextHeight('|') + 8;
    closeB.OnClick := @leftside_ToolboxPaneCloseClick;

    ToolboxTree := TTreeView.Create(form);
    ToolboxTree.Parent := sub;
    ToolboxTree.Align := alClient;
    if appSettings.Values['show-scrollbar'] = '1' then
    ToolboxTree.ScrollBars := ssAutoVertical
    else
    ToolboxTree.ScrollBars := ssNone;
    ToolboxTree.Name := 'ToolboxTree';
    ToolboxTree.ReadOnly := true;
    ToolboxTree.RowSelect := true;
    ToolboxTree.RightClickSelect := true;
    ToolboxTree.BorderStyle := bsNone;
    ToolboxTree.Images := ToolboxImages;
    ToolboxTree.ShowLines := false;
    ToolboxTree.DragKind := dkDrag;
    ToolboxTree.DragMode := dmAutomatic;

    ProjectTreePop := TPopupMenu.Create(form);
    ProjectTreePop.Name := 'ProjectTreePop';
    ProjectTreePop.Images := MainImages;

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actCreateUnit'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actCreateForm'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actCreateFrame'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actCreateModule'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actCreateReport'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Caption := '-';
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actAddUnit'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actEditUnit'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actRenameUnit'));
    ProjectTreePop.Items.Add(menu);

    menu := TMenuItem.Create(form);
    menu.Action := TAction(form.find('actRemoveUnit'));
    ProjectTreePop.Items.Add(menu);

    ProjectTree.PopupMenu := ProjectTreePop;
end;

procedure leftside_ProjectTreeDblClick(Sender: TTreeView);
begin
    TAction(MainForm.find('actEditUnit')).Execute;
end;

procedure pane_ToolboxSearch_Change(Sender: TEditButton);
begin
    if ActiveProjectFile <> '' then
    doPopulateToolbox((Pos('UI ', ActiveProject.Values['type']) > 0));
end;

procedure leftside_ProjectSearch(Sender: TEditButton);
begin
    if ActiveProjectFile <> '' then
    doPopulateProjectTree(false, Sender.Text);
end;

procedure leftside_ProjectPaneCloseClick(Sender: TObject);
begin
    TMenuItem(MainForm.find('mProjectPaneCheck')).Click;
end;

procedure leftside_ToolboxPaneCloseClick(Sender: TObject);
begin
    TMenuItem(MainForm.find('mToolBoxPaneCheck')).Click;
end;

//unit constructor
constructor begin end.
