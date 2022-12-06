% Author: Birgit Nierula
% nierula@cbs.mpg.de

%% SRMR2_03_esg_analysis

clear; clc
delete(gcp('nocreate')) % clear parallel pool


%% variables that need to be changed
% step
step_number = 1;
% sampling rate
sampling_rate = 1000;
% subjects
subjects = 1:24;


%% define variables and paths
% experiment
srmr_nr = 2;
% conditions
conditions = [3 2 5 4]; % order changed so that mixed condition always comes first
disp('srmr_nr = ')
disp(srmr_nr)
disp('subjects = ')
disp(subjects)
disp('analysis loop = ')
disp(step_number)
disp('conditions = ')
disp(conditions)

% set paths
datadir = '/data/p_02151/SRMR2_experiment/analyzed_data/';
anadir = '/data/pt_02151/analysis/';
bidsdir = '/data/p_02151/SRMR2_experiment/bids/';
setenv('CFGDIR', [anadir 'manuscript_sep/scripts/cfg_srmr2/'])
    
setenv('RAWDIR', bidsdir) % here is the raw data
setenv('RPKDIR', [datadir 'Rpeak_detected/']) % here R-peak detected data (holds only ECG channel and trigger info)
setenv('ANADIR', [anadir 'final/tmp_data/']) % analysis directory
setenv('ESGDIR', [datadir 'esg/']);
setenv('EEGDIR', [datadir 'prepro_eeg_icaclean/'])
setenv('BSDIR', [datadir 'bs/']);
setenv('OTHERDIR', [datadir 'other/']);
setenv('GADIR', [datadir 'ga/']);
setenv('ZIMDIR', '/data/pt_02068/doc/LabBook_SRMR1/SRMR1/EXPERIMENT/analysis_ga/');
setenv('FIGUREPATH', [datadir 'figures/']); if ~exist(getenv('FIGUREPATH'), 'dir'), mkdir(getenv('FIGUREPATH')); end


% settings for figures
set(0, 'DefaulttextInterpreter', 'none')


% add toolboxes and other sources for scripts
addpath('/data/pt_02068/toolboxes/eeglab14_1_2b/') % eeglab toolbox
eeglab  % start eeglab and close gui
close


% scripts 
functions_path = '/data/pt_02068/analysis/manuscript_sep/scripts/functions/';
addpath(genpath(functions_path)) % scripts


