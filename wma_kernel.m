function wma_kernel(AOperation,InputParameter)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
switch upper(AOperation)
    case 'EPIDICOMTONIFTI' %EPI Dicom to Nifti
        run_EpiDicomToNifti(InputParameter);
    case 'T1DICOMTONIFTI' %T1DicomToNifti
        run_T1DicomToNifti(InputParameter);
    case 'REMOVEFIRSTTIMEPOINTS' %Remove First Time Points
        run_RemoveFirstTimePoints(InputParameter);
    case 'SLICETIMING' %Slice Timing
        run_SliceTiming(InputParameter);
    case 'REALIGN' %Realign
        run_Realign(InputParameter);
    case 'REGRESSOUTCOVARIATES' %RegressOutCovariates
        run_RegressOutCovariates_seg(InputParameter);
    case 'CROPT1'
        run_cropt1(InputParameter);
    case 'REORIENTT1BEFORECOREG' %ReorientT1BeforeCoreg
        run_ReorientT1BeforeCoreg(InputParameter);
    case 'BET'
        run_bet(InputParameter);
    case 'COREGISTERBET'
        run_Coregister_bet(InputParameter);
    case 'NEWSEGMENT'
        run_NewSegment_dartel(InputParameter);
    case 'FUNWHITEMATTER'
        run_fun_whitematter(InputParameter);
    case 'NORMALIZE_DARTEL'
        run_Normalize_dartel(InputParameter);  
    case 'GROUP_WMMASK'
        run_group_wmmask(InputParameter);
    case 'SMOOTH' %Smooth
        run_Smooth(InputParameter);
    case 'DETREND' %Detrend
        run_Detrend(InputParameter);
    case 'FILTER' %Filter
        run_Filter(InputParameter);

end
end

function run_EpiDicomToNifti(InputParameter)
indir_FunRaw=InputParameter.EpiDicomToNifti.InDirFunRaw;
outdir_FunImg=InputParameter.EpiDicomToNifti.OutDirFunImg;
indir_Dicom2Nifti(indir_FunRaw,outdir_FunImg);
end


function run_T1DicomToNifti(InputParameter)
indir_T1Raw = InputParameter.T1DicomToNifti.InDirT1Raw;
outdir_T1Img = InputParameter.T1DicomToNifti.OutDirT1Img;
indir_Dicom2Nifti(indir_T1Raw,outdir_T1Img);
end

function run_RemoveFirstTimePoints(InputParameter)
    indir_FunImg=InputParameter.RemoveFirstTimePoints.InDirFunImg;
    outdir_FunImg=InputParameter.RemoveFirstTimePoints.OutDirFunImg;
    TimePointsAmount=InputParameter.RemoveFirstTimePoints.TimePointsAmount;
    
    indir_RmFirstTimePoints(indir_FunImg,outdir_FunImg,TimePointsAmount);
end



function run_SliceTiming(InputParameter)
    indir_FunImg=InputParameter.SliceTiming.InDirFunImg;
    outdir_FunImg=InputParameter.SliceTiming.OutDirFunImg;
    SN=InputParameter.SliceTiming.SliceNumber;
    SO=InputParameter.SliceTiming.SliceOrder;
    RS=InputParameter.SliceTiming.ReferenceSlice;
%     if SN==0 || SO==0 || RS==0
%         subj_list=dir_NameList(indir_FunImg);
%         JsonPath=inpath_Misc([indir_FunImg filesep subj_list{1}],'Get1stSubJsonPath');
%         if ~isempty(JsonPath)
%             [SN,SO,RS]=get_jsonfile(JsonPath);
%         else
%             error('have no json file in subject folder!');
%         end
%     end
    Parameter.SliceNumber=SN;
    Parameter.SliceOrder=SO;
    Parameter.ReferenceSlice=RS;
    Parameter.TR=InputParameter.SliceTiming.TR;
    
    indir_SliceTiming(indir_FunImg,outdir_FunImg,Parameter);
end

function run_Realign(InputParameter)
    indir_FunImg=InputParameter.Realign.InDirFunImg;
    outdir_FunImg=InputParameter.Realign.OutDirFunImg;
    outdir_RealignParameter=InputParameter.Realign.RealignParameterDir;
    
    indir_Realign(indir_FunImg,outdir_FunImg,outdir_RealignParameter);
end

function  run_ReorientT1BeforeCoreg(InputParameter)
    t1_indir=InputParameter.ReorientT1BeforeCoreg.InDirT1Img;
    ReorientMat_otdir=InputParameter.ReorientT1BeforeCoreg.ReorientMat_otdir;
    QC_otdir=InputParameter.ReorientT1BeforeCoreg.QC_otdir;
    infodr_reorient_t1(t1_indir,QC_otdir,ReorientMat_otdir)
end

