////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'envgeneral', 'envdesigner', 'enveditor';

var
    quickRef: TStringList;
    quickRefFinder: string;

function createQuickRef(Owner: TForm; refstr: TStringList; finder: string = ''): TForm;
begin
    quickRef := refstr;
    quickRefFinder := finder;
    result := TForm.CreateWithConstructor(Owner, @quickref_OnCreate);
end;

procedure quickref_OnCreate(Sender: TForm);
var
    tree: TTreeView;
    i: int;
    pop: TPopupMenu;
    refTimer: TTimer;
begin
    Sender.BorderStyle := fbsSizeable;
    Sender.BorderIcons := biSystemMenu + biMinimize;
    Sender.Caption := 'Quick Reference';
    Sender.Width := 500;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stAlways;
    Sender.Position := poDesigned;
    Sender.PopupParent := TForm(Sender.Owner);
    Sender.Color := clForm;
    Sender.OnClose := @quickref_OnClose;
    Sender.OnCloseQuery := @quickref_OnCloseQuery;
    Sender.Left := Screen.Width - 550;
    Sender.Top := 50;
    Sender.OnShow := @quickref_OnShow;

    refTimer := TTimer.Create(Sender);
    refTimer.Enabled := false;
    refTimer.Interval := 500;
    refTimer.OnTimer := @quickref_OnTimer;
    refTimer.Name := 'refTimer';

    tree := TTreeView.Create(Sender);
    tree.Parent := Sender;
    tree.Align := alClient;
    tree.BorderSpacing.Around := 5;
    tree.ReadOnly := true;
    tree.RowSelect := true;
    tree.ScrollBars := ssAutoBoth;
    tree.BorderStyle := bsNone;
    tree.Name := 'tree';
    tree.Images := MainImages;
    tree.OnGetImageIndex := @quickref_OnGetImage;
    tree.OnExpanded := @quickref_OnExpanded;
    tree.OnCollapsed := @quickref_OnCollapsed;

    tree.Items.BeginUpdate;

    quickRef.SaveToFile(TempDir+'tmp.tmp');
    TTreeView(Sender.find('tree')).LoadFromFile(TempDir+'tmp.tmp');
    DeleteFile(TempDir+'tmp.tmp');
    TTreeView(Sender.find('tree')).AlphaSort;

    tree.Items.EndUpdate;

    if quickRefFinder <> '' then
    begin
        if quickRefFinder[1] = 'T' then
        begin
            for i := 0 to tree.Items.Count -1 do
            begin
                if tree.Items.Item[i].Level = 1 then
                begin
                    if Pos(Lower(quickRefFinder+' = class('), Lower(tree.Items.Item[i].Text)) > 0 then
                    begin
                        tree.Items.Item[i].Selected := true;
                        tree.Items.Item[i].ImageIndex := 97;
                        tree.Items.Item[i].SelectedIndex := tree.Items.Item[i].ImageIndex;
                        tree.Items.Item[i].MakeVisible;
                        break;
                    end;
                end;
            end;
        end
            else
        begin
            for i := 0 to tree.Items.Count -1 do
            begin
                if tree.Items.Item[i].Level = 2 then
                begin
                    if Pos(Lower(quickRefFinder+'('), Lower(tree.Items.Item[i].Text)) > 0 then
                    begin
                        tree.Items.Item[i].Selected := true;
                        if (Pos('):', tree.Items.Item[i].Text) > 0) then
                        tree.Items.Item[i].ImageIndex := 99
                        else
                        tree.Items.Item[i].ImageIndex := 100;
                        tree.Items.Item[i].SelectedIndex := tree.Items.Item[i].ImageIndex;
                        tree.Items.Item[i].MakeVisible;
                        break;
                    end;
                end;
            end;
        end;
    end;

    pop := TPopupMenu.Create(Sender);
    pop.OnPopup := @quickref_OnPop;
    tree.PopupMenu := pop;
end;

procedure quickref_OnTimer(Sender: TTimer);
var
    node: TTreeNode = nil;
begin
    Sender.Enabled := false;
    if TTreeView(Sender.Owner.Find('tree')).Selected <> nil then
    node := TTreeView(Sender.Owner.Find('tree')).Selected;

    if node <> nil then
    begin
        node.Parent.Selected := true;
        Wait(100);
        node.Selected := true;
        node.MakeVisible;
        TForm(Sender.Owner).Width := TForm(Sender.Owner).Width +20;
    end;
