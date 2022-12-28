function [Operation,InputParameter] = wma_para(para)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
workspace = para.WorkPath;
FunImg = [workspace filesep para.EPIName];
T1Img = [workspace filesep para.T1Name];
FunImg_tmp = FunImg;
T1Img_tmp = T1Img;
Operation = {};
if para.D2N.IsD2N == 1
    if ~isempty(para.EPIName)
        para.D2N.EPI = 1;
    else
        para.D2N.EPI = 0;
    end
    if ~isempty(para.T1Name)
        para.D2N.T1 = 1;
    else
        para.D2N.T1 = 0;
    end
    if para.D2N.EPI == 1
        Operation = [Operation;{'EPIDICOMTONIFTI'}];
        InputParameter.EpiDicomToNifti.InDirFunRaw = FunImg_tmp;
        FunImg_tmp = [FunImg_tmp 'H'];
        InputParameter.EpiDicomToNifti.OutDirFunImg = FunImg_tmp;
    end
    if para.D2N.T1 == 1
        Operation = [Operation;{'T1DICOMTONIFTI'}];
        InputParameter.T1DicomToNifti.InDirT1Raw = T1Img_tmp;
        T1Img_tmp = [T1Img_tmp 'H'];
        InputParameter.T1DicomToNifti.OutDirT1Img = T1Img_tmp;
    end
end
if para.RemoveTimes.IsRemoveTime == 1
    Operation = [Operation;{'REMOVEFIRSTTIMEPOINTS'}];
    InputParameter.RemoveFirstTimePoints.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'T'];
    InputParameter.RemoveFirstTimePoints.OutDirFunImg = FunImg_tmp;
    InputParameter.RemoveFirstTimePoints.TimePointsAmount = fun_num(para.RemoveTimes.Time);
    
end
if para.Slice.IsSlice == 1
    Operation = [Operation;{'SLICETIMING'}];
    InputParameter.SliceTiming.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'A'];
    InputParameter.SliceTiming.OutDirFunImg = FunImg_tmp;
    InputParameter.SliceTiming.SliceNumber = fun_num(para.Slice.SliceNumber);
    InputParameter.SliceTiming.SliceOrder = fun_num(para.Slice.SliceOrder);
    InputParameter.SliceTiming.ReferenceSlice = fun_num(para.Slice.SliceRefer);
    InputParameter.SliceTiming.TR = fun_num(para.TR);
end

if para.Realign.IsRealign == 1
    Operation = [Operation;{'REALIGN'}];
    InputParameter.Realign.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'R'];
    InputParameter.Realign.OutDirFunImg = FunImg_tmp;
    InputParameter.Realign.RealignParameterDir = [workspace filesep 'RealignParameter'];
end




if para.Reorient.isT1ImgReorient == 1 && para.IsT1Preprocess == 1
    Operation = [Operation;{'REORIENTT1BEFORECOREG'}];
    InputParameter.ReorientT1BeforeCoreg.InDirT1Img = T1Img_tmp;
    InputParameter.ReorientT1BeforeCoreg.ReorientMat_otdir = [workspace filesep 'ReorientMats'];
    InputParameter.ReorientT1BeforeCoreg.QC_otdir = [workspace filesep 'QC'];
end

if para.Bet.IsBet == 1 && para.IsT1Preprocess == 1
    Operation = [Operation;{'BET'}];
    InputParameter.Bet.InDirRealignParameter = [workspace filesep 'RealignParameter'];
    InputParameter.Bet.InDirT1Img = T1Img_tmp;
    InputParameter.Bet.OtDirT1Img = [T1Img_tmp '_Bet'];
end

if para.Coregister.IsrCoregister == 1 && para.IsT1Preprocess == 1
    Operation = [Operation;{'COREGISTERBET'}];
    InputParameter.Coregister_bet.InDirT1Img = T1Img_tmp;
    InputParameter.Coregister_bet.InDirBet = [T1Img_tmp '_Bet'];
    InputParameter.Coregister_bet.InDirRealignParameter = [workspace filesep 'RealignParameter'];
    T1Img_tmp = [T1Img_tmp 'C'];
    InputParameter.Coregister_bet.OtDirT1Img = T1Img_tmp;
    
