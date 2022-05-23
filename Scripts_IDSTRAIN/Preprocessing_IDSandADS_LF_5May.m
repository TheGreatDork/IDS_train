%% Script to preprocess and compute coherence - May 5th Laura. 

clear all;clc;

%% Add paths
pathhome='/Users/laura/Documents/IDSTRAINDATA'; %add here your path
addpath(genpath(pathhome));
addpath '/Users/laura/Documents/fieldtrip-20211001'
ft_defaults

%% reading EEG data
subj={'1', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19'};

s=1; %select subject
cfg = [];
cfg.dataset                 = [pathhome,'/subj',subj{1,s},'/00',subj{1,s},'.eeg']; 
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = 'S 20'; % trigger for ADS
cfg.trialdef.prestim        = -0.123; % in seconds
cfg.trialdef.poststim       = 501.863; % in seconds, L: changed from 505 to the accurate time
%cfg.trialdef.poststim       = 400,74; % in seconds, Subject16 and Subject18
cfg = ft_definetrial(cfg);

cfg.reref                = 'yes';
cfg.channel              = 'EEG';
cfg.refchannel           = {'M2'};
cfg.lpfilter             = 'yes';
cfg.lpfreq               = 30;
data = ft_preprocessing(cfg);



% %% ICA
% cfg = [];
% cfg.channel = 'EEG';
% cfg.method = 'fastica';
% ic_data = ft_componentanalysis(cfg,data);
% 
% cfg = [];
% cfg.viewmode = 'component';
% cfg.continuous = 'yes';
% cfg.blocksize = 60;
% cfg.layout   = 'easycapM1.lay'
% %cfg.channels = [1:10];
% ft_databrowser(cfg,ic_data);
% 
% %Reject the component
% cfg = []
% cfg.component = [2];
% data_post_ica = ft_rejectcomponent(cfg, ic_data); % probably the output should be 'data'

%% Reading audio data

Fs=44100;
%lag = 100;  % for example, later we will use the real lag
audio=[];
audio_sample=[];
trial_resample=[];
trial_resample_hp=[];

y=[];amp=[];
file=fullfile('ADS_Final.wav');
y=audioread(file);
t=1/Fs:1/Fs:size(y,1)/Fs;

% extracting the envelop
M=hilbert(y); 
amp=abs(M);

% create fieldtrip structure for audio
audio_file=[];
S = ['Audio','ADS'];
audio_file.label=cellstr(S);
audio_file.fsample=Fs;
audio_file.trial{1,1}=amp';
audio_file.time{1,1}= t;

% resampling audio from 44.1 kHz -> 1 kHz
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

%% Add audio to data

cfg=[];
cfg.channel={'EEG'};
data_1=ft_selectdata(cfg,data);

data_1.label{end+1,1}='Audio';
data_1.trial{1}(end+1,1:(length(audio.time{1,1})))=audio.trial{1,1};

%% small segments of 2 seconds overlapping 1 second

windowlen=5000; %I have changed the window - May 5th 
noverlap=2500; %I have changed the overlapping - May 5th 
nsamples = [];
data_audio_segm=[];
count=1;
Fdata=[];Faudio=[];
nchan = length(data_1.label);
data_audio_segm = [];
trigcodes = [];

nsamples=length(data_1.trial{1});
winstart=1;
while (winstart+windowlen < nsamples)
    data_audio_segm.trial{1,count}(:,1:windowlen)= data_1.trial{1,1}(:,winstart:winstart+windowlen-1);
    data_audio_segm.time{1,count}= linspace(0,1,windowlen);
    trigcodes = [trigcodes data_1.trialinfo(1)];
    count=count+1;
    winstart=winstart+windowlen/2; %overlap by half windowlen
end
data_audio_segm.label=data_1.label;
data_audio_segm.fsample=data_1.fsample;

for i=1:length(data_audio_segm.trial)
a(i,1)=mean(data_audio_segm.trial{i}(17,:));
end
tokeep =find(a);

cfg=[];
cfg.trials=tokeep';
data_segm=ft_selectdata(cfg,data_audio_segm);

%% artifact rejection
cfg          = [];
cfg.method   = 'summary';%Select z-scores in trials
cfg.metric  = 'zvalue';
cfg.channel     = {'all' '-Audio'};
%cfg.keeptrial = 'yes';
[data_clean]        = ft_rejectvisual(cfg,data_segm); 

data_segm.trial(:,data_clean.bad_trials)=[];
data_segm.time(:,data_clean.bad_trials)=[];

%% Save the data before computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_conn'],'data_segm')

clear all;clc;
%% Reading audio data

Fs=44100;
%lag = 100;  % for example, later we will use the real lag
audio=[];
audio_sample=[];
trial_resample=[];
trial_resample_hp=[];

y=[];amp=[];
file=fullfile('ADS_Final.wav');
y=audioread(file);
t=1/Fs:1/Fs:size(y,1)/Fs;

% extracting the envelop
M=hilbert(y); 
amp=abs(M);

% create fieldtrip structure for audio
audio_file=[];
S = ['Audio','ADS'];
audio_file.label=cellstr(S);
audio_file.fsample=Fs;
audio_file.trial{1,1}=amp';
audio_file.time{1,1}= t;

% resampling audio from 44.1 kHz -> 1 kHz
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

%% Add audio to data

cfg=[];
cfg.channel={'EEG'};
data_1=ft_selectdata(cfg,data);

data_1.label{end+1,1}='Audio';
data_1.trial{1}(end+1,1:(length(audio.time{1,1})))=audio.trial{1,1};

%% small segments of 2 seconds overlapping 1 second

windowlen=5000; %I have changed the window - May 5th 
noverlap=2500; %I have changed the overlapping - May 5th 
nsamples = [];
data_audio_segm=[];
count=1;
Fdata=[];Faudio=[];
nchan = length(data_1.label);
data_audio_segm = [];
trigcodes = [];

nsamples=length(data_1.trial{1});
winstart=1;
while (winstart+windowlen < nsamples)
    data_audio_segm.trial{1,count}(:,1:windowlen)= data_1.trial{1,1}(:,winstart:winstart+windowlen-1);
    data_audio_segm.time{1,count}= linspace(0,1,windowlen);
    trigcodes = [trigcodes data_1.trialinfo(1)];
    count=count+1;
    winstart=winstart+windowlen/2; %overlap by half windowlen
end
data_audio_segm.label=data_1.label;
data_audio_segm.fsample=data_1.fsample;

for i=1:length(data_audio_segm.trial)
a(i,1)=mean(data_audio_segm.trial{i}(17,:));
end
tokeep =find(a);

cfg=[];
cfg.trials=tokeep';
data_segm=ft_selectdata(cfg,data_audio_segm);

%% artifact rejection
cfg          = [];
cfg.method   = 'summary';%Select z-scores in trials
cfg.metric  = 'zvalue';
cfg.channel     = {'all' '-Audio'};
%cfg.keeptrial = 'yes';
[data_clean]        = ft_rejectvisual(cfg,data_segm); 

data_segm.trial(:,data_clean.bad_trials)=[];
data_segm.time(:,data_clean.bad_trials)=[];

%% Save the data before computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_conn'],'data_segm')


%% reading EEG data
subj={'1', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19'};

s=1; %select subject
cfg = [];
cfg.dataset                 = [pathhome,'/subj',subj{1,s},'/00',subj{1,s},'.eeg']; 
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = 'S 10'; % trigger for ADS
cfg.trialdef.prestim        = -0.123; % in seconds
cfg.trialdef.poststim       = 501.863; % in seconds, L: changed from 505 to the accurate time
%cfg.trialdef.poststim       = 400,74; % in seconds, Subject16 and Subject18
cfg = ft_definetrial(cfg);

cfg.reref                = 'yes';
cfg.channel              = 'EEG';
cfg.refchannel           = {'M2'};
cfg.lpfilter             = 'yes';
cfg.lpfreq               = 30;
data = ft_preprocessing(cfg);



% %% ICA
% cfg = [];
% cfg.channel = 'EEG';
% cfg.method = 'fastica';
% ic_data = ft_componentanalysis(cfg,data);
% 
% cfg = [];
% cfg.viewmode = 'component';
% cfg.continuous = 'yes';
% cfg.blocksize = 60;
% cfg.layout   = 'easycapM1.lay'
% %cfg.channels = [1:10];
% ft_databrowser(cfg,ic_data);
% 
% %Reject the component
% cfg = []
% cfg.component = [2];
% data_post_ica = ft_rejectcomponent(cfg, ic_data); % probably the output should be 'data'

%% Reading audio data

Fs=44100;
%lag = 100;  % for example, later we will use the real lag
audio=[];
audio_sample=[];
trial_resample=[];
trial_resample_hp=[];

y=[];amp=[];
file=fullfile('ADS_Final.wav');
y=audioread(file);
t=1/Fs:1/Fs:size(y,1)/Fs;

% extracting the envelop
M=hilbert(y); 
amp=abs(M);

% create fieldtrip structure for audio
audio_file=[];
S = ['Audio','ADS'];
audio_file.label=cellstr(S);
audio_file.fsample=Fs;
audio_file.trial{1,1}=amp';
audio_file.time{1,1}= t;

% resampling audio from 44.1 kHz -> 1 kHz
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

%% Add audio to data

cfg=[];
cfg.channel={'EEG'};
data_1=ft_selectdata(cfg,data);

data_1.label{end+1,1}='Audio';
data_1.trial{1}(end+1,1:(length(audio.time{1,1})))=audio.trial{1,1};

%% small segments of 2 seconds overlapping 1 second

windowlen=5000; %I have changed the window - May 5th 
noverlap=2500; %I have changed the overlapping - May 5th 
nsamples = [];
data_audio_segm=[];
count=1;
Fdata=[];Faudio=[];
nchan = length(data_1.label);
data_audio_segm = [];
trigcodes = [];

nsamples=length(data_1.trial{1});
winstart=1;
while (winstart+windowlen < nsamples)
    data_audio_segm.trial{1,count}(:,1:windowlen)= data_1.trial{1,1}(:,winstart:winstart+windowlen-1);
    data_audio_segm.time{1,count}= linspace(0,1,windowlen);
    trigcodes = [trigcodes data_1.trialinfo(1)];
    count=count+1;
    winstart=winstart+windowlen/2; %overlap by half windowlen
end
data_audio_segm.label=data_1.label;
data_audio_segm.fsample=data_1.fsample;

for i=1:length(data_audio_segm.trial)
a(i,1)=mean(data_audio_segm.trial{i}(17,:));
end
tokeep =find(a);

cfg=[];
cfg.trials=tokeep';
data_segm=ft_selectdata(cfg,data_audio_segm);

%% artifact rejection
cfg          = [];
cfg.method   = 'summary';%Select z-scores in trials
cfg.metric  = 'zvalue';
cfg.channel     = {'all' '-Audio'};
%cfg.keeptrial = 'yes';
[data_clean]        = ft_rejectvisual(cfg,data_segm); 

data_segm.trial(:,data_clean.bad_trials)=[];
data_segm.time(:,data_clean.bad_trials)=[];

%% Save the data before computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'ADS_conn'],'data_segm')

