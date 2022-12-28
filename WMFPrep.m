function varargout = WMFPrep(varargin)
%-----------------------------------------------------------
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  <a href="jiaweisun0512@163.com">Sun Jia-Wei</a>; 


gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @WMFPrep_OpeningFcn, ...
                   'gui_OutputFcn',  @WMFPrep_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
   gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function WMFPrep_OpeningFcn(hObject, eventdata, handles, varargin)
disp('Thanks a lot for your email to Li jiao (jiaoli@uestc.edu.cn) or Sun Jia-Wei (jiaweisun0512@163.com) for any suggestion.');
disp('Citing Information:');
disp('If you think WMFPrep is useful for your work, citing it in your paper would be greatly appreciated!')
disp('References: ');
disp('1. Jiao Li, et al., Human Brain Mapping, 2019, 40(15): 4331-4344.');
disp('2. Jiao Li, et al., Translational Psychiatry, 2020, 10(1): 365.');
disp('3. Jiao Li, et al., Translational Psychiatry, 2020, 10(1): 147.');
disp('4. Gong-Jun Ji, et al., Science Bulletin, 2017, 62(9): 656-657.');
handles.output = hObject;
handles = WMA_InitAllParameter(handles);
handles = WMA_LoadPara(handles);
ReMoveAllPanel(handles);
set(handles.panel_parameter,'Visible','on');
guidata(hObject, handles);

function varargout = WMFPrep_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


%%  worksapce fun t1 
function pbtn_workspace_Callback(hObject, eventdata, handles)
WorkPath = uigetdir(pwd);
if exist(num2str(WorkPath),'dir')
    set(handles.edit_workspace,'string',WorkPath);
    cd(WorkPath);
    handles.para.WorkPath = WorkPath;
else
    set(handles.edit_workspace,'string',pwd);
    handles.para.WorkPath = pwd;  
end
guidata(hObject, handles);
function edit_workspace_Callback(hObject, eventdata, handles)
WorkPath = get(hObject,'String');
if exist(num2str(WorkPath),'dir')
    handles.para.WorkPath = WorkPath;
else
    error([WorkPath ' don''t exist']);
end
guidata(hObject, handles);
function edit_workspace_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_fundir_Callback(hObject, eventdata, handles)
fun_Object = handles.edit_fundir;
if (get(hObject,'Value')==get(fun_Object,'Max'))
    set(fun_Object,'Enable','on')
elseif (get(hObject,'Value')==get(fun_Object,'Min'))
    set(fun_Object,'Enable','off')
end
function edit_fundir_Callback(hObject, eventdata, handles)
if ~isempty(get(hObject,'String'))
    ReMoveAllPanel(handles);
    set(handles.panel_sublist,'Visible','on');
end
ListObject = handles.list_sub_list;
FunName = get(hObject,'String');
WorkPath = handles.para.WorkPath;
FunPath = [WorkPath filesep FunName];
handles.para.EPIName = FunName;
if exist(FunPath,'dir')
    Sub = dir(FunPath);
    if length(Sub) == 2
        set(ListObject,'String','EPIPath Have none SubFolder');  
    else
        SubName = dir_NameList(FunPath);
        set(ListObject,'String',SubName); 
    end    
else
    set(ListObject,'String','Don''t have this EPIPath'); 
end
guidata(hObject, handles);
function edit_fundir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_t1dir_Callback(hObject, eventdata, handles)
T1Object = handles.edit_t1dir;
if (get(hObject,'Value')==get(T1Object,'Max'))
    set(T1Object,'Enable','on')
elseif (get(hObject,'Value')==get(T1Object,'Min'))
    set(T1Object,'Enable','off')
end
function edit_t1dir_Callback(hObject, eventdata, handles)
if ~isempty(get(hObject,'String'))
    ReMoveAllPanel(handles);
    set(handles.panel_sublist,'Visible','on');
end
ListObject = handles.list_sub_list;
T1Name = get(hObject,'String');
WorkPath = handles.para.WorkPath;
T1Path = [WorkPath filesep T1Name];
handles.para.T1Name = T1Name;
if exist(T1Path,'dir')
    Sub = dir(T1Path);
    if length(Sub) == 2
        set(ListObject,'String','T1Path Have none SubFolder');  
    else
        SubName = dir_NameList(T1Path);
        set(ListObject,'String',SubName); 
    end    
