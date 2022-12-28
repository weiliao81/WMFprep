function infodr_crop_t1(indir_t1)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
    sub_lst = dir_NameList(indir_t1);
    for sub_idx = 1 : length(sub_lst)
        sub_nam = sub_lst{sub_idx};
        sub_pth = [indir_t1 filesep sub_nam];
        sub_file_lst = dir_NameList(sub_pth);
        sub_file_idx = fun_ismember(sub_file_lst,'.nii$|.img$|.nii.gz$','regexp');
        sub_file_nam = sub_file_lst{sub_file_idx};
        sub_file_pth = [sub_pth filesep sub_file_nam];
        indir_crop_t1(sub_file_pth, sub_pth);
    end
end