////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

//uses 'globals'; //this causes circular use ??? why ???

function createPublishProject(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @publishproject_OnCreate);
end;

procedure publishproject_OnCreate(Sender: TForm);
var
    lab: TLabel;
    bp: TButtonPanel;
    progress: TProgressBar;
begin
    Sender.BorderStyle := fbsDialog;
    Sender.BorderIcons := 0;
    Sender.Caption := 'Publish Project';
    Sender.Width := 400;
    Sender.Height := 90;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @publishproject_OnClose;
    Sender.OnCloseQuery := @publishproject_OnCloseQuery;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Publishing your project to the store, please wait...';
    lab.AutoSize := true;
    lab.Left := 20;
    lab.Top := 20;

    progress := TProgressBar.Create(Sender);
    progress.Parent := Sender;
    progress.Color := clNone;
    progress.Left := 20;
    progress.Top := 40;
    progress.Width := 360;
    progress.Style := pbstMarquee;
    progress.Smooth := true;
end;

procedure publishproject_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure publishproject_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin

    end;
end;


//unit constructor
constructor begin end.