function run_Normalize_newsegment_dartel(InputParameter)
    indir_epi_img          =InputParameter.Normalize.dartel.InDirFunImg;
    indir_t1_img           =InputParameter.Normalize.dartel.InDirT1Img;
    indir_realignparameter =InputParameter.Normalize.dartel.InDirRealignParameter;
    outdir_normalized_epi  =InputParameter.Normalize.dartel.OutDirFunImg;
    outdir_t1_new_segment  =InputParameter.Normalize.dartel.OutDirT1NewSegment;
    outdir_t1_coregister   =InputParameter.Normalize.dartel.OutDirT1CoregisterFun;
    outfolder_Template     =InputParameter.Normalize.dartel.OutFodrTemplate;
    output_folder_for_check=InputParameter.Normalize.dartel.InFodrChekNormPic;

    parameters.bb          =InputParameter.Normalize.dartel.BoundingBox;
    parameters.vox         =InputParameter.Normalize.dartel.VoxSize;
    parameters.AffineRegularisation=InputParameter.Normalize.dartel.AffineRegularisation;

    indir_Normalize_newsegment_dartel_module...
            (indir_epi_img,indir_t1_img,indir_realignparameter,...
            outdir_normalized_epi,outdir_t1_new_segment,outdir_t1_coregister,...
             parameters,output_folder_for_check,outfolder_Template)
end

function run_crop_t1(InputParameter)
    T1_Indir =InputParameter.CropT1.InDirT1Img;
    infodr_crop_t1(T1_Indir);
end

function run_bet(InputParameter)
    RealignParameter_Indir = InputParameter.Bet.InDirRealignParameter;
    T1_Indir = InputParameter.Bet.InDirT1Img;
    T1_betdir = InputParameter.Bet.OtDirT1Img;
    infodr_Bet(RealignParameter_Indir,T1_Indir,T1_betdir)
end


function run_NewSegment_dartel(InputParameter)    %   NewSegment Jiawei Sun 220830
    indir_t1=InputParameter.NewSegment.InDirT1Img;
    outdir_new_segment=InputParameter.NewSegment.OutDirT1NewSegment;
%     Parameter.AffineRegularisation=InputParameter.NewSegment.Parameter.AffineRegularisation;    
    Parameter=InputParameter.NewSegment.Parameter;
    indir_NewSegment_dartel(indir_t1,outdir_new_segment,Parameter);
end

function run_Coregister_bet(InputParameter)
    indir_t1img =  InputParameter.Coregister_bet.InDirT1Img;
    indir_realignparameter = InputParameter.Coregister_bet.InDirRealignParameter;
    outdir_t1_coregister = InputParameter.Coregister_bet.OtDirT1Img;
    indir_t1bet = InputParameter.Coregister_bet.InDirBet;
    indir_Coregister_bet(indir_t1img,indir_realignparameter,outdir_t1_coregister,indir_t1bet);
end



function run_Normalize_dartel(InputParameter)
    indir_epi_img = InputParameter.Normalize.InDirFunImg;
    t1_new_segment = InputParameter.Normalize.InDirT1Img_newseg;
    outdir_normalized_epi = InputParameter.Normalize.Dartel.OtDirFunImg_nmlz;
    output_folder_for_check = InputParameter.Normalize.Dartel.OtDirImg_check;   
    outfolder_Template = InputParameter.Normalize.Dartel.OtDir_dartel;
    parameters.bb=InputParameter.Normalize.Dartel.BoundingBox;
    parameters.vox=InputParameter.Normalize.Dartel.VoxSize;
    parameters.AffineRegularisation=InputParameter.Normalize.Dartel.AffineRegularisation;
    set_spm_path('default');
    indir_dartel_creat_templates(t1_new_segment,outfolder_Template);
    set_spm_path('default');
    indir_Normalize_dartel_update(indir_epi_img,outfolder_Template,t1_new_segment,outdir_normalized_epi,...
         output_folder_for_check,parameters);
end


function run_Smooth(InputParameter)
    indir_FunImg=InputParameter.Smooth.InDirFunImg;
    outdir_FunImg=InputParameter.Smooth.OutDirFunImg;
    Parameter.FWHM=InputParameter.Smooth.FWHM;
    
    if 3~=length(Parameter.FWHM)
        error('FWHM is not [X X X]');
    end
    
    indir_SPMdefaultSmooth(indir_FunImg,outdir_FunImg,Parameter)
end

function run_Detrend(InputParameter)
 indir_FunImg=InputParameter.Detrend.InDirFunImg;
 outdir_FunImg=InputParameter.Detrend.OutDirFunImg;
 CutNumber=InputParameter.Detrend.CutNumber;
 
 indir_Detrend(indir_FunImg,outdir_FunImg,CutNumber);
end

function run_Filter(InputParameter)

indir_FunImg=InputParameter.Filter.InDirFunImg;
outdir_FunImg=InputParameter.Filter.OutDirFunImg;
infile_Mask=InputParameter.Filter.InFileMask;

