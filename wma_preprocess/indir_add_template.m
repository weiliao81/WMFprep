function indir_add_template(indir_file,indir_template,otdir)
[data,voxdim,header] = rp_readfile(indir_file);
[data_tmplt,voxdim_tmplt] = rp_readfile(indir_template);
if voxdim~=voxdim_tmplt
    disp(['dimension of nifiy: ' fun_str(voxdim) '¡Ù' 'dimension of template: ' fun_str(voxdim_tmplt)])
    data_tmplt = fun_resliceimg(indir_template,'',voxdim,0,indir_file);
    disp('strat resliced template')
end
data(data~=0) = 1;
data = data.*data_tmplt;
fun_mkdir(otdir);
rp_WriteNiftiImage(data,header,otdir);
end