end;

procedure quickref_OnShow(Sender: TForm);
begin
    TTimer(Sender.Find('refTimer')).Enabled := true;
end;

procedure quickref_OnExpanded(Sender: TTreeView; node: TTreeNode);
begin
    if node.ImageIndex = 13 then
    begin
        node.ImageIndex := 14;
        node.SelectedIndex := node.ImageIndex;
    end;
end;

procedure quickref_OnCollapsed(Sender: TTreeView; node: TTreeNode);
begin
    if node.ImageIndex = 14 then
    begin
        node.ImageIndex := 13;
        node.SelectedIndex := node.ImageIndex;
    end;
end;

procedure quickref_OnPop(Sender: TPopupMenu);
var
    tree: TTreeView;
    menu: TMenuItem;
begin
    tree := TTreeView(Sender.Owner.find('tree'));

    Sender.Items.Clear;

    if tree.Selected <> nil then
    begin
        if not (tree.Selected.ImageIndex in [13,14]) then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Open Online Documentation';
            menu.OnClick := @quickref_OnOpenOnline;
            Sender.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            Sender.Items.Add(menu);
        end;
    end;

    menu := TMenuItem.Create(Sender.Owner);
    menu.Caption := 'Expand All';
    menu.OnClick := @quickref_OnExpandAll;
    Sender.Items.Add(menu);

    menu := TMenuItem.Create(Sender.Owner);
    menu.Caption := 'Collapse All';
    menu.OnClick := @quickref_OnCollapseAll;
    Sender.Items.Add(menu);

    if tree.Selected <> nil then
    begin
        if (tree.Selected.ImageIndex = 97) and
           (Pos('class()', tree.Selected.Text) = 0) then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            Sender.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Go to Parent Class';
            menu.OnClick := @quickref_OnGotoParent;
            Sender.Items.Add(menu);
        end
        else
        if tree.Selected.ImageIndex = 13 then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            Sender.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Expand';
            menu.OnClick := @quickref_OnExpand;
            Sender.Items.Add(menu);
        end
        else
        if tree.Selected.ImageIndex = 14 then
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            Sender.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Collapse';
            menu.OnClick := @quickref_OnCollapse;
            Sender.Items.Add(menu);
        end
        else
        begin
            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := '-';
            Sender.Items.Add(menu);

            menu := TMenuItem.Create(Sender.Owner);
            menu.Caption := 'Copy Text';
            menu.OnClick := @quickref_OnCopyText;
            Sender.Items.Add(menu);
        end;
    end;
end;

procedure quickref_OnOpenOnline(Sender: TMenuItem);
var
    tree: TTreeView;
    code: string = '';
begin
    tree := TTreeView(Sender.Owner.find('tree'));

    if tree.Selected <> nil then
    begin
        if tree.Selected.ImageIndex in [97] then
        begin
            code := tree.Selected.Text;
            code := Trim(copy(code, 0, Pos(' ', code) -1));
            code := 'https://liveapps.center/docs/'+Lower(code);
        end;

        if tree.Selected.ImageIndex in [98..101] then
        begin
            if tree.Selected.Parent.ImageIndex in [13,14] then
            begin
                code := tree.Selected.Parent.Text+'-'+tree.Selected.Parent.Parent.Text;
                code := ReplaceAll(code, '/', '-');
                code := 'https://liveapps.center/docs/'+Lower(code)+'#'+tree.Selected.Text;
            end
                else
            begin
                code := tree.Selected.Parent.Text;
                code := Trim(copy(code, 0, Pos(' ', code) -1));
                code := 'https://liveapps.center/docs/'+Lower(code)+'#'+tree.Selected.Text;
            end;
        end;

        if tree.Selected.ImageIndex in [102] then
        begin
            code := tree.Selected.Text;
            code := Trim(copy(code, 0, Pos(':', code) -1));
            code := 'https://liveapps.center/docs/'+Lower(code);
        end;

        if tree.Selected.ImageIndex in [103] then
        begin
            code := tree.Selected.Text;
            code := Trim(copy(code, Pos(':', code) +1, 100));
            code := 'https://liveapps.center/docs/'+Lower(code);
        end;
    end;


    if (tree.Selected <> nil) and (code <> '') then
        ShellOpen(code);