else
    set(ListObject,'String','Don''t have this T1Path'); 
end
guidata(hObject, handles);
function edit_t1dir_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_TR_Callback(hObject, eventdata, handles)
handles.para.TR = str2num(get(hObject,'String'));
guidata(hObject, handles);
function edit_TR_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function list_sub_list_Callback(hObject, eventdata, handles)
function list_sub_list_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% d2n 
function cebx_d2n_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_d2n;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.D2N.IsD2N = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.D2N.IsD2N = 0;
end
guidata(hObject, handles);

function txt_d2n_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_d2n;
set(panel_Object,'Visible','on');

function cebx_d2n_fun_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.D2N.EPI = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.D2N.EPI = 0;
end
guidata(hObject, handles);

function cebx_d2n_t1_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.D2N.T1 = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.D2N.T1 = 0;
end
guidata(hObject, handles);

%% Remove first n time points 
function cebx_RemoveTimes_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_removetimes;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.RemoveTimes.IsRemoveTime = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.RemoveTimes.IsRemoveTime = 0;
end
guidata(hObject, handles);

function txt_RemoveTimes_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_removetimes;
set(panel_Object,'Visible','on');

function edit_RemoveTimes_n_Callback(hObject, eventdata, handles)
handles.para.RemoveTimes.Time = str2num(get(hObject,'String'));
guidata(hObject, handles);

function edit_RemoveTimes_n_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Slice Timing
function cebx_SliceTiming_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_slicetiming;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Slice.IsSlice = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Slice.IsSlice = 0;
end
guidata(hObject, handles);

function txt_SliceTiming_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_slicetiming;
set(panel_Object,'Visible','on');

function edit_Slice_num_Callback(hObject, eventdata, handles)
handles.para.Slice.SliceNumber = str2num(get(hObject,'String'));
guidata(hObject, handles);
function edit_Slice_num_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Slice_order_Callback(hObject, eventdata, handles)
OrderStr =num2str(str2num(get(hObject,'String')));
set(hObject,'String',OrderStr);
handles.para.Slice.SliceOrder = str2num(OrderStr);
guidata(hObject, handles);
function edit_Slice_order_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_Slice_reference_Callback(hObject, eventdata, handles)
handles.para.Slice.SliceRefer = str2num(get(hObject,'String'));
guidata(hObject, handles);
function edit_Slice_reference_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Realign
function cebx_Realign_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_realign;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Realign.IsRealign = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Realign.IsRealign = 0;
end
guidata(hObject, handles);

function txt_Realign_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_realign;
set(panel_Object,'Visible','on');

%% T1 preprocess

function cebx_T1Preprocess_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_T1Preprocess;
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.IsT1Preprocess = 1;
    set(panel_Object,'Visible','on');
else
    handles.para.IsT1Preprocess = 0;
    set(handles.panel_parameter,'Visible','on');
end
guidata(hObject, handles);

function txt_T1Preprocess_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_T1Preprocess;
set(panel_Object,'Visible','on');

% Reorient
function cebx_Reorient_T1img_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Reorient.isT1ImgReorient = 1;
else
    handles.para.Reorient.isT1ImgReorient = 0;
end
guidata(hObject, handles);

% Bet
function cebx_Bet_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Bet.IsBet = 1;
else
    handles.para.Bet.IsBet = 0;
end
guidata(hObject, handles);

% Coregister
function cebx_Coregister_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Coregister.IsrCoregister = 1;
else
    handles.para.Coregister.IsrCoregister = 0;
end
guidata(hObject, handles);

% New Segment
function cebx_NewSegment_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.NewSeg.IsNewSeg = 1;
else
    handles.para.NewSeg.IsNewSeg = 0;
end
guidata(hObject, handles);

function rbtn_NewSeg_people_EA_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(handles.rbtn_NewSeg_people_EU,'Value',0);
    handles.para.NewSeg.AffineRegularisation = 'eastern';
end
guidata(hObject, handles);

function rbtn_NewSeg_people_EU_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(handles.rbtn_NewSeg_people_EA,'Value',0);
    handles.para.NewSeg.AffineRegularisation = 'mni';
end
guidata(hObject, handles);

