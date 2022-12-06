% Birgit Nierula 
% nierula@cbs.mpg.de

%% SRMR2: Import data from BIDS folder
% This script 
% 1) imports all stimulation stimulation blocks from the bids folder
% 2) removes the stimulus artifact iv: -1.5 to 1.5 ms
% 3) downsamples the signal to 5000 Hz
% 4) exclude all channels and saves only ECG channel


%% Prep
srmr_nr = 2;
ana_dir = '/data/pt_02151/';
cfg_path =  [ana_dir 'analysis/manuscript_sep/scripts/cfg_srmr2/']; % here is important info for the analysis
% Add paths
addpath('/data/pt_02068/toolboxes/eeglab14_1_2b/')
addpath(genpath('/data/pt_02068/analysis/manuscript_sep/scripts/functions/'))
bids_dir = '/data/p_02151/SRMR2_experiment/bids/';
% Start EEGLab
eeglab; 
close

n_subjects = 24;

for subject = 1:n_subjects
    
    % set environment variables and add paths
    subject_id = sprintf('sub-%03i', subject);
    raw_path = [bids_dir subject_id '/eeg/']; % here is the raw data for this subject in eeglab format     
    analysis_path = [ana_dir 'analysis/final/tmp_data/' subject_id '/'];
    if ~exist(analysis_path, 'dir')
        mkdir(analysis_path)
    end

    
    %% ===== 1) load data =============
    
    % define different endings for each block
    for condition = 1:5 % 1 = rest, 2 = median digits, 3 = median mixed nerve, 4 = tibial digits, 5 = tibial mixed nerve
        
        [cond_info] = get_conditionInfo(condition, srmr_nr);
        cond_name = cond_info.cond_name;
        trigger_name = cond_info.trigger_name;
        
        % get file names
        cond_files = dir([raw_path '*' cond_name '*.set']);
        nblocks = size(cond_files, 1);
        stimulation = condition - 1;
        
        % get file names
        cond_files = {fileList.name}; clear fileList

        % block counter for each of the blocks
        block_counter = 0;

        
        for aFileNumber = 1:size(cond_files, 2)

            block_counter = block_counter +1;

            %% ===== load data =============
            cnt = pop_loadset('filename', cond_files{aFileNumber}, 'filepath', raw_path);
            
            % change event latencies to matlab convention
            if ~isempty(cnt.event)
                for ievent = 1:size(cnt.event, 2)
                    cnt.event(ievent).latency = cnt.event(ievent).latency + 1;
                end
            end

            %% ===== 2) remove stimulus artefact =============
            remove_stimart = true;
            
            if remove_stimart
                if stimulation ~= 0
                    % interpolate stimulus artefact
                    load([cfg_path 'cfg.mat'], 'interpol_window_rpeak') %[-1.5 1.5]
                    cnt = prepro_removeStimArtefact(cnt, trigger_name, interpol_window_rpeak, 1:size({cnt.chanlocs.labels}, 2), 1);
                    close
                end
            end

            %% ===== 3) downsample =============
            % new sampling rate
            load([cfg_path 'cfg.mat'], 'srate_rpeak') % 5000 Hz
            cnt = pop_resample(cnt, srate_rpeak);
            cnt = eeg_checkset(cnt);
            
            %% ===== 4) select ECG channel
            [~, idx] = ismember({cnt.chanlocs.labels}, {'ECG'});
            ecg_channel = find(idx);
            cnt = pop_select(cnt, 'channel', ecg_channel);

            %% ===== 5) save =============
            fname_new = ['noStimart_sr' num2str(srate_rpeak) '_ecgChan_' cond_name '_' num2str(block_counter) '.set'];            
            cnt = pop_saveset(cnt, 'filename', fname_new, 'filepath', analysis_path);
            clear cnt
            
        end
    end

end

    
    
