function infodr_get_group_wmmask(indir_t1,otdir_gpmask,gp_mask_thrsd,idvd_mask_thrsd,remove_img,otdir_gpmask_remove,method)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
brainmask_pth = which('BrainMask_05_61x73x61.img');
ot_dir = fileparts(otdir_gpmask);
sub_mask_dir = [ot_dir filesep 'SubMasks'];
sub_lst = dir_NameList(indir_t1);
brain_data = rp_readfile(brainmask_pth);
for sub_idx = 1 : length(sub_lst)
    sub_nam = sub_lst{sub_idx};
    sub_t1_pth = [indir_t1 filesep sub_nam];
    sub_t1_file_lst = dir_NameList(sub_t1_pth);
    sub_t1_file_idx = fun_ismember(sub_t1_file_lst,'^wc2\w*','regexp'); %revsied by Jiawei Sun 220831
    sub_t1_file_nam = sub_t1_file_lst{sub_t1_file_idx};
    sub_t1_file_pth = [sub_t1_pth filesep sub_t1_file_nam];
    [sub_data,sub_vox,sub_head] = rp_readfile(sub_t1_file_pth);
    sub_data_mask = sub_data;
    sub_data_mask(sub_data_mask >= idvd_mask_thrsd) = 1;
    sub_data_mask(sub_data_mask < idvd_mask_thrsd) = 0;  %revsied by Jiawei Sun 221226
    gp_mask_data(:,:,:,sub_idx) = sub_data_mask;
    sub_head.dt = [2,0];
    sub_head.pinfo(1) = 1;
    rp_WriteNiftiImage(sub_data_mask,sub_head,[sub_mask_dir filesep sub_nam '.nii']);
end
gp_mask_data = mean(gp_mask_data,4);
gp_mask_data(gp_mask_data>=gp_mask_thrsd) = 1;
gp_mask_data(gp_mask_data<gp_mask_thrsd) = 0; %revsied by Jiawei Sun 221226
fun_mkdir(otdir_gpmask);
rp_WriteNiftiImage(gp_mask_data,sub_head,otdir_gpmask);

if exist(remove_img,'file')
    indir_remove_region(otdir_gpmask,otdir_gpmask_remove,remove_img);
    gp_mask = otdir_gpmask_remove;
else
    gp_mask = otdir_gpmask;
end


if isfield(method,'list')&&~isempty(method.list)
    method_list = method.list;
    if find(fun_ismember(method_list,'uniform_parcellate','strcmp'))
        otdir_up = method.uniform_parcellate.otdir_up;
        otdir_up_mat = method.uniform_parcellate.otdir_mat;
        K_num = method.uniform_parcellate.Knum;    
        indir_uniform_parcellate(otdir_gpmask,otdir_up,K_num,otdir_up_mat);
    end
    if  find(fun_ismember(method_list,'template','strcmp'))
        indir_template = method.template.indir_template;
        otdir = method.template.otdir;
        indir_add_template(gp_mask,indir_template,otdir);
    end
end