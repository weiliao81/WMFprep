function indir_t1_dartel(dir_new_segment) %220830
    %DARTEL: Create Template
    SPMJOB = load('indir_t1_dartel_template.mat');
    %Look for rc1* and rc2* images.
    rc1_file_lst=[];
    rc2_file_lst=[];
    sub_lst = dir_NameList(dir_new_segment);
    for sub_idx = 1 : length(sub_lst)
        sub_nam = sub_lst{sub_idx};
        sub_pth = [dir_new_segment filesep sub_nam];
        sub_file_lst = dir_NameList(sub_pth);
        rc1_file_idx=fun_ismember(sub_file_lst,'^rc1\w*','regexp');
        rc1_file_lst=[rc1_file_lst;{[sub_pth filesep sub_file_lst{rc1_file_idx}]}];
        rc2_file_idx=fun_ismember(sub_file_lst,'^rc2\w*','regexp');
        rc2_file_lst=[rc2_file_lst;{[sub_pth filesep sub_file_lst{rc2_file_idx}]}];
    end
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.warp.images{1,1}=rc1_file_lst;
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.warp.images{1,2}=rc2_file_lst;
    fprintf(['Running DARTEL: Create Template.\n']);
    spm_jobman('run',SPMJOB.matlabbatch);
    
    % DARTEL: Normalize to MNI space - GM, WM, CSF and T1 Images.
    SPMJOB = load('indir_t1_dartel_manysubs.mat');
    flow_file_lst=[];
    gm_file_lst=[];
    wm_file_lst=[];
    csf_file_lst=[];
    for sub_idx = 1 : length(sub_lst)
        sub_nam = sub_lst{sub_idx};
        sub_pth = [dir_new_segment filesep sub_nam];
        sub_file_lst = dir_NameList(sub_pth);
        flow_file_idx=fun_ismember(sub_file_lst,'^u_\w*','regexp');
        flow_file_lst=[flow_file_lst;{[sub_pth filesep sub_file_lst{flow_file_idx}]}];
        gm_file_idx=fun_ismember(sub_file_lst,'^c1\w*','regexp');
        gm_file_lst=[gm_file_lst;{[sub_pth filesep sub_file_lst{gm_file_idx}]}];
        wm_file_idx=fun_ismember(sub_file_lst,'^c2\w*','regexp');
        wm_file_lst=[wm_file_lst;{[sub_pth filesep sub_file_lst{wm_file_idx}]}];
        csf_file_idx=fun_ismember(sub_file_lst,'^c3\w*','regexp');
        csf_file_lst=[csf_file_lst;{[sub_pth filesep sub_file_lst{csf_file_idx}]}];
        if sub_idx==1 
            template_idx=fun_ismember(sub_file_lst,'^Template_6\w*','regexp');
            template_file={[sub_pth filesep sub_file_lst{template_idx}]};
        end
    end
    
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.template=template_file;
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subjs.flowfields=flow_file_lst;
    
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subjs.images{1,1}=gm_file_lst;
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subjs.images{1,2}=wm_file_lst;
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subjs.images{1,3}=csf_file_lst;
    
    fprintf(['Running DARTEL: Normalize to MNI space for VBM. Modulated version With smooth kernel [8 8 8].\n']);
    spm_jobman('run',SPMJOB.matlabbatch);
    
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.fwhm=[0 0 0]; % Do not want to perform smooth
    fprintf(['Running DARTEL: Normalize to MNI space for VBM. Modulated version.\n']);
    spm_jobman('run',SPMJOB.matlabbatch);
    
    SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.preserve = 0;
    if exist('T1SourceFileSet','var')
        SPMJOB.matlabbatch{1,1}.spm.tools.dartel.mni_norm.data.subjs.images{1,4}=T1SourceFileSet;
    end
    fprintf(['Running DARTEL: Normalize to MNI space for VBM. Unmodulated version.\n']);
    spm_jobman('run',SPMJOB.matlabbatch);
end


