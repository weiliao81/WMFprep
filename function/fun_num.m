function ot_num = fun_num(in)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
switch class(in)
    case 'char' 
        ot_num = str2num(in);
        if isnan(ot_num)
            error('can''t covert to num');
        end
    case 'double'
        ot_num = in;
    case 'cell'
        ot_num = cellfun(@fun_num,in,'UniformOutput',false);
    otherwise
        fprintf([class(in) ' now can''t change to ''char'' type\n']);
end
end