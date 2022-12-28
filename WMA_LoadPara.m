function handles = WMA_LoadPara(handles,mat_indr)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
if nargin<2
    mat_indr = '';
end
if isempty(mat_indr)
    para = handles.para;
else
    para = fun_load(mat_indr);
end
set(handles.edit_workspace,'String',para.WorkPath);
if ~isempty(para.EPIName)
    set(handles.cebx_fundir,'Value',1);
    set(handles.edit_fundir,'String',para.EPIName);
    set(handles.edit_fundir,'enable','on');
end
if ~isempty(para.T1Name)
    set(handles.cebx_t1dir,'Value',1);
    set(handles.edit_t1dir,'String',para.T1Name);
    set(handles.edit_t1dir,'enable','on');
end
set(handles.edit_TR,'String',para.TR);

set(handles.cebx_d2n,'Value',para.D2N.IsD2N);
set(handles.cebx_d2n_fun,'Value',para.D2N.EPI);
set(handles.cebx_d2n_t1,'Value',para.D2N.T1);

set(handles.cebx_RemoveTimes,'Value',para.RemoveTimes.IsRemoveTime);
set(handles.edit_RemoveTimes_n,'String',para.RemoveTimes.Time);

set(handles.cebx_SliceTiming,'Value',para.Slice.IsSlice);
set(handles.edit_Slice_reference,'String',para.Slice.SliceRefer);
set(handles.edit_Slice_order,'String',fun_str(para.Slice.SliceOrder));
set(handles.edit_Slice_num,'String',para.Slice.SliceNumber);

set(handles.cebx_Realign,'Value',para.Realign.IsRealign);

set(handles.cebx_T1Preprocess,'Value',para.IsT1Preprocess);
set(handles.cebx_Reorient_T1img,'Value',para.Reorient.isT1ImgReorient);
set(handles.cebx_Bet,'Value',para.Bet.IsBet);
set(handles.cebx_Coregister,'Value',para.Coregister.IsrCoregister);
set(handles.cebx_NewSegment,'Value',para.NewSeg.IsNewSeg);
switch(para.NewSeg.AffineRegularisation)
    case 'mni'
        set(handles.rbtn_NewSeg_people_EU,'Value',1);
        set(handles.rbtn_NewSeg_people_EA,'Value',0);
    case 'eastern'
        set(handles.rbtn_NewSeg_people_EU,'Value',0);
        set(handles.rbtn_NewSeg_people_EA,'Value',1);
end

set(handles.cebx_FunWM,'Value',para.FunWM.IsFunWM);
set(handles.edit_FunWM_wmthreshold,'String',para.FunWM.mask_p_thrsd);

set(handles.cebx_Normalize,'Value',para.Normalize.IsNormal);
set(handles.edit_nmlz_box,'String',fun_str(para.Normalize.BoundingBox));
set(handles.edit_nmlz_voxelsize,'String',fun_str(para.Normalize.VoxSize));
switch para.Normalize.Method
    case 'nmlz_dartel'
        set(handles.rbtn_nmlz_dartel_newseg_WM,'Value',1);
        set(handles.rbtn_nmlz_people_EA,'Visible','on');
        set(handles.rbtn_nmlz_people_EU,'Visible','on');
        switch(para.Normalize.AffineRegularisation)
            case 'mni'
                set(handles.rbtn_nmlz_people_EU,'Value',1);
                set(handles.rbtn_nmlz_people_EA,'Value',0);
            case 'eastern'
                set(handles.rbtn_nmlz_people_EU,'Value',0);
                set(handles.rbtn_nmlz_people_EA,'Value',1);
        end
end

set(handles.cebx_GWM,'Value',para.GWM.IsGWM);
set(handles.edit_GWM_group_threshold,'String',para.GWM.WMthrsd_gp);
set(handles.cebx_GWM_RemoveRegion,'Value',para.GWM.ISRemoveRegion);
set(handles.edit_GWM_RemoveRegion,'String',para.GWM.RemoveRegion);
if fun_ismember(para.GWM.method,'uniform_parcellate','strcmp')
    set(handles.cebx_GWM_UP,'Value',1);
end
set(handles.edit_GWM_UP_knum,'String',para.GWM.up.Knum);

if fun_ismember(para.GWM.method,'template','strcmp')
    set(handles.cebx_GWM_tmplt,'Value',1);
end
set(handles.edit_GWM_tmplt,'String',para.GWM.tmplt.InDirTemplate);

set(handles.cebx_Smooth,'Value',para.Smooth.IsSmooth);
set(handles.edit_Smooth_FWHM,'String',fun_str(para.Smooth.FWHM));

set(handles.cebx_Detrend,'Value',para.Detrend.IsDetrend);

set(handles.cebx_Cov,'Value',para.Cov_seg.IsCov);
set(handles.edit_Cov_Polynomialtrend,'String',para.Cov_seg.IsCovDetrend);

set(handles.cebx_Cov_Friston24,'Value',para.Cov_seg.IsCovFriston24);
set(handles.cebx_Cov_global,'Value',para.Cov_seg.IsCovGlobal);
set(handles.cebx_Cov_GM,'Value',para.Cov_seg.IsCovGM);
set(handles.edit_Cov_GMMaskThrsd,'String',para.Cov_seg.GM_pthrsd);
set(handles.cebx_Cov_csf,'Value',para.Cov_seg.IsCovCSF);
set(handles.edit_Cov_CsfMaskThrsd,'String',para.Cov_seg.CSF_pthrsd);
set(handles.cebx_Cov_addmean,'Value',para.Cov_seg.IsAddMeanBack);
set(handles.cebx_Cov_other,'Value',para.Cov_seg.IsCovOther);
set(handles.list_Cov_other,'String',para.Cov_seg.CovOtherROI);

set(handles.cebx_Filter,'Value',para.Filter.IsFilter);
set(handles.edit_Filter_lowcut,'String',para.Filter.LowCut_HighPass);
set(handles.edit_Filter_highcut,'String',para.Filter.LowPass_HighCut);
handles = rmfield(handles,'para');
handles.para = para;
end


