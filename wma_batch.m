function wma_batch(OperationList,InputParameter)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com

h = waitbar(0,'Calculating, please wait...');

for i=1:length(OperationList)
    waitbar(i / length(OperationList));  
    start_time = get_disp(OperationList{i},'start');
    wma_kernel(OperationList{i},InputParameter);
    get_disp(OperationList{i},'over',start_time);
end
close(h)
end

function start_time = get_disp(OperationTag,tag,start_time)
Operation_name = get_name(OperationTag);
if nargin<3
    start_time = '';
end
if strcmp(tag,'start')
    start_time = now;
    disp([Operation_name '  Start at ' datestr(start_time,15)]);
end
if strcmp(tag,'over')
    end_time = now;
    last_time = end_time-start_time;
    disp([Operation_name '  Over at ' datestr(end_time,15) ' and Last ' datestr(last_time,15)]);
end
end

function name = get_name(OperationTag)
switch upper(OperationTag)
    case 'EPIDICOMTONIFTI' %EPI Dicom to Nifti
        name = 'EPI: Dicom to Nifti';
    case 'T1DICOMTONIFTI' %T1DicomToNifti
        name = 'T1: Dicom to Nifti';
    case 'REMOVEFIRSTTIMEPOINTS' %Remove First Time Points
        name = 'EPI: Remove first n time points';
    case 'SLICETIMING' %Slice Timing
        name = 'EPI: Slice timing';
    case 'REALIGN' %Realign
        name = 'EPI: Realign';
    case 'REGRESSOUTCOVARIATES' %RegressOutCovariates
        name = 'EPI: Regress out covariates';
    case 'REORIENTT1BEFORECOREG' %ReorientT1BeforeCoreg
        name = 'T1: Reorient T1';
    case 'BET'
        name = 'T1: Bet';
    case 'COREGISTERBET'
        name = 'T1: Coregister';
    case 'NEWSEGMENT'
        name = 'T1: New Segment';
    case 'FUNWHITEMATTER'
        name = 'EPI: Apply white mask to EPI';
    case 'NORMALIZE_DARTEL'
        name = 'EPI: Normalize by DARTEL using T1 new segment';
    case 'GROUP_WMMASK'
        name = 'Get group white mask';
    case 'SMOOTH' %Smooth
        name = 'EPI: Smooth';
    case 'DETREND' %Detrend
        name = 'EPI: Detrend';
    case 'FILTER' %Filter
        name = 'EPI: Filter';
end
end