%% Same script for IDS. 

%% Add paths
pathhome='/Users/laura/Documents/IDSTRAINDATA'; %add here your path
addpath(genpath(pathhome));
addpath '/Users/laura/Documents/fieldtrip-20211001'
ft_defaults

%% reading EEG data
subj={'1', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '17', '18', '19'};

s=1; %select subject
cfg = [];
cfg.dataset                 = [pathhome,'/subj',subj{1,s},'/00',subj{1,s},'.eeg']; 
cfg.trialdef.eventtype      = 'Stimulus';
cfg.trialdef.eventvalue     = 'S 10'; % trigger for ADS
cfg.trialdef.prestim        = -0.123; % in seconds
cfg.trialdef.poststim       = 501.863; % in seconds, L: changed from 505 to the accurate time
%cfg.trialdef.poststim       = 400,74; % in seconds, Subject16 and Subject18
cfg = ft_definetrial(cfg);

cfg.reref                = 'yes';
cfg.channel              = 'EEG';
cfg.refchannel           = {'M2'};
cfg.lpfilter             = 'yes';
cfg.lpfreq               = 30;
data = ft_preprocessing(cfg);



% %% ICA
% cfg = [];
% cfg.channel = 'EEG';
% cfg.method = 'fastica';
% ic_data = ft_componentanalysis(cfg,data);
% 
% cfg = [];
% cfg.viewmode = 'component';
% cfg.continuous = 'yes';
% cfg.blocksize = 60;
% cfg.layout   = 'easycapM1.lay'
% %cfg.channels = [1:10];
% ft_databrowser(cfg,ic_data);
% 
% %Reject the component
% cfg = []
% cfg.component = [2];
% data_post_ica = ft_rejectcomponent(cfg, ic_data); % probably the output should be 'data'

