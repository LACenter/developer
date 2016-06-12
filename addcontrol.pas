////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'globals';

function createDesignerComponent(Designer: TDesigner; img: int; clName: string): TDesignerComponent;
var
    dc: TDesignerComponent;
    comp: TComponent;
begin
    dc := TDesignerComponent.Create(Designer);
    dc.Parent := Designer;
    dc.Width := 30;
    dc.Height := 30;
    dc.Name := findFreeName(clName, Designer);
    dc.RealClassName := 'T'+clName; //class name start with T
    toolboxImages.GetBitmap(img, dc.Bitmap);

    comp := Designer.CreateComponentClass(dc.RealClassName);
    if comp <> nil then
    begin
        comp.Name := dc.Name;
        result := dc;
    end
        else
    begin
        dc.Free;
        result := nil;
        doMsgError(MainForm, 'Error', 'Could not create component.');
    end;
end;

function createDesignerControl(Designer: TDesigner; img: int; clName: string; Parent: TComponent): TDesignerControl;
var
    dc: TDesignerControl;
    comp: TControl;
    comp2: TComponent;
begin
    dc := TDesignerControl.Create(Designer);
    dc.Name := findFreeName(clName, Designer);
    dc.RealClassName := 'T'+clName; //class name start with T
    dc.ParentColor := false;

    if Pos('(Android', ActiveProject.Values['type']) = 0 then
    begin
        comp := Designer.CreateControlClass(dc.RealClassName);

        if comp <> nil then
        begin
            comp.Name := dc.Name;
            if Parent = Designer then
            begin
                comp.Parent := TWinControl(Designer.RealForm);
                dc.Parent := Designer;
            end
                else
            begin
                //only allow drops on certain parent
                //rest should be managed by code
                try
                    if (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TPanel') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TBGRAPanel') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TGroupBox') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TTabSheet') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TScrollBox') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TRLBand') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TRLSubDetail') or
                       (TWinControl(Designer.RealForm.find(Parent.Name)).ClassName = 'TDBGroupBox') then
                    begin
                        comp.Parent := TWinControl(Designer.RealForm.find(Parent.Name));
                        dc.Parent := TWinControl(Designer.find(Parent.Name));
                    end
                        else
                    begin
                        comp.Parent := TWinControl(Designer.RealForm);
                        dc.Parent := Designer;
                    end;
                except
                    comp.Parent := TWinControl(Designer.RealForm);
                    dc.Parent := Designer;
                end;
            end;

            //select design time painter
            if dc.RealClassName = 'TButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TBitBtn' then dc.PaintName := 'button';
            if dc.RealClassName = 'TColorButton' then dc.PaintName := 'colorbutton';
            if dc.RealClassName = 'TBGRAButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TSpeedButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TEdit' then dc.PaintName := 'edit';
            if dc.RealClassName = 'TMaskEdit' then dc.PaintName := 'edit';
            if dc.RealClassName = 'TDBEdit' then dc.PaintName := 'edit';
            if dc.RealClassName = 'TMemo' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TDBMemo' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TComboBox' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TFilterComboBox' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TFloatSpinEdit' then dc.PaintName := 'spinedit';
            if dc.RealClassName = 'TSpinEdit' then dc.PaintName := 'spinedit';
            if dc.RealClassName = 'TSplitter' then dc.PaintName := 'splitter';
            if dc.RealClassName = 'TDBComboBox' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TDBLookupComboBox' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TDBDateTimePicker' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TDateTimePicker' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TColorBox' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TEditButton' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TDirectoryEdit' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TFileNameEdit' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TCalcEdit' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TDateEdit' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TDBDateEdit' then dc.PaintName := 'comboedit';
            if dc.RealClassName = 'TLabel' then dc.PaintName := 'label';
            if dc.RealClassName = 'TStaticText' then dc.PaintName := 'label';
            if dc.RealClassName = 'TBGRALabel' then dc.PaintName := 'label';
            if dc.RealClassName = 'TBGRALabelFX' then dc.PaintName := 'label';
            if dc.RealClassName = 'TDBText' then dc.PaintName := 'label';
            if dc.RealClassName = 'TBGRALED' then dc.PaintName := 'led';
            if dc.RealClassName = 'TTreeView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TShellTreeView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TListView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TShellListView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TFileListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TDBListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TDBLookupListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TColorListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TCheckListBox' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TDBImage' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TCheckBox' then dc.PaintName := 'check';
            if dc.RealClassName = 'TDBCheckBox' then dc.PaintName := 'check';
            if dc.RealClassName = 'TRadioButton' then dc.PaintName := 'radio';
            if dc.RealClassName = 'TGradientBackground' then dc.PaintName := 'gradient';
            if dc.RealClassName = 'TLedIndicator' then dc.PaintName := 'ledindicator';
            if dc.RealClassName = 'TPageControl' then dc.PaintName := 'pages';
            if dc.RealClassName = 'TProgressBar' then dc.PaintName := 'progress';
            if dc.RealClassName = 'TRichMemo' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TSyntaxMemo' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TToggleBox' then dc.PaintName := 'button';
            if dc.RealClassName = 'TToolBar' then dc.PaintName := 'toolbar';
            if dc.RealClassName = 'TToolButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TTrackBar' then dc.PaintName := 'trackbar';
            if dc.RealClassName = 'TUrlLink' then dc.PaintName := 'label';
            if dc.RealClassName = 'TWorkBook' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TUpDown' then dc.PaintName := 'splitter';
            if dc.RealClassName = 'TImage' then dc.PaintName := 'image';

            if dc.RealClassName = 'TRLBand' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLLabel' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLAngleLabel' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLDBImage' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLDBMemo' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLDBResult' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLDBRichText' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLRichText' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLDBText' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLImage' then dc.PaintName := 'image';
            if dc.RealClassName = 'TRLMemo' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLSubDetail' then dc.PaintName := 'rllabel';
            if dc.RealClassName = 'TRLSystemInfo' then dc.PaintName := 'rllabel';

            //Custom Painters
            if (dc.RealClassName = 'TDTAnalogClock') or
               (dc.RealClassName = 'TDTThemedClock') or
               (dc.RealClassName = 'TDTThemedGauge') or
               (dc.RealClassName = 'TBubbleShape') or
               (dc.RealClassName = 'TCircleProgress') or
               (dc.RealClassName = 'TCircleShape') or
               (dc.RealClassName = 'TEllipseShape') or
               (dc.RealClassName = 'THexagonShape') or
               (dc.RealClassName = 'TOctagonShape') or
               (dc.RealClassName = 'TParallelShape') or
               (dc.RealClassName = 'TPentagonShape') or
               (dc.RealClassName = 'TRectShape') or
               (dc.RealClassName = 'TRectangleShape') or
               (dc.RealClassName = 'TRoundRectShape') or
               (dc.RealClassName = 'TRoundSquareShape') or
               (dc.RealClassName = 'TShape') or
               (dc.RealClassName = 'TShapeProgress') or
               (dc.RealClassName = 'TSquareShape') or
               (dc.RealClassName = 'TStarShape') or
               (dc.RealClassName = 'TTrapezShape') or
               (dc.RealClassName = 'TTriangleShape') or
               (dc.RealClassName = 'TArrow') or
               (dc.RealClassName = 'TATTabs') or
               (dc.RealClassName = 'TECProgressBar') or
               (dc.RealClassName = 'TECSlider') or
               (dc.RealClassName = 'TECRuler') or
               (dc.RealClassName = 'TECSwitch') or
               (dc.RealClassName = 'TCalendar') or
               (dc.RealClassName = 'TDBCalendar') or
               (dc.RealClassName = 'TBarCode') or
               (dc.RealClassName = 'TDBBarCode') or
               (dc.RealClassName = 'TRLBarcode') or
               (dc.RealClassName = 'TAAnalogClock') or
               (dc.RealClassName = 'TASwitchButton') or
               (dc.RealClassName = 'TARatingBar') or
               (dc.RealClassName = 'TADigitalClock') or
               (dc.RealClassName = 'TRLDBBarcode') then
            begin
                dc.PaintName := 'custom';
                dc.OnCustomPaint := @doCustomControlPaint;
            end;

            //sizing
            //we need to make sure that controls width and height are aligned to the grid
            if (dc.PaintName = 'button') then
            begin
                comp.Height := 30;
                comp.Width := Designer.GridSize * 10;
            end;

            if (dc.PaintName = 'edit') or
               (dc.PaintName = 'spinedit') or
               (dc.PaintName = 'combo') or
               (dc.PaintName = 'comboedit') then
                comp.width := Designer.GridSize * 10;

            if (dc.PaintName = 'memo') then
            begin
                comp.Width := Designer.GridSize * 15;
                comp.Height := Designer.GridSize * 10;
            end;

            if (dc.RealClassName = 'TSpeedButton') or
               (dc.RealClassName = 'TColorButton') then
            begin
                comp.Height := 30;
                comp.Width := 30;
            end;

            if (dc.RealClassName = 'TCalcEdit') then
                TCalcEdit(comp).Caption := '0';

            if (dc.RealClassName = 'TBGRALabelFX') then
            begin
                comp.AutoSize := false;
                comp.Width := 150;
                comp.Height := 40;
                comp.Color := Designer.Color;
                comp.Font.Size := 14;
            end;

            if (dc.RealClassName = 'TBGRALabel') then
            begin
                comp.AutoSize := false;
                comp.Width := 150;
                comp.Height := 40;
                comp.Color := Designer.Color;
                comp.Font.Size := 12;
                TBGRALabel(comp).ParentColor := true;
            end;

            if (dc.RealClassName = 'TLabel') then
            begin
                comp.Color := Designer.Color;
                dc.Transparent := TLabel(comp).Transparent;
                TLabel(comp).ParentColor := true;
            end;

            if (dc.RealClassName = 'TToolBar') then
            begin
                TToolBar(comp).ButtonWidth := 32;
                TToolBar(comp).ButtonHeight := 30;
                TToolBar(comp).AutoSize := false;
                TToolBar(comp).Height := 32;
            end;

            if (dc.RealClassName = 'TProgressBar') then
                TProgressBar(comp).Color := clNone;

            if (dc.RealClassName = 'TBGRALED') then
            begin
                comp.Width := 25;
                comp.Height := 25;
            end;

            if (dc.RealClassName = 'TChrome') then
            begin
                comp.Color := clWhite;
                comp.Width := 250;
                comp.Height := 200;
            end;

            if (dc.RealClassName = 'TVideo') then
            begin
                comp.Width := 250;
                comp.Height := 200;
            end;

            if (dc.RealClassName = 'TECSwitch') then
            begin
                TECSwitch(comp).SwitchWidth := 80;
                TECSwitch(comp).SwitchHeight := 30;
                TECSwitch(comp).Caption := '';
                comp.Width := TECSwitch(comp).SwitchWidth;
                comp.Height := TECSwitch(comp).SwitchHeight;
            end;

            if (dc.RealClassName = 'TDBText') then
                TDBText(comp).ParentColor := true;

            if (dc.RealClassName = 'TStaticText') then
                comp.Height := 20;

            if (dc.RealClassName = 'TStatusBar') then
            begin
                comp.AutoSize := false;
                comp.Height := 22;
            end;

            if (dc.RealClassName = 'TUrlLink') then
            begin
                comp.AutoSize := false;
                comp.Height := 20;
                comp.Width := 100;
            end;

            if (dc.RealClassName = 'TATTabs') then
            begin
                TATTabs(comp).ColorBG := Designer.Color;
                TATTabs(comp).ColorTabActive := clWindow;
                TATTabs(comp).ColorTabOver := clWindow;
                TATTabs(comp).ColorTabPassive := clSilver;
            end;

            if dc.RealClassName = 'TLedIndicator' then
               TLedIndicator(comp).Color := clBlack;
            //sizing end

            //report
            if (dc.RealClassName = 'TRLBand') then
            begin
                TRLBand(comp).AutoSize := false;
                TRLBand(comp).Align := alTop;
                dc.Align := alTop;
                dc.BorderSpacing.Bottom := 20;
            end;

            if (dc.RealClassName = 'TRLSubDetail') then
            begin
                TRLSubDetail(comp).AutoSize := false;
                TRLSubDetail(comp).Align := alTop;
                TRLSubDetail(comp).Color := clSilver;
                dc.Align := alTop;
                dc.BorderSpacing.Bottom := 20;
            end;

            if (dc.RealClassName = 'TRLLabel') then
            begin
                TRLLabel(comp).AutoSize := false;
                TRLLabel(comp).Layout := rtlCenter;
                TRLLabel(comp).Caption := TRLLabel(comp).Name;
            end;

            if (dc.RealClassName = 'TRLAngleLabel') then
            begin
                TRLAngleLabel(comp).AutoSize := false;
                TRLAngleLabel(comp).Layout := rtlCenter;
                TRLAngleLabel(comp).Caption := TRLAngleLabel(comp).Name;
            end;

            if (dc.RealClassName = 'TRLBarcode') then
            begin
                TRLBarcode(comp).AutoSize := false;
                TRLBarcode(comp).Layout := rtlCenter;
                TRLBarcode(comp).Caption := TRLBarcode(comp).Name;
            end;

            if (dc.RealClassName = 'TRLDBBarcode') then
            begin
                TRLDBBarcode(comp).AutoSize := false;
                TRLDBBarcode(comp).Layout := rtlCenter;
                TRLDBBarcode(comp).Caption := TRLDBBarcode(comp).Name;
            end;

            if (dc.RealClassName = 'TRLDBImage') then
            begin
                TRLDBImage(comp).AutoSize := false;
            end;

            if (dc.RealClassName = 'TRLImage') then
            begin
                TRLImage(comp).AutoSize := false;
                TRLImage(comp).Width := 60;
                TRLImage(comp).Height := 60;
            end;

            if (dc.RealClassName = 'TRLDBMemo') then
            begin
                TRLDBMemo(comp).AutoSize := false;
                TRLDBMemo(comp).Caption := TRLDBMemo(comp).Name;
            end;

            if (dc.RealClassName = 'TRLMemo') then
            begin
                TRLMemo(comp).AutoSize := false;
                TRLMemo(comp).Caption := TRLMemo(comp).Name;
            end;

            if (dc.RealClassName = 'TRLDBResult') then
            begin
                TRLDBBarcode(comp).AutoSize := false;
                TRLDBBarcode(comp).Layout := rtlCenter;
                TRLDBBarcode(comp).Caption := TRLDBBarcode(comp).Name;
            end;

            if (dc.RealClassName = 'TRLDBRichText') then
            begin
                TRLDBRichText(comp).AutoSize := false;
                TRLDBRichText(comp).Caption := TRLDBRichText(comp).Name;
            end;

            if (dc.RealClassName = 'TRLRichText') then
            begin
                TRLRichText(comp).AutoSize := false;
                TRLRichText(comp).Caption := TRLRichText(comp).Name;
            end;

            if (dc.RealClassName = 'TRLDBText') then
            begin
                TRLDBText(comp).AutoSize := false;
                TRLDBText(comp).Layout := rtlCenter;
                TRLDBText(comp).Caption := TRLDBText(comp).Name;
            end;

            if (dc.RealClassName = 'TRLSystemInfo') then
            begin
                TRLSystemInfo(comp).AutoSize := false;
                TRLSystemInfo(comp).Layout := rtlCenter;
                TRLSystemInfo(comp).Caption := TRLSystemInfo(comp).Name;
            end;


            dc.Font.Assign(comp.Font);
            dc.Text := comp.Caption;
            dc.Align := comp.Align;
            dc.Color := comp.Color;
            dc.Width := comp.Width;
            dc.Height := comp.Height;
            dc.AutoSize := comp.AutoSize;


            result := dc;
        end
            else
        begin
            dc.Free;
            result := nil;
            doMsgError(MainForm, 'Error', 'Could not create component.');
        end;
    end
        else
    begin
        //Android components
        comp2 := Designer.CreateComponentClass(dc.RealClassName);

        if comp2 <> nil then
        begin
            comp2.Name := dc.Name;
            if Parent = Designer then
            begin
                TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                dc.Parent := Designer;
            end
                else
            begin
                try
                    if (Designer.RealForm.find(Parent.Name).ClassName = 'TAPanel') or
                       (Designer.RealForm.find(Parent.Name).ClassName = 'TACustomDialog') or
                       (Designer.RealForm.find(Parent.Name).ClassName = 'TAView') then
                    begin
                        TAVisualControl(comp2).Parent := TAVisualControl(Designer.RealForm.find(Parent.Name));
                        dc.Parent := TWinControl(Designer.find(Parent.Name));
                    end
                        else
                    begin
                        TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                        dc.Parent := Designer;
                    end;
                except
                    TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                    dc.Parent := Designer;
                end;
            end;

            //select design time painter
            if dc.RealClassName = 'TAButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TAImageButton' then dc.PaintName := 'button';
            if dc.RealClassName = 'TACheckBox' then dc.PaintName := 'check';
            if dc.RealClassName = 'TARadioButton' then dc.PaintName := 'radio';
            if dc.RealClassName = 'TAGridView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAListView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAHorizontalScrollView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAScrollView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAImageView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAProgressBar' then dc.PaintName := 'progress';
            if dc.RealClassName = 'TASeekBar' then dc.PaintName := 'trackbar';
            if dc.RealClassName = 'TASpinner' then dc.PaintName := 'combo';
            if dc.RealClassName = 'TATextEdit' then dc.PaintName := 'edit';
            if dc.RealClassName = 'TATextView' then dc.PaintName := 'label';
            if dc.RealClassName = 'TAView' then dc.PaintName := 'memo';
            if dc.RealClassName = 'TAWebView' then dc.PaintName := 'memo';

            if (dc.RealClassName = 'TAAnalogClock') or
               (dc.RealClassName = 'TADigitalClock') or
               (dc.RealClassName = 'TASwitchButton') or
               (dc.RealClassName = 'TARatingBar') then
            begin
                dc.PaintName := 'custom';
                dc.OnCustomPaint := @doCustomControlPaint;
            end;

            if dc.RealClassName <> 'TAImageButton' then
                TAVisualControl(comp2).Text := comp2.Name;

            TAVisualControl(comp2).MarginLeft := 5;
            TAVisualControl(comp2).MarginTop := 5;
            TAVisualControl(comp2).MarginRight := 5;
            TAVisualControl(comp2).MarginBottom := 5;
            TAVisualControl(comp2).LayoutParamWidth := lpWrapContent;
            TAVisualControl(comp2).LayoutParamHeight := lpWrapContent;
            dc.Text := TAVisualControl(comp2).Text;
            dc.Left := TAVisualControl(comp2).Left;
            dc.Top := TAVisualControl(comp2).Top;
            dc.Width := TAVisualControl(comp2).Width;
            dc.Height := TAVisualControl(comp2).Height;

            result := dc;
        end
        else
        begin
            dc.Free;
            result := nil;
            doMsgError(MainForm, 'Error', 'Could not create component.');
        end;
    end;
