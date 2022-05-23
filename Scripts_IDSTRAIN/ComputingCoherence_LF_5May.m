clear all

%% Add paths

restoredefaultpath

pathhome='/Users/laura/Documents/IDSTRAINDATA'; %add here your path
addpath(genpath(pathhome));
addpath '/Users/laura/Documents/fieldtrip-20211001'
ft_defaults
%% Read data
subj={'1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19', '20', '21', '22', '23', '24'};

for s=1:length(subj)

    ADS_conn = ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_conn']);
    load (ADS_conn, 'data_segm');
    
% Compute coherence. 
cfg                 = [];
cfg.output          = 'powandcsd'; % fourier
cfg.method          = 'mtmfft'; %gives the average frequency-content of the trial
cfg.taper           = 'hanning'; % hanning  dpss, raw data is windowed
cfg.pad             = 5; % I have changed the padding into the actual window.
%cfg.tapsmofrq       = 1;
cfg.foi             = 0:0.2:10; %Here I have changed the freq steps to 0.2 Hz, 5th May
cfg.keeptrials      = 'yes';
cfg.channel         = {'EEG' 'Audio'};
cfg.channelcmb      = {'EEG' 'Audio'};
freq_csd            = ft_freqanalysis(cfg, data_segm);

cfg                 = [];
cfg.method          = 'coh';
cfg.channelcmb      = {'EEG' 'Audio'};
coh_ADS                = ft_connectivityanalysis(cfg, freq_csd); %changed from conn to coh

%% Save the data after computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_coh'],'coh_ADS')

%now we do IDS 

 IDS_conn = ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'IDS_conn']);
    load (IDS_conn, 'data_segm');

    % Compute coherence. 
cfg                 = [];
cfg.output          = 'powandcsd'; % fourier
cfg.method          = 'mtmfft'; %gives the average frequency-content of the trial
cfg.taper           = 'hanning'; % hanning  dpss, raw data is windowed
cfg.pad             = 5; %I have changed the padding into the actual window.
%cfg.tapsmofrq       = 1;
cfg.foi             = 0:0.2:10; %Here I have changed the freq steps to 0.2 Hz, 5th May
cfg.keeptrials      = 'yes';
cfg.channel         = {'EEG' 'Audio'};
cfg.channelcmb      = {'EEG' 'Audio'};
freq_csd            = ft_freqanalysis(cfg, data_segm);

cfg                 = [];
cfg.method          = 'coh';
cfg.channelcmb      = {'EEG' 'Audio'};
coh_IDS                = ft_connectivityanalysis(cfg, freq_csd); %changed from conn to coh

%% Save the data after computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'IDS_coh'],'coh_IDS')

end


