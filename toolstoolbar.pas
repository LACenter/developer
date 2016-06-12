////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

//IMPORTANT!
//COMPONENT CREATED IN THIS UNIT CAN NOT BE FOUND IN MAINFORM
//THE OWNER IS THE CODEUNIT FORM

uses 'globals';

procedure CreateToolsToolbar(form: TForm; Parent: TPanel);
var
    bar: TToolbar;
    tb: TToolButton;
    menu: TMenuItem;
    movePop: TPopupMenu;
    sizePop: TPopupMenu;
begin
    bar := TToolbar.Create(form);
    bar.Parent := Parent;
    bar.Images := MainImages;
    bar.Name := 'ToolsToolBar';
    bar.EdgeBorders := 0;
    bar.ButtonWidth := 26;
    bar.ButtonHeight := 26;
    bar.AutoSize := true;
    bar.BorderSpacing.Top := 2;
    bar.ShowHint := true;

    movePop := TPopupMenu.Create(form);
    movePop.Images := MainImages;
    sizePop := TPopupMenu.Create(form);
    sizePop.Images := MainImages;

    //Important!
    //since the owner is codeunit we need to use MainForm.find to find actions
    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actBringToFront'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actSendToBack'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actAlignLeftSides'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actAlignTopSides'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actAlignRightSides'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actAlignBottomSides'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actCenterHorz'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actCenterVert'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actSizeControls'));
    tb.DropDownMenu := sizePop;

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actSizeControlsLeft'));
        sizePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actSizeControlsTop'));
        sizePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actSizeControlsRight'));
        sizePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actSizeControlsBottom'));
        sizePop.Items.Add(menu);

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actMoveControls'));
    tb.DropDownMenu := movePop;

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actMoveControlsLeft'));
        movePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actMoveControlsTop'));
        movePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actMoveControlsRight'));
        movePop.Items.Add(menu);

        menu := TMenuItem.Create(form);
        menu.Action := TAction(MainForm.Find('actMoveControlsBottom'));
        movePop.Items.Add(menu);

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actTabOrder'));

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actChangeParent'));

        tb := TToolButton.Create(form); tb.parent := bar; tb.Style := tbsDivider; tb.width := 5;

    tb := TToolButton.Create(form);
    tb.parent := bar;
    tb.Action := TAction(MainForm.Find('actDelete'));
end;

//unit constructor
constructor begin end.
