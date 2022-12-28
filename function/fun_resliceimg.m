function [OutVolume,OutHead] = fun_resliceimg(in_img,ot_pth,voxel_size,hld,targetspace)
%	Copyright(c) 2021
%	Written by Sun Jia-Wei
% 	Mail to Authors:  jiaweisun0512@163.com
if ~isempty(ot_pth)
    fun_mkdir(ot_pth);
end

if isfolder(in_img)
    file_lst = dir_NameList(in_img);
    for file_idx = 1 : length(file_lst)
        file_nam = file_lst{file_idx};
        file_pth = [in_img filesep file_nam];
        fun_resliceimg(file_pth,ot_pth,voxel_size,hld,targetspace)
    end
    OutVolume = '';
    OutHead = '';
elseif isfile(in_img)
    [pthstr,namstr,extstr] = fileparts(in_img);
    if isfolder(ot_pth)
        ot_file_pth = [ot_pth filesep namstr '_rsls' '.nii'];
    else
        ot_file_pth = ot_pth;
    end
    [OutVolume,OutHead] = rp_resliceimg(in_img,ot_file_pth,voxel_size,hld,targetspace);
end
end

function [OutVolume,OutHead] = rp_resliceimg(InputFile,OutputFile,NewVoxSize,hld, TargetSpace)
% FORMAT [OutVolume] = y_ResliceImage(InputFile,OutputFile,NewVoxSize,hld, TargetSpace)
% Input:
%   InputFile - input filename
%   OutputFile - output filename
%   NewVoxSize - 1x3 matrix of new vox size.
%   hld - interpolation method. 0: Nearest Neighbour. 1: Trilinear.
%   TargetSpace - Define the target space. 'ImageItself': defined by the image itself (corresponds  to the new voxel size); 'XXX.img': defined by a target image 'XXX.img' (the NewVoxSize parameter will be discarded in such a case).
% Output:
%   OutVolume   The resliced output volume
%   And the resliced image file stored in OutputFile
%   Example: y_Reslice('D:\Temp\mean.img','D:\Temp\mean3x3x3.img',[3 3 3],1,'ImageItself')
%       This was used to reslice the source image 'D:\Temp\mean.img' to a
%       resolution as 3mm*3mm*3mm by trilinear interpolation and save as 'D:\Temp\mean3x3x3.img'.
%__________________________________________________________________________
% Written by YAN Chao-Gan 090302 for DPARSF. Referenced from spm_reslice.m in SPM5.
% State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University, China, 100875
% ycg.yan@gmail.com
%__________________________________________________________________________
% Revised by YAN Chao-Gan 100401. Fixed a bug while calculating the new dimension.
% Revised by YAN Chao-Gan 120229. Simplified the processing.
% Last Revised by YAN Chao-Gan 121214. Fixed the brain edge artifact when reslice to a bigger FOV. Apply a mask from the source image: don't extend values to outside brain.

if nargin<=4
    TargetSpace='ImageItself';
end


if ~strcmpi(TargetSpace,'ImageItself')
    [RefData, RefHead]   = rp_ReadNiftiImage(TargetSpace,1);
    mat=RefHead.mat;
    dim=RefHead.dim;
else
    [RefData, RefHead]   = rp_ReadNiftiImage(InputFile);
    origin=RefHead.mat(1:3,4);
    origin=origin+[RefHead.mat(1,1);RefHead.mat(2,2);RefHead.mat(3,3)]-[NewVoxSize(1)*sign(RefHead.mat(1,1));NewVoxSize(2)*sign(RefHead.mat(2,2));NewVoxSize(3)*sign(RefHead.mat(3,3))];
    origin=round(origin./NewVoxSize').*NewVoxSize';
    mat = [NewVoxSize(1)*sign(RefHead.mat(1,1))                 0                                   0                       origin(1)
        0                         NewVoxSize(2)*sign(RefHead.mat(2,2))              0                       origin(2)
        0                                      0                      NewVoxSize(3)*sign(RefHead.mat(3,3))  origin(3)
        0                                      0                                   0                          1      ];

    dim=(RefHead.dim-1).*diag(RefHead.mat(1:3,1:3))';
    dim=floor(abs(dim./NewVoxSize))+1;
end


[SourceData SourceHead]=rp_ReadNiftiImage(InputFile);

[x1,x2,x3] = ndgrid(1:dim(1),1:dim(2),1:dim(3));
d     = [hld*[1 1 1]' [1 1 0]'];
C = spm_bsplinc(SourceHead, d);
v = zeros(dim);

M = inv(SourceHead.mat)*mat; % M = inv(mat\SourceHead.mat) in spm_reslice.m
y1   = M(1,1)*x1+M(1,2)*x2+(M(1,3)*x3+M(1,4));
y2   = M(2,1)*x1+M(2,2)*x2+(M(2,3)*x3+M(2,4));
y3   = M(3,1)*x1+M(3,2)*x2+(M(3,3)*x3+M(3,4));


OutVolume    = spm_bsplins(C, y1,y2,y3, d);

%Revised by YAN Chao-Gan 121214. Apply a mask from the source image: don't extend values to outside brain.
tiny = 5e-2; % From spm_vol_utils.c
Mask = true(size(y1));
Mask = Mask & (y1 >= (1-tiny) & y1 <= (SourceHead.dim(1)+tiny));
Mask = Mask & (y2 >= (1-tiny) & y2 <= (SourceHead.dim(2)+tiny));
Mask = Mask & (y3 >= (1-tiny) & y3 <= (SourceHead.dim(3)+tiny));

OutVolume(~Mask) = 0;


OutHead=SourceHead;
OutHead.mat      = mat;
OutHead.dim(1:3) = dim;
if ~isempty(OutputFile)
    rp_WriteNiftiImage(OutVolume,OutHead,OutputFile);
end
end
