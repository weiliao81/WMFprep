function indir_Coregister_bet(InDir_T1Img,InDir_RealignParameter,OutDir_T1Coregister,InDir_T1Bet)
%-InDir{1}=T1Img;
%-InDir{2}=RealignParameter;
%-OutDir=T1Coregister;

%-----------------------------------------------------------
%   Copyright(c) 2015
%	Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%	Written by JIA Xi-Ze 201502
%	http://www.restfmri.net/
% 	Mail to Authors: jxz.rest@gmail.com, jiaxize@foxmail.com
%   Revised by Sun Jia-Wei 210816

[ImgType,ImgExt]=indir_Chek(InDir_T1Img);
sub_list = dir_NameList(InDir_T1Img);
for sub_idx = 1 :length(sub_list)
    sub_name = sub_list{sub_idx};
    sub_pth = [InDir_T1Img filesep sub_name];
    sub_T1_co_name = fun_get_pth_regexp(sub_pth,'(^co|crop)\w*(.nii|.img)$');
    if isempty(sub_T1_co_name)
        sub_T1_co_name = fun_get_pth_regexp(sub_pth,'(.nii|.img)$');
    end
    sub_T1_co_pth = [sub_pth filesep sub_T1_co_name];
    fun_cp(sub_T1_co_pth,[OutDir_T1Coregister filesep sub_name]);
end
SpmBatch=cell(length(sub_list),1);


for i=1:length(sub_list)
    SpmBatch{i}.jobs = init_SpmBatch('Coregister');
    Parameter=init_CoregisterParameter(OutDir_T1Coregister,InDir_RealignParameter,sub_list{i},InDir_T1Bet);
    SpmBatch{i} = output_SpmBatch4Corgstr(SpmBatch{i},Parameter);
end


batch_run_spm_jobman(sub_list,SpmBatch);

% parfor i=1:length(SubfodrList)
%     run_SpmBatch(SpmBatch{i});
% end


function Parameter=init_CoregisterParameter(T1CoregisterDir,InDir_RealignParameter,SubfodrNam,InDir_T1Bet)

Parameter.MeanFilePath=get_MeanImgPath_bet([InDir_RealignParameter filesep SubfodrNam]);
if ~exist(InDir_T1Bet,'dir')
    Parameter.CoT1FilePath=inpath_Misc([T1CoregisterDir filesep SubfodrNam],'Get1stSubImgPath');
    Parameter.other = '';
else
    Parameter.CoT1FilePath=inpath_Misc([InDir_T1Bet filesep SubfodrNam],'Get1stSubImgPath');
    Parameter.other = inpath_Misc([T1CoregisterDir filesep SubfodrNam],'Get1stSubImgPath');
end


function SpmBatch = output_SpmBatch4Corgstr(SpmBatch,Parameter)
SpmBatch.jobs{1,1}.spatial{1,1}.coreg{1,1}.estimate.ref = {[Parameter.MeanFilePath ',1']};
SpmBatch.jobs{1,1}.spatial{1,1}.coreg{1,1}.estimate.source ={Parameter.CoT1FilePath};
if ~isempty(Parameter.other)
    SpmBatch.jobs{1,1}.spatial{1,1}.coreg{1,1}.estimate.other={Parameter.other};
end
