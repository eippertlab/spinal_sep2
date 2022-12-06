% Author: Birgit Nierula
% nierula@cbs.mpg.de

%% ESG preprocessing wrapper script

clear; clc
delete(gcp('nocreate')) % clear parallel pool

%% variables that need to be changed
% loop
loop_number = 1;
disp(['loop number = ' num2str(loop_number)])
% subjects
subject_idx = 1:24; 


%% define variables and paths
% experiment
srmr_nr = 2;
% conditions
conditions = 2:5;
% subjects
subjects = 1:24;
if ~isempty(subject_idx)
    new_subjects = subjects(subject_idx);
else
    new_subjects = subjects;
end
subjects = new_subjects
% sampling rate
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
setenv('ESGDIR', [datadir 'esg/'])
setenv('BSDIR', [datadir 'bs/'])
setenv('OTHERDIR', [datadir 'other/'])
setenv('ZIMDIR', '/data/pt_02151/doc/LabBook_SRMR2/EXPERIMENT/preprocessing_ESG/');


% settings for figures
set(0, 'DefaulttextInterpreter', 'none')


% add toolboxes and other sources for scripts
addpath('/data/pt_02068/toolboxes/eeglab14_1_2b/') % eeglab toolbox
eeglab  % start eeglab and close gui
close


% scripts 
functions_path = '/data/pt_02068/analysis/manuscript_sep/scripts/functions/';
addpath(genpath(functions_path)) % scripts



%% preprocessing loops
esg_preprocessing_loops(loop_number, subjects, conditions, srmr_nr, sampling_rate)
