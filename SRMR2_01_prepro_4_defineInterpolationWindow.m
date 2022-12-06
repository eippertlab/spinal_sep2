% Author: Birgit Nierula 
% nierula@cbs.mpg.de
%% Define individual interpolation windows

srmr_nr = 2;
ana_dir = '/data/pt_02151/';
bids_dir = '/data/p_02151/SRMR2_experiment/bids/';
cfg_path =  [ana_dir 'analysis/manuscript_sep/scripts/cfg_srmr2/']; % here is important info for the analysis
% Add paths
addpath('/data/pt_02068/toolboxes/eeglab14_1_2b/')
addpath(genpath('/data/pt_02068/analysis/manuscript_sep/scripts/functions/'))
% Start EEGLab
eeglab; 
close

n_subjects = 24;

for subject = 1:n_subjects
    out  = prepro_defineInterpolWindow(subject, srmr_nr, bids_dir);
    interpol_window.columNames = {'subject_id' 'cervical_start' 'cervical_end' 'lumbar_start' 'lumbar_end'};
    interpol_window.x(subject, :) = out;
end

save([cfg_path 'interpolation_window.mat'], 'interpol_window')