end

if  para.NewSeg.IsNewSeg == 1 && para.IsT1Preprocess == 1
    Operation = [Operation;{'NEWSEGMENT'}];
    InputParameter.NewSegment.InDirT1Img = T1Img_tmp;
    T1Img_tmp = [T1Img_tmp 'E'];
    InputParameter.NewSegment.OutDirT1NewSegment = T1Img_tmp;
    InputParameter.NewSegment.Parameter.AffineRegularisation = para.NewSeg.AffineRegularisation;   
end

if para.Cov_seg.IsCov == 1
    Operation = [Operation;{'REGRESSOUTCOVARIATES'}];
    InputParameter.RegressOutCovariates_seg.InDirFunImg = FunImg_tmp;
    InputParameter.RegressOutCovariates_seg.OutDirCov = [FunImg_tmp '_Covs'];
    InputParameter.RegressOutCovariates_seg.InDirSeg = T1Img_tmp;
    FunImg_tmp = [FunImg_tmp 'C'];
    InputParameter.RegressOutCovariates_seg.OutDirFunImg = FunImg_tmp;
    InputParameter.RegressOutCovariates_seg.IsRemoveIntercept = ~para.Cov_seg.IsAddMeanBack;
    InputParameter.RegressOutCovariates_seg.PolynomialTrend = para.Cov_seg.IsCovDetrend ;
    InputParameter.RegressOutCovariates_seg.IsWholeBrain = para.Cov_seg.IsCovGlobal;
    InputParameter.RegressOutCovariates_seg.IsCSF = para.Cov_seg.IsCovCSF;
    InputParameter.RegressOutCovariates_seg.CSF_pthrsd = fun_num(para.Cov_seg.CSF_pthrsd);
    InputParameter.RegressOutCovariates_seg.IsWhiteMatter = para.Cov_seg.IsCovWM;
    InputParameter.RegressOutCovariates_seg.WM_pthrsd = fun_num(para.Cov_seg.WM_pthrsd);
    InputParameter.RegressOutCovariates_seg.IsGreyMatter = para.Cov_seg.IsCovGM;
    InputParameter.RegressOutCovariates_seg.GM_pthrsd = fun_num(para.Cov_seg.GM_pthrsd);
    InputParameter.RegressOutCovariates_seg.IsOtherCovariatesROI = para.Cov_seg.IsCovOther;
    InputParameter.RegressOutCovariates_seg.IsHeadMotion_Friston24 = para.Cov_seg.IsCovFriston24; 
    InputParameter.RegressOutCovariates_seg.IsHeadMotion_Rigidbody6 = 0;
    [fdir,fname] = fileparts(FunImg);
    InputParameter.RegressOutCovariates_seg.InDirRealignParameter = [fdir filesep 'RealignParameter'];
    InputParameter.RegressOutCovariates_seg.OtherCovariatesROIList = para.Cov_seg.CovOtherROI;
end

if para.FunWM.IsFunWM == 1
    Operation = [Operation;{'FUNWHITEMATTER'}];
    InputParameter.FunWM.InDirFunImg = FunImg_tmp;
    InputParameter.FunWM.InDirT1Seg = T1Img_tmp;
    FunImg_tmp = [FunImg_tmp 'M'];
    InputParameter.FunWM.OtDirFunImg = FunImg_tmp;
    InputParameter.FunWM.OtDirT1C2 = [T1Img_tmp '_WM'];
    InputParameter.FunWM.mask_p_thrsd = fun_num(para.FunWM.mask_p_thrsd);
end