%% Apply white mask to EPI
function cebx_FunWM_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_FunWM;
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.FunWM.IsFunWM = 1;
    set(panel_Object,'Visible','on');
else
    handles.para.FunWM.IsFunWM = 0;
    set(handles.panel_parameter,'Visible','on');
end
guidata(hObject, handles);

function txt_FunWM_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_FunWM;
set(panel_Object,'Visible','on'); 

function edit_FunWM_wmthreshold_Callback(hObject, eventdata, handles)
handles.para.FunWM.mask_p_thrsd = get(hObject,'String');
handles.para.GWM.WMthrsd_idvd = get(hObject,'String');
guidata(hObject, handles);

function edit_FunWM_wmthreshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Nomalize 
function cebx_Normalize_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_normalize;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Normalize.IsNormal = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Normalize.IsNormal = 0;
end
guidata(hObject, handles)

function txt_Normalize_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_normalize;
set(panel_Object,'Visible','on');

function edit_nmlz_box_Callback(hObject, eventdata, handles)
handles.para.Normalize.BoundingBox = num2str(get(hObject,'String'));
guidata(hObject, handles);

function edit_nmlz_box_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function edit_nmlz_voxelsize_Callback(hObject, eventdata, handles)
handles.para.Normalize.VoxSize = num2str(get(hObject,'String'));
guidata(hObject, handles);

function edit_nmlz_voxelsize_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function rbtn_nmlz_dartel_newseg_WM_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Normalize.Method = 'nmlz_dartel';
end
guidata(hObject, handles);

function rbtn_nmlz_people_EA_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(handles.rbtn_nmlz_people_EU,'Value',0);
    handles.para.Normalize.AffineRegularisation = 'eastern';
end
guidata(hObject, handles);

function rbtn_nmlz_people_EU_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    set(handles.rbtn_nmlz_people_EA,'Value',0);
    handles.para.Normalize.AffineRegularisation = 'mni';
end
guidata(hObject, handles);


%%  GWM
function cebx_GWM_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_gwm;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.GWM.IsGWM  = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(handles.panel_parameter,'Visible','on');
    handles.para.GWM.IsGWM  = 0;
end
guidata(hObject, handles);
function txt_GWM_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_gwm;
set(panel_Object,'Visible','on');
function edit_GWM_group_threshold_Callback(hObject, eventdata, handles)
handles.para.GWM.WMthrsd_gp = num2str(get(hObject,'String'));
guidata(hObject, handles);
function edit_GWM_group_threshold_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_GWM_RemoveRegion_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.GWM.ISRemoveRegion = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.GWM.ISRemoveRegion = 0;
end
guidata(hObject, handles);  
function pbtn_GWM_RemoveRegion_Callback(hObject, eventdata, handles)
[remove_mask_nam,remove_mask_pth] = uigetfile({'*.nii';'*.img'},pwd);
remove_mask_file = [remove_mask_pth remove_mask_nam];
if remove_mask_pth ~= 0
    set(handles.edit_GWM_RemoveRegion,'String',remove_mask_file);
end
handles.para.GWM.RemoveRegion = remove_mask_file;
guidata(hObject, handles);
function edit_GWM_RemoveRegion_Callback(hObject, eventdata, handles)
remove_mask_pth = get(hObject,'String');
if exist(num2str(remove_mask_pth),'dir')
    handles.para.GWM.RemoveRegion = remove_mask_pth;
else
    error([remove_mask_pth ' don''t exist']);
end
guidata(hObject, handles);
function edit_GWM_RemoveRegion_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_GWM_UP_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.GWM.method{1,1} = 'uniform_parcellate';
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.GWM.method{1,1} = '';
end
guidata(hObject, handles);  
function edit_GWM_UP_knum_Callback(hObject, eventdata, handles)
handles.para.GWM.up.Knum = num2str(get(hObject,'String'));
guidata(hObject, handles);
function edit_GWM_UP_knum_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_GWM_tmplt_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.GWM.method{1,2} = 'template';
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.GWM.method{1,2} = '';
end
guidata(hObject, handles);  
function psbtn_GWM_tmplt_Callback(hObject, eventdata, handles)
[tmplt_nam,tmplt_pth] = uigetfile({'*.nii';'*.img'},pwd);
tmplt_file = [tmplt_pth tmplt_nam];
if tmplt_pth ~= 0
    set(handles.edit_GWM_tmplt,'String',tmplt_file);
