function file_nam = fun_get_pth_regexp(indir,str)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
    file_lst = dir_NameList(indir);
    file_idx = fun_ismember(file_lst,str,'regexp');
    if length(find(file_idx))>1
        error('the match file is more than one');
    elseif length(find(file_idx))==0;
        file_nam = ''
    else
        file_nam = file_lst{file_idx};
    end       
end