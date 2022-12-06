% SRMR1-script:
% edit('/data/pt_02068/analysis/final/scripts/SRMR1_02_eeg_prepro_appendedBlocks.m')
%% EEG preprocessing wrapper script

clear; clc
delete(gcp('nocreate')) % clear parallel pool

%% variables that need to be changed

% loop
loop_number = 1;
disp(['loop number = ' num2str(loop_number)])
% subject, condition, and block info
subject_idx = 1:24; 
condition_idx = 2:5;
% ica info
chan_name = 'C4';
iso_latency = [20 20 39 39];
display_time = 2; % duration (in seconds) the continuous raw and ica data of one channel are displayed on the screen



%% define variables and paths
disp(['loop number = ' num2str(loop_number)])
% experiment
srmr_nr = 2;
% conditions
conditions = 1:5;
% subjects
subjects = 1:24;

% set paths
datadir = '/data/p_02151/SRMR2_experiment/analyzed_data/';
anadir = '/data/pt_02151/analysis/';
bidsdir = '/data/p_02151/SRMR2_experiment/bids/';
setenv('CFGDIR', [anadir 'manuscript_sep/scripts/cfg_srmr2/'])

setenv('RAWDIR', bidsdir) % here is the raw data
setenv('RPKDIR', [datadir 'Rpeak_detected/']) % here R-peak detected data (holds only ECG channel and trigger info)
setenv('ANADIR', [anadir 'final/tmp_data/']) % analysis directory
setenv('EEGDIR', [datadir 'prepro_eeg_icaclean/'])
setenv('ZIMDIR', '/data/pt_02151/doc/LabBook_SRMR2/EXPERIMENT/preprocessing_EEG/');


% settings for figures
set(0, 'DefaulttextInterpreter', 'none')

% add toolboxes and other sources for scripts
addpath('/data/pt_02068/toolboxes/eeglab2019_1/') % eeglab toolbox
eeglab  % start eeglab and close gui


% all scripts are here (for both srmr experiments)
functions_path = '/data/pt_02068/analysis/manuscript_sep/scripts/functions/';
addpath(genpath(functions_path)) % scripts

eeg_preprocessing_loops(srmr_nr, loop_number, subjects, conditions, ...
    subject_idx, condition_idx, chan_name, display_time, iso_latency)
