////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

procedure createToolbar(form: TForm);
var
    bar: TToolbar;
    tb: TToolButton;
    toolPop: TPopupMenu;
    menu: TMenuItem;
    editButton: TEditButton;
    closeB: TSpeedButton;
begin
    bar := TToolbar.Create(form);
    bar.Parent := form;
    bar.Images := MainImages;
    bar.Name := 'ToolBar';
    bar.EdgeBorders := 0;
    bar.ButtonWidth := 32;
    bar.ButtonHeight := 32;
    bar.AutoSize := true;
    bar.BorderSpacing.Left := 2;
    bar.BorderSpacing.Right := 2;
    bar.BorderSpacing.Bottom := 2;
    bar.BorderSpacing.Top := 2;
    bar.ShowHint := true;
    bar.Transparent := false;
    bar.Color := form.Color;
    bar.Wrapable := false;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actNewProject'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actOpenProject'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actNewUnit'));

        ////////////////////////////////////////////////////////////////
        toolPop := TPopupMenu.Create(form);
        toolPop.Images := MainImages;

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCreateUnit'));
        toolPop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCreateForm'));
        toolPop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCreateFrame'));
        toolPop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCreateModule'));
        toolPop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(form.Find('actCreateReport'));
        toolPop.Items.Add(menu);

        tb.DropDownMenu := toolPop;
        ////////////////////////////////////////////////////////////////

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actAddUnit'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actEditUnit'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actRenameUnit'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actRemoveUnit'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    //we won't need open for now
    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actOpen'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actSave'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actSaveAll'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actUndo'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actRedo'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actCut'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actCopy'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actPaste'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actRun'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actDebugRun'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actContinue'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actStep'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actCompile'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actResources'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actBuild'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actTargets'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actPublishProject'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actTodo'));


    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actFindPrev'));
    tb.Align := alRight;
    tb.Width := 32;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(form.Find('actFindNext'));
    tb.Align := alRight;
    tb.Width := 32;
    tb.BorderSpacing.Right := 5;




////////////////////////////////////////////////////////////////////////


    editButton := TEditButton.Create(form);
    editButton.Parent := bar;
    editButton.Align := alRight;
    editButton.Width := 90;
    editButton.Button.Flat := true;
    editButton.BorderStyle := bsNone;
    editButton.Name := 'UnitSearch';
    editButton.Hint := 'Search Unit';
    editButton.Button.Hint := 'Clear Search';
    editButton.Button.Glyph.LoadFromResource('bmp_delfilter');
    editButton.ShowHint := true;
    editButton.Font.Style := 0;
    editButton.Text := '<search>';
    editButton.Font.Color := clGrayText;
    editButton.TabStop := false;
    editButton.BorderSpacing.Top := 5;
    editButton.BorderSpacing.Bottom := 5;
    editButton.Color := bar.Color;
    editButton.ButtonWidth := form.Canvas.TextHeight('|') + 8;
    editButton.OnEnter := @pane_Search_Enter;
    editButton.OnExit := @pane_Search_Exit;
    editButton.OnButtonClick := @pane_Search_ButtonClick;
    editButton.OnKeyDown := @toolbar_Search_KeyDown;

    closeB := TSpeedButton.Create(form);
    closeB.Parent := bar;
    closeB.Align := alRight;
    CloseB.Caption := '';
    CloseB.Glyph.LoadFromResource('bmp_pclose2');
    CloseB.Font.Color := clRed;
    CloseB.Font.Style := fsBold;
    CloseB.Name := 'CloseButton';
    CloseB.Flat := true;
    CloseB.Hint := 'Close Page/Project';
    CloseB.Left := editButton.Left + editButton.Width;
    closeB.ShowHint := true;
    closeB.BorderSpacing.Top := 5;
    closeB.BorderSpacing.Bottom := 4;
    closeB.BorderSpacing.Right := 3;
    closeB.OnClick := @toolbar_Close_Click;
    closeB.Width := form.Canvas.TextHeight('|') + 8;

    progress := TProgressBar.Create(form);
    progress.Parent := bar;
    progress.Align := alRight;
    progress.BorderSpacing.Top := 8;
    progress.BorderSpacing.Bottom := 8;
    progress.Name := 'Progress';
    progress.Style := pbstMarquee;
    progress.Color := clNone;
    progress.Width := 100;
    progress.Left := editButton.Left - 110;
    progress.BorderSpacing.Right := 10;
    progress.Visible := false;
end;

procedure toolbar_Search_KeyDown(Sender: TEditButton; var Key: int; keyInfo: TKeyInfo);
begin
    if Pages.TabCount = 0 then exit;

    if Key = 13 then
    begin
        if (Sender.Text <> '') and
           (Sender.Text <> '<search>') then
        begin
            doSetAtivePageTab(0);
            doGetActiveCodeEditor.SearchFor(Sender.Text, false, false, false);
        end;
    end;
end;

//unit constructor
constructor begin end.