end;

function createDesignerContainer(Designer: TDesigner; img: int; clName: string; Parent: TWinControl): TDesignerContainer;
var
    dc: TDesignerContainer;
    comp: TControl;
    comp2: TComponent;
begin
    dc := TDesignerContainer.Create(Designer);
    dc.Name := findFreeName(clName, Designer);
    dc.RealClassName := 'T'+clName; //class name start with T
    dc.ParentColor := false;

    if Pos('(Android', ActiveProject.Values['type']) = 0 then
    begin
        comp := Designer.CreateControlClass(dc.RealClassName);
        if comp <> nil then
        begin
            comp.Name := dc.Name;
            if Parent = Designer then
            begin
                comp.Parent := TWinControl(Designer.RealForm);
                dc.Parent := Designer;
            end
                else
            begin
                comp.Parent := TWinControl(Designer.RealForm.find(Parent.Name));
                dc.Parent := TWinControl(Designer.find(Parent.Name));
            end;

            comp.Width := Designer.GridSize * 15;
            comp.Height := Designer.GridSize * 10;

            dc.Text := comp.Caption;
            dc.Align := comp.Align;
            dc.Color := comp.Color;
            dc.Width := comp.Width;
            dc.Height := comp.Height;

            result := dc;
        end
            else
        begin
            dc.Free;
            result := nil;
            doMsgError(MainForm, 'Error', 'Could not create component.');
        end;
    end
        else
    begin
        comp2 := Designer.CreateComponentClass(dc.RealClassName);
        if comp2 <> nil then
        begin
            comp2.Name := dc.Name;
            if Parent = Designer then
            begin
                TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                dc.Parent := Designer;
            end
                else
            begin
                try
                    if (Designer.RealForm.find(Parent.Name).ClassName = 'TAPanel') or
                       (Designer.RealForm.find(Parent.Name).ClassName = 'TACustomDialog') or
                       (Designer.RealForm.find(Parent.Name).ClassName = 'TAView') then
                    begin
                        TAVisualControl(comp2).Parent := TAVisualControl(Designer.RealForm.find(Parent.Name));
                        dc.Parent := TWinControl(Designer.find(Parent.Name));
                    end
                        else
                    begin
                        TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                        dc.Parent := Designer;
                    end;
                except
                    TAVisualControl(comp2).Parent := TAForm(Designer.RealForm);
                    dc.Parent := Designer;
                end;
            end;

            TAVisualControl(comp2).MarginLeft := 5;
            TAVisualControl(comp2).MarginTop := 5;
            TAVisualControl(comp2).MarginRight := 5;
            TAVisualControl(comp2).MarginBottom := 5;
            TAVisualControl(comp2).Text := comp2.Name;
            TAVisualControl(comp2).LayoutParamWidth := lpWrapContent;
            TAVisualControl(comp2).LayoutParamHeight := lpWrapContent;
            dc.Text := TAVisualControl(comp2).Text;
            dc.Left := TAVisualControl(comp2).Left;
            dc.Top := TAVisualControl(comp2).Top;
            dc.Width := TAVisualControl(comp2).Width;
            dc.Height := TAVisualControl(comp2).Height;

            result := dc;
        end
            else
        begin
            dc.Free;
            result := nil;
            doMsgError(MainForm, 'Error', 'Could not create component.');
        end;
    end;
end;

function findFreeName(compName: string; des: TDesigner): string;
var
    c: int = 1;
begin
    while des.find(compName+IntToStr(c)) <> nil do
        c := c + 1;

    result := compName+IntToStr(c);
end;

//unit constructor
constructor begin end.