if para.Normalize.IsNormal == 1
    switch para.Normalize.Method
        case 'nmlz_dartel'
            Operation = [Operation;{'NORMALIZE_DARTEL'}];
            InputParameter.Normalize.InDirFunImg = FunImg_tmp;
            FunImg_tmp = [FunImg_tmp 'W'];
            InputParameter.Normalize.InDirT1Img_newseg = T1Img_tmp;
            InputParameter.Normalize.Dartel.BoundingBox = fun_num(para.Normalize.BoundingBox);
            InputParameter.Normalize.Dartel.VoxSize = fun_num(para.Normalize.VoxSize);
            InputParameter.Normalize.Dartel.AffineRegularisation = para.Normalize.AffineRegularisation;
            InputParameter.Normalize.Dartel.OtDirFunImg_nmlz = FunImg_tmp;
            InputParameter.Normalize.Dartel.OtDirImg_check = [workspace filesep 'PicturesForChkNormalization'];  
            InputParameter.Normalize.Dartel.OtDir_dartel = [workspace filesep 'dartel_template'];
    end
end

if para.GWM.IsGWM == 1
    Operation = [Operation;{'GROUP_WMMASK'}];
    gp_wmmask_suffix_nam = '_group_WMMask';
    wm_nam = 'WM';
    wm_remove_nam = [wm_nam '_RemoveArea'];
    gp_wmmask_pth = [FunImg_tmp gp_wmmask_suffix_nam];
    InputParameter.GWM.InDirT1Img = T1Img_tmp;
    InputParameter.GWM.OtDirGroupMask = [gp_wmmask_pth filesep wm_nam '.nii'];
    InputParameter.GWM.WMthrsd_gp = fun_num(para.GWM.WMthrsd_gp);
    InputParameter.GWM.WMthrsd_idvd = fun_num(para.GWM.WMthrsd_idvd);
    InputParameter.GWM.ISRemoveRegion = para.GWM.ISRemoveRegion;
    InputParameter.GWM.RemoveRegion = para.GWM.RemoveRegion;
    InputParameter.GWM.OtDirGroupMask_remove = [gp_wmmask_pth filesep wm_remove_nam '.nii'];
    InputParameter.GWM.method = para.GWM.method;
    InputParameter.GWM.up.Knum = fun_num(para.GWM.up.Knum);
    InputParameter.GWM.tmplt.InDirTemplate = para.GWM.tmplt.InDirTemplate;
    region_num = 2^fun_num(InputParameter.GWM.up.Knum);
    if InputParameter.GWM.ISRemoveRegion == 0
        InputParameter.GWM.RemoveRegion = '';
    end

    if exist(InputParameter.GWM.RemoveRegion,'file')
        file_nam = wm_remove_nam;
    else
        file_nam = wm_nam;
    end
    wm_uniform_parcellate = [file_nam '_uniform_parcellate_'];
    InputParameter.GWM.up.OtDir = [gp_wmmask_pth filesep wm_uniform_parcellate fun_str(region_num) '.nii'];
    InputParameter.GWM.up.OtDirmat = '';
    InputParameter.GWM.tmplt.OtDir = [gp_wmmask_pth filesep file_nam '_template' '.nii'];
    
end

if para.Smooth.IsSmooth == 1
    Operation = [Operation;{'SMOOTH'}];
    InputParameter.Smooth.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'S'];
    InputParameter.Smooth.OutDirFunImg = FunImg_tmp;
    InputParameter.Smooth.FWHM = fun_num(para.Smooth.FWHM);
end
if para.Detrend.IsDetrend == 1
    Operation = [Operation;{'DETREND'}];
    InputParameter.Detrend.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'D'];
    InputParameter.Detrend.OutDirFunImg = FunImg_tmp;
    InputParameter.Detrend.CutNumber = 10;
end

if para.Filter.IsFilter == 1
    Operation = [Operation;{'FILTER'}];
    InputParameter.Filter.InDirFunImg = FunImg_tmp;
    FunImg_tmp = [FunImg_tmp 'F'];
    InputParameter.Filter.OutDirFunImg = FunImg_tmp;
    InputParameter.Filter.InFileMask = 0;
    InputParameter.Filter.SamplePeriod = fun_num(para.TR);
    InputParameter.Filter.LowPass_HighCutoff = fun_num(para.Filter.LowPass_HighCut);
    InputParameter.Filter.HighPass_LowCutoff = fun_num(para.Filter.LowCut_HighPass);
    InputParameter.Filter.IsAddMeanBack = 'Yes';
    InputParameter.Filter.CutNumber = 10;
end
end

