function fun_addmask(indr,maskfile,ot)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
    [msk_data,msk_voxel,msk_header] = rp_readfile(maskfile);
    msk_data(msk_data>0 | msk_data<0) = 1;
    fun_mkdir(ot);
    if isdir(indr)
        map_nam = dir_NameList(indr);
        for map_num = 1 :length(map_nam)
            map_pth = [indr filesep map_nam{map_num}];
            if fun_match_nifti(map_nam{map_num})
                [map_data,map_voxel,map_header] = rp_readfile(map_pth);
                map_data(msk_data == 0) = 0;
                rp_WriteNiftiImage(map_data,map_header,[ot filesep map_nam{map_num}]);      
            end
        end
    elseif exist(indr,'file')
        [map_data,map_voxel,map_header] = rp_readfile(indr);
        if length(size(map_data)) == 3
            map_data(msk_data == 0) = 0;
            rp_WriteNiftiImage(map_data,map_header,ot);
        elseif length(size(map_data)) == 4
            [x,y,z,t] = size(map_data);
            for t_idx = 1 : length(t)
                map_data(:,:,:,t_idx) = map_data(:,:,:,t_idx).*msk_data;
            end
            rp_Write4DNIfTI(map_data,map_header,ot);
        end
    else
        disp('indir wrong!')
    end 
end