end
handles.para.GWM.tmplt.InDirTemplate = tmplt_file;
guidata(hObject, handles);
function edit_GWM_tmplt_Callback(hObject, eventdata, handles)
tmplt_pth = get(hObject,'String');
if exist(num2str(tmplt_pth),'dir')
    handles.para.GWM.tmplt.InDirTemplate = tmplt_pth;
else
    error([tmplt_pth ' don''t exist']);
end
guidata(hObject, handles);
function edit_GWM_tmplt_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%% Smooth
function cebx_Smooth_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_smooth;

if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Smooth.IsSmooth = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Smooth.IsSmooth = 0;
end
guidata(hObject, handles)
function txt_Smooth_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_smooth;
set(panel_Object,'Visible','on');

function edit_Smooth_FWHM_Callback(hObject, eventdata, handles)
handles.para.Smooth.FWHM = get(hObject,'String');
guidata(hObject, handles);
function edit_Smooth_FWHM_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%% Detrend
function cebx_Detrend_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_detrend;

if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Detrend.IsDetrend = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Detrend.IsDetrend = 0;
end
guidata(hObject, handles)
function txt_Detrend_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_detrend;
set(panel_Object,'Visible','on');

%% Covariates
function cebx_Cov_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_cov;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Cov_seg.IsCov = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Cov_seg.IsCov = 0;
end
guidata(hObject, handles)
function txt_Cov_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_cov;
set(panel_Object,'Visible','on');

function edit_Cov_Polynomialtrend_Callback(hObject, eventdata, handles)
tag = get(hObject,'String');
if num2str(tag)~=0
    handles.para.Cov_seg.IsCovDetrend = 1;
else
    handles.para.Cov_seg.IsCovDetrend = 0;

end
guidata(hObject, handles);
function edit_Cov_Polynomialtrend_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_Cov_Friston24_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsCovFriston24 = 1;
    disp('Reference: Friston KJ, Williams S, Howard R, Frackowiak RSJ, Turner R. Movement-Related effects in fMRI timeseries.Magn Reson Med. 1996; 35: 346¨C355.');
else
    handles.para.Cov_seg.IsCovFriston24 = 0;
end
guidata(hObject, handles);

function cebx_Cov_GM_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsCovGM = 1;
else
    handles.para.Cov_seg.IsCovGM = 0;
end
guidata(hObject, handles);

function edit_Cov_GMMaskThrsd_Callback(hObject, eventdata, handles)
handles.para.Cov_seg.GM_pthrsd = get(hObject,'String');
guidata(hObject, handles);

function edit_Cov_GMMaskThrsd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cebx_Cov_csf_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsCovCSF = 1;
else
    handles.para.Cov_seg.IsCovCSF = 0;
end
guidata(hObject, handles);
function edit_Cov_CsfMaskThrsd_Callback(hObject, eventdata, handles)
handles.para.Cov_seg.CSF_pthrsd = get(hObject,'String');
guidata(hObject, handles);
function edit_Cov_CsfMaskThrsd_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function cebx_Cov_global_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsCovGlobal = 1;
else
    handles.para.Cov_seg.IsCovGlobal = 0;
end
guidata(hObject, handles);

function cebx_Cov_addmean_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsAddMeanBack = 1;
else
    handles.para.Cov_seg.IsAddMeanBack = 0;
end
guidata(hObject, handles);

function cebx_Cov_other_Callback(hObject, eventdata, handles)
if (get(hObject,'Value')==get(hObject,'Max'))
    handles.para.Cov_seg.IsCovOther = 1;
    if isempty(get(handles.list_Cov_other,'String'))
        handles.para.Cov_seg.CovOtherROI = rp_ROIList_gui({});
        set(handles.list_Cov_other,'String',handles.para.Cov_seg.CovOtherROI);
    else
        handles.para.Cov_seg.CovOtherROI = rp_ROIList_gui(get(handles.list_Cov_other,'String'));
        set(handles.list_Cov_other,'String',handles.para.Cov_seg.CovOtherROI);
    end
elseif (get(hObject,'Value')==get(hObject,'Min'))
    handles.para.Cov_seg.IsCovOther = 0;
    handles.Cov_seg.CovOtherROI = {''};
    set(handles.list_Cov_other,'String','');
