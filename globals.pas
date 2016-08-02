////////////////////////////////////////////////////////////////////////
//
// LA Developer - RAD with LA SDK
//
// Author    : LA Center Corporation (la@liveapps.center)
// Copyright : 2016 LA Center Corporation
//
////////////////////////////////////////////////////////////////////////

uses 'codeunit', 'msgbox';

const _APP_NAME = 'LA.Developer';
const _APP_VERSION = '1.78';
const _APP_COPYRIGHT = '© 2016 LA.Center Corporation';
const _APP_SUPPORT = 'developer.support@liveapps.center';
const _APP_WEBSITE = 'https://liveapps.center';

const _CODEPAGE = 19;
const _MAINPAGE = 53;
const _FORMPAGE = 20;
const _FRAMEPAGE = 73;
const _REPORTPAGE = 74;
const _MODULEPAGE = 75;
const _OBJECTIMG = 79;
const _CONTROLIMG = 80;

//varialbes that we want to access globally
var appSettings: TStringList = nil;     //appSettings
var mainForm: TForm = nil;              //mainform
var mainImages: TImageList = nil;       //main images 16
var mainImages32: TImageList = nil;     //main images 32
var ToolboxImages: TImageList = nil;    //toolbox images
var mainActions: TActionList = nil;     //main actions
var Pages: TATTabs = nil;               //IDE Tabs
var PropTabs: TATTabs = nil;            //Object Inspector Tabs
var clientHost: TPanel;                 //Code/Form Editor Parent
var Focuser: TEdit;                     //Used to divert focus
var progress: TProgressBar = nil;
var statusbar: TStatusBar = nil;
//var tbLIST: TStringList = nil;
//var tbXML: TXML = nil;                  //Toolbox XML
var DesClip: TStringList = nil;         //Desinger Clipboard
var Compiler: TLACompiler = nil;        //The Compiler
var Account: TLAAccount = nil;          //The Account Manager
var todoDialog: TForm = nil;            //Todo Dialog
var AfterCloseTimer: TTimer = nil;

var leftTopPanel: TPanel = nil;
var leftBottomPanel: TPanel = nil;
var leftPanel: TPanel = nil;
var leftInSplitter: TSplitter = nil;
var leftOutSplitter: TSplitter = nil;
var rightTopPanel: TPanel = nil;
var rightBottomPanel: TPanel = nil;
var rightPanel: TPanel = nil;
var rightInSplitter: TSplitter = nil;
var rightOutSplitter: TSplitter = nil;
var outputPanel: TPanel = nil;
var bottomOutSplitter: TSplitter = nil;
var accountProgress: TProgressBar = nil;
var accountTransferFile: string = '';

var customPropEdit: TEdit;              //for testing Custom Prop Editor - not used

var ProjectTree: TTreeView = nil;
var ToolboxTree: TTreeView = nil;
var OutputTree: TTreeView = nil;
var ObjectTree: TTreeView = nil;
var PropTree: TTreeView = nil;
var EventTree: TTreeView = nil;

var libCLI: TStringList = nil;
var libCGI: TStringList = nil;
var libFCGI: TStringList = nil;
var libSERVER: TStringList = nil;
var libUIStd: TStringList = nil;
var libUIAdv: TStringList = nil;
var libUIAnd: TStringList = nil;
var libClassList: TStringList = nil;
var libMethodList: TStringList = nil;
var _LIB: TStringList = nil;                    //current open library
var _Breakpoints: TStringList = nil;

var pasCodeTemplates: TStringList = nil;
var cppCodeTemplates: TStringList = nil;
var jsCodeTemplates: TStringList = nil;
var vbCodeTemplates: TStringList = nil;

var finderFindMRU: TStringList = nil;
var finderReplaceMRU: TStringList = nil;

var DefaultProjectLocation: string = '';
var ActiveProjectFile: string = '';
var ActiveProject: TStringList = nil;

var stopUnit: string = '';
var stopLine: int = 0;
var stopCol: int = 0;
var stopError: bool = false;

////////////////////////////////////////////////////////////////////////

//CUSTOM MESSAGEBOX

////////////////////////////////////////////////////////////////////////

procedure doMsgError(Owner: TForm; cap, text: string);
begin
    createMsgBox(Owner, cap, text, msgTypeError).ShowModalDimmed;
end;

function doMsgWarning(Owner: TForm; cap, text: string): int;
begin
    result := createMsgBox(Owner, cap, text, msgTypeWarning).ShowModalDimmed;
end;

function doMsgQuestion(Owner: TForm; cap, text: string): int;
begin
    result := createMsgBox(Owner, cap, text, msgTypeQuestion).ShowModalDimmed;
end;

function doMsgWarningCancel(Owner: TForm; cap, text: string): int;
begin
    result := createMsgBox(Owner, cap, text, msgTypeWarning, true).ShowModalDimmed;
end;

function doMsgQuestionCancel(Owner: TForm; cap, text: string): int;
begin
    result := createMsgBox(Owner, cap, text, msgTypeQuestion, true).ShowModalDimmed;
end;

////////////////////////////////////////////////////////////////////////

//GLOBAL METHODS

////////////////////////////////////////////////////////////////////////


procedure AddToRecentList(fileName: string);
var
    str: TStringList;
begin
    str := TStringList.Create;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects') then
        str.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');
    if str.IndexOf(fileName) = -1 then
        str.Add(fileName);
    str.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');
    str.Free;
end;

procedure doSaveAppSettings();
begin
    appSettings.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'developer.settings');
end;

procedure doPopulateRecentList();
var
    list: TListView;
    item: TListItem;
    str: TStringList;
    tmp: TStringList;
    i: int;
    ptype, pname, lang: string;
begin
    list := TListView(Application.MainForm.find('RecentList'));
    list.Items.BeginUpdate;
    list.Items.Clear;

    str := TStringList.Create;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects') then
        str.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'recent.projects');
    for i := 0 to str.Count -1 do
    begin
        if trim(str.Strings[i]) <> '' then
        begin
            if FileExists(str.Strings[i]) then
            begin
                tmp := TStringList.Create;
                tmp.LoadFromFile(str.Strings[i]);
                ptype := tmp.Values['type'];
                lang := tmp.Values['language'];
                tmp.Free;
                pname := FileNameOf(str.Strings[i]);
                pname := copy(pname, 0, Pos(FileExtOf(pname), pname) -1);

                item := list.Items.Add;
                item.Caption := pname;
                item.SubItems.Add(ptype+' - '+lang);
                item.SubItems.Add(str.Strings[i]);
                if Pos(' CLI (', ptype) > 0 then
                item.ImageIndex := 0
                else if Pos(' FCGI (', ptype) > 0 then
                item.ImageIndex := 2
                else if Pos(' CGI (', ptype) > 0 then
                item.ImageIndex := 1
                else if Pos(' SERVER (', ptype) > 0 then
                item.ImageIndex := 3
                else if Pos(' UI (', ptype) > 0 then
                item.ImageIndex := 4;
            end;
        end;
    end;

    list.Items.EndUpdate;
end;

function doValidateName(val: string): bool;
const
    allowedChars = ['A'..'Z','a'..'z','0'..'9','-','_'];
var
    i: int;
begin
    //we want no spaces or special chars
    result := true;
    if Len(val) <> 0 then
    begin
        for i := 1 to Len(val) do
        begin
            if not (val[i] in allowedChars) then //check for allowed chars
            begin
                doMsgError(MainForm, 'Invalid Name', 'Given name contains invalid characters, please use only characters in the range of [A-Z,a-z,0-9,-,_]');
                result := false;
            end;
        end;
        if result then
        begin
            if val[1] in ['0'..'9'] then //last check if starting with number
            begin
                doMsgError(MainForm, 'Invalid Name', 'Given name cannot start with a number.');
                result := false;
            end;
        end;
    end
        else
        result := false;
end;

procedure doPopulateProjectTree(openMainFile: bool = true; filter: string = '');
var
    i: Integer;
    fname, mainfile: string;
    projectRoot: string;
    root, child: TTreeNode;
    unitType: int;
    opentype: int;
begin
    projectRoot := FilePathOf(ActiveProjectFile);
    fname := FileNameOf(ActiveProjectFile);
    fname := copy(fname, 0, Pos(FileExtOf(fname), fname) -1);

    ProjectTree.BeginUpdate;
    ProjectTree.Items.Clear;

    root := ProjectTree.Items.Add(fname);
    root.ImageIndex := 21;
    root.SelectedIndex := root.ImageIndex;

    //first select mainfile
    mainfile := ActiveProject.Values['mainfile'];
    opentype := _CODEPAGE;

    for i := 0 to ActiveProject.Count -1 do
    begin
        if Pos('file=', ActiveProject.Strings[i]) > 0 then
        begin
            if Pos('=mainform.', ActiveProject.Strings[i]) > 0 then
            begin
                mainfile := copy(ActiveProject.Strings[i], Pos('=', ActiveProject.Strings[i]) +1, 1000);
                if Pos('-WR', ActiveProject.Values['type']) = 0 then
                opentype := _FORMPAGE
                else
                opentype := _CODEPAGE;
            end;
            fname := copy(ActiveProject.Strings[i], Pos('=', ActiveProject.Strings[i]) +1, 1000);
            if (filter <> '') and
               (filter <> '<search>') then
            begin
                if Pos(lower(filter), lower(fname)) > 0 then
                begin
                    child := ProjectTree.Items.AddChild(root, fname);
                    child.ImageIndex := StrToIntDef(copy(ActiveProject.Strings[i], 0, 2), _CODEPAGE);
                    unitType := StrToIntDef(copy(ActiveProject.Strings[i], 0, 2), _CODEPAGE);
                    if child.Text = ActiveProject.Values['mainfile'] then
                    child.ImageIndex := 53;
                    child.SelectedIndex := child.ImageIndex;
                end;
            end
                else
            begin
                child := ProjectTree.Items.AddChild(root, fname);
                child.ImageIndex := StrToIntDef(copy(ActiveProject.Strings[i], 0, 2), _CODEPAGE);
                unitType := StrToIntDef(copy(ActiveProject.Strings[i], 0, 2), _CODEPAGE);
                if child.Text = ActiveProject.Values['mainfile'] then
                child.ImageIndex := 53;
                child.SelectedIndex := child.ImageIndex;
            end;
        end;
    end;

    root.Expanded := true;
    ProjectTree.EndUpdate;

    //open main file
    if openMainFile then
    begin
        if trim(mainfile) <> '' then
            createCodeUnit(MainForm, clientHost, projectRoot+mainfile, opentype);
    end;
