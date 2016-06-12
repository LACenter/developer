////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'resadd';

var
    resmanStr: TStringList;
    resmanFile: string;

function createResMan(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @resman_OnCreate);
end;

procedure resman_OnCreate(Sender: TForm);
var
    list: TListView;
    col: TListColumn;
    bt: TButton;
    i: int;
    rname, fname: string;
    item: TListItem;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Resource Manager';
    Sender.Width := 500;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @resman_OnClose;
    Sender.OnCloseQuery := @resman_OnCloseQuery;

    resmanFile := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
    resmanStr := TStringList.Create;
    resmanStr.LoadFromFile(resmanFile);

    list := TListView.Create(Sender);
    list.Parent := Sender;
    list.Left := 20;
    list.Top := 20;
    list.Height := 360;
    list.Width := 380;
    list.ScrollBars := ssAutoVertical;
    list.ViewStyle := vsReport;
    list.Name := 'list';
    list.SmallImages := MainImages;
    list.OnChange := @resman_ListChange;
    list.ReadOnly := true;
    list.RowSelect := true;
    list.OnDblClick := @resman_ListDblClick;

    col := list.Columns.Add;
    col.Caption := 'Resource Name';
    col.Width := 150;

    col := list.Columns.Add;
    col.Caption := 'File Name';
    col.Width := 205;

    for i := 0 to resmanStr.Count -1 do
    begin
        //appicon and form resources are not managed from here
        //so we need to exclude them
        if (Pos(':appicon=', resmanStr.Strings[i]) = 0) and
           (Pos('.frm', resmanStr.Strings[i]) = 0) and
           (Pos('$'+'res:', resmanStr.Strings[i]) > 0) then
        begin
            rname := copy(resmanStr.Strings[i], Pos(':', resmanStr.Strings[i]) +1, 1000);
            fname := copy(rname, Pos('=', rname) + 1, 1000);
            fname := copy(fname, Pos(']', fname) +1, 1000);
            rname := copy(rname, 0, Pos('=', rname) -1);

            item := list.Items.Add;
            item.Caption := rname;
            item.SubItems.Add(fname);
            item.ImageIndex := 87;
        end;
    end;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 410;
    bt.Top := 20;
    bt.Width := 70;
    bt.Height := 25;
    bt.Name := 'btAdd';
    bt.Caption := 'Add';
    bt.OnClick := @resman_AddClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 410;
    bt.Top := 50;
    bt.Width := 70;
    bt.Height := 25;
    bt.Name := 'btReplace';
    bt.Caption := 'Replace';
    bt.Enabled := false;
    bt.OnClick := @resman_ReplaceClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 410;
    bt.Top := 80;
    bt.Width := 70;
    bt.Height := 25;
    bt.Name := 'btDelete';
    bt.Caption := 'Delete';
    bt.Enabled := false;
    bt.OnClick := @resman_DeleteClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 410;
    bt.Top := 355;
    bt.Width := 70;
    bt.Height := 25;
    bt.Name := 'btClose';
    bt.Caption := 'Close';
    bt.ModalResult := mrCancel;
    bt.Cancel := true;
end;

procedure resman_ListDblClick(Sender: TListView);
begin
    if (Sender.SelCount = 1) then
    begin
        createResAdd(MainForm, TListView(Sender.Owner.find('list')),
            TListView(Sender.Owner.find('list')).Selected.Caption).ShowModal;
    end;
end;

procedure resman_ListChange(Sender: TListView; Item: TListItem; Change: TItemChange);
begin
    TButton(Sender.Owner.find('btDelete')).Enabled := (Sender.SelCount = 1);
    TButton(Sender.Owner.find('btReplace')).Enabled := (Sender.SelCount = 1);
end;

procedure resman_AddClick(Sender: TButton);
begin
    createResAdd(MainForm, TListView(Sender.Owner.find('list')), '').ShowModal;
end;

procedure resman_ReplaceClick(Sender: TButton);
begin
    createResAdd(MainForm, TListView(Sender.Owner.find('list')),
        TListView(Sender.Owner.find('list')).Selected.Caption).ShowModal;
end;

procedure resman_DeleteClick(Sender: TButton);
var
    i: int;
    list: TListView;
begin
    if MsgQuestion('Please Confirm', 'You are about to delete a resource, continue?') then
    begin
        list := TListView(Sender.Owner.find('list'));
        for i := 0 to resmanStr.Count -1 do
        begin
            //we have to seperate the $ sign otherwise compiler error
            if Pos('$'+'res:'+list.Selected.Caption, resmanStr.Strings[i]) > 0 then
            begin
                resmanStr.Delete(i);
                break;
            end;
        end;
        list.Selected.Delete;
        resman_ListChange(list, nil, 0);
    end;
end;

procedure resman_OnClose(Sender: TForm; Action: TCloseAction);
begin
    resmanStr.SaveToFile(resmanFile);
    resmanStr.Free;
    Action := caFree;
end;

procedure resman_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    i: int;
    list: TListView;

    procedure AddOrReplace(rname, fname: string);
    var
        index: int;
        i: int;
        isBasic: bool = false;
        filename: string;
    begin
        index := -1;
        for i := 0 to resmanStr.Count -1 do
        begin
            //we have to seperate the $ sign otherwise compiler error
            if Pos('$'+'res:'+rname+'=', resmanStr.Strings[i]) > 0 then
            begin
                index := i;
                break;
            end;
        end;

        isBasic := (ActiveProject.Values['language'] = 'Basic');

        filename := FileNameOf(fname);

        if index = -1 then
        begin
            //we have to seperate the $ sign otherwise compiler error
            if isBasic then
            resmanStr.Add(''''+'$'+'res:'+rname+'=[project-home]resources/'+filename)
            else
            resmanStr.Add('//'+'$'+'res:'+rname+'=[project-home]resources/'+filename);
        end
            else
        begin
            //we have to seperate the $ sign otherwise compiler error
            if isBasic then
            resmanStr.Strings[index] := ''''+'$'+'res:'+rname+'=[project-home]resources/'+filename
            else
            resmanStr.Strings[index] := '//'+'$'+'res:'+rname+'=[project-home]resources/'+filename
        end;

        fileName := FilePathOf(ActiveProjectFile)+'resources/'+filename;

        CopyFile(fname, filename);
    end;
begin
    list := TListView(Sender.find('list'));

    for i := 0 to list.Items.Count -1 do
    begin
        //only add/replace new/changed items
        if FileExists(list.Items.Item[i].SubItems.Strings[0]) then
        begin
            AddOrReplace(list.Items.Item[i].Caption,
                            list.Items.Item[i].SubItems.Strings[0]);
        end;
    end;
end;

//unit constructor
constructor begin end.
