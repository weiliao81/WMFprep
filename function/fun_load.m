function ot = fun_load(pth,num)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
if nargin < 2
    num = 1;
end
    tmp_struc = load(pth);
    tmp = fieldnames(tmp_struc);
    ot = tmp_struc.(tmp{num});
end