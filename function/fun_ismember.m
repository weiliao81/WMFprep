function idx = fun_ismember(cell,str,tag)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
    switch tag
        case 'strcmp'
            idx = cellfun(@(x) strcmp(x,str),fun_str(cell),'UniformOutput', false);
        case 'regexp'
            idx = cellfun(@(x) ~isempty(regexp(x,str,'once')),fun_str(cell),'UniformOutput', false);
        case 'strcmpi'
            idx = cellfun(@(x) strcmpi(x,str),fun_str(cell),'UniformOutput', false);
    end
    idx = cell2mat(idx);
end