end
guidata(hObject, handles);

function list_Cov_other_Callback(hObject, eventdata, handles)

function list_Cov_other_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



%% Filter
function cebx_Filter_Callback(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_filter;
if (get(hObject,'Value')==get(hObject,'Max'))
    set(panel_Object,'Visible','on');
    handles.para.Filter.IsFilter = 1;
elseif (get(hObject,'Value')==get(hObject,'Min'))
    set(panel_Object,'Visible','off');
    set(handles.panel_parameter,'Visible','on');
    handles.para.Filter.IsFilter = 0;
end
guidata(hObject, handles)
function txt_Filter_ButtonDownFcn(hObject, eventdata, handles)
ReMoveAllPanel(handles);
panel_Object = handles.panel_filter;
set(panel_Object,'Visible','on');
function edit_Filter_lowcut_Callback(hObject, eventdata, handles)
handles.para.Filter.LowCut_HighPass= num2str(get(hObject,'String'));
guidata(hObject, handles);
function edit_Filter_lowcut_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit_Filter_highcut_Callback(hObject, eventdata, handles)
handles.para.Filter.LowPass_HighCut = num2str(get(hObject,'String'));
guidata(hObject, handles);
function edit_Filter_highcut_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function ReMoveAllPanel(handles)
set(handles.panel_parameter,'Visible','off');
set(handles.panel_cov,'Visible','off');
set(handles.panel_smooth,'Visible','off');
set(handles.panel_realign,'Visible','off');
set(handles.panel_removetimes,'Visible','off');
set(handles.panel_d2n,'Visible','off');
set(handles.panel_normalize,'Visible','off');
set(handles.panel_slicetiming,'Visible','off');
set(handles.panel_sublist,'Visible','off');
set(handles.panel_filter,'Visible','off');
set(handles.panel_gwm,'Visible','off');
set(handles.panel_detrend,'Visible','off');
set(handles.panel_T1Preprocess,'Visible','off');
set(handles.panel_FunWM,'Visible','off');


function psbtn_Load_Callback(hObject, eventdata, handles)
[para_nam,para_pth] = uigetfile({'*.mat;'});
handles = WMA_LoadPara(handles,[para_pth para_nam]);
guidata(hObject, handles);


function pabtn_Save_Callback(hObject, eventdata, handles)
para = handles.para;
date = GetDate();
[SetSaveName, SetSavePath]= uiputfile({'*.mat'},[para.WorkPath filesep 'WMFPrep_ParamaterAutoSave_' date '.mat']);
if ~isempty(SetSaveName)
    save([SetSavePath filesep SetSaveName],'para');
end

function psbtn_Run_Callback(hObject, eventdata, handles)
set(hObject,'enable','off');
set(hObject,'BackgroundColor','Red');   
para = handles.para;
date = GetDate();
save([para.WorkPath filesep 'WMFPrep_ParamaterAutoSave_' date '.mat'],'para');
[Operation,InputParameter] = wma_para(para);
wma_batch(Operation,InputParameter);
set(hObject,'enable','on');
set(hObject,'BackgroundColor',[0.941176470588235,0.941176470588235,0.941176470588235]);



function edit_Parallel_Callback(hObject, eventdata, handles)
num = str2num(get(hObject,'String'));
if num == 0
    delete(gcp('nocreate'));
elseif num > 0
    if isempty(gcp('nocreate'))
        set_matlabpool(num);
    end
end
function edit_Parallel_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function set_matlabpool(Size_MatlabPool)
    PCTVer = ver('distcomp');
    if ~isempty(PCTVer)
        FullMatlabVersion = sscanf(version,'%d.%d.%d.%d%s');
        if FullMatlabVersion(1)*1000+FullMatlabVersion(2)<8*1000+3 
                    parpool(Size_MatlabPool)
        
        else
                    parpool(Size_MatlabPool)
                
        end  
    end
    
function date = GetDate()
    time = fix(clock);
    year = num2str(time(1));
    month = num2str(time(2),'%02d');
    day = num2str(time(3),'%02d');
    hour = num2str(time(4),'%02d');
    minute= num2str(time(5),'%02d');
    second = num2str(time(6),'%02d');
    date = [year '_' month '_' day '_' hour '_' minute '_' second];
