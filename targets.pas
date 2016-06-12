////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createTargets(Owner: TForm): TForm;
begin
    result := TForm.CreateWithConstructor(Owner, @targets_OnCreate);
end;

procedure targets_OnCreate(Sender: TForm);
var
    bp: TButtonPanel;
    chk: TCheckBox;
    lab: TLabel;
    tars: string;
begin
    Sender.BorderStyle := fbsSingle;
    Sender.BorderIcons := biSystemMenu;
    Sender.Caption := 'Select Build Targets';
    Sender.Width := 460;
    Sender.Height := 400;
    Sender.ShowInTaskBar := stNever;
    Sender.Position := poMainFormCenter;
    Sender.Color := clForm;
    if not OSX then //not in mac because MacOSX Bug!
    begin
        Sender.PopupParent := TForm(Sender.Owner);
        Sender.PopupMode := pmAuto;
    end;
    Sender.OnClose := @targets_OnClose;
    Sender.OnCloseQuery := @targets_OnCloseQuery;

    tars := Lower(Compiler.LicensedTargets);

    lab := TLabel.Create(Sender);
    lab.Parent := Sender;
    lab.Caption := 'Please check mark all operating systems you wish to target.';
    lab.AutoSize := true;
    lab.Font.Style := fsBold;
    lab.Top := 20;
    lab.Left := 20;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'linuxpi';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 45;
    chk.Height := 30;
    chk.Checked := (Pos('linuxpi', ActiveProject.Values['targets']) > 0);
    if Pos('linuxpi', tars) > 0 then
    chk.Caption := 'Linux PI (Licensed)'
    else
    begin
        chk.Caption := 'Linux PI (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'linux32';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 75;
    chk.Height := 30;
    chk.Checked := (Pos('linux32', ActiveProject.Values['targets']) > 0);
    if Pos('linux32', tars) > 0 then
    chk.Caption := 'Linux 32 (Licensed)'
    else
    begin
        chk.Caption := 'Linux 32 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'linux64';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 105;
    chk.Height := 30;
    chk.Checked := (Pos('linux64', ActiveProject.Values['targets']) > 0);
    if Pos('linux64', tars) > 0 then
    chk.Caption := 'Linux 64 (Licensed)'
    else
    begin
        chk.Caption := 'Linux 64 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    //

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'windowsce';
    chk.Left := 240;
    chk.Width := 200;
    chk.Top := 45;
    chk.Height := 30;
    chk.Checked := (Pos('windowsce', ActiveProject.Values['targets']) > 0);
    if Pos('windowsce', tars) > 0 then
    chk.Caption := 'Windows CE (Licensed)'
    else
    begin
        chk.Caption := 'Windows CE (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'windows32';
    chk.Left := 240;
    chk.Width := 200;
    chk.Top := 75;
    chk.Height := 30;
    chk.Checked := (Pos('windows32', ActiveProject.Values['targets']) > 0);
    if Pos('windows32', tars) > 0 then
    chk.Caption := 'Windows 32 (Licensed)'
    else
    begin
        chk.Caption := 'Windows 32 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'windows64';
    chk.Left := 240;
    chk.Width := 200;
    chk.Top := 105;
    chk.Height := 30;
    chk.Checked := (Pos('windows64', ActiveProject.Values['targets']) > 0);
    if Pos('windows64', tars) > 0 then
    chk.Caption := 'Windows 64 (Licensed)'
    else
    begin
        chk.Caption := 'Windows 64 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    //

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'freebsd32';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 155;
    chk.Height := 30;
    chk.Checked := (Pos('freebsd32', ActiveProject.Values['targets']) > 0);
    if Pos('freebsd32', tars) > 0 then
    chk.Caption := 'FreeBSD 32 (Licensed)'
    else
    begin
        chk.Caption := 'FreeBSD 32 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'freebsd64';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 185;
    chk.Height := 30;
    chk.Checked := (Pos('freebsd64', ActiveProject.Values['targets']) > 0);
    if Pos('freebsd64', tars) > 0 then
    chk.Caption := 'FreeBSD 64 (Licensed)'
    else
    begin
        chk.Caption := 'FreeBSD 64 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    //

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'macosx';
    chk.Left := 240;
    chk.Width := 200;
    chk.Top := 155;
    chk.Height := 30;
    chk.Checked := (Pos('macosx', ActiveProject.Values['targets']) > 0);
    if Pos('macosx', tars) > 0 then
    chk.Caption := 'Mac OSX (Licensed)'
    else
    begin
        chk.Caption := 'Mac OSX (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) = 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := '';
    chk.Left := 240;
    chk.Width := 200;
    chk.Top := 185;
    chk.Height := 30;
    chk.Caption := 'XAP-CloudOS (Licensed)';
    chk.Font.Style := fsBold;
    chk.Checked := true;
    chk.OnChange := @targets_OnStoreChecked;


    ///

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'androidarmv6';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 235;
    chk.Height := 30;
    chk.Checked := (Pos('androidarmv6', ActiveProject.Values['targets']) > 0);
    if Pos('androidarmv6', tars) > 0 then
    chk.Caption := 'Android ARMv6 (Licensed)'
    else
    begin
        chk.Caption := 'Android ARMv6 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) > 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'androidarmv7';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 265;
    chk.Height := 30;
    chk.Checked := (Pos('androidarmv7', ActiveProject.Values['targets']) > 0);
    if Pos('androidarmv7', tars) > 0 then
    chk.Caption := 'Android ARMv7 (Licensed)'
    else
    begin
        chk.Caption := 'Android ARMv7 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) > 0);
    if not chk.Enabled then chk.Checked := false;

    chk := TCheckBox.Create(Sender);
    chk.Parent := Sender;
    chk.AutoSize := false;
    chk.Hint := 'android32';
    chk.Left := 20;
    chk.Width := 200;
    chk.Top := 295;
    chk.Height := 30;
    chk.Checked := (Pos('android32', ActiveProject.Values['targets']) > 0);
    if Pos('android32', tars) > 0 then
    chk.Caption := 'Android x86 (Licensed)'
    else
    begin
        chk.Caption := 'Android x86 (Not Licensed)';
        chk.Enabled := false;
        chk.Checked := false;
    end;
    chk.Enabled := (Pos('(Android', ActiveProject.Values['type']) > 0);
    if not chk.Enabled then chk.Checked := false;


    bp := TButtonPanel.Create(Sender);
    bp.Parent := Sender;
    bp.Color := clForm;
    bp.Name := 'ButtonPanel';
    bp.ShowButtons := pbCancel + pbOK;
    bp.ShowGlyphs := 0;
    bp.BorderSpacing.Around := 20;
end;

procedure targets_OnStoreChecked(Sender: TCheckBox);
begin
    Sender.Checked := true;
end;

procedure targets_OnClose(Sender: TForm; Action: TCloseAction);
begin
    Action := caFree;
end;

procedure targets_OnCloseQuery(Sender: TForm; var CanClose: bool);
var
    i: int;
    tars: string = '';
begin
    if Sender.ModalResult = mrOK then
    begin
        for i := 0 to Sender.ComponentCount -1 do
        begin
            if Sender.Components[i].ClassName = 'TCheckBox' then
            begin
                if TCheckBox(Sender.Components[i]).Hint <> '' then
                begin
                    if TCheckBox(Sender.Components[i]).Checked then
                    begin
                        if tars = '' then
                        tars := TCheckBox(Sender.Components[i]).Hint
                        else
                        tars := tars+','+TCheckBox(Sender.Components[i]).Hint;
                    end;
                end;
            end;
        end;
        ActiveProject.Values['targets'] := tars;
        ActiveProject.SaveToFile(ActiveProjectFile);
    end;
end;

//unit constructor
constructor begin end.
