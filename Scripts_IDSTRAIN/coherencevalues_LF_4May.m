%% Compute coherence. This step must be done after saving the preprocessed data.

cfg                 = [];
cfg.output          = 'powandcsd'; % fourier
cfg.method          = 'mtmfft';
cfg.taper           = 'hanning'; % hanning  dpss
cfg.pad             = 2;
%cfg.tapsmofrq       = 1;
cfg.foi          = 0:0.1:10; %Here I have changed the freq steps to 0.1 Hz
cfg.keeptrials      = 'yes';
cfg.channel         = {'EEG' 'Audio'};
cfg.channelcmb      = {'EEG' 'Audio'};
freq_csd            = ft_freqanalysis(cfg, data_segm);

cfg                 = [];
cfg.method          = 'coh';
cfg.channelcmb      = {'EEG' 'Audio'};
conn                = ft_connectivityanalysis(cfg, freq_csd);

%% Save the data after computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_conn'],'conn')

%This is for ADS. You can copy and paste, and create the one for IDS using
%the same steps. 

%% Extracting the coherence values. You can copy from here until the end of the script and create a new script if that's easier.
%% Paths
pathhome='/Users/laura/Documents/IDSTRAIN/coherence'; %add here your path
addpath(genpath(pathhome));
%% Define variables 
subj=[1 3:32]; %add here your subjects

s=1%:length(subj)
%clearvars -except pathhome subj s
%% Load data
filename=[pathhome,'/subj', num2str(subj(s)),'_ADS_conn'];
load(filename);

%% Extract coherence values individually (per subject)
%Since we go from 0 to 10 in steps on 0.1, we get the value (:) from the
%column number -> For example, to get the value 0.1 we would write (:,2). 

 m_delta_ADS = [max(ADS_conn(:, 11)) max(ADS_conn(:, 12)) max(ADS_conn(:, 13)) max(ADS_conn(:, 14)) max(ADS_conn(:, 15))...
     max(ADS_conn(:, 16)) max(ADS_conn(:, 17)) max(ADS_conn(:, 18)) max(ADS_conn(:, 19)) max(ADS_conn(:, 20))...
     max(ADS_conn(:, 21)) max(ADS_conn(:, 22)) max(ADS_conn(:, 23)) max(ADS_conn(:, 24)) max(ADS_conn(:, 25))...
     max(ADS_conn(:, 26)) max(ADS_conn(:, 27)) max(ADS_conn(:, 28)) max(ADS_conn(:, 29)) max(ADS_conn(:, 30))...
     max(ADS_conn(:, 31))];

 m_delta_IDS = [max(IDS_conn(:, 11)) max(IDS_conn(:, 12)) max(IDS_conn(:, 13)) max(IDS_conn(:, 14)) max(IDS_conn(:, 15))...
     max(IDS_conn(:, 16)) max(IDS_conn(:, 17)) max(IDS_conn(:, 18)) max(IDS_conn(:, 19)) max(IDS_conn(:, 20))...
     max(IDS_conn(:, 21)) max(IDS_conn(:, 22)) max(IDS_conn(:, 23)) max(IDS_conn(:, 24)) max(IDS_conn(:, 25))...
     max(IDS_conn(:, 26)) max(IDS_conn(:, 27)) max(IDS_conn(:, 28)) max(IDS_conn(:, 29)) max(IDS_conn(:, 30))...
     max(IDS_conn(:, 31))];
 
 %Now you can do the same for theta, just type the numbers from 31 to 51. 
 
%  %% loop para extraer todos los valores de coherencia de todos los sujetos y devolverlos a una matriz ordenada por sujetos. 
%  %De esta forma es más sencillo y rápido extraer los valores de coherencia.
% 
%  clear all; clc; 
% %% Paths
% pathhome='/Users/laura/Documents/DATOSFINALES_RhythAdults/coherence';
% addpath(genpath(pathhome));
% %% Define variables 
% subj=[1 3:32];
% 
%  for s = 1:length(subj)
%      filename=[pathhome,'/subj', num2str(subj(s)),'_coherence_speech'];
%      load(filename);
%      filename1=[pathhome,'/subj', num2str(subj(s)),'_coherence_music'];
%      load(filename1);
%      m(s,:) = [max(coh_audio_reg_spanish(:, 6)) max(coh_audio_irreg_spanish(:, 6)) max(coh_audio_mm_spanish(:, 6))...
%       max(coh_audio_reg_basque(:, 5)) max(coh_audio_irreg_basque(:, 5)) max(coh_audio_mm_basque(:, 5))...
%       max(coh_audio_music_reg_spanish(:, 6)) max(coh_audio_music_irreg_spanish(:, 6)) max(coh_audio_music_mm_spanish(:, 6))...
%       max(coh_audio_music_reg_basque(:, 5)) max(coh_audio_music_irreg_basque(:, 5)) max(coh_audio_music_mm_basque(:, 5))...
%       max(coh_audio_reg_spanish(:, 11)) max(coh_audio_irreg_spanish(:, 11)) max(coh_audio_mm_spanish(:, 11))...
%       max(coh_audio_reg_basque(:, 11)) max(coh_audio_irreg_basque(:, 11)) max(coh_audio_mm_basque(:, 11))...
%       max(coh_audio_music_reg_spanish(:, 11)) max(coh_audio_music_irreg_spanish(:, 11)) max(coh_audio_music_mm_spanish(:, 11))...
%       max(coh_audio_music_reg_basque(:, 11)) max(coh_audio_music_irreg_basque(:, 11)) max(coh_audio_music_mm_basque(:, 11))]
%    
%  end
%  
%  
%  
%      