////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

const
    msgTypeError = 0;
    msgTypeWarning = 1;
    msgTypeQuestion = 2;

var
    msgboxCaption: string;
    msgboxText: string;
    msgBoxType: int = 0;
    msgboxCancel: bool = false;

function createMsgBox(Owner: TForm; cap, text: string; mtype: int; ShowCancel: bool = false): TForm;
begin
    msgboxCaption := cap;
    msgboxText := text;
    msgboxType := mtype;
    msgboxCancel := ShowCancel;
    result := TForm.CreateWithConstructor(Owner, @msgbox_OnCreate);
end;

procedure msgbox_OnCreate(Sender: TForm);
var
    img: TImage;
    lab: TLabel;
    bp: TButtonPanel;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := msgboxCaption;
    Sender.Width := 400;
    Sender.Height := 150;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poOwnerFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @msgbox_OnClose;
    Sender.Color := clWindow;
    Sender.Font.Color := clWindowText;

    img := TImage.Create(Sender);
    img.Parent := Sender;
    img.Left := 20;
    img.Top := 20;
    img.Width := 48;
    img.Height := 48;

    if msgboxType = msgTypeError then
        ResToFile('msgerror', TempDir+'tmp.png');
    if msgboxType = msgTypeWarning then
        ResToFile('msgwarning', TempDir+'tmp.png');
    if msgboxType = msgTypeQuestion then
        ResToFile('msgquestion', TempDir+'tmp.png');

    img.Picture.LoadFromFile(TempDir+'tmp.png');
    DeleteFile(TempDir+'tmp.png');

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.AutoSize := false;
    lab.Left := 78;
    lab.Top := 20;
    lab.Width := 300;
    lab.Height := 58;
    lab.WordWrap := true;
    lab.Caption := msgboxText;
    lab.ParentFont := true;
    lab.Transparent := true;

    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clWindow;
    bp.Name := 'ButtonPanel';

    if msgboxType = msgTypeError then
    begin
        bp.ShowButtons := pbCancel;
        bp.CancelButton.Caption := 'OK';
    end;
    if (msgboxType = msgTypeWarning) or
       (msgboxType = msgTypeQuestion) then
    begin
        bp.ShowButtons := pbOK + pbCancel;
        bp.OKButton.Caption := 'Yes';
        bp.OKButton.ModalResult := mrYes;
        bp.CancelButton.Caption := 'No';
        bp.CancelButton.ModalResult := mrNo;
    end;
    if msgboxCancel then
    begin
        bp.ShowButtons := pbOK + pbClose + pbCancel;
        bp.OKButton.Caption := 'Yes';
        bp.OKButton.ModalResult := mrYes;
        bp.CancelButton.Caption := 'No';
        bp.CancelButton.ModalResult := mrNo;
        bp.CloseButton.Caption := 'Cancel';
        bp.CloseButton.ModalResult := mrCancel;
    end;


    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
end;

procedure msgbox_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

//unit constructor
constructor begin end.