end;

function doHasChanges(): bool;
var
    i: int;
    data: TATTabData;
    vars: TVars;
begin
    result := false;
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        vars := TVars(TComponent(data.TabObject).find('Vars'));
        if vars.asBool('modified') then
            result := true;
    end;
end;

function doIsModified(): bool;
var
    data: TATTabData;
    vars: TVars;
begin
    result := false;
    if Pages.TabCount <> 0 then
    begin
        data := Pages.GetTabData(Pages.TabIndex);
        vars := TVars(TComponent(data.TabObject).find('Vars'));
        if vars.asBool('modified') then
            result := true;
    end;
end;

procedure doUpdateEnvironmentOptions();
var
    i: int;
    data: TATTabData;
begin
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        doLoadDesignerSettings(TDesigner(TComponent(data.TabObject).find('Designer')));
        doLoadEditorSettings(TSyntaxMemo(TComponent(data.TabObject).find('Editor')));
    end;
end;

procedure doResetAllPropEditors();
var
    i: int;
    data: TATTabData;
begin
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        TDesigner(TComponent(data.TabObject).find('Designer')).ResetEditor;
    end;
end;

function activePageCaption(): string;
var
    i: int;
    data: TATTabData;
begin
    data := Pages.GetTabData(Pages.TabIndex);
    result := data.TabCaption;
end;

function activePageImg(): int;
var
    i: int;
    data: TATTabData;
begin
    data := Pages.GetTabData(Pages.TabIndex);
    result := data.TabImageIndex;
end;

procedure doSetAtivePageTab(idx: int);
var
    data: TATTabData;
begin
    data := Pages.GetTabData(Pages.TabIndex);
    TATTabs(TComponent(data.TabObject).find('CodePage')).TabIndex := idx;
end;

function doGetAtivePageTab(): int;
var
    data: TATTabData;
begin
    data := Pages.GetTabData(Pages.TabIndex);
    result := TATTabs(TComponent(data.TabObject).find('CodePage')).TabIndex;
end;

function isUnitOpen(fileName: string): bool;
var
    i: int;
    data: TATTabData;
    vars: TVars;
begin
    result := false;
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        vars := TVars(TComponent(data.TabObject).find('Vars'));
        if vars.asString('fullfilename') = fileName then
        begin
            Pages.TabIndex := i;
            TTimer(TComponent(data.TabObject).find('focusTimer')).Enabled := true;
            result := true;
            break;
        end;
    end;
end;

function doSaveAll(): bool;
var
    i: int;
    data: TATTabData;
begin
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        codeUnitSave(TComponent(data.TabObject));
    end;
    result := true;
end;

function doSave(): bool;
var
    data: TATTabData;
begin
    data := Pages.GetTabData(Pages.TabIndex);
    codeUnitSave(TComponent(data.TabObject));
    result := true;
end;

procedure doClose();
var
    data: TATTabData;
begin
    if Pages.TabCount <> 0 then
    begin
        data := Pages.GetTabData(Pages.TabIndex);
        if codeUnitSave(TComponent(data.TabObject), true) then
        begin
            data.TabObject.Free;
            Pages.DeleteTab(Pages.TabIndex, false, false);
        end;
    end;
    TTimer(MainForm.find('AfterCloseTimer')).Enabled := true;
end;

function doGetActiveDesigner(): TDesigner;
var
    data: TATTabData;
begin
    result := nil;
    if Pages.TabCount <> 0 then
    begin
        data := Pages.GetTabData(Pages.TabIndex);
        result := TDesigner(TComponent(data.TabObject).find('Designer'));
    end;
end;

function doGetActiveCodeEditor(): TSyntaxMemo;
var
    data: TATTabData;
begin
    result := nil;
    if Pages.TabCount <> 0 then
    begin
        data := Pages.GetTabData(Pages.TabIndex);
        result := TSyntaxMemo(TComponent(data.TabObject).find('Editor'));
    end;
end;

function doGetActiveDesignerActivePage(): int;
var
    data: TATTabData;
begin
    result := nil;
    if Pages.TabCount <> 0 then
    begin
        data := Pages.GetTabData(Pages.TabIndex);
        result := TATTabs(TComponent(data.TabObject).find('CodePage')).TabIndex;
    end;
end;

function doCloseProject(): bool;
var
    i: int;
    data: TATTabData;
    vars: TVars;
    hasChanges: bool = false;
    canClose: bool = true;
    chk: int;
begin
    for i := Pages.TabCount -1 downto 0 do
    begin
        data := Pages.GetTabData(i);
        vars := TVars(TComponent(data.TabObject).find('Vars'));
        if vars.asBool('modified') then
            hasChanges := true;
    end;

    if hasChanges then
    begin
        chk := doMsgQuestionCancel(MainForm, 'Save Changes', 'Would you like to save all the changes in this project?');
        if chk = mrNo then
        canClose := true;       //no save

        if chk = mrCancel then
        canClose := false;      //cancel operation

        if chk = mrYes then     //force save all
        begin
            for i := Pages.TabCount -1 downto 0 do
            begin
                data := Pages.GetTabData(i);
                codeUnitSave(TComponent(data.TabObject));
                canClose := true;
            end;
        end;
    end;

    if CanClose then
    begin
        for i := Pages.TabCount -1 downto 0 do  //free all tabs and forms
        begin
            data := Pages.GetTabData(i);
            data.TabObject.Free;
            Pages.DeleteTab(i, false, false);
        end;
        ProjectTree.Items.Clear;
        ToolboxTree.Items.Clear;
        ObjectTree.Items.Clear;
        EventTree.Items.Clear;
        PropTree.Items.Clear;
        ActiveProjectFile := '';
        statusbar.Panels.Items[0].Text := 'Project: None';
        libClassList.Clear;
        libMethodList.Clear;
        _Breakpoints.Clear;

        Application.MainForm.Caption := Application.Title;
    end;

    result := canClose;
end;

procedure doAddFormResource(resname: string);
var
    rname: string;
    pfile: string;
    plang: string;
    str: TStringList;
