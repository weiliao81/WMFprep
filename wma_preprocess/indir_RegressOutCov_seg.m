function indir_RegressOutCov_seg(Fun_Indir,indir_segment,Fun_Outdir,Cov_OutDir,Parameter)
%Parameter.IsWholeBrain
%Parameter.IsCSF
%Parameter.IsWhiteMatter
%Parameter.IsHeadMotion_Friston24
%Parameter.IsOtherCovariatesROI
%Parameter.IsRemoveIntercept
%Parameter.PolynomialTrend
%Parameter.InDirRealignParameter
%Parameter.OtherCovariatesROIList
%-----------------------------------------------------------
%   Copyright(c) 2015
%	Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%	Written by JIA Xi-Ze 201502
%	http://www.restfmri.net/
% 	Mail to Authors: jxz.rest@gmail.com, jiaxize@foxmail.com
%   fixed bug line about Parameter.CovariablesTextfilepath 170201 by jiaxize

%   Modified by Li Zi-Qi and Jia Xi-Ze 191113
%   Shirui technology co., LTD
%   Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%   Modified by Sun Jia-Wei 211002

infodr_get_cov_mask(Fun_Indir,indir_segment,Parameter.InDirRealignParameter,Cov_OutDir,Parameter);
SubfodrList=dir_NameList(Fun_Indir);
OtherCovariatesROIList = Parameter.OtherCovariatesROIList;
fun_mkdir(Fun_Outdir);
% if matlabpool('size')>0    
if ~isempty(gcp('nocreate'))
    parfor i=1:length(SubfodrList)
        BrainMask=[Cov_OutDir filesep 'AutoMasks' filesep 'AutoMasks_' SubfodrList{i} '.nii'];
        CsfMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_' SubfodrList{i} '_CSF.nii'];
        WhiteMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_' SubfodrList{i} '_WM.nii'];
        GreyMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_' SubfodrList{i} '_GM.nii'];
        CovariatesROIList=Generate_CovROIlist(Parameter,BrainMask,CsfMask,WhiteMask,GreyMask,OtherCovariatesROIList);
        CovariablesTextfilepath=[Cov_OutDir filesep SubfodrList{i} filesep 'RegressOut_Covariables.txt'];
        out_CovariablesTextfilepath(Fun_Indir,Cov_OutDir,SubfodrList{i},CovariatesROIList,Parameter,CovariablesTextfilepath);
        infodr_RegressOutCov([Fun_Indir filesep SubfodrList{i}],...
                              [Fun_Outdir filesep SubfodrList{i}],...
                              '',Parameter,CovariablesTextfilepath);
    end
else
    for i=1:length(SubfodrList)
        BrainMask=[Cov_OutDir filesep 'AutoMasks' filesep 'AutoMasks_' SubfodrList{i} '.nii'];
        CsfMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_ThrdMask_' SubfodrList{i} '_CSF.nii'];
        WhiteMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_ThrdMask_' SubfodrList{i} '_WM.nii'];
        GreyMask=[Cov_OutDir filesep 'SegmentationMasks' filesep 'FunSpace_ThrdMask_' SubfodrList{i} '_GM.nii'];
        CovariatesROIList=Generate_CovROIlist(Parameter,BrainMask,CsfMask,WhiteMask,GreyMask,OtherCovariatesROIList);
        CovariablesTextfilepath=[Cov_OutDir filesep SubfodrList{i} filesep 'RegressOut_Covariables.txt'];
        out_CovariablesTextfilepath(Fun_Indir,Cov_OutDir,SubfodrList{i},CovariatesROIList,Parameter,CovariablesTextfilepath);
        infodr_RegressOutCov([Fun_Indir filesep SubfodrList{i}],...
                              [Fun_Outdir filesep SubfodrList{i}],...
                              '',Parameter,CovariablesTextfilepath);
    end    
end
    
    
    

end


function CovROI=Generate_CovROIlist(Parameter,BrainMask,CsfMask,WhiteMask,GreyMask,OtherCovariatesROIList)
    CovROI=[];
    
    if isfield(Parameter,'IsWholeBrain')&&(1==Parameter.IsWholeBrain)
       CovROI=[CovROI;{BrainMask}];
    end
    
    if isfield(Parameter,'IsCSF')&&(1==Parameter.IsCSF)
       CovROI=[CovROI;{CsfMask}];
    end
    
    if isfield(Parameter,'IsWhiteMatter')&&(1==Parameter.IsWhiteMatter)
       CovROI=[CovROI;{WhiteMask}];
    end
    
    if isfield(Parameter,'IsGreyMatter')&&(1==Parameter.IsGreyMatter)
       CovROI=[CovROI;{GreyMask}];
    end
    
    if isfield(Parameter,'IsOtherCovariatesROI')&&(1==Parameter.IsOtherCovariatesROI)
       CovROI=[CovROI;OtherCovariatesROIList]; 
    end
end

function out_CovariablesTextfilepath(Fun_Indir,Cov_OutDir,SubfodrNam,CovariatesROIList,Parameter,CovariablesTextfilepath)

        Signal_Matrix=Extract_ROISignal([Fun_Indir filesep SubfodrNam],...
                                        CovariatesROIList,...
                                        [Cov_OutDir filesep SubfodrNam filesep 'Covariates']);
                                
        RpCovariables=get_Rp_Covariables(Parameter,SubfodrNam); 
        
        
        if ~isempty(CovariatesROIList)
            CovTC=load([Cov_OutDir filesep SubfodrNam filesep 'ROISignals_Covariates.txt']);
            CovariablesMatrix=[RpCovariables,CovTC];
        else
            CovariablesMatrix=RpCovariables;
        end
        
        save(CovariablesTextfilepath, 'CovariablesMatrix', '-ASCII', '-DOUBLE','-TABS');

end

function RpCovariables=get_Rp_Covariables(Parameter,SubfodrNam)
if (Parameter.IsHeadMotion_Rigidbody6==1)
    riby6_cova= get_rigidbody6_covariables(Parameter,SubfodrNam);
    RpCovariables=riby6_cova;
elseif (Parameter.IsHeadMotion_Friston24==1)
   riby6_cova_crnt_tp= get_rigidbody6_covariables(Parameter,SubfodrNam);
   riby6_cova_prvis_tp=[zeros(1,size(riby6_cova_crnt_tp,2));riby6_cova_crnt_tp(1:end-1,:)];
   riby6_cova_crnt_tp_sq=riby6_cova_crnt_tp.^2;
   riby6_cova_prvis_tp_sq=riby6_cova_prvis_tp.^2;
   RpCovariables=[riby6_cova_crnt_tp,riby6_cova_prvis_tp,riby6_cova_crnt_tp_sq,riby6_cova_prvis_tp_sq];
else
    RpCovariables=[];
end

end

function rigidbody6_covariables= get_rigidbody6_covariables(Parameter,SubfodrNam)
    Rpfile=inpath_Misc([Parameter.InDirRealignParameter filesep SubfodrNam filesep 'rp*'],...
                       'Get1SubPath_RegExp');
    rigidbody6_covariables=load(Rpfile);
end