%% Reading audio data

Fs=44100;
%lag = 100;  % for example, later we will use the real lag
audio=[];
audio_sample=[];
trial_resample=[];
trial_resample_hp=[];

y=[];amp=[];
file=fullfile('IDS_Hypo_Final.wav');
y=audioread(file);
t=1/Fs:1/Fs:size(y,1)/Fs;

% extracting the envelop
M=hilbert(y); 
amp=abs(M);

% create fieldtrip structure for audio
audio_file=[];
S = ['Audio','IDS'];
audio_file.label=cellstr(S);
audio_file.fsample=Fs;
audio_file.trial{1,1}=amp';
audio_file.time{1,1}= t;

% resampling audio from 44.1 kHz -> 1 kHz
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

%% Add audio to data

cfg=[];
cfg.channel={'EEG'};
data_1=ft_selectdata(cfg,data);

data_1.label{end+1,1}='Audio';
data_1.trial{1}(end+1,1:(length(audio.time{1,1})))=audio.trial{1,1};

%% small segments of 2 seconds overlapping 1 second

windowlen=5000; %I have changed the window - May 5th 
noverlap=2500; %I have changed the overlapping - May 5th 
nsamples = [];
data_audio_segm=[];
count=1;
Fdata=[];Faudio=[];
nchan = length(data_1.label);
data_audio_segm = [];
trigcodes = [];