switch step_number
    
    case 1
        %% separate digit conditions and save
        parfor isubject = 1:length(subjects)
            subject = subjects(isubject);
            for inerve = 1:2
                prepro_separate_sensoryConditions(subject, nerve)
                prepro_mixedLong(subject, inerve, srmr_nr)
            end
        end
    case 2
        %% save latency of all potentials (EEG, ESG, ENG,...)
        for isubject = subjects
            for inerve = 1:2
                close all
                prepro_extractSepParameters(isubject, inerve, srmr_nr);
            end
        end
        
    case  3
        %% extract latency and amplitude
        parfor icondition = 1:length(conditions)
            condition = conditions(icondition);
            ga_amplitudeAndLatency(subjects, icondition, srmr_nr);
            ga_amplitudeAndLatency_allSubjects(subjects, condition, srmr_nr);
        end
        
    case 4
        %% detection of SEPs at different levels
        for icondition = conditions
            has_allsubj = true; % subjets where no potential was visible were substituted with the amplitude at grand average latency (over all subj)
            stat_number = 1;
            ga_detection_stats(subjects, icondition, srmr_nr, stat_number, has_allsubj);
            stat_number = 2;
            ga_detection_stats(subjects, icondition, srmr_nr, stat_number, has_allsubj);
        end
        % make table
        get_detection_statsTable(conditions, srmr_nr)
        % latency
        savepath_ga = getenv('GADIR');
        for nerve = 1:2
            if srmr_nr == 2
                extension_conds = {'mixed' 'digits_d1' 'digits_d2' 'digits_d12' 'digits_d'};
            else
                extension_conds = {'mixed'};
            end
            if nerve == 1
                nerve_name = 'med';
                chan_names = {'Biceps' 'SC6' 'esg_cca' 'eeg_cca'};
            elseif nerve == 2
                nerve_name = 'tib';
                chan_names = {'Knee' 'L1' 'esg_cca' 'eeg_cca'};
            end
            for icond = 1:length(extension_conds)
                for ichan = 1:length(chan_names)
                    load([savepath_ga 'stats_group_latency_' nerve_name '_' extension_conds{icond} '_' chan_names{ichan} '.mat'])
                    lat.(nerve_name).(extension_conds{icond}).(chan_names{ichan}) = latency; 
                    clear latency
                end
            end
        end
        % check # of subjects in which potential was visible at individual level here:
        ga_latencyTable(subjects, conditions, srmr_nr)
        
    case 5
        % statistical comparison btw mixed and sensory conditions
        has_allsubj = true;
        for nerve = 1:2
            ga_mixedsensory_stats(subjects, nerve, has_allsubj)
        end
        % figure
        for nerve = 1:2
            ga_mixedsensory_figure(subjects, nerve)
        end
        
    case 6
        %% attenuation effect
        % matrix for stats
        conditions = sort(conditions);
        has_allsubj = false;
        srmr2_data4stats(subjects, conditions, has_allsubj)
        % stats and plots
        for nerve = 1:2   % 1= median, 2= tibial
            plot_attenuationeffect(subjects, nerve)
        end

     case 7
        %% SEP traces: single and double finger stimulation
        for icondition = [2 4] % only sensory conditions
            figure_spinalSEP_digits(icondition, subjects)
        end
        
    case 8
        %% preparing varables...    
        % ...for robustness analysis: all subjects included (subjects with 
        % no sensory sep use time point after mixed nerve sep for amplitude 
        % calculation (--> see step 10)
        ga_data4robustness_allsubj(subjects, conditions, srmr_nr);
        
    case 9
        %% preparing varables... 
        % ...for correlation analysis: only subjects with good sep included 
        for nerve = 1:2 % start withe median nerve conditions
            if nerve == 1
                conditions = [3 2];
            else
                conditions = [5 4];
            end

            % re-arrange data and perform binning analyses within participants and conditions:
            [amp_bin, mats_concat] = ga_data4correlation(subjects, conditions, srmr_nr);
        end
        
        %% correlation along somatosensory processing hierarchy assessed with linear mixed effects models
        % code from Tilman Stephani (stephani@cbs.mpg.de)
        % see the following R script:
        % SRMR2_LME_single_trial_analyses_R.R
    
    case 10
        %% preparing varables...    
        % ...for robustness analysis: all subjects included (subjects with 
        % no sensory sep use time point after mixed nerve sep for amplitude 
        % calculation 
        ga_data4robustness_allsubj(subjects, conditions, srmr_nr);
        
        %% robustness analysis 
        % code from Merve Kaptan (mkaptan@cbs.mpg.de)
        robustnessSEP_wrapper

    case 11
        %% replicate late potentials from srmr 1
        % same prepro but filter from 5 to 400 Hz
        % then cluster based permutation test + plots 
        for condition = [3 5] % only mixed nerve conditions
            for isubject = subjects
                is_restcontrol = false; new_ref = [];
                epo_esg{isubject} = srmr_prepro_latepotentials_esg(isubject, condition, is_restcontrol, new_ref, srmr_nr);
                is_restcontrol = true;
                epo_control{isubject} = srmr_prepro_latepotentials_esg(isubject, condition, is_restcontrol, new_ref, srmr_nr);
            end
            trials = [cellfun(@(x) x.trials, epo_esg)' cellfun(@(x) x.trials, epo_control)'];
            figure_late_seps(epo_esg, epo_control, condition)
            stats_late_seps(epo_esg, epo_control, condition, srmr_nr) % plots also the figure!
            clear epo*
        end
        
        
end