begin
    rname := copy(resname, 0, Pos('.', resname) -1);
    str := TStringList.Create;
    pfile := FilePathOf(ActiveProjectFile)+ActiveProject.Values['mainfile'];
    plang := ActiveProject.Values['language'];
    if FileExists(pfile) then
    begin
        str.LoadFromFile(pFile);

        //we have to seperate the $ sign otherwise compiler error => resource not found
        if plang = 'Basic' then
        str.Add(''''+'$'+'res:'+rname+'=[project-home]'+resname)
        else
        str.Add('//'+'$'+'res:'+rname+'=[project-home]'+resname);

        str.SaveToFile(pFile);
    end;
    str.Free;
end;

procedure ExtractLibraryKeys(proType: string);
var
    i, j, k: int;
    clName: string;
    str: TStringList;
begin
    case proType of     //select library
        'cli'       : _LIB := libCLI;
        'cgi'       : _LIB := libCGI;
        'fcgi'      : _LIB := libFCGI;
        'server'    : _LIB := libSERVER;
        'ui'        : _LIB := libUIAdv;
        'uice'      : _LIB := libUIStd;
        'uiand'     : _LIB := libUIAnd;
    end;

    //Exract Classes
    libExtractClasses(_LIB, libClassList,
        (appSettings.Values['events-as-keys'] = '1'),
        (appSettings.Values['props-as-keys'] = '1'),
        (appSettings.Values['methods-as-keys'] = '1'));
    //Extract Functions
    libExtractFunctions(_LIB, libMethodList);
    //Extract Types
    libExtractTypes(_LIB, libMethodList);
end;

procedure doCreateUnit(unitName: string; utype: int);
var
    root: string;
    f: TForm;
begin
    root := FilePathOf(ActiveProjectFile);

    if ActiveProject.Values['language'] = 'Basic' then
    begin
        if utype = _FORMPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_formvb', root+unitName+'.vb');
                doAddFormResource(unitName+'.vb.frm');
            end
                else
                ResToFile('tpl_formvb2', root+unitName+'.vb');
        end
        else if utype = _FRAMEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_framevb', root+unitName+'.vb');
                doAddFormResource(unitName+'.vb.frm');
            end
                else
                ResToFile('tpl_framevb2', root+unitName+'.vb');
        end
        else if utype = _REPORTPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_reportvb', root+unitName+'.vb');
                doAddFormResource(unitName+'.vb.frm');
            end
                else
                ResToFile('tpl_reportvb2', root+unitName+'.vb');
        end
        else if utype = _MODULEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_modulevb', root+unitName+'.vb');
                doAddFormResource(unitName+'.vb.frm');
            end
                else
                ResToFile('tpl_modulevb2', root+unitName+'.vb');
        end
            else
            ResToFile('tpl_unitvb', root+unitName+'.vb');

        if Pos('-WR', ActiveProject.Values['type']) = 0 then
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.vb', utype);
            ActiveProject.Add(IntToStr(utype)+'file='+unitName+'.vb');
        end
            else
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.vb', _CODEPAGE);
            ActiveProject.Add(IntToStr(_CODEPAGE)+'file='+unitName+'.vb');
        end;
    end;

    if ActiveProject.Values['language'] = 'C++' then
    begin
        if utype = _FORMPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_formcpp', root+unitName+'.c++');
                doAddFormResource(unitName+'.c++.frm');
            end
                else
                ResToFile('tpl_formcpp2', root+unitName+'.c++');
        end
        else if utype = _FRAMEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_framecpp', root+unitName+'.c++');
                doAddFormResource(unitName+'.c++.frm');
            end
                else
                ResToFile('tpl_framecpp2', root+unitName+'.c++');
        end
        else if utype = _REPORTPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_reportcpp', root+unitName+'.c++');
                doAddFormResource(unitName+'.c++.frm');
            end
                else
                ResToFile('tpl_reportcpp2', root+unitName+'.c++');
        end
        else if utype = _MODULEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_modulecpp', root+unitName+'.c++');
                doAddFormResource(unitName+'.c++.frm');
            end
                else
                ResToFile('tpl_modulecpp2', root+unitName+'.c++');
        end
            else
            ResToFile('tpl_unitcpp', root+unitName+'.c++');

        if Pos('-WR', ActiveProject.Values['type']) = 0 then
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.c++', utype);
            ActiveProject.Add(IntToStr(utype)+'file='+unitName+'.c++');
        end
            else
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.c++', _CODEPAGE);
            ActiveProject.Add(IntToStr(_CODEPAGE)+'file='+unitName+'.c++');
        end;
    end;

    if ActiveProject.Values['language'] = 'JScript' then
    begin
        if utype = _FORMPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_formjs', root+unitName+'.js');
                doAddFormResource(unitName+'.js.frm');
            end
                else
                ResToFile('tpl_formjs2', root+unitName+'.js');
        end
        else if utype = _FRAMEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_framejs', root+unitName+'.js');
                doAddFormResource(unitName+'.js.frm');
            end
                else
                ResToFile('tpl_framejs2', root+unitName+'.js');
        end
        else if utype = _REPORTPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_reportjs', root+unitName+'.js');
                doAddFormResource(unitName+'.js.frm');
            end
                else
                ResToFile('tpl_reportjs2', root+unitName+'.js');
        end
        else if utype = _MODULEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_modulejs', root+unitName+'.js');
                doAddFormResource(unitName+'.js.frm');
            end
                else
                ResToFile('tpl_modulejs2', root+unitName+'.js');
        end
            else
            ResToFile('tpl_unitjs', root+unitName+'.js');

        if Pos('-WR', ActiveProject.Values['type']) = 0 then
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.js', utype);
            ActiveProject.Add(IntToStr(utype)+'file='+unitName+'.js');
        end
            else
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.js', _CODEPAGE);
            ActiveProject.Add(IntToStr(_CODEPAGE)+'file='+unitName+'.js');
        end;
    end;

    if ActiveProject.Values['language'] = 'Pascal' then
    begin
        if utype = _FORMPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_formpas', root+unitName+'.pas');
                doAddFormResource(unitName+'.pas.frm');
            end
                else
                ResToFile('tpl_formpas2', root+unitName+'.pas');
        end
        else if utype = _FRAMEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_framepas', root+unitName+'.pas');
                doAddFormResource(unitName+'.pas.frm');
            end
                else
                ResToFile('tpl_framepas2', root+unitName+'.pas');
        end
        else if utype = _REPORTPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_reportpas', root+unitName+'.pas');
                doAddFormResource(unitName+'.pas.frm');
            end
                else
                ResToFile('tpl_reportpas2', root+unitName+'.pas');
        end
        else if utype = _MODULEPAGE then
        begin
            if Pos('-WR', ActiveProject.Values['type']) = 0 then
            begin
                ResToFile('tpl_modulepas', root+unitName+'.pas');
                doAddFormResource(unitName+'.pas.frm');
            end
                else
                ResToFile('tpl_modulepas2', root+unitName+'.pas');
        end
            else
            ResToFile('tpl_unitpas', root+unitName+'.pas');

        if Pos('-WR', ActiveProject.Values['type']) = 0 then
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.pas', utype);
            ActiveProject.Add(IntToStr(utype)+'file='+unitName+'.pas');
        end
            else
        begin
            createCodeUnit(MainForm, clientHost, root+unitName+'.pas', _CODEPAGE);
            ActiveProject.Add(IntToStr(_CODEPAGE)+'file='+unitName+'.pas');
        end;
    end;

    ActiveProject.SaveToFile(ActiveProjectFile);
    doPopulateProjectTree(false);
end;

procedure doOpenFile(fileName: string);
begin
    if Pos('.txt', Lower(fileName)) > 0 then
    begin
        QueMessage('LANotepad-Startup', fileName);
        LaunchLiveApplication('LA-193139295745909146361979', 'Launching LA.Notepad, please wait...');
    end
    else if Pos('.sql', Lower(fileName)) > 0 then
    begin
        QueMessage('LASQLDeveloper-Startup', fileName);
        LaunchLiveApplication('LA-5779545179252997420827008', 'Launching LA.SQL Developer, please wait...');
    end
        else
        doMsgError(MainForm, 'Error', 'Unknown extention, could not open file');
end;

procedure doOpenProject(fileName: string);
var
    isUI: bool = false;
begin
    progress.Show;
    statusbar.Panels.Items[0].Text := 'Preparing project library, please wait...';
    Screen.Cursor := crHourGlass;
    Application.ProcessMessages;

    ActiveProjectFile := fileName;
    ActiveProject.LoadFromFile(fileName);
    ActiveProject.Sort;

    if Pos('CLI (', ActiveProject.Values['type']) > 0 then
        ExtractLibraryKeys('cli')
    else if Pos('FCGI (', ActiveProject.Values['type']) > 0 then
        ExtractLibraryKeys('fcgi')
    else if Pos('CGI (', ActiveProject.Values['type']) > 0 then
        ExtractLibraryKeys('cgi')
    else if Pos('SERVER (', ActiveProject.Values['type']) > 0 then
        ExtractLibraryKeys('server')
    else if Pos('UI (Standard', ActiveProject.Values['type']) > 0 then
    begin
        ExtractLibraryKeys('uice');
        isUI := true;
    end
    else if Pos('UI (Android', ActiveProject.Values['type']) > 0 then
    begin
        ExtractLibraryKeys('uiand');
        isUI := true;
    end
    else if Pos('UI (Advanced', ActiveProject.Values['type']) > 0 then
    begin
        ExtractLibraryKeys('ui');
        isUI := true;
    end;

    doPopulateProjectTree;
    doPopulateToolbox(isUI);

    TStatusBar(MainForm.find('StatusBar')).
        Panels.Items[0].Text := 'Project: '+ActiveProjectFile;

    Application.MainForm.Caption :=
        '['+copy(FileNameOf(ActiveProjectFile), 0, Pos('.', FileNameOf(ActiveProjectFile)) -1)+'] '+Application.Title;

    progress.Hide;
    Screen.Cursor := crDefault;
    Application.ProcessMessages;

    AddToRecentList(fileName);
    doPopulateRecentList;
end;

procedure doCreateNewProject(location, name, lang, protype: string);
var
    str: TStringList;
begin
    appsettings.Values['default-location'] := location;
    doSaveAppSettings;

    ForceDir(location+name+DirSep+'resources');
    str := TStringList.Create;
    str.Add('language='+lang);
    str.Add('type='+protype);
    str.Add('launcherid=');
    str.Add('macbundle=0');
    str.Add('macbundle-icon=');
    str.Add('publish-oncompile=0');
    str.Add('targets=');

    if Pos('CLI (', protype) > 0 then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            ResToFile('tpl_clivb', location+name+DirSep+name+'.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            ResToFile('tpl_clicpp', location+name+DirSep+name+'.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            ResToFile('tpl_clijs', location+name+DirSep+name+'.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            ResToFile('tpl_clipas', location+name+DirSep+name+'.pas');
        end;
    end
    else if Pos('FCGI (', protype) > 0 then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            ResToFile('tpl_fcgivb', location+name+DirSep+name+'.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            ResToFile('tpl_fcgicpp', location+name+DirSep+name+'.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            ResToFile('tpl_fcgijs', location+name+DirSep+name+'.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            ResToFile('tpl_fcgipas', location+name+DirSep+name+'.pas');
        end;
    end
    else if Pos('CGI (', protype) > 0 then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            ResToFile('tpl_cgivb', location+name+DirSep+name+'.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            ResToFile('tpl_cgicpp', location+name+DirSep+name+'.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            ResToFile('tpl_cgijs', location+name+DirSep+name+'.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            ResToFile('tpl_cgipas', location+name+DirSep+name+'.pas');
        end;
    end
    else if Pos('SERVER (', protype) > 0 then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            ResToFile('tpl_servervb', location+name+DirSep+name+'.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            ResToFile('tpl_servercpp', location+name+DirSep+name+'.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            ResToFile('tpl_serverjs', location+name+DirSep+name+'.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            ResToFile('tpl_serverpas', location+name+DirSep+name+'.pas');
        end;
    end

    ////ANDROID
    else if (Pos('UI (Android', protype) > 0) and
            (Pos('-WR', protype) = 0) then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.vb');
            ResToFile('tpl_auivb', location+name+DirSep+name+'.vb');
            ResToFile('tpl_amainformvb', location+name+DirSep+'mainform.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.c++');
            ResToFile('tpl_auicpp', location+name+DirSep+name+'.c++');
            ResToFile('tpl_amainformcpp', location+name+DirSep+'mainform.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.js');
            ResToFile('tpl_auijs', location+name+DirSep+name+'.js');
            ResToFile('tpl_amainformjs', location+name+DirSep+'mainform.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.pas');
            ResToFile('tpl_auipas', location+name+DirSep+name+'.pas');
            ResToFile('tpl_amainformpas', location+name+DirSep+'mainform.pas');
        end;
    end
    else if (Pos('UI (Android', protype) > 0) and
            (Pos('-WR', protype) > 0) then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.vb');
            ResToFile('tpl_auivb2', location+name+DirSep+name+'.vb');
            ResToFile('tpl_amainformvb2', location+name+DirSep+'mainform.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.c++');
            ResToFile('tpl_auicpp2', location+name+DirSep+name+'.c++');
            ResToFile('tpl_amainformcpp2', location+name+DirSep+'mainform.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.js');
            ResToFile('tpl_auijs2', location+name+DirSep+name+'.js');
            ResToFile('tpl_amainformjs2', location+name+DirSep+'mainform.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.pas');
            ResToFile('tpl_auipas2', location+name+DirSep+name+'.pas');
            ResToFile('tpl_amainformpas2', location+name+DirSep+'mainform.pas');
        end;
    end
    ////ANDROID


    else if (Pos('UI (', protype) > 0) and
            (Pos('-WR', protype) = 0) then
    begin
        ResToFile('devicon', location+name+DirSep+'resources'+DirSep+'app.ico');

        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.vb');
            ResToFile('tpl_uivb', location+name+DirSep+name+'.vb');
            ResToFile('tpl_mainformvb', location+name+DirSep+'mainform.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.c++');
            ResToFile('tpl_uicpp', location+name+DirSep+name+'.c++');
            ResToFile('tpl_mainformcpp', location+name+DirSep+'mainform.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.js');
            ResToFile('tpl_uijs', location+name+DirSep+name+'.js');
            ResToFile('tpl_mainformjs', location+name+DirSep+'mainform.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            str.Add(IntToStr(_FORMPAGE)+'file=mainform.pas');
            ResToFile('tpl_uipas', location+name+DirSep+name+'.pas');
            ResToFile('tpl_mainformpas', location+name+DirSep+'mainform.pas');
        end;
    end
    else if (Pos('UI (', protype) > 0) and
            (Pos('-WR', protype) > 0) then
    begin
        if lang = 'Basic' then
        begin
            str.Add('mainfile='+name+'.vb');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.vb');
            ResToFile('tpl_uivb2', location+name+DirSep+name+'.vb');
            ResToFile('tpl_mainformvb2', location+name+DirSep+'mainform.vb');
        end
        else if lang = 'C++' then
        begin
            str.Add('mainfile='+name+'.c++');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.c++');
            ResToFile('tpl_uicpp2', location+name+DirSep+name+'.c++');
            ResToFile('tpl_mainformcpp2', location+name+DirSep+'mainform.c++');
        end
        else if lang = 'JScript' then
        begin
            str.Add('mainfile='+name+'.js');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.js');
            ResToFile('tpl_uijs2', location+name+DirSep+name+'.js');
            ResToFile('tpl_mainformjs2', location+name+DirSep+'mainform.js');
        end
        else if lang = 'Pascal' then
        begin
            str.Add('mainfile='+name+'.pas');
            str.Add(IntToStr(_CODEPAGE)+'file=mainform.pas');
            ResToFile('tpl_uipas2', location+name+DirSep+name+'.pas');
            ResToFile('tpl_mainformpas2', location+name+DirSep+'mainform.pas');
        end;
    end;

    str.SaveToFile(location+name+DirSep+name+'.la-project');
    str.Free;

    doOpenProject(location+name+DirSep+name+'.la-project');
end;

procedure doPopulateToolbox(isUI: bool = false);
var
    root, child: TTreeNode;
    tmp: TStringList;
    i, j: int;
    filter, s, im: string;

    function findNode(txt: string): TTreeNode;
        var
            i: int;
    begin
        for i := 0 to ToolboxTree.Items.Count -1 do
        begin
            if ToolboxTree.Items.Item[i].Text = txt then
            begin
                result := ToolboxTree.Items.Item[i];
                break;
            end;
        end;
    end;
begin
    if ActiveProjectFile = '' then exit;

    if TEditButton(MainForm.find('ToolBoxSearch')).Text <> '<search>' then
    filter := TEditButton(MainForm.find('ToolBoxSearch')).Text
    else
    filter := '';

    //Screen.Cursor := crHourGlass;

    tmp := TStringList.Create;
    tmp.Duplicates := dupIgnore;

    ToolboxTree.Items.BeginUpdate;
    ToolboxTree.Items.Clear;

    if Pos('UI (Adv', ActiveProject.Values['type']) > 0 then
    tmp.LoadFromResource('tbadv')
    else if Pos('UI (Sta', ActiveProject.Values['type']) > 0 then
    tmp.LoadFromResource('tbstd')
    else if Pos('UI (Android', ActiveProject.Values['type']) > 0 then
    tmp.LoadFromResource('tband')
    else
    tmp.LoadFromResource('tbcli');

    tmp.Sort;


    if filter = '' then
    begin
        for i := 0 to tmp.Count -1 do
        begin
            root := ToolboxTree.Items.Add(tmp.Names[i]);
            root.ImageIndex := StrToIntDef(tmp.ValueByIndex(i), -1);
            root.SelectedIndex := root.ImageIndex;
        end;
    end
        else
    begin
        for i := 0 to tmp.Count -1 do
        begin
            if Pos(Lower(filter), Lower(tmp.Names[i])) > 0 then
            begin
                root := ToolboxTree.Items.Add(tmp.Names[i]);
                root.ImageIndex := StrToIntDef(tmp.ValueByIndex(i), -1);
                root.SelectedIndex := root.ImageIndex;
            end;
        end;
    end;

    {for i := 0 to tbXML.Document.Count -1 do
    begin
        if not isUI then
        begin
            if tbXML.Document.getChild(i).getAttribute('ui') = 'false' then
            begin
                if tmp.IndexOf(tbXML.Document.getChild(i).getAttribute('maincat')) = -1 then
                    tmp.Add(tbXML.Document.getChild(i).getAttribute('maincat'));
            end;
        end
            else
        begin
            if tmp.IndexOf(tbXML.Document.getChild(i).getAttribute('maincat')) = -1 then
                tmp.Add(tbXML.Document.getChild(i).getAttribute('maincat'));
        end;

    end;
    tmp.Sort;

    for i := 0 to tmp.Count -1 do
    begin
        root := ToolboxTree.Items.Add(tmp.Strings[i]);
        root.ImageIndex := 1;
        root.SelectedIndex := root.ImageIndex;

        for j := 0 to tbXML.Document.Count -1 do
        begin
            if not isUI then
            begin
                if tbXML.Document.getChild(j).getAttribute('ui') = 'false' then
                begin
                    if (tbXML.Document.getChild(j).getAttribute('maincat') = tmp.Strings[i]) then
                    begin
                        if libClassList.IndexOf('T'+tbXML.Document.getChild(j).getAttribute('name')) <> -1 then
                        begin
                            if filter <> '' then
                            begin
                                if Pos(Lower(filter), Lower(tbXML.Document.getChild(j).getAttribute('name'))) > 0 then
                                begin
                                    child := ToolboxTree.Items.AddChild(root, tbXML.Document.getChild(j).getAttribute('name'));
                                    child.ImageIndex := StrToIntDef(tbXML.Document.getChild(j).getAttribute('img'), -1);
                                    child.SelectedIndex := child.ImageIndex;
                                end;
                            end
                                else
                            begin
                                child := ToolboxTree.Items.AddChild(root, tbXML.Document.getChild(j).getAttribute('name'));
                                child.ImageIndex := StrToIntDef(tbXML.Document.getChild(j).getAttribute('img'), -1);
                                child.SelectedIndex := child.ImageIndex;
                            end;
                        end;
                    end;
                end;
            end
                else
            begin
                if (tbXML.Document.getChild(j).getAttribute('maincat') = tmp.Strings[i]) then
                begin
                    if libClassList.IndexOf('T'+tbXML.Document.getChild(j).getAttribute('name')) <> -1 then
                    begin
                        if filter <> '' then
                        begin
                            if Pos(Lower(filter), Lower(tbXML.Document.getChild(j).getAttribute('name'))) > 0 then
                            begin
                                child := ToolboxTree.Items.AddChild(root, tbXML.Document.getChild(j).getAttribute('name'));
                                child.ImageIndex := StrToIntDef(tbXML.Document.getChild(j).getAttribute('img'), -1);
                                child.SelectedIndex := child.ImageIndex;
                            end;
                        end
                            else
                        begin
                            child := ToolboxTree.Items.AddChild(root, tbXML.Document.getChild(j).getAttribute('name'));
                            child.ImageIndex := StrToIntDef(tbXML.Document.getChild(j).getAttribute('img'), -1);
                            child.SelectedIndex := child.ImageIndex;
                        end;
                    end;
                end;
            end;
        end;
        root.Text := root.Text+' ('+IntToStr(root.Count)+')';
        if filter <> '' then
        root.Expanded := true;
    end;}

    //ToolboxTree.AlphaSort;

    if ToolboxTree.Items.Count <> 0 then
    root := ToolboxTree.Items.Insert(ToolboxTree.Items.Item[0], 'Select Mode')
    else
    root := ToolboxTree.Items.Add('Select Mode');
    root.ImageIndex := 0;
    root.SelectedIndex := root.ImageIndex;
    root.Selected := true;

    ToolboxTree.Items.EndUpdate;
    tmp.Free;

    //Screen.Cursor := crDefault;
end;

////////////////////////////////////////////////////////////////////////

//CENTRALIZED EVENTS

////////////////////////////////////////////////////////////////////////

procedure pane_Search_Enter(Sender: TEditButton);
begin
    if Sender.Text = '<search>' then
    begin
        Sender.Color := clWindow;
        Sender.Font.Color := clWindowText;
        Sender.Text := '';
    end;
end;

procedure pane_Search_Exit(Sender: TEditButton);
begin
    if Trim(Sender.Text) = '' then
    begin
        Sender.Color := Sender.Parent.Color;
        Sender.Font.Color := clGrayText;
        Sender.Text := '<search>';
        Focuser.SetFocus;
    end;
end;

procedure pane_Search_ButtonClick(Sender: TEditButton);
begin
    Sender.Color := Sender.Parent.Color;
    Sender.Font.Color := clGrayText;
    Sender.Text := '<search>';
    Focuser.SetFocus;
end;

procedure toolbar_Close_Click(Sender: TObject);
begin
    if Pages.TabCount > 0 then
    doClose
    else if ActiveProjectFile <> '' then
    begin
        if doMsgQuestion(MainForm, 'Close Project', 'You are about to close this project, continue?') = mrYes then
        begin
            TAction(MainForm.find('actCompile')).Execute;
            doCloseProject;
        end;
    end;
end;

procedure doCustomControlPaint(Sender: TDesignerObject; Canvas: TCanvas; objWidth, objHeight: integer; AClassName: string);
var
    png: TPortableNetworkGraphic;
begin
    png := TPortableNetworkGraphic.Create;
    if (AClassName = 'TDTAnalogClock') or
       (AClassName = 'TAAnalogClock') then
    begin
        png.LoadFromResource('clock1');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TADigitalClock' then
    begin
        png.LoadFromResource('digiclock');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TARatingBar' then
    begin
        png.LoadFromResource('rating');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TDTThemedClock' then
    begin
        png.LoadFromResource('clock2');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TDTThemedGauge' then
    begin
        png.LoadFromResource('gauge');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TBubbleShape' then
    begin
        png.LoadFromResource('bubble');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TCircleProgress') or
       (AClassName = 'TCircleShape') then
    begin
        png.LoadFromResource('circle');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TEllipseShape' then
    begin
        png.LoadFromResource('ellipse');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'THexagonShape' then
    begin
        png.LoadFromResource('hexagon');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TOctagonShape' then
    begin
        png.LoadFromResource('octagon');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TParallelShape' then
    begin
        png.LoadFromResource('parallel');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if AClassName = 'TPentagonShape' then
    begin
        png.LoadFromResource('pentagon');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TRectShape') or
       (AClassName = 'TRectangleShape') then
    begin
        png.LoadFromResource('rectangle');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TRoundRectShape') then
    begin
        png.LoadFromResource('roundrect');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TShape') or
       (AClassName = 'TShapeProgress') or
       (AClassName = 'TSquareShape') then
    begin
        png.LoadFromResource('square');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TRoundSquareShape') then
    begin
        png.LoadFromResource('roundsquare');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TStarShape') then
    begin
        png.LoadFromResource('star');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TTrapezShape') then
    begin
        png.LoadFromResource('trapez');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TTriangleShape') then
    begin
        png.LoadFromResource('triangle');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TArrow') then
    begin
        if TArrow(TDesignerObject(Sender).RealComponent).ArrowType = atLeft then
        png.LoadFromResource('arrow-left');
        if TArrow(TDesignerObject(Sender).RealComponent).ArrowType = atUp then
        png.LoadFromResource('arrow-top');
        if TArrow(TDesignerObject(Sender).RealComponent).ArrowType = atRight then
        png.LoadFromResource('arrow-right');
        if TArrow(TDesignerObject(Sender).RealComponent).ArrowType = atDown then
        png.LoadFromResource('arrow-bottom');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TATTabs') then
    begin
        png.LoadFromResource('attabs');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TECProgressBar') then
    begin
        png.LoadFromResource('ecprogress');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TECSlider') then
    begin
        png.LoadFromResource('ecslider');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TECRuler') then
    begin
        png.LoadFromResource('ecruler');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TECSwitch') or
       (AClassName = 'TASwitchButton') then
    begin
        png.LoadFromResource('ecswitch');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TCalendar') or
       (AClassName = 'TDBCalendar') then
    begin
        png.LoadFromResource('calendar');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    if (AClassName = 'TBarCode') or
       (AClassName = 'TDBBarCode') or
       (AClassName = 'TRLBarcode') or
       (AClassName = 'TRLDBBarcode') then
    begin
        png.LoadFromResource('barcode');
        Canvas.drawImageStretch(png, 0, 0, objWidth, objHeight);
    end;
    png.Free;
end;

procedure doCompilerMessage(Sender: TLACompiler; message: string);
var
    item: TTreeNode;
    uname, line, col, ext: string;
    i: int;
begin
    if Sender <> nil then
    begin
        if Sender.isHardLicense then
        begin
            if Pos('Please login to your', message) > 0 then
                exit;
        end;

        item := OutputTree.Items.Add(message);
        if Pos('GC-ERROR', message) > 0 then
        item.ImageIndex := 84
        else
        item.ImageIndex := 83;
        item.SelectedIndex := item.ImageIndex;
        item.MakeVisible;

        if appSettings.Values['show-output-onlyon-error'] = '1' then
        begin
            if Pos('GC-ERROR', message) > 0 then
            begin
                if not TMenuItem(MainForm.find('mOutputPaneCheck')).Checked then
                    TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
            end;
        end
            else
        begin
            if not TMenuItem(MainForm.find('mOutputPaneCheck')).Checked then
                TMenuItem(MainForm.find('mOutputPaneCheck')).Click;
        end;

        if Pos('### MAKE', message) > 0 then
        begin
            if ActiveProject.Values['publish-oncompile'] = '1' then
                if Account.Connected then
                    if Trim(ActiveProject.Values['launcherid']) <> '' then
                        TTimer(MainForm.find('PublishTimer')).Enabled := true;

            if ActiveProject.Values['macbundle'] = '1' then
                Compiler.CreateMacBundle(ActiveProject.Values['macbundle-icon'], ActiveProjectFile);
        end;

        if Pos('### TERMINATE', message) > 0 then
        begin
            TStatusBar(MainForm.find('Statusbar')).Panels.Items[2].Text := 'Compiler: Idle';
            if not stopError then
            stopUnit := '';
            if doGetActiveCodeEditor <> nil then
            begin
                doGetActiveCodeEditor.setRunLine(-1);
                doGetActiveCodeEditor.Invalidate;
            end;
        end;
    end;

    if Pos('unit [', Lower(message)) > 0 then
    begin
        uname := copy(message, Pos('[', message) +1, 1000);
        uname := copy(uname, 0, Pos(']', uname) -1);
        line := copy(message, Pos(']', message) +1, 1000);
        line := copy(line, Pos('[', line) +1, 1000);
        line := copy(line, 0, Pos(']', line) -1);
        col := copy(line, Pos(':', line) +1, 100);
        line := copy(line, 0, Pos(':', line) -1);

        if Pos('GC-ERROR', message) > 0 then
        stopError := true;

        stopUnit := uname;
        stopLine := StrToIntDef(line, 1);
        stopCol := StrToIntDef(col, 1);

        if uname <> '' then
        begin
            ext := FileExtOf(ActiveProject.Values['mainfile']);
            if Pos('='+stopUnit+ext, ActiveProject.Text) = 0 then
            begin
                //we stopped at a unit that is not included in the project
                doMsgError(MainForm, 'Error', 'The unit ['+stopUnit+'] was not found in your project definition file. Please add this unit to your project.');
                stopUnit := '';
            end
                else
            begin
                if not isUnitOpen(FilePathOf(ActiveProjectFile)+stopUnit+ext) then
                begin
                    for i := 0 to ProjectTree.Items.Count -1 do
                    begin
                        if ProjectTree.Items.Item[i].Text = stopUnit+ext then
                        begin
                            ProjectTree.Items.Item[i].Selected := true;
                            sleep(100);
                            TAction(MainForm.find('actEditUnit')).Execute;
                            break;
                        end;
                    end;
                end;

                TStatusBar(MainForm.find('Statusbar')).Panels.Items[1].Text :=
                    'Line/Column: '+Line+'/'+Col;

                if doGetActiveCodeEditor <> nil then
                begin
                    doSetAtivePageTab(0);
                    doGetActiveCodeEditor.CaretY := stopLine;
                    doGetActiveCodeEditor.CaretX := stopCol;
                    doGetActiveCodeEditor.setRunLine(stopLine);
                    doGetActiveCodeEditor.Invalidate;
                end;
            end;
        end;
    end;
end;

procedure doLoadDesignerSettings(Designer: TDesigner);
begin
    Designer.AllowHalfStep := (appSettings.Values['designer-AllowHalfStep'] = '1');
    Designer.ApplyDarkContrastColor := (appSettings.Values['designer-ApplyDarkContrastColor'] = '1');
    Designer.ShowDropMarker := (appSettings.Values['designer-ShowDropMarker'] = '1');
    Designer.ShowGrid := (appSettings.Values['designer-ShowGrid'] = '1');
    Designer.ShowComponentHint := (appSettings.Values['designer-ShowComponentHint'] = '1');
    Designer.SnapToGrid := (appSettings.Values['designer-SnapToGrid'] = '1');
    Designer.ShowGridLines := (appSettings.Values['designer-ShowGridLines'] = '1');
    Designer.ShowMargin := (appSettings.Values['designer-ShowMargin'] = '1');
    Designer.ShowSplits := (appSettings.Values['designer-ShowSplits'] = '1');
    Designer.ShowSpaceGuide := (appSettings.Values['designer-ShowSpaceGuide'] = '1');
    Designer.ShowGuideLines := (appSettings.Values['designer-ShowGuideLines'] = '1');
    Designer.GridSize := StrToIntDef(appSettings.Values['designer-GridSize'], 10);
    Designer.Split := StrToIntDef(appSettings.Values['designer-Split'], 4);
    Designer.GridXLineSize := StrToIntDef(appSettings.Values['designer-GridXLineSize'], 50);
    Designer.GridYLineSize := StrToIntDef(appSettings.Values['designer-GridYLineSize'], 50);
    Designer.MarginLeft := StrToIntDef(appSettings.Values['designer-MarginLeft'], 20);
    Designer.MarginTop := StrToIntDef(appSettings.Values['designer-MarginTop'], 20);
    Designer.MarginRight := StrToIntDef(appSettings.Values['designer-MarginRight'], 20);
    Designer.MarginBottom := StrToIntDef(appSettings.Values['designer-MarginBottom'], 20);
    Designer.HandleSize := StrToIntDef(appSettings.Values['designer-HandleSize'], 6);
    Designer.SelectorColor := StringToColorDef(appSettings.Values['designer-SelectorColor'], clSkyBlue);
    Designer.SelectorBorderColor := StringToColorDef(appSettings.Values['designer-SelectorBorderColor'], clNavy);
    Designer.GridColor := StringToColorDef(appSettings.Values['designer-GridColor'], clBlack);
    Designer.MarginColor := StringToColorDef(appSettings.Values['designer-MarginColor'], clNavy);
    Designer.SplitColor := StringToColorDef(appSettings.Values['designer-SplitColor'], clNavy);
    Designer.LockedColor := StringToColorDef(appSettings.Values['designer-LockedColor'], clRed);
    Designer.PropertiesColor := StringToColorDef(appSettings.Values['designer-PropertiesColor'], clNavy);
    Designer.DarkContrastColor := StringToColorDef(appSettings.Values['designer-DarkContrastColor'], clCream);
    Designer.HalfSpaceMarginColor := StringToColorDef(appSettings.Values['designer-HalfSpaceMarginColor'], clRed);
    Designer.FullSpaceMarginColor := StringToColorDef(appSettings.Values['designer-FullSpaceMarginColor'], clBlue);
    Designer.GuideLineColorLeft := StringToColorDef(appSettings.Values['designer-GuideLineColorLeft'], clBlue);
    Designer.GuideLineColorTop := StringToColorDef(appSettings.Values['designer-GuideLineColorTop'], clBlue);
    Designer.GuideLineColorRight := StringToColorDef(appSettings.Values['designer-GuideLineColorRight'], clBlue);
    Designer.GuideLineColorBottom := StringToColorDef(appSettings.Values['designer-GuideLineColorBottom'], clBlue);
    Designer.HandleColor := StringToColorDef(appSettings.Values['designer-HandleColor'], clBlue);
end;

procedure doLoadEditorSettings(Editor: TSyntaxMemo);
begin
    Editor.CompletionShortcut := TextToShortcut(appSettings.Values['autocompletion-shortcut']);
    Editor.TemplateShortcut := TextToShortcut(appSettings.Values['codetemplate-shortcut']);
    Editor.Color := StringToColorDef(appSettings.Values['editor-Color'], clWindow);
    Editor.Font.Color := StringToColorDef(appSettings.Values['editor-FontColor'], clWindowText);
    Editor.Font.Name := appSettings.Values['editor-FontName'];
    Editor.Font.Size := StrToIntDef(appSettings.Values['editor-FontSize'], 0);
    Editor.Highlighter.CommentAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-CommentAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.CommentAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-CommentAttributes-ForegroundColor'], clGreen);
    Editor.Highlighter.CommentAttributes.Bold := (appsettings.Values['editor-CommentAttributes-Bold'] = '1');
    Editor.Highlighter.CommentAttributes.Italic := (appsettings.Values['editor-CommentAttributes-Italic'] = '1');
    Editor.Highlighter.IdentifierAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-IdentifierAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.IdentifierAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-IdentifierAttributes-ForegroundColor'], clWindowText);
    Editor.Highlighter.IdentifierAttributes.Bold := (appsettings.Values['editor-IdentifierAttributes-Bold'] = '1');
    Editor.Highlighter.IdentifierAttributes.Italic := (appsettings.Values['editor-IdentifierAttributes-Italic'] = '1');
    Editor.Highlighter.KeywordAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-KeywordAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.KeywordAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-KeywordAttributes-ForegroundColor'], clBlue);
    Editor.Highlighter.KeywordAttributes.Bold := (appsettings.Values['editor-KeywordAttributes-Bold'] = '1');
    Editor.Highlighter.KeywordAttributes.Italic := (appsettings.Values['editor-KeywordAttributes-Italic'] = '1');
    Editor.Highlighter.ConstantAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-ConstantAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.ConstantAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-ConstantAttributes-ForegroundColor'], clTeal);
    Editor.Highlighter.ConstantAttributes.Bold := (appsettings.Values['editor-ConstantAttributes-Bold'] = '1');
    Editor.Highlighter.ConstantAttributes.Italic := (appsettings.Values['editor-ConstantAttributes-Italic'] = '1');
    Editor.Highlighter.ClassAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-ClassAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.ClassAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-ClassAttributes-ForegroundColor'], clNavy);
    Editor.Highlighter.ClassAttributes.Bold := (appsettings.Values['editor-ClassAttributes-Bold'] = '1');
    Editor.Highlighter.ClassAttributes.Italic := (appsettings.Values['editor-ClassAttributes-Italic'] = '1');
    Editor.Highlighter.NumberAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-NumberAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.NumberAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-NumberAttributes-ForegroundColor'], clPurple);
    Editor.Highlighter.NumberAttributes.Bold := (appsettings.Values['editor-NumberAttributes-Bold'] = '1');
    Editor.Highlighter.NumberAttributes.Italic := (appsettings.Values['editor-NumberAttributes-Italic'] = '1');
    Editor.Highlighter.SymbolAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-SymbolAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.SymbolAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-SymbolAttributes-ForegroundColor'], clRed);
    Editor.Highlighter.SymbolAttributes.Bold := (appsettings.Values['editor-SymbolAttributes-Bold'] = '1');
    Editor.Highlighter.SymbolAttributes.Italic := (appsettings.Values['editor-SymbolAttributes-Italic'] = '1');
    Editor.Highlighter.StringAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-StringAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.StringAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-StringAttributes-ForegroundColor'], clMaroon);
    Editor.Highlighter.StringAttributes.Bold := (appsettings.Values['editor-StringAttributes-Bold'] = '1');
    Editor.Highlighter.StringAttributes.Italic := (appsettings.Values['editor-StringAttributes-Italic'] = '1');
    Editor.Highlighter.SpaceAttributes.BackgroundColor := StringToColorDef(appsettings.Values['editor-SpaceAttributes-BackgroundColor'], clWindow);
    Editor.Highlighter.SpaceAttributes.ForegroundColor := StringToColorDef(appsettings.Values['editor-SpaceAttributes-ForegroundColor'], clWindowText);
    Editor.Highlighter.SpaceAttributes.Bold := (appsettings.Values['editor-SpaceAttributes-Bold'] = '1');
    Editor.Highlighter.SpaceAttributes.Italic := (appsettings.Values['editor-SpaceAttributes-Italic'] = '1');
    Editor.SelectedColor := StringToColorDef(appsettings.Values['editor-SelectedColor'], clHighlight);
    Editor.SelectedTextColor :=  StringToColorDef(appsettings.Values['editor-SelectedTextColor'], clHighlightText);
    Editor.BracketMatchColor := StringToColorDef(appsettings.Values['editor-BracketMatchColor'], clYellow);
    Editor.BracketMatchTextColor := StringToColorDef(appsettings.Values['editor-BracketMatchTextColor'], clBlack);
    Editor.MouseLinkColor := StringToColorDef(appsettings.Values['editor-MouseLinkColor'], clWindow);
    Editor.MouseLinkTextColor := StringToColorDef(appsettings.Values['editor-MouseLinkTextColor'], clBlue);
    Editor.BlockIndent := StrToIntDef(appsettings.Values['editor-BlockIndent'], 4);
    Editor.BlockTabIndent := StrToIntDef(appsettings.Values['editor-BlockTabIndent'], 4);
    Editor.TabWidth := StrToIntDef(appsettings.Values['editor-TabWidth'], 4);
    Editor.ExtraCharSpacing := StrToIntDef(appsettings.Values['editor-ExtraCharSpacing'], 0);
    Editor.ExtraLineSpacing := StrToIntDef(appsettings.Values['editor-ExtraLineSpacing'], 1);
    Editor.GutterVisible := (appsettings.Values['editor-GutterVisible'] = '1');
    Editor.GutterColor := StringToColorDef(appsettings.Values['editor-GutterColor'], clWindow);
    Editor.GutterTextColor := StringToColorDef(appsettings.Values['editor-GutterTextColor'], clWindowText);
    Editor.GutterBorderColor := StringToColorDef(appsettings.Values['editor-GutterBorderColor'], $efefef);
    Editor.GutterModifiedColor := StringToColorDef(appsettings.Values['editor-GutterModifiedColor'], $00aaff);
    Editor.GutterSavedColor := StringToColorDef(appsettings.Values['editor-GutterSavedColor'], $ffaa00);
    Editor.RightEdge := StrToIntDef(appsettings.Values['editor-RightEdge'], 80);
    Editor.RightEdgeColor := StringToColorDef(appsettings.Values['editor-RightEdgeColor'], $efefef);

    Editor.HasUseMouseActions := true;
    Editor.HasAltSetsColumnMode := (appsettings.Values['editor-HasAltSetsColumnMode'] = '1');
    Editor.HasDragDropEditing := (appsettings.Values['editor-HasDragDropEditing'] = '1');
    Editor.HasRightMouseMovesCursor := (appsettings.Values['editor-HasRightMouseMovesCursor'] = '1');
    Editor.HasDoubleClickSelectsLine := (appsettings.Values['editor-HasDoubleClickSelectsLine'] = '1');
    Editor.HasShowCtrlMouseLinks := (appsettings.Values['editor-HasShowCtrlMouseLinks'] = '1');
    Editor.HasCtrlWheelZoom := (appsettings.Values['editor-HasCtrlWheelZoom'] = '1');
    Editor.ResetMouseActions;

    Editor.HasAutoIndent := (appsettings.Values['editor-HasAutoIndent'] = '1');
    Editor.HasBracketHighlight := (appsettings.Values['editor-HasBracketHighlight'] = '1');
    Editor.HasEnhanceHomeKey := (appsettings.Values['editor-HasEnhanceHomeKey'] = '1');
    Editor.HasGroupUndo := (appsettings.Values['editor-HasGroupUndo'] = '1');
    Editor.HasHalfPageScroll := (appsettings.Values['editor-HasHalfPageScroll'] = '1');
    Editor.HasHideRightMargin := (appsettings.Values['editor-HasHideRightMargin'] = '1');
    Editor.HasKeepCaretX := (appsettings.Values['editor-HasKeepCaretX'] = '1');
    Editor.HasScrollByOneLess := (appsettings.Values['editor-HasScrollByOneLess'] = '1');
    Editor.HasScrollPastEof := (appsettings.Values['editor-HasScrollPastEof'] = '1');
    Editor.HasScrollPastEol := (appsettings.Values['editor-HasScrollPastEol'] = '1');
    Editor.HasScrollHintFollows := (appsettings.Values['editor-HasScrollHintFollows'] = '1');
    Editor.HasShowScrollHint := (appsettings.Values['editor-HasShowScrollHint'] = '1');
    Editor.HasShowSpecialChars := (appsettings.Values['editor-HasShowSpecialChars'] = '1');
    Editor.HasSmartTabs := (appsettings.Values['editor-HasSmartTabs'] = '1');
    Editor.HasTabIndent := (appsettings.Values['editor-HasTabIndent'] = '1');
    Editor.HasTabsToSpaces := (appsettings.Values['editor-HasTabsToSpaces'] = '1');
    Editor.HasTrimTrailingSpaces := (appsettings.Values['editor-HasTrimTrailingSpaces'] = '1');
    Editor.HasCaretSkipsSelection := (appsettings.Values['editor-HasCaretSkipsSelection'] = '1');
    Editor.HasCaretSkipTab := (appsettings.Values['editor-HasCaretSkipTab'] = '1');
    Editor.HasAlwaysVisibleCaret := (appsettings.Values['editor-HasAlwaysVisibleCaret'] = '1');
    Editor.HasEnhanceEndKey := (appsettings.Values['editor-HasEnhanceEndKey'] = '1');
    Editor.HasPersistentBlock := (appsettings.Values['editor-HasPersistentBlock'] = '1');
    Editor.HasOverwriteBlock := (appsettings.Values['editor-HasOverwriteBlock'] = '1');
    Editor.HasAutoHideCursor := (appsettings.Values['editor-HasAutoHideCursor'] = '1');
    Editor.HasColorSelectionTillEol := (appsettings.Values['editor-HasColorSelectionTillEol'] = '1');

    if appsettings.Values['editor-HighlightWordsAtCursor'] = '1' then
    Editor.HighlightAllWordsAtCursor
        (StringToColorDef(appsettings.Values['editor-HighlightWordsAtCursor-FrameColor'], clHighlight),
         StringToColorDef(appsettings.Values['editor-HighlightWordsAtCursor-BackColor'], clNone),
         StringToColorDef(appsettings.Values['editor-HighlightWordsAtCursor-ForeColor'], clNone))
    else
    Editor.ClearAllHightlights;

    TTimer(Editor.Owner.Find('CodeCompTimer')).Enabled := false;
    TTimer(Editor.Owner.Find('CodeCompTimer')).Interval := StrToIntDef(appsettings.Values['editor-CodeCompletionTimer'], 1000);

    TTimer(Editor.Owner.Find('CodeAssistTimer')).Enabled := false;
    TTimer(Editor.Owner.Find('CodeAssistTimer')).Interval := StrToIntDef(appsettings.Values['editor-CodeAssistantTimer'], 1000);
end;

procedure doResetAppSettings();
begin
    //GENERAL
    appSettings.Values['dateformat'] := 'mmmm, dddd dd, yyyy';
    appSettings.Values['author'] := 'Your Company/Name';
    appSettings.Values['show-scrollbar'] := '1';
    appSettings.Values['show-toolbar'] := '1';
    appSettings.Values['show-designtoolbar'] := '1';
    appSettings.Values['show-statusbar'] := '1';
    appSettings.Values['show-projectpane'] := '1';
    appSettings.Values['show-toolboxpane'] := '1';
    appSettings.Values['show-objectspane'] := '1';
    appSettings.Values['show-inspectorpane'] := '1';
    appSettings.Values['props-as-keys'] := '0';
    appSettings.Values['events-as-keys'] := '0';
    appSettings.Values['methods-as-keys'] := '0';
    appSettings.Values['create-TObject-events'] := '0';
    appSettings.Values['save-oncompile'] := '1';
    appSettings.Values['show-output-onlyon-error'] := '1';
    appSettings.Values['warn-before-delete'] := '1';
    appSettings.Values['login-email'] := '';
    appSettings.Values['login-pass'] := '';
    appSettings.Values['remember-login'] := '0';


    //DESIGNER
    appSettings.Values['designer-SelectorColor'] := ColorToString(clSkyBlue);
    appSettings.Values['designer-SelectorBorderColor'] := ColorToString(clNavy);
    appSettings.Values['designer-GridColor'] := ColorToString(clNavy);
    appSettings.Values['designer-MarginColor'] := ColorToString(clNavy);
    appSettings.Values['designer-SplitColor'] := ColorToString(clNavy);
    appSettings.Values['designer-LockedColor'] := ColorToString(clRed);
    appSettings.Values['designer-PropertiesColor'] := ColorToString(clNavy);
    appSettings.Values['designer-DarkContrastColor'] := ColorToString(clCream);
    appSettings.Values['designer-HalfSpaceMarginColor'] := ColorToString(clRed);
    appSettings.Values['designer-FullSpaceMarginColor'] := ColorToString(clBlue);
    appSettings.Values['designer-GuideLineColorLeft'] := ColorToString(clBlue);
    appSettings.Values['designer-GuideLineColorTop'] := ColorToString(clBlue);
    appSettings.Values['designer-GuideLineColorRight'] := ColorToString(clBlue);
    appSettings.Values['designer-GuideLineColorBottom'] := ColorToString(clBlue);
    appSettings.Values['designer-HandleColor'] := ColorToString(clNavy);
    appSettings.Values['designer-GridSize'] := '10';
    appSettings.Values['designer-Split'] := '4';
    appSettings.Values['designer-GridXLineSize'] := '50';
    appSettings.Values['designer-GridYLineSize'] := '50';
    appSettings.Values['designer-MarginLeft'] := '20';
    appSettings.Values['designer-MarginTop'] := '20';
    appSettings.Values['designer-MarginRight'] := '20';
    appSettings.Values['designer-MarginBottom'] := '20';
    appSettings.Values['designer-HandleSize'] := '6';
    appSettings.Values['designer-AllowHalfStep'] := '1';
    appSettings.Values['designer-ApplyDarkContrastColor'] := '0';
    appSettings.Values['designer-ShowDropMarker'] := '1';
    appSettings.Values['designer-ShowGrid'] := '1';
    appSettings.Values['designer-ShowComponentHint'] := '1';
    appSettings.Values['designer-SnapToGrid'] := '1';
    appSettings.Values['designer-ShowGridLines'] := '0';
    appSettings.Values['designer-ShowMargin'] := '0';
    appSettings.Values['designer-ShowSplits'] := '0';
    appSettings.Values['designer-ShowSpaceGuide'] := '1';
    appSettings.Values['designer-ShowGuideLines'] := '1';


    //EDITOR
    //check for a good default font
    if Screen.Fonts.IndexOf('Liberation Mono') <> -1 then           //linux 1. choice
    begin
        appsettings.Values['editor-FontName'] := 'Liberation Mono';
        appsettings.Values['editor-FontSize'] := '10';
    end
    else if Screen.Fonts.IndexOf('Ubuntu Mono') <> -1 then          //linux 2. choice
    begin
        appsettings.Values['editor-FontName'] := 'Ubuntu Mono';
        appsettings.Values['editor-FontSize'] := '10';
    end
    else if Screen.Fonts.IndexOf('DejaVu Sans Mono') <> -1 then     //linux 3. choice / osx 1. choice
    begin
        appsettings.Values['editor-FontName'] := 'DejaVu Sans Mono';
        appsettings.Values['editor-FontSize'] := '10';
    end
    else if Screen.Fonts.IndexOf('Droid Sans Mono') <> -1 then      //linux 4. choice / osx 2. choice
    begin
        appsettings.Values['editor-FontName'] := 'Droid Sans Mono';
        appsettings.Values['editor-FontSize'] := '10';
    end
    else if Screen.Fonts.IndexOf('Consolas') <> -1 then             //windows 1. choice / osx 3. choice
    begin
        appsettings.Values['editor-FontName'] := 'Consolas';
        appsettings.Values['editor-FontSize'] := '10';
    end
    else if Screen.Fonts.IndexOf('Courier New') <> -1 then          //other os / fallback
    begin
        appsettings.Values['editor-FontName'] := 'Courier New';
        appsettings.Values['editor-FontSize'] := '10';
    end;

    if OSX then
    appsettings.Values['editor-FontSize'] := '12';

    //color
    appsettings.Values['editor-StopErrorForeColor'] := ColorToString(clYellow);
    appsettings.Values['editor-StopErrorBackColor'] := ColorToString(clMaroon);
    appsettings.Values['editor-StopForeColor'] := ColorToString(clWhite);
    appsettings.Values['editor-StopBackColor'] := ColorToString(clGreen);
    appsettings.Values['editor-StopBreakForeColor'] := ColorToString(clWhite);
    appsettings.Values['editor-StopBreakBackColor'] := ColorToString(clRed);
    appsettings.Values['editor-ActiveLineColor'] := ColorToString($efefef);
    appsettings.Values['editor-SelectedColor'] := ColorToString(clHighlight);
    appsettings.Values['editor-SelectedTextColor'] := ColorToString(clHighlightText);
    appsettings.Values['editor-BracketMatchColor'] := ColorToString(clYellow);
    appsettings.Values['editor-BracketMatchTextColor'] := ColorToString(clBlack);
    appsettings.Values['editor-MouseLinkColor'] := ColorToString(clWindow);
    appsettings.Values['editor-MouseLinkTextColor'] := ColorToString(clBlue);
    appsettings.Values['editor-Color'] := ColorToString(clWindow);
    appSettings.Values['editor-FontColor'] := ColorToString(clWindowText);
    appsettings.Values['editor-GutterColor'] := ColorToString(clWindow);
    appsettings.Values['editor-GutterTextColor'] := ColorToString(clWindowText);
    appsettings.Values['editor-GutterBorderColor'] := ColorToString($efefef);
    appsettings.Values['editor-GutterModifiedColor'] := ColorToString($00aaff);
    appsettings.Values['editor-GutterSavedColor'] := ColorToString($ffaa00);
    appsettings.Values['editor-RightEdgeColor'] := ColorToString($efefef);

    //key color
    appsettings.Values['editor-CommentAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-CommentAttributes-ForegroundColor'] := ColorToString(clGray);
    appsettings.Values['editor-CommentAttributes-Bold'] := '0';
    appsettings.Values['editor-CommentAttributes-Italic'] := '1';
    appsettings.Values['editor-IdentifierAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-IdentifierAttributes-ForegroundColor'] := ColorToString(clWindowText);
    appsettings.Values['editor-IdentifierAttributes-Bold'] := '0';
    appsettings.Values['editor-IdentifierAttributes-Italic'] := '0';
    appsettings.Values['editor-KeywordAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-KeywordAttributes-ForegroundColor'] := ColorToString(clBlue);
    appsettings.Values['editor-KeywordAttributes-Bold'] := '1';
    appsettings.Values['editor-KeywordAttributes-Italic'] := '0';
    appsettings.Values['editor-ConstantAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-ConstantAttributes-ForegroundColor'] := ColorToString(clTeal);
    appsettings.Values['editor-ConstantAttributes-Bold'] := '1';
    appsettings.Values['editor-ConstantAttributes-Italic'] := '0';
    appsettings.Values['editor-ClassAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-ClassAttributes-ForegroundColor'] := ColorToString(clNavy);
    appsettings.Values['editor-ClassAttributes-Bold'] := '1';
    appsettings.Values['editor-ClassAttributes-Italic'] := '0';
    appsettings.Values['editor-NumberAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-NumberAttributes-ForegroundColor'] := ColorToString(clPurple);
    appsettings.Values['editor-NumberAttributes-Bold'] := '0';
    appsettings.Values['editor-NumberAttributes-Italic'] := '0';
    appsettings.Values['editor-SymbolAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-SymbolAttributes-ForegroundColor'] := ColorToString(clRed);
    appsettings.Values['editor-SymbolAttributes-Bold'] := '0';
    appsettings.Values['editor-SymbolAttributes-Italic'] := '0';
    appsettings.Values['editor-StringAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-StringAttributes-ForegroundColor'] := ColorToString(clMaroon);
    appsettings.Values['editor-StringAttributes-Bold'] := '0';
    appsettings.Values['editor-StringAttributes-Italic'] := '0';
    appsettings.Values['editor-SpaceAttributes-BackgroundColor'] := ColorToString(clWindow);
    appsettings.Values['editor-SpaceAttributes-ForegroundColor'] := ColorToString(clWindowText);
    appsettings.Values['editor-SpaceAttributes-Bold'] := '0';
    appsettings.Values['editor-SpaceAttributes-Italic'] := '0';

    //Highlighter
    appsettings.Values['editor-HighlightWordsAtCursor'] := '1';
    appsettings.Values['editor-HighlightWordsAtCursor-FrameColor'] := ColorToString(clHighlight);
    appsettings.Values['editor-HighlightWordsAtCursor-BackColor'] := ColorToString(clNone);
    appsettings.Values['editor-HighlightWordsAtCursor-ForeColor'] := ColorToString(clNone);

    //bool
    appSettings.Values['autocompletion'] := '1';
    appSettings.Values['autoassistant'] := '1';
    appsettings.Values['editor-GutterVisible'] := '1';
    appsettings.Values['editor-HasAutoIndent'] := '1';
    appsettings.Values['editor-HasBracketHighlight'] := '1';
    appsettings.Values['editor-HasEnhanceHomeKey'] := '1';
    appsettings.Values['editor-HasGroupUndo'] := '0';
    appsettings.Values['editor-HasHalfPageScroll'] := '0';
    appsettings.Values['editor-HasHideRightMargin'] := '0';
    appsettings.Values['editor-HasKeepCaretX'] := '1';
    appsettings.Values['editor-HasScrollByOneLess'] := '0';
    appsettings.Values['editor-HasScrollPastEof'] := '1';
    appsettings.Values['editor-HasScrollPastEol'] := '1';
    appsettings.Values['editor-HasScrollHintFollows'] := '0';
    appsettings.Values['editor-HasShowScrollHint'] := '0';
    appsettings.Values['editor-HasShowSpecialChars'] := '0';
    appsettings.Values['editor-HasSmartTabs'] := '0';
    appsettings.Values['editor-HasTabIndent'] := '1';
    appsettings.Values['editor-HasTabsToSpaces'] := '1';
    appsettings.Values['editor-HasTrimTrailingSpaces'] := '1';
    appsettings.Values['editor-HasCaretSkipsSelection'] := '0';
    appsettings.Values['editor-HasCaretSkipTab'] := '0';
    appsettings.Values['editor-HasAlwaysVisibleCaret'] := '0';
    appsettings.Values['editor-HasEnhanceEndKey'] := '1';
    appsettings.Values['editor-HasPersistentBlock'] := '0';
    appsettings.Values['editor-HasOverwriteBlock'] := '1';
    appsettings.Values['editor-HasAutoHideCursor'] := '0';
    appsettings.Values['editor-HasColorSelectionTillEol'] := '0';
    appsettings.Values['editor-HasUseMouseActions'] := '0';
    appsettings.Values['editor-HasAltSetsColumnMode'] := '0';
    appsettings.Values['editor-HasDragDropEditing'] := '0';
    appsettings.Values['editor-HasRightMouseMovesCursor'] := '1';
    appsettings.Values['editor-HasDoubleClickSelectsLine'] := '0';
    appsettings.Values['editor-HasShowCtrlMouseLinks'] := '1';
    appsettings.Values['editor-HasCtrlWheelZoom'] := '1';
    appSettings.Values['editor-autoclose-brackets'] := '1';

    //int
    appsettings.Values['editor-RightEdge'] := '80';
    appsettings.Values['editor-TabWidth'] := '4';
    appSettings.Values['autocompletion-chars'] := '4';
    appsettings.Values['editor-BlockIndent'] := '4';
    appsettings.Values['editor-BlockTabIndent'] := '0';
    appsettings.Values['editor-ExtraCharSpacing'] := '0';
    appsettings.Values['editor-ExtraLineSpacing'] := '0';

    appsettings.Values['editor-CodeCompletionTimer'] := '50';
    appsettings.Values['editor-CodeAssistantTimer'] := '50';

    //other
    appSettings.Values['autocompletion-shortcut'] := 'Ctrl+Space';
    appSettings.Values['codetemplate-shortcut'] := 'Shift+Space';

    doSaveAppSettings;
end;

////////////////////////////////////////////////////////////////////////

//unit constructor
constructor
begin
    //adjust ModalDimmed Rect
    if IsWindowsXP then
    begin
        AdjustDimOffsetLeft(-9);
        AdjustDimOffsetWidth(9);
    end;
    if IsWindowsVista or IsWindows7 then
    begin
        AdjustDimOffsetLeft(-8);
        AdjustDimOffsetWidth(16);
        AdjustDimOffsetHeight(8);
    end;
    if Linux then
    begin
        AdjustDimOffsetLeft(-1);
        AdjustDimOffsetTop(-1);
        AdjustDimOffsetWidth(4);
        AdjustDimOffsetHeight(2);
    end;

    DesClip := TStringList.Create;
    ActiveProject := TStringList.Create;

    //tbXML := TXML.Create;
    //tbXML.LoadFromResource('tbxml');
    //tbLIST := TStringList.Create;
    //tbLIST.LoadFromResource('tbxml');

    libCLI := TStringList.Create;
    libCLI.LoadFromResource('libcli');
    libCGI := TStringList.Create;
    libCGI.LoadFromResource('libcgi');
    libFCGI := TStringList.Create;
    libFCGI.LoadFromResource('libfcgi');
    libSERVER := TStringList.Create;
    libSERVER.LoadFromResource('libserver');
    libUIStd := TStringList.Create;
    libUIStd.LoadFromResource('libuice');
    libUIAdv := TStringList.Create;
    libUIAdv.LoadFromResource('libui');
    libUIAnd := TStringList.Create;
    libUIAnd.LoadFromResource('libuiand');

    libClassList := TStringList.Create;
    libClassList.Duplicates := dupIgnore;
    libMethodList := TStringList.Create;
    libMethodList.Duplicates := dupIgnore;

    _Breakpoints := TStringList.Create;
    _Breakpoints.Duplicates := dupIgnore;

    pasCodeTemplates := TStringList.Create;
    cppCodeTemplates := TStringList.Create;
    jsCodeTemplates := TStringList.Create;
    vbCodeTemplates := TStringList.Create;

    finderFindMRU := TStringList.Create;
    finderReplaceMRU := TStringList.Create;

    //Create Default Location
    DefaultProjectLocation := UserDir+_APP_NAME+DirSep+'Projects'+DirSep;
    ForceDir(UserDir+_APP_NAME+DirSep+'Projects');
    ForceDir(UserDir+_APP_NAME+DirSep+'Settings');

    appSettings := TStringList.Create;
    if FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'developer.settings') then
        appSettings.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'developer.settings');

    if not FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas') then
    begin
        pasCodeTemplates.LoadFromResource('pas_template');
        pasCodeTemplates.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas');
    end
        else
        pasCodeTemplates.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.pas');

    if not FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp') then
    begin
        cppCodeTemplates.LoadFromResource('cpp_template');
        cppCodeTemplates.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp');
    end
        else
        cppCodeTemplates.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.cpp');

    if not FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js') then
    begin
        jsCodeTemplates.LoadFromResource('js_template');
        jsCodeTemplates.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js');
    end
        else
        jsCodeTemplates.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.js');

    if not FileExists(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb') then
    begin
        vbCodeTemplates.LoadFromResource('vb_template');
        vbCodeTemplates.SaveToFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb');
    end
        else
        vbCodeTemplates.LoadFromFile(UserDir+_APP_NAME+DirSep+'Settings'+DirSep+'code-template.vb');


    //setup proxy - this will also be forwared to the compiler
    clearProxy;
    setProxyHost(appsettings.Values['proxy-host']);
    setProxyPort(appsettings.Values['proxy-port']);
    setProxyUser(appsettings.Values['proxy-user']);
    setProxyPass(appsettings.Values['proxy-pass']);

    deletefile(TempDir+'lamsg.que');

    //Setup Default App Settings
    if trim(appSettings.Text) = '' then
        doResetAppSettings;

    appsettings.Values['editor-CodeCompletionTimer'] := '50';
    appsettings.Values['editor-CodeAssistantTimer'] := '50';

end.
