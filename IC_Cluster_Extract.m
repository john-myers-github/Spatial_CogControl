%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ICA Activations from Cluster: Extracts Independent Component Time Series from Corresponding Clusters 
%   Across Subjects and Conditions
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Establish the Main Directory %%

maindir = 'I:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';

%% Identify Subjects in Each Cluster (predetermined during clustering) %% 

Cluster(1).subject = {'590' '591' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '725'  '731' '732'  '733'  '734'  '736' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'PK' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(2).subject = {'583' '585' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725' '731' '732' '734' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'NJ' 'RM' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(3).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '717' '720' '724' '725'  '731' '732'  '733' '734'  '736'  'AE' 'AF' 'CH'  'JL' 'JM' 'KC' 'KM' 'LF' 'MS'  'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'ZU'};
Cluster(4).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '714' '715' '716' '717' '720' '724' '725'  '731' '732'  '733' '734' '736' 'AE' 'AF' 'CH' 'DQ'  'JF' 'JL' 'JM' 'KC' 'KM' 'MS'  'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(5).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '665' '681' '690' '707' '710' '714' '715' '717' '720' '724' '725'  '731' '732'  '733' '734'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(6).subject = {'585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '720' '724' '725'  '731'  '733' '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'KM' 'MS' 'NJ' 'PK' 'RM' 'SB' 'SS' 'WB'};
Cluster(7).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725'  '731'  '732'  '733'  '734'  '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(8).subject = {'585' '590' '591' '594' '657' '659' '665' '710' '712' '714' '716' '717' '731'  '732'  '733' '736'  'AE' 'AF' 'CH' 'PK' 'RN' 'SS' 'WB'};

%% Define Conditions %%

condition1 = {'_50C','_50IC'};
condition2 = {'_C','_IC'};
subj = 1;

%% Initialize EEGLAB %%
% [ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%% Load Dataset from Each Condition and Extract Subject IC Activation %%

for c = 1:size(Cluster, 2) % loop through each cluster
    for subj = 1:size(Cluster(c).subject, 2) % loop through each subject
        subjectid = [Cluster(c).subject{subj}];
        subfield  = ['s', subjectid];
        
        %% Condition 1 %%
        EEG = pop_loadset('filename',[subjectid, '_50C', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 1
%       [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);        
        ic_index1 = STUDY.cluster(c+2).comps(subj); % find component number corresponding to each subject
        ic_data1 = EEG.icaact(ic_index1, :, :); % IC data vector
        cog_control_data(c).cluster(1).(subfield) = ic_data1;
        
        %% Condition 2 %%
        EEG = pop_loadset('filename',[subjectid, '_50C', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 2
%       [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);        
        ic_index2 = STUDY.cluster(c+2).comps(subj); % find component number corresponding to each subject
        ic_data2 = EEG.icaact(ic_index2, :, :); % IC data vector
        cog_control_data(c).cluster(2).(subfield) = ic_data2;

       %% Condition 3 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 3
%       [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);        
        ic_index3 = STUDY.cluster(c+2).comps(subj); % find component number corresponding to each subject
        ic_data3 = EEG.icaact(ic_index3, :, :); % IC data vector
        cog_control_data(c).cluster(3).(subfield) = ic_data3;

        %% Condition 4 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 4
%       [ALLEEG, EEG, CURRENTSET] = eeg_store(ALLEEG, EEG, 0);        
        ic_index4 = STUDY.cluster(c+2).comps(subj); % find component number corresponding to each subject
        ic_data4 = EEG.icaact(ic_index4, :, :); % IC data vector
        cog_control_data(c).cluster(4).(subfield) = ic_data4;
        
    end
    subj = 1; % reinitialize subjects
end

disp('ITS DONE!!!');