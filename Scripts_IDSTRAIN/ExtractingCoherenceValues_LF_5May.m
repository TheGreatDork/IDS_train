
%Script to extract coherence values. Laura, May 5th. 

%% Paths
restoredefaultpath

pathhome='/Users/laura/Documents/IDSTRAINDATA'; %add here your path
addpath(genpath(pathhome));
addpath '/Users/laura/Documents/fieldtrip-20211001'
ft_defaults
restoredefaultpath

%% Define variables 
subj=[1:20]; %add here your subjects

s=1%:length(subj)
%clearvars -except pathhome subj s
%% Load data
filename=[pathhome,'/subj', num2str(subj(s)), '/', num2str(subj(s)),'ADS_coh'];
load(filename);
filename1=[pathhome,'/subj', num2str(subj(s)), '/', num2str(subj(s)),'IDS_coh'];
load(filename1);
%% Extract coherence values individually (per subject)
%Since we go from 0 to 10 in steps on 0.2, we get the value (:) from the
%column number -> For example, to get the value 0.2 we would write (:,2). 

coh_ADS = coh_ADS.cohspctrm;
coh_IDS = coh_IDS.cohspctrm;

% Delta values 

 m_delta_ADS = [max(coh_ADS(:, 1)) max(coh_ADS(:, 2)) max(coh_ADS(:, 3)) max(coh_ADS(:, 4)) max(coh_ADS(:, 5))...
     max(coh_ADS(:, 6)) max(coh_ADS(:, 7)) max(coh_ADS(:, 8)) max(coh_ADS(:, 9)) max(coh_ADS(:, 10))...
     max(coh_ADS(:, 11)) max(coh_ADS(:, 12)) max(coh_ADS(:, 13)) max(coh_ADS(:, 14)) max(coh_ADS(:, 15))...
     max(coh_ADS(:, 16)) max(coh_ADS(:, 17)) max(coh_ADS(:, 18)) max(coh_ADS(:, 19))];
 
 m_delta_IDS = [max(coh_IDS(:, 1)) max(coh_IDS(:, 2)) max(coh_IDS(:, 3)) max(coh_IDS(:, 4)) max(coh_IDS(:, 5))...
     max(coh_IDS(:, 6)) max(coh_IDS(:, 7)) max(coh_IDS(:, 8)) max(coh_IDS(:, 9)) max(coh_IDS(:, 10))...
     max(coh_IDS(:, 11)) max(coh_IDS(:, 12)) max(coh_IDS(:, 13)) max(coh_IDS(:, 14)) max(coh_IDS(:, 15))...
     max(coh_IDS(:, 16)) max(coh_IDS(:, 17)) max(coh_IDS(:, 18)) max(coh_IDS(:, 19))];

% Theta values

 m_theta_ADS = [max(coh_ADS(:, 20)) max(coh_ADS(:, 21)) max(coh_ADS(:, 22)) max(coh_ADS(:, 23)) max(coh_ADS(:, 24))...
     max(coh_ADS(:, 25)) max(coh_ADS(:, 26)) max(coh_ADS(:, 27)) max(coh_ADS(:, 28)) max(coh_ADS(:, 29))...
     max(coh_ADS(:, 30)) max(coh_ADS(:, 31)) max(coh_ADS(:, 32)) max(coh_ADS(:, 33)) max(coh_ADS(:, 34))...
     max(coh_ADS(:, 35)) max(coh_ADS(:, 36)) max(coh_ADS(:, 37)) max(coh_ADS(:, 38)) max(coh_ADS(:, 39))...
     max(coh_ADS(:, 40)) max(coh_ADS(:, 41)) max(coh_ADS(:, 42)) max(coh_ADS(:, 43)) max(coh_ADS(:, 44))...
     max(coh_ADS(:, 45)) max(coh_ADS(:, 46)) max(coh_ADS(:, 47)) max(coh_ADS(:, 48)) max(coh_ADS(:, 49))...
     max(coh_ADS(:, 50))];
 
 m_theta_IDS = [max(coh_IDS(:, 20)) max(coh_IDS(:, 21)) max(coh_IDS(:, 22)) max(coh_IDS(:, 23)) max(coh_IDS(:, 24))...
     max(coh_IDS(:, 25)) max(coh_IDS(:, 26)) max(coh_IDS(:, 27)) max(coh_IDS(:, 28)) max(coh_IDS(:, 29))...
     max(coh_IDS(:, 30)) max(coh_IDS(:, 31)) max(coh_IDS(:, 32)) max(coh_IDS(:, 33)) max(coh_IDS(:, 34))...
     max(coh_IDS(:, 35)) max(coh_IDS(:, 36)) max(coh_IDS(:, 37)) max(coh_IDS(:, 38)) max(coh_IDS(:, 39))...
     max(coh_IDS(:, 40)) max(coh_IDS(:, 41)) max(coh_IDS(:, 42)) max(coh_IDS(:, 43)) max(coh_IDS(:, 44))...
     max(coh_IDS(:, 45)) max(coh_IDS(:, 46)) max(coh_IDS(:, 47)) max(coh_IDS(:, 48)) max(coh_IDS(:, 49))...
     max(coh_IDS(:, 50))];

 filename=[pathhome,'/coherence/subj',num2str(subj(s)),'_coherence_speech'];
save(filename,'m_delta_ADS','m_delta_IDS','m_theta_ADS',' m_theta_IDS')