Parameter.SamplePeriod=InputParameter.Filter.SamplePeriod;
Parameter.LowPass_HighCutoff=InputParameter.Filter.LowPass_HighCutoff;
Parameter.HighPass_LowCutoff=InputParameter.Filter.HighPass_LowCutoff;
Parameter.IsAddMeanBack=InputParameter.Filter.IsAddMeanBack;
Parameter.CutNumber=InputParameter.Filter.CutNumber;

indir_Filter(indir_FunImg,outdir_FunImg,infile_Mask,Parameter);

end


function run_RegressOutCovariates_seg(InputParameter)
Fun_Indir = InputParameter.RegressOutCovariates_seg.InDirFunImg;
Fun_Outdir = InputParameter.RegressOutCovariates_seg.OutDirFunImg;
Cov_OutDir = InputParameter.RegressOutCovariates_seg.OutDirCov;
indir_segment = InputParameter.RegressOutCovariates_seg.InDirSeg;
Parameter.IsRemoveIntercept=InputParameter.RegressOutCovariates_seg.IsRemoveIntercept;
Parameter.PolynomialTrend=InputParameter.RegressOutCovariates_seg.PolynomialTrend;
Parameter.IsGreyMatter = InputParameter.RegressOutCovariates_seg.IsGreyMatter;
Parameter.GM_pthrsd = InputParameter.RegressOutCovariates_seg.GM_pthrsd;
Parameter.IsWholeBrain = InputParameter.RegressOutCovariates_seg.IsWholeBrain;
Parameter.IsCSF = InputParameter.RegressOutCovariates_seg.IsCSF;
Parameter.CSF_pthrsd = InputParameter.RegressOutCovariates_seg.CSF_pthrsd;
Parameter.IsWhiteMatter = InputParameter.RegressOutCovariates_seg.IsWhiteMatter;
Parameter.WM_pthrsd = InputParameter.RegressOutCovariates_seg.WM_pthrsd;
% Parameter.IsHeadMotion_Rigidbody6 = InputParameter.RegressOutCovariates_seg.IsHeadMotion_Rigidbody6;
Parameter.IsOtherCovariatesROI = InputParameter.RegressOutCovariates_seg.IsOtherCovariatesROI;
Parameter.InDirRealignParameter = InputParameter.RegressOutCovariates_seg.InDirRealignParameter;
Parameter.OtherCovariatesROIList = InputParameter.RegressOutCovariates_seg.OtherCovariatesROIList;

if isfield(InputParameter.RegressOutCovariates_seg,'IsHeadMotion_Rigidbody6')% LI Zi-Qi 200502
      Parameter.IsHeadMotion_Rigidbody6 = InputParameter.RegressOutCovariates_seg.IsHeadMotion_Rigidbody6;
else
    Parameter.IsHeadMotion_Rigidbody6=0;
end
if isfield(InputParameter.RegressOutCovariates_seg,'IsHeadMotion_Friston24')
   Parameter.IsHeadMotion_Friston24=InputParameter.RegressOutCovariates_seg.IsHeadMotion_Friston24;
else
   Parameter.IsHeadMotion_Friston24=0; 
end
indir_RegressOutCov_seg(Fun_Indir,indir_segment,Fun_Outdir,Cov_OutDir,Parameter);
end


function run_fun_whitematter(InputParameter)
    indir_fun = InputParameter.FunWM.InDirFunImg;
    indir_t1seg = InputParameter.FunWM.InDirT1Seg;
    otdir_t1_c2 = InputParameter.FunWM.OtDirT1C2;
    otdir_fun = InputParameter.FunWM.OtDirFunImg;
    mask_p_thrsd = InputParameter.FunWM.mask_p_thrsd;
    infodr_fun_whitematter(indir_fun,indir_t1seg,otdir_fun,otdir_t1_c2,mask_p_thrsd);
end

function run_group_wmmask(InputParameter)
    indir_t1 = InputParameter.GWM.InDirT1Img;
    otdir_gpmask = InputParameter.GWM.OtDirGroupMask;
    idvd_mask_thrsd = InputParameter.GWM.WMthrsd_idvd;
    gp_mask_thrsd = InputParameter.GWM.WMthrsd_gp;
    remove_img = InputParameter.GWM.RemoveRegion;
    otdir_gpmask_remove = InputParameter.GWM.OtDirGroupMask_remove;
    method.list = InputParameter.GWM.method;
    method.uniform_parcellate.Knum = InputParameter.GWM.up.Knum;
    method.uniform_parcellate.otdir_up = InputParameter.GWM.up.OtDir;
    method.uniform_parcellate.otdir_mat = InputParameter.GWM.up.OtDirmat;
    method.template.indir_template = InputParameter.GWM.tmplt.InDirTemplate;
    method.template.otdir = InputParameter.GWM.tmplt.OtDir;
    infodr_get_group_wmmask(indir_t1,otdir_gpmask,gp_mask_thrsd,idvd_mask_thrsd,remove_img,otdir_gpmask_remove,method)
end

