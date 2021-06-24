%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   ICA Coherence for Subjects Common to Cluster: Extracts Independent 
%   Component Time Series from Corresponding Clusters Across Conditions for 
%   Subjects Common to the clusters and computes Coherence (for use with Cognitive Control Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Lisa's Data
% Establish the Main Directory %
maindir = 'D:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';

% Identify Subjects in Each Cluster (predetermined during clustering) %% 
Cluster(1).subject = {'590' '591' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '725'  '731' '732'  '733'  '734'  '736' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'PK' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(2).subject = {'583' '585' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725' '731' '732' '734' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'NJ' 'RM' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(3).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '717' '720' '724' '725'  '731' '732'  '733' '734'  '736'  'AE' 'AF' 'CH'  'JL' 'JM' 'KC' 'KM' 'LF' 'MS'  'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'ZU'};
Cluster(4).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '714' '715' '716' '717' '720' '724' '725' '731' '732' '733' '734' '736' 'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'NJ' 'PK' 'RM' 'RN' 'SS' 'WB' 'ZU'};
Cluster(5).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '665' '681' '690' '707' '710' '714' '715' '717' '720' '724' '725'  '731' '732'  '733' '734'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(6).subject = {'585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '720' '724' '725'  '731'  '733' '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'KM' 'MS' 'NJ' 'PK' 'RM' 'SS' 'WB' 'ZU'};
Cluster(7).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725'  '731'  '732'  '733'  '734'  '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(8).subject = {'585' '590' '591' '594' '657' '659' '665' '710' '712' '714' '716' '717' '731'  '732'  '733' '736'  'AE' 'AF' 'CH' 'PK' 'RN' 'SS' 'WB'};

%% Define Clusters of Interest and Select the Subjects Common to the Clusters(script equipped for 2) %%
n_combos = 1; % set number of cluster combinations
c_1 = 1; % number of each cluster
c_2 = 2;
[subjects_common, index_c1, index_c2] = intersect(Cluster(c_1).subject, Cluster(c_2).subject); % finds and indexes subjects common to both clusters
subjs = subjects_common';
group_name = ['common_', num2str(c_1), 'vs', num2str(c_2)];

%% Initialize Structure %%
cog_control_cluster.(group_name) = [];

%% Define Conditions %%
condition1 = {'_50C','_50IC'};
condition2 = {'_C','_IC'};

%% Specify Coherence Parameters %%
epoch = [-800 1200];
freq1 = 3;  % frequency 1 (Hz)
freq2 = 8; % frequency 2 (Hz)
wavelet_spec = [3 0.5];

%% Load Dataset from Each Condition and Extract Subject IC Activation %%
for c = 1:size(n_combos)
    for subj = 1:size(subjects_common, 2) % loop through each subject
        subjectid = [subjects_common{subj}];
        subfield  = ['s', subjectid];

        %% Condition 1 %%
        EEG = pop_loadset('filename',[subjectid, '_50C', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 1
        time_pnts = size(EEG.data, 2);
        EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
            % Cluster 1 %
            ic_index1a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index1a  = STUDY.cluster(c_1+2).comps(ic_index1a_);
            ic_data1a = EEG.icaact(ic_index1a, :, :); % IC data vector

            % Cluster 2 %
            ic_index1b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index1b  = STUDY.cluster(c_2+2).comps(ic_index1b_);
            ic_data1b = EEG.icaact(ic_index1b, :, :); % IC data vector
 
        cog_control_common(c).cluster_1vs2(1).(subfield) = ic_data1a;
        cog_control_common(c).cluster_1vs2(2).(subfield) = ic_data1b; 
        
        % Coherence for Condition 1 %
        [coh1, cohangle1, timesout, freqsout] = newcrossf(ic_data1a, ic_data1b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index1a ic_index1b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
        cog_control_coherence(c).cluster_1vs2(1).(subfield) = mean(coh1); 
        
%       Plot value for each condition for each subject %
%       figure('Name', ['IC Coherence - ', subfield, ' IC ', num2str(ic_index1a), ' vs. IC ', num2str(ic_index1b) ' -- 50C', '_C']); 
%       pop_newcrossf(EEG, 0, ic_index1a, ic_index1b, epoch, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index1a ic_index1b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'timesout', 400, 'padratio', 8, 'freqs', [freq1 freq2], 'maxamp', 0.5);

        %% Condition 2 %%
        EEG = pop_loadset('filename',[subjectid, '_50C', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 2              
        EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
            % Cluster 1 %
            ic_index2a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index2a  = STUDY.cluster(c_1+2).comps(ic_index2a_);
            ic_data2a = EEG.icaact(ic_index2a, :, :); % IC data vector

            % Cluster 2 %
            ic_index2b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index2b  = STUDY.cluster(c_2+2).comps(ic_index2b_);
            ic_data2b = EEG.icaact(ic_index2b, :, :); % IC data vector

        cog_control_common(c).cluster_1vs2(3).(subfield) = ic_data2a;
        cog_control_common(c).cluster_1vs2(4).(subfield) = ic_data2b; 
        
        % Coherence for Condition 2 %
        [coh2, cohangle2, timesout] = newcrossf(ic_data2a, ic_data2b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index2a ic_index2b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
        cog_control_coherence(c).cluster_1vs2(2).(subfield) = mean(coh2); 
        
%       % Plot value for each condition for each subject %
%       figure('Name', ['IC Coherence - ', subfield, ' IC ', num2str(ic_index2a), ' vs. IC ', num2str(ic_index2b) ' -- 50C', '_IC']); 
%       pop_newcrossf(EEG, 0, ic_index2a, ic_index2b, epoch, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index2a ic_index2b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'timesout', 400, 'padratio', 8, 'freqs', [freq1 freq2], 'maxamp', 0.5);
         
        %% Condition 3 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 3               
        EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);
            % Cluster 1 %
            ic_index3a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index3a  = STUDY.cluster(c_1+2).comps(ic_index3a_);
            ic_data3a = EEG.icaact(ic_index3a, :, :); % IC data vector

            % Cluster 2 %
            ic_index3b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index3b  = STUDY.cluster(c_2+2).comps(ic_index3b_);
            ic_data3b = EEG.icaact(ic_index3b, :, :); % IC data vector

        cog_control_common(c).cluster_1vs2(5).(subfield) = ic_data3a;
        cog_control_common(c).cluster_1vs2(6).(subfield) = ic_data3b;

        % Coherence for Condition 3 %
        [coh3, cohangle3, timesout] = newcrossf(ic_data3a, ic_data3b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index3a ic_index3b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
        cog_control_coherence(c).cluster_1vs2(3).(subfield) = mean(coh3); 
        
%       % Plot value for each condition for each subject %
%       figure('Name', ['IC Coherence - ', subfield, ' IC ', num2str(ic_index3a), ' vs. IC ', num2str(ic_index3b) ' -- 50C', '_IC']); 
%       pop_newcrossf(EEG, 0, ic_index3a, ic_index3b, epoch, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index3a ic_index3b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'timesout', 400, 'padratio', 8, 'freqs', [freq1 freq2], 'maxamp', 0.5);
        
        %% Condition 4 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 4               
        EEG.icaact = (EEG.icaweights*EEG.icasphere)*EEG.data(EEG.icachansind,:);    
            % Cluster 1 %
            ic_index4a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index4a  = STUDY.cluster(c_1+2).comps(ic_index4a_);
            ic_data4a = EEG.icaact(ic_index4a, :, :); % IC data vector

            % Cluster 2 %
            ic_index4b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index4b  = STUDY.cluster(c_2+2).comps(ic_index4b_);
            ic_data4b = EEG.icaact(ic_index4b, :, :); % IC data vector

        cog_control_common(c).cluster_1vs2(7).(subfield) = ic_data4a;
        cog_control_common(c).cluster_1vs2(8).(subfield) = ic_data4b;

        % Coherence for Condition 3 %
        [coh4, cohangle4, timesout] = newcrossf(ic_data4a, ic_data4b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index4a ic_index4b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
        cog_control_coherence(c).cluster_1vs2(4).(subfield) = mean(coh4); 
         
%       % Plot value for each condition for each subject %
%       figure('Name', ['IC Coherence - ', subfield, ' IC ', num2str(ic_index4a), ' vs. IC ', num2str(ic_index4b) ' -- 50C', '_IC']); 
%       pop_newcrossf(EEG, 0, ic_index4a, ic_index4b, epoch, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index4a ic_index4b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'timesout', 400, 'padratio', 8, 'freqs', [freq1 freq2], 'maxamp', 0.5);
        
    end
    subj = 1; % reinitialize subjects
end

disp('ITS DONE!!!');