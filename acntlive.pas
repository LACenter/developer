////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals', 'acntlivedb', 'acntlivecode', 'acntliveres', 'acntlivefiles';

function createAccountLive(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructor(Owner, @acntlive_OnCreate);
end;

procedure acntlive_OnCreate(Sender: TForm);
var
    Pages: TPageControl;
    tab: TTabSheet;
    fp: TFrame;
begin
    Sender.Color := clForm;

    Pages := TPageControl.Create(Sender);
    Pages.Parent := Sender;
    Pages.Align := alClient;
    Pages.BorderSpacing.Around := 10;
    Pages.Images := MainImages;
    Pages.Name := 'Pages';
    Pages.OnChange := @acntlive_OnPageChange;

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Live DB';
    tab.ImageIndex := 91;

    fp := createAccountLiveDB(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'livedb';

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Live Code';
    tab.ImageIndex := 19;

    fp := createAccountLiveCode(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'livecode';

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Live Files';
    tab.ImageIndex := 9;

    fp := createAccountLiveFiles(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'livefiles';

    ///

    tab := TTabSheet.Create(Sender);
    tab.PageControl := Pages;
    tab.Caption := 'Live Resources';
    tab.ImageIndex := 87;

    fp := createAccountLiveRes(Sender);
    fp.Parent := tab;
    fp.Align := alClient;
    fp.Name := 'liveres';
end;

procedure acntlive_OnPageChange(Sender: TPageControl);
begin
    if Sender.ActivePageIndex = 0 then
        TAction(Sender.Owner.find('livedb').find('actPopulateDatabases')).Execute;
    if Sender.ActivePageIndex = 1 then
        TAction(Sender.Owner.find('livecode').find('actPopulateLiveNodes')).Execute;
    if Sender.ActivePageIndex = 2 then
        TAction(Sender.Owner.find('livefiles').find('actPopulateLiveNodes')).Execute;
    if Sender.ActivePageIndex = 3 then
        TAction(Sender.Owner.find('liveres').find('actPopulateLiveNodes')).Execute;
end;

//unit constructor
constructor begin end.
