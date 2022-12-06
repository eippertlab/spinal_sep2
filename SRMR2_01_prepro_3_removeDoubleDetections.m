% Author: Birgit Nierula 
% nierula@cbs.mpg.de

%% Remove double detections of R-peaks
%% --> to use after manual detection steps
 
srmr_nr = 2;
ana_dir = '/data/pt_02151/';
sav_dir = '/data/p_02151/SRMR2_experiment/analyzed_data/Rpeak_detected/';
cfg_path =  [ana_dir 'analysis/manuscript_sep/scripts/cfg_srmr2/']; % here is important info for the analysis
% Add paths
addpath('/data/pt_02068/toolboxes/eeglab14_1_2b/')
addpath(genpath('/data/pt_02068/analysis/manuscript_sep/scripts/functions/'))
% Start EEGLab
eeglab; 
close

n_subjects = 24;

for subject = 1:n_subjects
    
    % set path
    subject_id = sprintf('sub-%03i', subject);
    analysis_path = [ana_dir 'analysis/final/tmp_data/' subject_id '/'];
    save_path = [sav_dir subject_id '/'];

    % define different endings for each block
    for condition = 1:5 % 1 = rest, 2 = median digits, 3 = median mixed nerve, 4 = tibial digits, 5 = tibial mixed nerve
        [cond_info] = get_conditionInfo(condition, srmr_nr);
        cond_name = cond_info.cond_name;
        nblocks = cond_info.nblocks;
        
        for iblock = 1:nblocks
            
            
            %% ===== load data =============
            load([cfg_path 'cfg.mat'], 'srate_rpeak')
            file_name = ['noStimart_sr' num2str(srate_rpeak) '_rpeak_autocorrect_ecgChan_' cond_name '_' num2str(iblock) '_mancorr.set'];
            cnt = pop_loadset('filename', file_name, 'filepath', analysis_path);
            
            %% ===== remove double-detections =============
            cnt = ecg_removeDoubleDetections(cnt);
            
            %% ===== save data =============
            cnt = pop_saveset(cnt, 'filename', file_name, 'filepath', save_path);
            
        end
    end
end