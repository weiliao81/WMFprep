function indir_Normalize_dartel_update(indir_epi_img,infolder_Template,indir_new_segment,outdir_normalized_epi,outfodr_ChekNorm,parameters)
%parameters.bb
%parameters.vox
%outfodr_ChekNorm = ''; do not creat folder for check normalize
%Normalize InDir_Img by dartel
 %-----------------------------------------------------------
%   Copyright(c) 2015
%	Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%	Written by JIA Xi-Ze 201502
%	http://www.restfmri.net/
% 	Mail to Authors: jxz.rest@gmail.com, jiaxize@foxmail.com


[brain_img_file_type,ImgExt]=indir_Chek(indir_epi_img);
SubfodrList=dir_NameList(indir_epi_img);

SpmBatch=cell(length(SubfodrList),1);
for i=1:length(SubfodrList)
    SpmBatch{i}.jobs = init_SpmBatch('dartel_normalise_to_mni_space');
    infodr_epi_img=[indir_epi_img filesep SubfodrList{i}];
    infodr_t1_new=[indir_new_segment filesep SubfodrList{i}];
    parameters=init_normalize_dartel_parameter(infodr_epi_img,infolder_Template,infodr_t1_new,brain_img_file_type,parameters);
    SpmBatch{i} = output_spm_batch_normalize_dartel(SpmBatch{i},parameters);
end
if ~isempty(gcp('nocreate'))
    parfor i=1:length(SubfodrList)
        run_SpmBatch(SpmBatch{i});
    end
else
    for i=1:length(SubfodrList)
        run_SpmBatch(SpmBatch{i});
    end
end

move_InDir2OutDir(indir_epi_img,outdir_normalized_epi,'RegularExpression',[get_Postfix('Normalize_dartel') '*']);
if ~isempty(outfodr_ChekNorm)
   indir_GeneratePics4Chek(outdir_normalized_epi,outfodr_ChekNorm);
end

end

function parameters=init_normalize_dartel_parameter ...
                (infodr_epi_img,infolder_Template,infodr_t1_new,brain_img_file_type,parameters)
  
obj_temp_path=path_operation(infolder_Template);     
obj_t1_new_path=path_operation(infodr_t1_new);     


% for SPM12
if strcmpi('.4dnii',brain_img_file_type)
    parameters.images={inpath_Misc(infodr_epi_img,'Get1stSubNiiPath')};
elseif strcmpi('.nii.gz',brain_img_file_type)
    inpath_Misc(infodr_epi_img,'Gunzip1stSubGzFile');
    parameters.images={inpath_Misc(infodr_epi_img,'Get1stSubNiiPath')};
else
    parameters.images=spread_Fodr4SPM(infodr_epi_img,brain_img_file_type);
end

parameters.template={obj_temp_path.must_1_brain_image_with_prefix('Template_6')}; 
parameters.fwhm=[0 0 0];
parameters.preserve=0;
parameters.flowfield={obj_t1_new_path.must_1_brain_image_with_prefix('u_')}; 
end

function SpmBatch = output_spm_batch_normalize_dartel(SpmBatch,parameters)
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.fwhm=parameters.fwhm;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.preserve=parameters.preserve;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.bb=parameters.bb;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.vox=parameters.vox;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.template=parameters.template;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.data.subj(1,1).images=parameters.images;
        SpmBatch.jobs{1,1}.spm.tools.dartel.mni_norm.data.subj(1,1).flowfield=parameters.flowfield;
end
