function infodr_reorient_t1(t1_indir,QC_otdir,ReorientMat_otdir)
%Data Processing Assistant for Resting-State fMRI (DPARSF) Advanced Edition (alias: DPARSFA) GUI by YAN Chao-Gan
%-----------------------------------------------------------
%	Copyright(c) 2009; GNU GENERAL PUBLIC LICENSE
%   The Nathan Kline Institute for Psychiatric Research, 140 Old Orangeburg Road, Orangeburg, NY 10962; 
%   Child Mind Institute, 445 Park Avenue, New York, NY 10022; 
%   The Phyllis Green and Randolph Cowen Institute for Pediatric Neuroscience, New York University Child Study Center, New York, NY 10016
%	State Key Laboratory of Cognitive Neuroscience and Learning, Beijing Normal University
%	Written by YAN Chao-Gan
%	http://rfmri.org/DPARSF
% $mail     =ycg.yan@gmail.com
%-----------------------------------------------------------
% 	Mail to Author:  <a href="ycg.yan@gmail.com">YAN Chao-Gan</a> 

% Begin initialization code - DO NOT EDIT
% Do not need parfor
% First check which kind of T1 image need to be applied
% Revised by Sun Jia-Wei 210816
sub_lst = dir_NameList(t1_indir);
fun_mkdir(ReorientMat_otdir);
%Reorient
for i=1:length(sub_lst)
    sub_nam = sub_lst{i};
    sub_pth = [t1_indir filesep sub_nam];
    fprintf('Reorienting T1 Image Interactively for %s: \n',sub_lst{i});
    sub_crop_nam = fun_get_pth_regexp(sub_pth,'(^co|crop)\w*(.nii|.img)$');
    sub_crop_pth = [sub_pth filesep sub_crop_nam];
    global rp_spm_image_Parameters
    rp_spm_image_Parameters.ReorientFileList={[sub_crop_pth ',1']};
    uiwait(rp_spm_image('init',sub_crop_pth));
    mat=rp_spm_image_Parameters.ReorientMat;

    % YAN Chao-Gan 131126. Save the QC scores and comments
    QCScore(i,1) = rp_spm_image_Parameters.QCScore;
    QCComment{i,1} = rp_spm_image_Parameters.QCComment;

    save([ReorientMat_otdir,filesep,sub_lst{i},'_ReorientT1ImgMat.mat'],'mat')
    clear global rp_spm_image_Parameters
    fprintf('Reorienting T1 Image Interactively for %s: OK\n',sub_lst{i});
end


%Write the QC information as {WorkDir}/QC/RawT1ImgQC.tsv
fun_mkdir(QC_otdir);
fid = fopen([QC_otdir,filesep,'RawT1ImgQC.tsv'],'w');

fprintf(fid,'Subject ID');
fprintf(fid,['\t','QC Score']);
fprintf(fid,['\t','QC Comment']);
fprintf(fid,'\n');
for i=1:length(sub_lst)
    fprintf(fid,'%s',sub_lst{i});
    fprintf(fid,'\t%g',QCScore(i,1));
    fprintf(fid,'\t%s',QCComment{i,1});
    fprintf(fid,'\n');
end
fclose(fid);


end