nsamples=length(data_1.trial{1});
winstart=1;
while (winstart+windowlen < nsamples)
    data_audio_segm.trial{1,count}(:,1:windowlen)= data_1.trial{1,1}(:,winstart:winstart+windowlen-1);
    data_audio_segm.time{1,count}= linspace(0,1,windowlen);
    trigcodes = [trigcodes data_1.trialinfo(1)];
    count=count+1;
    winstart=winstart+windowlen/2; %overlap by half windowlen
end
data_audio_segm.label=data_1.label;
data_audio_segm.fsample=data_1.fsample;

for i=1:length(data_audio_segm.trial)
a(i,1)=mean(data_audio_segm.trial{i}(17,:));
end
tokeep =find(a);

cfg=[];
cfg.trials=tokeep';
data_segm=ft_selectdata(cfg,data_audio_segm);

%% artifact rejection
cfg          = [];
cfg.method   = 'summary';%Select z-scores in trials
cfg.metric  = 'zvalue';
cfg.channel     = {'all' '-Audio'};
%cfg.keeptrial = 'yes';
[data_clean]        = ft_rejectvisual(cfg,data_segm); 

data_segm.trial(:,data_clean.bad_trials)=[];
data_segm.time(:,data_clean.bad_trials)=[];

%% Save the data before computing coherence

save ([pathhome,'/subj',subj{1,s},'/',subj{1,s},'IDS_conn'],'data_segm')

