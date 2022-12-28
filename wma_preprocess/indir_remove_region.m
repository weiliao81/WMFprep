function indir_remove_region(indir_file,otdir_file,region_file)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com
fun_mkdir(otdir_file);
[region_data,region_voxdim] = rp_readfile(region_file);
[data,voxdim,head] = rp_readfile(indir_file);
if voxdim~=region_voxdim
    disp(['dimension of nifiy: ' fun_str(voxdim) '¡Ù' 'dimension of mask: ' fun_str(region_voxdim)]);
    disp('strat resliced template');
    region_data_tmp = fun_resliceimg(region_file,'',voxdim,0,indir_file); %revised by Jiawei Sun 220831
end
data(region_data_tmp~=0) = 0;
rp_WriteNiftiImage(data,head,otdir_file);
end