end;

procedure quickref_OnCopyText(Sender: TMenuItem);
var
    tree: TTreeView;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    if tree.Selected <> nil then
        clip.setText(tree.Selected.Text);
end;

procedure quickref_OnCollapseAll(Sender: TMenuItem);
var
    tree: TTreeView;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    tree.FullCollapse;
end;

procedure quickref_OnExpandAll(Sender: TMenuItem);
var
    tree: TTreeView;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    tree.FullExpand;
end;

procedure quickref_OnExpand(Sender: TMenuItem);
var
    tree: TTreeView;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    if tree.Selected <> nil then
        tree.Selected.Expand(false);
end;

procedure quickref_OnCollapse(Sender: TMenuItem);
var
    tree: TTreeView;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    if tree.Selected <> nil then
        tree.Selected.Collapse(false);
end;

procedure quickref_OnGotoParent(Sender: TMenuItem);
var
    tree: TTreeView;
    i: int;
    className: string;
begin
    tree := TTreeView(Sender.Owner.find('tree'));
    if tree.Selected <> nil then
    begin
        className := copy(tree.Selected.Text, Pos('(', tree.Selected.Text) +1, 100);
        className := copy(className, 0, Pos(')', className) -1);

        for i := 0 to tree.Items.Count -1 do
        begin
            if tree.Items.Item[i].Level = 1 then
            begin
                if Pos(className+' = class(', tree.Items.Item[i].Text) > 0 then
                begin
                    tree.Items.Item[i].Selected := true;
                    tree.Items.Item[i].ImageIndex := 97;
                    tree.Items.Item[i].SelectedIndex := tree.Items.Item[i].ImageIndex;
                    tree.Items.Item[i].MakeVisible;
                    break;
                end;
            end;
        end;
    end;
end;

procedure quickref_OnGetImage(Sender: TTreeView; item: TTreeNode);
begin
    if item.Level = 0 then
    begin
        if item.Expanded then
        item.ImageIndex := 14
        else
        item.ImageIndex := 13;
        item.SelectedIndex := item.ImageIndex;
    end;
    if (item.Level = 1) and (item.Parent.Text = 'Classes') then
    begin
        item.ImageIndex := 97;
        item.SelectedIndex := item.ImageIndex;
    end;
    if (item.Level = 1) and (item.Parent.Text = 'Functions') then
    begin
        if item.Expanded then
        item.ImageIndex := 14
        else
        item.ImageIndex := 13;
        item.SelectedIndex := item.ImageIndex;
    end;
    if (item.Level = 1) and (item.Parent.Text = 'Types') then
    begin
        item.ImageIndex := 102;
        item.SelectedIndex := item.ImageIndex;
    end;
    if (item.Level = 1) and (item.Parent.Text = 'Variables') then
    begin
        item.ImageIndex := 103;
        item.SelectedIndex := item.ImageIndex;
    end;

    if (Pos('event ', item.Text) > 0) then
    begin
        item.ImageIndex := 101;
        item.SelectedIndex := item.ImageIndex;
    end;

    if (Pos('property ', item.Text) > 0) then
    begin
        item.ImageIndex := 98;
        item.SelectedIndex := item.ImageIndex;
    end;

    if (Pos('function ', item.Text) > 0) then
    begin
        item.ImageIndex := 99;
        item.SelectedIndex := item.ImageIndex;
    end;

    if (Pos('procedure ', item.Text) > 0) then
    begin
        item.ImageIndex := 100;
        item.SelectedIndex := item.ImageIndex;
    end;

    if (item.Level = 2) and
       (item.Parent.ImageIndex in [13, 14]) then
    begin
        if (Pos('):', item.Text) > 0) then
        begin
            item.ImageIndex := 99;
            item.SelectedIndex := item.ImageIndex;
        end
            else
        begin
            item.ImageIndex := 100;
            item.SelectedIndex := item.ImageIndex;
        end;
    end;
end;

procedure quickref_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure quickref_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin

end;

//unit constructor
constructor begin end.
