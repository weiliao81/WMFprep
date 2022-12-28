function ot_str = fun_str(in)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
switch class(in)
    case 'char' 
        ot_str = in;
    case 'double'
        ot_str = num2str(in);
    case 'cell'
        ot_str = cellfun(@fun_str,in,'UniformOutput',false);
    otherwise
        fprintf([class(in) ' now can''t change to ''char'' type\n']);
end
end