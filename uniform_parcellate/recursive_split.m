function [cell_ind]=recursive_split(vol,cell_ind,k,K)
%	Copyright(c) 2021
%	Written by Li Jiao
% 	Mail to Authors: jiaoli@uestc.edu.cn
if k==K 
    sz=length(cell_ind);
    cell_ind{sz+1}=find(vol); 
else
    k=k+1;
    [a,b]=split_volume(vol);
    cell_ind1=recursive_split(a,cell_ind,k,K);
    cell_ind2=recursive_split(b,cell_ind,k,K);
    cell_ind=cat(2,cell_ind1,cell_ind2);
end