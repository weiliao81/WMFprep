function indir_uniform_parcellate(indir_mask,otdir_file,K_num,otdir_mat)
%	Copyright(c) 2021
%	Written by Li Jiao
% 	Mail to Authors: jiaoli@uestc.edu.cn
%   Revised by Sun Jia-Wei 210816
%   Value of K in 2^K
%   K determines the number of nodes.
%   Number of nodes is given by 2^K 
%	K_num:            1    2    3    4    5    6    7    8    9    10    11   12
%	Number of Nodes:  2    4    8    16   32   64   128  256  512  1024  2048 4096

%DO NOT MODIFY AFTER THIS LINE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Read mask
[data,hdr]=rp_ReadNiftiImage(indir_mask);
%% NOTE UR data LLLLLRRRRR or LRLRLRLR
%Uncomment this to constrain mask to one hemishere:
% g=rem(data,2);
% data=zeros(size(data));
% data(find(g))=1;

%Simulated data:
%data=zeros(100,100,5);
%data([5:95],[5:95],2)=1;

fprintf('Starting recursion...\n');
fprintf('This may take several minutes\n');
fprintf('(E.g. about 20 mins. to parcellate one hemisphere for K=9)\n');
k=0;
cell_ind={};
[cell_ind]=recursive_split(data,cell_ind,k,K_num);

vol=zeros(size(data));
index=randperm(length(cell_ind));
for i=1:length(cell_ind)
    vol(cell_ind{i})=index(i); 
    sz(i)=length(cell_ind{i}); 
end

fprintf('Total nodes: %d, Min size node: %d, Max size node: %d\n',length(cell_ind),min(sz),max(sz));
rp_WriteNiftiImage(vol,hdr,otdir_file); %modifed by Jiawei Sun 220831
%mat2nii(vol,otdir_file,size(data),32,indir_mask);

[updata,uphead] = rp_ReadNiftiImage(otdir_file);
for i=1:max(updata(:))
    data1 = zeros(size(updata));
    data1(find(updata == i)) = 1;
    cen= regionprops(data1);
    nodeCentroid(i,:)=([uphead.dim(1)-cen.Centroid(1,2)+1,cen.Centroid(1,1),cen.Centroid(1,3)]'...
        -abs(uphead.mat(1:3,4))./uphead.mat(2,2))*uphead.mat(2,2);
    clear data1 cen;
end
if ~isempty(otdir_mat)
    save(otdir_mat,'nodeCentroid');
end
end