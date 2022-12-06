% Author: Birgit Nierula
% nierula@cbs.mpg.de

%% other (ENG and EMG) preprocessing wrapper script

clear; clc
delete(gcp('nocreate')) % clear parallel pool

%% variables that need to be changed
% loop
loop_number = 1;
disp(['loop number = ' num2str(loop_number)])
% subject, condition, and block info
subject_idx = []; 
condition_idx = [];



%% define variables and paths
% experiment
srmr_nr = 2;
% conditions
conditions = 2:5;
if ~isempty(condition_idx)
    conditions = conditions(condition_idx);
end
disp('conditions:')
disp(conditions)
% subjects
subjects = 1:24;
if ~isempty(subject_idx)
    subjects = subjects(subject_idx);
end
disp('subjects:')
disp(subjects)
sampling_rate = 1000;


% set paths
datadir = '/data/p_02151/SRMR2_experiment/analyzed_data/';
anadir = '/data/pt_02151/analysis/';
bidsdir = '/data/p_02151/SRMR2_experiment/bids/';
setenv('CFGDIR', [anadir 'manuscript_sep/scripts/cfg_srmr2/'])

setenv('RAWDIR', bidsdir) % here is the raw data
setenv('RPKDIR', [datadir 'Rpeak_detected/']) % here R-peak detected data (holds only ECG channel and trigger info)
setenv('ANADIR', [anadir 'final/tmp_data/']) % analysis directory
setenv('EEGDIR', [datadir 'prepro_eeg_icaclean/'])
setenv('ESGDIR', [datadir 'esg/']);
setenv('BSDIR', [datadir 'bs/']);
setenv('OTHERDIR', [datadir 'other/']);
setenv('ZIMDIR', '/data/pt_02151/doc/LabBook_SRMR2/EXPERIMENT/preprocessing_other/');


% settings for figures
set(0, 'DefaulttextInterpreter', 'none')

% add toolboxes and other sources for scripts
addpath('/data/pt_02068/toolboxes/eeglab2019_1/') % eeglab toolbox
eeglab  % start eeglab and close guiclear
close


% all scripts are here (for both srmr experiments)
functions_path = '/data/pt_02068/analysis/manuscript_sep/scripts/functions/';
addpath(genpath(functions_path)) % scripts



other_preprocessing_loops(srmr_nr, loop_number, subjects, conditions, sampling_rate)

