////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createTodo(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @todo_OnCreate);
end;

procedure todo_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    list: TListView;
    col: TListColumn;
begin
    Sender.Caption := 'Todo List';
    Sender.Width := 500;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stAlways;
    Sender.Position := poDesigned;
    Sender.Left := Screen.Width - 550;
    Sender.Top := 50;
    Sender.Color := clForm;
    Sender.OnClose := @todo_OnClose;
    Sender.OnActivate := @todo_OnActivate;

    list := TListView.Create(Sender);
    list.Parent := Sender;
    list.Align := alClient;
    list.BorderSpacing.Around := 3;
    list.Name := 'list';
    list.SmallImages := MainImages;
    list.ReadOnly := true;
    list.RowSelect := true;
    list.ViewStyle := vsReport;
    list.ScrollBars := ssAutoBoth;
    list.OnDblClick := @todo_listDblClick;
    list.OnKeyDown := @todo_listKeyDown;
    list.ColumnClick := false;

    col := list.Columns.Add;
    col.Caption := 'Status';
    col.Width := 65;

    col := list.Columns.Add;
    col.Caption := 'Todo';

    col := list.Columns.Add;
    col.Caption := 'Unit';
    col.Width := 80;

    Sender.OnResize := @todo_OnResize;
end;

procedure todo_listDblClick(Sender: TListView);
var
    fname: string;
    line,i: int;
begin
    if Sender.SelCount <> 0 then
    begin
        fname := Sender.Selected.SubItems.Strings[2];
        line := StrToInt(Sender.Selected.SubItems.Strings[3]);
        if isUnitOpen(fname) then
        begin
            doSetAtivePageTab(0);
            doGetActiveCodeEditor.CaretY := line +1;
        end
            else
        begin
            for i := 0 to ProjectTree.Items.Count -1 do
            begin
                if ProjectTree.Items.Item[i].Text = FileNameOf(fname) then
                begin
                    ProjectTree.Items.Item[i].Selected := true;
                    break;
                end;
            end;
            TAction(MainForm.find('actEditUnit')).Execute;
            doSetAtivePageTab(0);
            doGetActiveCodeEditor.CaretY := line +1;
        end;
        doGetActiveCodeEditor.Invalidate;
    end;
end;

procedure todo_listKeyDown(Sender: TListView; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 13 then
    todo_listDblClick(Sender);
end;

procedure todo_OnResize(Sender: TForm);
begin
    TListView(Sender.find('list')).Columns[1].Width := Sender.Width -175;
end;

procedure todo_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caHide;
end;

procedure todo_OnActivate(Sender: TForm);
var
    i, j: int;
    str: TStringList;
    found: TStringList;
    fname: string;
    item: TListItem;
    list: TListView;
    selIndex: int;
begin
    list := TListView(Sender.find('list'));

    if list.selCount <> 0 then
    selIndex := list.Selected.Index
    else
    selIndex := -1;

    list.Items.BeginUpdate;
    list.Items.Clear;
    list.Cursor := crHourGlass;
    Application.ProcessMessages;

    found := TStringList.Create;
    str := TStringList.Create;
    for i := 0 to ActiveProject.Count -1 do
    begin
        if Pos('file=', ActiveProject.Strings[i]) > 0 then
        begin
            fname := FilePathOf(ActiveProjectFile)+
                copy(ActiveProject.Strings[i],
                        Pos('=', ActiveProject.Strings[i]) +1, 1000);
            if FileExists(fname) then
            begin
                str.LoadFromFile(fname);
                //ShowMessage(fname);
                for j := 0 to str.Count -1 do
                begin
                    if Pos('todo:', Lower(str.Strings[j])) > 0 then
                    begin
                        item := list.items.Add;
                        item.Caption := 'TODO';
                        item.SubItems.Add(copy(str.Strings[j], Pos('todo:', Lower(str.Strings[j])) + 5, 1000));
                        item.SubItems.Add(FileNameOf(fname));
                        item.SubItems.Add(fname);
                        item.SubItems.Add(IntToStr(j));
                        item.ImageIndex := 70;
                    end;
                    if Pos('done:', Lower(str.Strings[j])) > 0 then
                    begin
                        item := list.items.Add;
                        item.Caption := 'DONE';
                        item.SubItems.Add(copy(str.Strings[j], Pos('done:', Lower(str.Strings[j])) + 5, 1000));
                        item.SubItems.Add(FileNameOf(fname));
                        item.SubItems.Add(fname);
                        item.SubItems.Add(IntToStr(j));
                        item.ImageIndex := 86;
                    end;
                    if Pos('note:', Lower(str.Strings[j])) > 0 then
                    begin
                        item := list.items.Add;
                        item.Caption := 'NOTE';
                        item.SubItems.Add(copy(str.Strings[j], Pos('note:', Lower(str.Strings[j])) + 5, 1000));
                        item.SubItems.Add(FileNameOf(fname));
                        item.SubItems.Add(fname);
                        item.SubItems.Add(IntToStr(j));
                        item.ImageIndex := 45;
                    end;
                end;
            end;
        end;
    end;
    str.Free;
    found.Free;

    if selIndex <> -1 then
    begin
        try list.Items.Item[selIndex].Selected := true; except end;
    end;

    list.Items.EndUpdate;

    list.Cursor := crDefault;
    Application.ProcessMessages;
end;

//unit constructor
constructor begin end.
