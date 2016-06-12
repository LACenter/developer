////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

var
    taborderDesigner: TDesigner;

function createTabOrder(Owner: TForm; des: TDesigner): TForm;
begin
    taborderDesigner := des;
    result := TForm.CreateWithConstructor(Owner, @taborder_OnCreate);
end;

procedure taborder_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    list: TListBox;
    bt: TButton;
    i: int;
    rc: TComponent;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Manage Tab Order';
    Sender.Width := 400;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @taborder_OnClose;
    Sender.OnCloseQuery := @taborder_OnCloseQuery;

    list := TListBox.Create(Sender);
    list.Parent := Sender;
    list.Left := 20;
    list.Top := 20;
    list.Width := 280;
    list.Height := 305;
    list.Name := 'List';
    list.OnSelectionChange := @taborder_OnSelChange;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 20;
    bt.Width := 70;
    bt.Height := 25;
    bt.Name := 'btTop';
    bt.Caption := 'First';
    bt.OnClick := @taborder_FirstClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 50;
    bt.Height := 25;
    bt.Width := 70;
    bt.Name := 'btUp';
    bt.Caption := 'Up';
    bt.OnClick := @taborder_UpClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 80;
    bt.Height := 25;
    bt.Width := 70;
    bt.Name := 'btDown';
    bt.Caption := 'Down';
    bt.OnClick := @taborder_DownClick;

    bt := TButton.Create(Sender);
    bt.Parent := Sender;
    bt.Left := 310;
    bt.Top := 110;
    bt.Height := 25;
    bt.Width := 70;
    bt.Name := 'btLast';
    bt.Caption := 'Last';
    bt.OnClick := @taborder_LastClick;

    for i := 0 to taborderDesigner.ComponentCount -1 do
    begin
        if Pos('TDesigner', taborderDesigner.Components[i].ClassName) > 0 then
        begin
            rc := TDesignerObject(taborderDesigner.Components[i]).RealComponent;
            if rc.hasProp('TabStop') then
            begin
                if rc.getProp('TabStop') then
                begin
                    if rc.hasProp('TabOrder') then
                    list.Items.Add(rc.Name);
                end;
            end;
        end;
    end;

    taborder_checkEnabled(bt);

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
end;

procedure taborder_OnSelChange(Sender: TListBox; user: bool);
begin
    taborder_checkEnabled(Sender);
end;

procedure taborder_checkEnabled(Sender: TComponent);
var
    list: TListBox;
    bt: TButton;
begin
    list := TListBox(Sender.Owner.find('List'));
    bt := TButton(Sender.Owner.find('btTop'));
    bt.Enabled := (list.ItemIndex <> -1) and (list.ItemIndex <> 0);

    bt := TButton(Sender.Owner.find('btUp'));
    bt.Enabled := (list.ItemIndex <> -1) and (list.ItemIndex > 0);

    bt := TButton(Sender.Owner.find('btDown'));
    bt.Enabled := (list.ItemIndex <> -1) and (list.ItemIndex < list.Items.Count -1);

    bt := TButton(Sender.Owner.find('btLast'));
    bt.Enabled := (list.ItemIndex <> -1) and (list.ItemIndex <> list.Items.Count -1);
end;

procedure taborder_FirstClick(Sender: TButton);
var
    list: TListBox;
    tmp: string;
begin
    list := TListBox(Sender.Owner.find('List'));
    if list.ItemIndex <> -1 then
    begin
        if list.ItemIndex <> 0 then
        begin
            tmp := list.Items.Strings[list.ItemIndex];
            list.Items.Delete(list.ItemIndex);
            list.Items.Insert(0, tmp);
            list.Selected[0] := true;
        end;
    end;
    taborder_checkEnabled(Sender);
end;

procedure taborder_UpClick(Sender: TButton);
var
    list: TListBox;
    tmp: string;
    idx: int;
begin
    list := TListBox(Sender.Owner.find('List'));
    if list.ItemIndex <> -1 then
    begin
        if list.ItemIndex <> 0 then
        begin
            idx := list.ItemIndex -1;
            tmp := list.Items.Strings[list.ItemIndex];
            list.Items.Delete(list.ItemIndex);
            list.Items.Insert(idx, tmp);
            list.Selected[idx] := true;
        end;
    end;
    taborder_checkEnabled(Sender);
end;

procedure taborder_DownClick(Sender: TButton);
var
    list: TListBox;
    tmp: string;
    idx: int;
begin
    list := TListBox(Sender.Owner.find('List'));
    if list.ItemIndex <> -1 then
    begin
        if list.ItemIndex <> list.Items.Count -1 then
        begin
            idx := list.ItemIndex +1;
            tmp := list.Items.Strings[list.ItemIndex];
            list.Items.Delete(list.ItemIndex);
            list.Items.Insert(idx, tmp);
            list.Selected[idx] := true;
        end;
    end;
    taborder_checkEnabled(Sender);
end;

procedure taborder_LastClick(Sender: TButton);
var
    list: TListBox;
    tmp: string;
begin
    list := TListBox(Sender.Owner.find('List'));
    if list.ItemIndex <> -1 then
    begin
        if list.ItemIndex <> list.Items.Count -1 then
        begin
            tmp := list.Items.Strings[list.ItemIndex];
            list.Items.Delete(list.ItemIndex);
            list.Items.Add(tmp);
            list.Selected[list.Items.Count -1] := true;
        end;
    end;
    taborder_checkEnabled(Sender);
end;

procedure taborder_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure taborder_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    list: TListBox;
    rc: TComponent;
    i: int;
begin
    if Sender.ModalResult = mrOK then
    begin
        list := TListBox(Sender.find('List'));
        for i := 0 to list.Items.Count -1 do
        begin
            rc := TDesignerObject(taborderDesigner.find(list.Items.Strings[i])).RealComponent;
            if rc <> nil then
                rc.setProp('TabOrder', i);
        end;
        taborderDesigner.PopulateProperties;
        taborderDesigner.Modified;
    end;
end;

//unit constructor
constructor begin end.
