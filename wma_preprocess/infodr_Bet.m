function infodr_Bet(RealignParameter_Indir,T1_Indir,T1_betdir)
%   Copyright(c) 2021
%	Written by Sun Jia-Wei 210816
% 	Mail to Authors: jiaweisun0512@163.com

sub_lst = dir_NameList(T1_Indir);
if ~isempty(gcp('nocreate'))
    parfor sub_idx = 1 : length(sub_lst)
        sub_nam = sub_lst{sub_idx};
        sub_Realign_pth = [RealignParameter_Indir filesep sub_nam];
        sub_t1_bet_file_pth = [T1_betdir filesep sub_nam];
        fun_mkdir(sub_t1_bet_file_pth);
        sub_T1_pth = [T1_Indir filesep sub_nam];

        sub_Realign_mean_nam = fun_get_pth_regexp(sub_Realign_pth,'^mean\w*(.nii|.img)$');
        sub_Realign_mean_pth = [sub_Realign_pth filesep sub_Realign_mean_nam];
        sub_Realign_mean_bet_nam = ['Bet_' sub_Realign_mean_nam];
        sub_Realign_mean_bet_pth = [sub_Realign_pth filesep sub_Realign_mean_bet_nam];
        indir_bet(sub_Realign_mean_pth, sub_Realign_mean_bet_pth, '-f 0.3');

        sub_T1_co_nam = fun_get_pth_regexp(sub_T1_pth,'(^co|crop)\w*(.nii|.img)$');
        sub_T1_pth = [sub_T1_pth filesep sub_T1_co_nam];
        sub_t1_bet_file_nam = ['Bet_' sub_T1_co_nam];
        sub_t1_bet_file_pth = [sub_t1_bet_file_pth filesep sub_t1_bet_file_nam];
        indir_bet(sub_T1_pth, sub_t1_bet_file_pth, '');
    end
else
    for sub_idx = 1 : length(sub_lst)
        sub_nam = sub_lst{sub_idx};
        sub_Realign_pth = [RealignParameter_Indir filesep sub_nam];
        sub_t1_bet_file_pth = [T1_betdir filesep sub_nam];
        fun_mkdir(sub_t1_bet_file_pth);
        sub_T1_pth = [T1_Indir filesep sub_nam];

        sub_Realign_mean_nam = fun_get_pth_regexp(sub_Realign_pth,'^mean\w*(.nii|.img)$');
        sub_Realign_mean_pth = [sub_Realign_pth filesep sub_Realign_mean_nam];
        sub_Realign_mean_bet_nam = ['Bet_' sub_Realign_mean_nam];
        sub_Realign_mean_bet_pth = [sub_Realign_pth filesep sub_Realign_mean_bet_nam];
        indir_bet(sub_Realign_mean_pth, sub_Realign_mean_bet_pth, '-f 0.3');

        sub_T1_co_nam = fun_get_pth_regexp(sub_T1_pth,'(^co|crop)\w*(.nii|.img)$');
        sub_T1_pth = [sub_T1_pth filesep sub_T1_co_nam];
        sub_t1_bet_file_nam = ['Bet_' sub_T1_co_nam];
        sub_t1_bet_file_pth = [sub_t1_bet_file_pth filesep sub_t1_bet_file_nam];
        indir_bet(sub_T1_pth, sub_t1_bet_file_pth, '');
    end
end

