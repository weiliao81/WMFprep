function fun_cp(indr,otdr)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
    if isfolder(indr)
        if ~exist(otdr,'dir')
            fun_mkdir(otdr);
        end
        copyfile(indr,otdr);
    elseif isfile(indr)
        [pthstr,namstr,ext] = fileparts(otdr);
        if ~isempty(ext)
            fun_mkdir(pthstr);
            copyfile(indr,otdr);
        else
            fun_mkdir(otdr);
            copyfile(indr,otdr);
        end
    else
        warning([ indr ' is''t exist']);
    end
end