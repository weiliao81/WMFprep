function indir_NewSegment_dartel(indir_t1,outdir_new_segment,Parameter)
%InDir_T1=T1ImgCoreg; Or InDir_T1=T1Img
%Parameter.AffineRegularisation='mni';  European brains (mni)
%Parameter.AffineRegularisation='eastern'; East Asian brains (eastern)
%-----------------------------------------------------------
%   Copyright(c) 2015
%	Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%	Written by JIA Xi-Ze 201502
%	http://www.restfmri.net/
% 	Mail to Authors: jxz.rest@gmail.com, jiaxize@foxmail.com
%   151208 jiaxize, support SPM12
%   revised by JIawei Sun in 220830: added the t1 dartel code




subjects_folder_list=init_InDirAndOutDir(indir_t1,outdir_new_segment);
indir_CopyT1(indir_t1,outdir_new_segment,subjects_folder_list);

SpmBatch=cell(length(subjects_folder_list),1);
for i=1:length(subjects_folder_list)
    SpmBatch{i}.jobs = init_SpmBatch('NewSegment');
    Parameter=init_NewSegmentParameter(outdir_new_segment,subjects_folder_list{i},Parameter);
    SpmBatch{i} = output_spmbatch_newsegment(SpmBatch{i},Parameter);
end

if ~isempty(gcp('nocreate'))
    parfor i=1:length(subjects_folder_list)
        run_SpmBatch(SpmBatch{i});
    end
else
    for i=1:length(subjects_folder_list)
        run_SpmBatch(SpmBatch{i});
    end
end

indir_t1_dartel(outdir_new_segment) %220830
end



function Parameter=init_NewSegmentParameter(outdir_new_segment,subjects_folder_name,Parameter)
  Parameter.T1FilePath=inpath_Misc([outdir_new_segment filesep subjects_folder_name],'Get1stSubImgPath');
  Parameter.SPMPath=get_Parameters('SpmFunctionPath');
end


function SpmBatch = output_spmbatch_newsegment(SpmBatch,Parameter)

if strcmpi(spm('ver'),'SPM8')
   for i=1:6
       SpmBatch.jobs{1,1}.spm.tools.preproc8.tissue(1,i).tpm{1,1} =...
                           [Parameter.SPMPath filesep 'toolbox' filesep 'Seg' filesep 'TPM.nii' ',' num2str(i)];
       SpmBatch.jobs{1,1}.spm.tools.preproc8.tissue(1,i).warped = [0 0];
   end
   SpmBatch.jobs{1,1}.spm.tools.preproc8.warp.affreg=Parameter.AffineRegularisation;
   SpmBatch.jobs{1,1}.spm.tools.preproc8.channel.vols={Parameter.T1FilePath};
elseif strcmpi(spm('ver'),'SPM12')
   preproc = SpmBatch.jobs{1,1}.spm.tools.preproc8;
   for i=1:6
       preproc.tissue(1,i).tpm{1,1} =...
                           [Parameter.SPMPath filesep 'tpm' filesep 'TPM.nii' ',' num2str(i)];
       preproc.tissue(1,i).warped = [0 0];% Do not need warped results. Warp by DARTEL
   end   
end
   preproc.warp.affreg=Parameter.AffineRegularisation;
   preproc.channel.vols={Parameter.T1FilePath};
   preproc.warp.mrf = 1;
   preproc.warp.cleanup = 1;
   preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
   preproc.warp.fwhm = 0;
   SpmBatch = [];
   SpmBatch.jobs{1,1}.spm.spatial.preproc = preproc;
end

