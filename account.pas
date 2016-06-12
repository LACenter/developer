////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'acntprofile', 'acntlive', 'storemanager';

function createAccountDialog(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @account_OnCreate);
end;

procedure account_OnCreate(Sender: TForm);
var
    fp: TFrame;
    Pages: TPageControl;
    tab: TTabSheet;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := _APP_NAME+' Account';
    Sender.Width := 700;
    Sender.Height := 550;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @account_OnClose;
    Sender.OnCloseQuery := @account_OnCloseQuery;


    Pages := TPageControl.Create(Sender);
    Pages.Parent := Sender;
    Pages.Align := alClient;
    Pages.BorderSpacing.Around := 5;
    Pages.Images := MainImages;
    Pages.OnChange := @account_OnPageChange;

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Account Details';
    tab.ImageIndex := 85;

    fp := createAccountProfile(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'details';

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Live Services';
    tab.ImageIndex := 72;

    fp := createAccountLive(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'services';

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'App-Store Manager';
    tab.ImageIndex := 90;

    fp := createStoreManager(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'store';
end;

procedure account_OnPageChange(Sender: TPageControl);
begin
    if Sender.ActivePageIndex = 1 then
    begin
        if TPageControl(Sender.Owner.find('services').find('Pages')).ActivePageIndex = 0 then
            TAction(Sender.Owner.find('services').find('livedb').find('actPopulateDatabases')).Execute;
        if TPageControl(Sender.Owner.find('services').find('Pages')).ActivePageIndex = 1 then
            TAction(Sender.Owner.find('services').find('livecode').find('actPopulateLiveNodes')).Execute;
        if TPageControl(Sender.Owner.find('services').find('Pages')).ActivePageIndex = 2 then
            TAction(Sender.Owner.find('services').find('livefiles').find('actPopulateLiveNodes')).Execute;
        if TPageControl(Sender.Owner.find('services').find('Pages')).ActivePageIndex = 3 then
            TAction(Sender.Owner.find('services').find('liveres').find('actPopulateLiveNodes')).Execute;
    end;
    if Sender.ActivePageIndex = 2 then
        TAction(Sender.Owner.find('store').find('actPopulateStore')).Execute;
end;

procedure account_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure account_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    if Sender.ModalResult = mrOK then
    begin

    end;
end;

//unit constructor
constructor begin end.
