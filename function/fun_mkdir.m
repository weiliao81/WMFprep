function indr = fun_mkdir(indr)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
[pth,nam,ext] = fileparts(indr);
    if exist(indr,'dir')
        return;
    elseif ~isempty(ext)
        fun_mkdir(pth);
    else
       mkdir(indr);
    end

end