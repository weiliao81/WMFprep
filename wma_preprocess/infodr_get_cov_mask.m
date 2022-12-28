function infodr_get_cov_mask(indir_fun,indir_segment,indir_reln,otdir_mask,input_para_tag)
sub_lst = dir_NameList(indir_fun);
fun_mkdir(otdir_mask);
seg_mask_pth = [otdir_mask filesep 'SegmentationMasks'];
auto_mask_pth = [otdir_mask filesep 'AutoMasks'];
fun_mkdir(seg_mask_pth);
for sub_idx = 1 :length(sub_lst)
    sub_nam = sub_lst{sub_idx};
    
    sub_reln_pth = [indir_reln filesep sub_nam];
    sub_reln_file_lst = dir_NameList(sub_reln_pth);
    sub_reln_mean_idx = fun_ismember(sub_reln_file_lst,'^mean\w*.nii','regexp');
    sub_reln_mean_nam = sub_reln_file_lst{sub_reln_mean_idx};
    sub_reln_mean_pth = [sub_reln_pth filesep sub_reln_mean_nam];
    
    sub_seg_pth = [indir_segment filesep sub_nam];
    sub_fun_pth = [indir_fun filesep sub_nam];
       
    if input_para_tag.IsGreyMatter == 1
        mask_p_thrsd = input_para_tag.GM_pthrsd;
        seg_tag = '^c1\w*.nii';
        seg_nam = 'GM';
        seg_file_rsls_mask(sub_seg_pth,sub_nam,seg_tag,seg_nam,sub_reln_mean_pth,seg_mask_pth,mask_p_thrsd);
    end
    if input_para_tag.IsWhiteMatter == 1
        mask_p_thrsd = input_para_tag.WM_pthrsd;
        seg_tag = '^c2\w*.nii';
        seg_nam = 'WM';
        seg_file_rsls_mask(sub_seg_pth,sub_nam,seg_tag,seg_nam,sub_reln_mean_pth,seg_mask_pth,mask_p_thrsd);
    end
    if input_para_tag.IsCSF == 1
        mask_p_thrsd = input_para_tag.CSF_pthrsd;
        seg_tag = '^c3\w*.nii';
        seg_nam = 'CSF';
        seg_file_rsls_mask(sub_seg_pth,sub_nam,seg_tag,seg_nam,sub_reln_mean_pth,seg_mask_pth,mask_p_thrsd);
    end
    if input_para_tag.IsWholeBrain == 1
        sub_fun_file_lst = dir_NameList(sub_fun_pth);
        sub_fun_file_pth = [sub_fun_pth filesep sub_fun_file_lst{fun_ismember(sub_fun_file_lst,'.nii','regexp')}];
        sub_auto_mask = [auto_mask_pth filesep 'AutoMasks_' sub_nam '.nii'];
        indir_Automask(sub_fun_file_pth,sub_auto_mask);
    end
end
end

function seg_file_rsls_mask(sub_seg_pth,sub_nam,seg_tag,seg_nam,sub_reln_mean_pth,seg_mask_pth,mask_p_thrsd)
sub_seg_file_lst = dir_NameList(sub_seg_pth);
sub_seg_file_idx = fun_ismember(sub_seg_file_lst,seg_tag,'regexp');
sub_seg_file_nam = sub_seg_file_lst{sub_seg_file_idx};
sub_seg_file_pth = [sub_seg_pth filesep sub_seg_file_nam];
sub_seg_file_rsls2fun_nam = ['FunSpace_' sub_nam '_' seg_nam '.nii'];
sub_seg_file_rsls2fun_pth = [seg_mask_pth filesep sub_seg_file_rsls2fun_nam];
sub_seg_file_mask_nam = ['FunSpace_ThrdMask_' sub_nam '_' seg_nam '.nii'];
sub_segfile_mask_pth = [seg_mask_pth filesep sub_seg_file_mask_nam];

[OutVolume,OutHead] = fun_resliceimg(sub_seg_file_pth,'','',1,sub_reln_mean_pth);
OutHead.pinfo = [1;0;0]; OutHead.dt = [16,0];
rp_WriteNiftiImage(OutVolume,OutHead,sub_seg_file_rsls2fun_pth);
OutVolume(isnan(OutVolume)) = 0;
OutVolume(OutVolume>mask_p_thrsd) = 1;
OutVolume(OutVolume<=mask_p_thrsd) = 0;
OutHead.pinfo = [1;0;0]; OutHead.dt = [2,0];
rp_WriteNiftiImage(OutVolume,OutHead,sub_segfile_mask_pth);   
end
