function infodr_fun_whitematter(indir_fun,indir_t1seg,otdir_fun,otdir_t1_c2,mask_p_thrsd)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com

sub_lst = dir_NameList(indir_fun);
for sub_idx = 1 : length(sub_lst)
    sub_nam = sub_lst{sub_idx};
    sub_c2_pth = [otdir_t1_c2 filesep sub_nam];
    sub_fun_pth = [indir_fun filesep sub_nam];
    sub_fun_file_lst = dir_NameList(sub_fun_pth);
    sub_fun_file_idx = fun_ismember(sub_fun_file_lst,'.nii$|.img$','regexp');
    sub_fun_file_nam = sub_fun_file_lst{sub_fun_file_idx};

    sub_t1seg_pth = [indir_t1seg filesep sub_nam];
    sub_t1seg_file_lst = dir_NameList(sub_t1seg_pth);
    sub_t1seg_file_c2_idx = fun_ismember(sub_t1seg_file_lst,'^c2\w*.nii','regexp');
    sub_t1seg_file_c2_nam = sub_t1seg_file_lst{sub_t1seg_file_c2_idx};
    [~,sub_t1seg_file_c2_filenam] = fileparts(sub_t1seg_file_c2_nam);

    sub_t1seg_file_c2_pth = [sub_t1seg_pth filesep sub_t1seg_file_c2_nam];
    sub_c2_file_pth = [sub_c2_pth filesep sub_t1seg_file_c2_nam];
    sub_c2_msk_file_pth = [sub_c2_pth filesep sub_t1seg_file_c2_filenam '_mask' '.nii'];
    sub_c2_msk_rsls_file_pth = [sub_c2_pth filesep sub_t1seg_file_c2_filenam '_mask_rsls2fun' '.nii'];
    sub_fun_file_pth = [sub_fun_pth filesep sub_fun_file_nam];
    sub_ot_fun_pth = [otdir_fun filesep sub_nam filesep 'M' sub_fun_file_nam];

    if length(find(sub_t1seg_file_c2_idx))==1
        fun_cp(sub_t1seg_file_c2_pth,sub_c2_file_pth); 
        [Data,Head] = rp_ReadNiftiImage(sub_c2_file_pth);
        Data(isnan(Data)) = 0;
        Data(Data>mask_p_thrsd)=1;
        Data(Data<=mask_p_thrsd)=0;
        Head.dt = [2,0];
        Head.pinfo(1) = 1;
        rp_WriteNiftiImage(Data,Head,sub_c2_msk_file_pth);
        
        fun_resliceimg(sub_c2_msk_file_pth,sub_c2_msk_rsls_file_pth,'',0,sub_fun_file_pth);
        fun_addmask(sub_fun_file_pth,sub_c2_msk_rsls_file_pth,sub_ot_fun_pth);
    else
        error([sub_nam ' :c2 file is error or more than one!']);
    end
end
    
end
