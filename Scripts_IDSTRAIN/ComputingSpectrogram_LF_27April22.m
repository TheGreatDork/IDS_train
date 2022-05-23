%% This script contains all the steps to compute a spectrogram of the audio files. Change the paths and the names as needed. You need to either create another script for ADS or use this but adapting it. Save the output with the frequency labels!

filepath='/Users/laura/Documents/IDSTRAINDATA'; 
cd(filepath);

%% Read the audio .wav file
Y=[];
[Y_IDS, Fs]=audioread('IDS_Hypo_Final.wav');

%% Convert from two channels to mono
yMono_IDS = sum(Y_IDS, 2) / size(Y_IDS, 2); %This step is not normally needed, but we don't know if it was recorded with 1 or 2 channels, so it is a sanity check. 

%% resample audio
IDS_audio = [];
cfg = [];
cfg.resample = 1000;
cfg.detrend = 'no'
IDS_audio = ft_resampledata(cfg, yMono_IDS);
IDS_audio = resample(cfg,yMono_IDS);


%% Plot signals in the time domain
t=1/Fs:1/Fs:length(yMono_IDS)/Fs;
%plot(t,yMono_IDS(:,1),'b');hold on;

%% Calculate the envelope
envelope_IDS=abs(hilbert(yMono_IDS));

plot(t,envelope_IDS(:,1),'r');hold on;

xlabel(['Time [s]']);
ylabel(['Amplitude']);
title('Audio signal');

%% resampling audio to 1Khz
trial_resample =[];
cfg            = [];
cfg.resamplefs = 1000;
cfg.detrend    = 'no';
trial_resample           = ft_resampledata(cfg,audio_file);

F=[file];
audio.label{1,1}=cellstr(F);
audio.fsample=trial_resample.fsample;
audio.trial{1,1}=trial_resample.trial{1,1}; %no lag
%audio.trial{1,f}=cat(2,zeros(1,lag),trial_resample.trial{1,1}); % lag
audio.time{1,1}= trial_resample.time{1,1};
%% Compute spectogram
L = size(envelope_IDS,1); 
P_envelope_IDS = abs(abs(fft(envelope_IDS',[],2))/L);


P_envelope_IDS_1 = P_envelope_IDS(:,1:L/2+1);
P_envelope_IDS_1(:,2:end-1) = 2*P_envelope_IDS_1(:,2:end-1);

%% plot the spectrogram 
f = Fs*(0:(L/2))/L;
plot(f,P_envelope_IDS_1./max(P_envelope_IDS_1),'b');hold on; %here you can change the color for the ADS one. 
xlim([0 10]);
