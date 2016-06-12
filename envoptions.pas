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
    gen: TFrame;
    des: TFrame;
    ed: TFrame;

function createEnvOptions(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @envoptions_OnCreate);
end;

procedure envoptions_OnCreate(Sender: TForm);
var
    tree: TTreeView;
    node: TTreeNode;
    bp: TButtonPanel;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Envionment Options';
    Sender.Width := 630;
    Sender.Height := 500;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @envoptions_OnClose;
    Sender.OnCloseQuery := @envoptions_OnCloseQuery;

    tree := TTreeView.Create(Sender);
    tree.Parent := Sender;
    tree.Align := alLeft;
    tree.BorderSpacing.Left := 20;
    tree.BorderSpacing.Top := 20;
    tree.BorderSpacing.Bottom := 5;
    tree.Width := 150;
    tree.ReadOnly := true;
    tree.RowSelect := true;
    tree.ScrollBars := ssAutoBoth;
    tree.ShowRoot := false;
    tree.ShowLines := false;
    tree.BorderStyle := bsNone;

    ed := createEnvEditor(Sender);
    ed.Parent := Sender;
    ed.Align := alClient;
    ed.BorderSpacing.Around := 5;
    ed.BorderSpacing.Right := 15;
    ed.BorderSpacing.Top := 15;

    des := createEnvDesigner(Sender);
    des.Parent := Sender;
    des.Align := alClient;
    des.BorderSpacing.Around := 5;
    des.BorderSpacing.Right := 15;
    des.BorderSpacing.Top := 15;

    gen := createEnvGeneral(Sender);
    gen.Parent := Sender;
    gen.Align := alClient;
    gen.BorderSpacing.Around := 5;
    gen.BorderSpacing.Right := 15;
    gen.BorderSpacing.Top := 15;

    node := tree.Items.Add('General Options');
    node.Data := gen;
    node.Selected := true;

    node := tree.Items.Add('Designer Options');
    node.Data := des;

    node := tree.Items.Add('Editor Options');
    node.Data := ed;

    tree.OnChange := @envoptions_TreeChange;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbHelp + pbCancel;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
    bp.CancelButton.Caption := 'Close';
    bp.HelpButton.Caption := 'Reset';
    bp.HelpButton.OnClick := @envoptions_ResetClick;
end;

procedure envoptions_ResetClick(Sender: TComponent);
begin
    if MsgQuestion('Please Confirm', 'You are about to reset all application settings to its default state, continue?') then
    begin
        doResetAppSettings;
        TForm(TControl(Sender).Parent.Parent).Close;
    end;
end;

procedure envoptions_TreeChange(Sender: TTreeView; Node: TTreeNode);
begin
    if Node.Index = 0 then
        gen.BringToFront;
    if Node.Index = 1 then
        des.BringToFront;
    if Node.Index = 2 then
        ed.BringToFront;
end;

procedure envoptions_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure envoptions_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    doSaveAppSettings;
    doUpdateEnvironmentOptions;
end;

//unit constructor
constructor begin end.
