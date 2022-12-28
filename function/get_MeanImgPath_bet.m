function MeanFilePath=get_MeanImgPath_bet(SubjPath_RealignParameter)
%-----------------------------------------------------------
%   Copyright(c) 2015
%	Center for Cognition and Brain Disorders, Hangzhou Normal University, Hangzhou 310015, China
%	Written by JIA Xi-Ze 201410
%	http://www.restfmri.net/
% 	Mail to Authors: jxz.rest@gmail.com, jiaxize@foxmail.com
%   Revised by Sun Jia-Wei 210816



MeanFilePath=infodr_GetIMGpath(SubjPath_RealignParameter,'Prefix','Bet');
if isempty(MeanFilePath)
    MeanFilePath=infodr_GetIMGpath(SubjPath_RealignParameter,'Prefix','mean');
end
if isempty(MeanFilePath)
    error('There is no mean* or mean * than 1 in %s',SubjPath_RealignParameter);
end

end


function OutPut=infodr_GetIMGpath(InfodrPath,Option,Parameter)
OutPut = '';
    switch Option
        case 'Prefix'
             Prefix=Parameter;
             OutPut=getpath_Prefix(InfodrPath,Prefix);
    end
end


function OutPut=getpath_Prefix(inpath,Prefix)
    if ~isdir(inpath)
        error('inpath within get_MeanImgPath is not a directory');
    end
    
    NiifileList=dir_4RegExp(inpath,[Prefix '*.nii']);
    GzfileList=dir_4RegExp(inpath,[Prefix '*.nii.gz']);
    ImgfileList=dir_4RegExp(inpath,[Prefix '*.img']);

    if (~isempty(NiifileList))&&(1==length(NiifileList))
        OutPut=[inpath filesep NiifileList{1}];
    elseif (~isempty(GzfileList))&&(1==length(GzfileList))
        OutPut=inpath_Misc([inpath filesep GzfileList{1}],'GunzipNiigzPath');
    elseif (~isempty(ImgfileList))&&(1==length(ImgfileList))
        OutPut=[inpath filesep ImgfileList{1}];    
    else
        OutPut='';
        fprintf('There is no %s in %s or more than 1\n',Prefix,inpath);
    end
end