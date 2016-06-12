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
    changeParentDesigner: TDesigner;

function createChangeParent(Owner: TForm; des: TDesigner): TForm;
begin
    changeParentDesigner := des;
    result := TForm.CreateWithConstructor(Owner, @changeparent_OnCreate);
end;

procedure changeparent_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    list: TListBox;
    i: Integer;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Change Control Parent';
    Sender.Width := 320;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @changeparent_OnClose;
    Sender.OnCloseQuery := @changeparent_OnCloseQuery;


    list := TListBox.Create(Sender);
    list.Parent := Sender;
    list.Left := 20;
    list.Top := 20;
    list.Width := 280;
    list.Height := 305;
    list.Name := 'List';
    list.OnSelectionChange := @changeparent_OnSelChange;
    list.OnDblClick := @changeparent_OnDblClick;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.OKButton.Caption := 'Change';
    bp.OKButton.Enabled := false;

    list.Items.Add('Container');
    if changeParentDesigner.SelControls.Count = 1 then
    begin
        if TComponent(changeParentDesigner.SelControls.Items[0]).ClassName <> 'TDesignerComponent' then
        begin
            for i := 0 to changeParentDesigner.ComponentCount -1 do
            begin
                if changeParentDesigner.Components[i].ClassName = 'TDesignerContainer' then
                begin
                    if TComponent(changeParentDesigner.SelControls.Items[0]).Name <>
                        changeParentDesigner.Components[i].Name then
                    list.Items.Add(changeParentDesigner.Components[i].Name);
                end;
            end;
        end;

        if TDesignerObject(changeParentDesigner.SelControls.Items[0]).Parent.Name = 'Designer' then
        list.Selected[0] := true
        else
        begin
            if list.Items.IndexOf(TDesignerObject(changeParentDesigner.SelControls.Items[0]).Parent.Name) <> -1 then
            list.Selected[list.Items.IndexOf(TDesignerObject(changeParentDesigner.SelControls.Items[0]).Parent.Name)] := true;
        end;
    end;
end;

procedure changeparent_OnDblClick(Sender: TListBox);
begin
    if TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled then
    TForm(Sender.Owner).ModalResult := mrOK;
end;

procedure changeparent_OnSelChange(Sender: TListBox; user: bool);
begin
    TButtonPanel(Sender.Owner.find('ButtonPanel')).OKButton.Enabled :=
        (Sender.ItemIndex <> -1);
end;

procedure changeparent_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure changeparent_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin
        if changeParentDesigner.SelControls.Count = 1 then
        begin
            if TListBox(Sender.find('List')).GetSelectedText = 'Container' then
            begin
                TDesignerObject(changeParentDesigner.SelControls.Items[0]).Parent := changeParentDesigner;
                TControl(TDesignerObject(changeParentDesigner.SelControls.Items[0]).RealComponent).Parent := TWinControl(changeParentDesigner.RealForm);
            end
                else
            begin
                TDesignerObject(changeParentDesigner.SelControls.Items[0]).Parent :=
                    TWinControl(changeParentDesigner.find(TListBox(Sender.find('List')).GetSelectedText));
                TControl(TDesignerObject(changeParentDesigner.SelControls.Items[0]).RealComponent).Parent :=
                    TWinControl(changeParentDesigner.RealForm.find(TListBox(Sender.find('List')).GetSelectedText));
            end;
            changeParentDesigner.PopulateObjects;
            changeParentDesigner.Modified;
        end;
    end;
end;

//unit constructor
constructor begin end.
