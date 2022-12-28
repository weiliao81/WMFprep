function ind_surf=get_surface_voxels(vol); 
%	Copyright(c) 2021
%	Written by Li Jiao
% 	Mail to Authors: jiaoli@uestc.edu.cn
%   Returns the index of all surface voxels in a binary volume
%   The neighborhood of a voxel is defined by kernel

ind=find(vol);
sz=size(vol);
coor=zeros(length(ind),3);
[coor(:,1),coor(:,2),coor(:,3)]=ind2sub(sz,ind);

krnl=[];
for i=-1:1
    for j=-1:1
        for k=-1:1
            if ~(i==0 & j==0 & k==0)
                krnl=[krnl,[i;j;k]];
            end
        end
    end
end

x=repmat(coor(:,1),1,26)-repmat(krnl(1,:),length(ind),1);
y=repmat(coor(:,2),1,26)-repmat(krnl(2,:),length(ind),1);
z=repmat(coor(:,3),1,26)-repmat(krnl(3,:),length(ind),1);

ind_ngh=sub2ind(sz,x,y,z);
ind_surf=[];
for i=1:length(ind)
    if ~all(vol(ind_ngh(i,:)))
        ind_surf=[ind_surf,ind(i)];
    end
end
