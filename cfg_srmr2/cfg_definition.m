% Author: Birgit Nierula
% nierula@cbs.mpg.de

%% cfg definition
% this file defines important analysis parameters.

%% sampling rate
srate_ica = 250;
srate_rpeak = 5000;

%% interpolation window - just for R-peak detection!!
interpol_window_rpeak = [-1.5 1.5];

%% interpolation window
% eeg 
interpol_window = [-1.5 4]; % same window Tilman used

% filtering
bp_ica = [0.5 45];
notch_freq = [48 52];
esg_bp_freq = [30 400];
other_hp_freq = [10 400]; % eng and emg
esg_bp_late = [5 400]; % filter for late potentials

% included subjects
subjects = 1:24; 

% epochs
iv_epoch = [-200 300]; % in ms
iv_baseline = [-100 -10]; %in ms

%% excluded channels
% spectrum in lumbar electrodes often off when a few or many big heart
% artifacts remained in the data, especially at AL. AC is also often
% off in the spectrum (could be due to swallowing or remaining heart
% artifacts)
    % subject  condition  block channel
esg_removedChans = {
    'sub-004' 'tib_mixed' '1' 'S33' % spectrum of S33 completely off
    'sub-004' 'tib_mixed' '1' 'L4' % spectrum of L4 completely off
    'sub-022' 'tib_digits' '4' 'S34' % bad chaennel - spectrum completely off troughout the block
    'sub-022' 'tib_digits' '4' 'S36' % bad chaennel - spectrum completely off at the end of the block
    'sub-022' 'tib_mixed' '1' 'S31' % bad chaennel - spectrum completely off
    'sub-022' 'tib_mixed' '1' 'S34' % bad chaennel - spectrum completely off
    };

save('/data/pt_02151/analysis/final/scripts/cfg_srmr2/cfg.mat', 'srate_ica',...
    'srate_rpeak', 'interpol_window_rpeak', 'interpol_window', ...
    'bp_ica', 'notch_freq', 'esg_bp_freq', 'esg_bp_late', 'subjects', 'iv_epoch', 'iv_baseline',...
    'esg_removedChans', 'other_hp_freq')
