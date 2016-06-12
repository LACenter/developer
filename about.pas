////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createAboutDialog(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @about_OnCreate);
end;

procedure about_OnCreate(Sender: TForm);
var
    img: TImage;
    lab: TLabel;
    closeB: TSpeedButton;
    bu: TButton;
begin
    Sender.BorderStyle := fbsNone;
    Sender.BorderIcons := 0;
    Sender.Caption := 'About';
    Sender.Width := 500;
    Sender.Height := 350;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @about_OnClose;

    img := TImage.Create(Sender);
    img.Parent := Sender;
    img.Align := alClient;
    ResToFile('splash', TempDir+'tmp.jpg');
    img.Picture.LoadFromFile(TempDir+'tmp.jpg');
    DeleteFile(TempDir+'tmp.jpg');

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := _APP_NAME+' Version '+_APP_VERSION;
    lab.Font.Color := clBlack;
    lab.Font.Size := 12;
    lab.Font.Style := fsBold;
    lab.AutoSize := false;
    lab.Width := Sender.Width;
    lab.Alignment := taCenter;
    lab.Left := 0;
    lab.Top := 300;

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := _APP_COPYRIGHT;
    lab.Font.Color := clBlack;
    lab.AutoSize := false;
    lab.Width := Sender.Width;
    lab.Alignment := taCenter;
    lab.Left := 0;
    lab.Top := 320;

    closeB := TSpeedButton.Create(Sender);
    closeB.Parent := Sender;
    closeB.Caption := 'X';
    closeB.Font.Style := fsBold;
    closeB.Left := Sender.Width - 30;
    closeB.Top := 8;
    closeB.Hint := 'Close';
    closeB.ShowHint := true;
    closeB.OnClick := @about_Close_Click;
    closeB.Flat := true;
    closeB.Width := closeB.Width -1;

    bu := TButton.Create(Sender);
    bu.Parent := Sender;
    bu.Left := -200;
    bu.ModalResult := mrCancel;
    bu.Cancel := true;
end;

procedure about_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure about_Close_Click(Sender: TSpeedButton);
begin
    TForm(Sender.Owner).Close;
end;

//unit constructor
constructor begin end.

