%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SINGLE TRIAL ICA Coherence for Subjects Common to Cluster: Extracts Independent 
%   Component Time Series from Corresponding Clusters Across Conditions for 
%   Subjects Common to the clusters and computes Coherence (for use with Cognitive Control Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Establish the Main Directory %%
maindir = 'I:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';
% maindir = 'D:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';

%% Identify Subjects in Each Cluster (predetermined during clustering) %% 
Cluster(1).subject = {'590' '591' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '725'  '731' '732'  '733'  '734'  '736' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'PK' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(2).subject = {'583' '585' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725' '731' '732' '734' 'AE' 'AF' 'CH' 'DQ'  'JF'  'JL' 'JM' 'KC' 'KM' 'MS'  'NJ' 'RM' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(3).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '717' '720' '724' '725'  '731' '732'  '733' '734'  '736'  'AE' 'AF' 'CH'  'JL' 'JM' 'KC' 'KM' 'LF' 'MS'  'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'ZU'};
Cluster(4).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '658' '659' '665' '681' '690' '707' '710' '714' '715' '716' '717' '720' '724' '725'  '731' '732'  '733' '734' '736' 'AE' 'AF' 'CH' 'DQ'  'JF' 'JL' 'JM' 'KC' 'KM' 'MS'  'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB' 'ZU'};
Cluster(5).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '665' '681' '690' '707' '710' '714' '715' '717' '720' '724' '725'  '731' '732'  '733' '734'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(6).subject = {'585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '716' '720' '724' '725'  '731'  '733' '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'KM' 'MS' 'NJ' 'PK' 'RM' 'SB' 'SS' 'WB'};
Cluster(7).subject = {'583' '585' '590' '591' '594' '595' '631' '657' '659' '665' '681' '690' '707' '710' '712' '714' '715' '716' '717' '720' '724' '725'  '731'  '732'  '733'  '734'  '736'  'AE' 'AF' 'CH' 'DQ' 'JF' 'JL' 'JM' 'KC' 'KM' 'LF' 'MS' 'NJ' 'PK' 'RM' 'RN' 'SB' 'SS' 'WB'};
Cluster(8).subject = {'585' '590' '591' '594' '657' '659' '665' '710' '712' '714' '716' '717' '731'  '732'  '733' '736'  'AE' 'AF' 'CH' 'PK' 'RN' 'SS' 'WB'};

%% Define Clusters of Interest and Select the Subjects Common to the Clusters(script equipped for 2) %%
n_combos = 1; % set number of cluster combinations
c_1 = 1; % number of each cluster
c_2 = 2;

%% FOR 2 CLUSTERS
[subjects_common, index_c1, index_c2] = intersect(Cluster(c_1).subject, Cluster(c_2).subject); % finds and indexes subjects common to both clusters
group_name = ['common_', num2str(c_1), 'vs', num2str(c_2)];

%% FOR 7 CLUSTERS %%
subjects_common_1_7 = mintersect(Cluster(1).subject, Cluster(2).subject, Cluster(3).subject, Cluster(4).subject, Cluster(5).subject, Cluster(6).subject, Cluster(7).subject);

%% Initialize Structure %%
cog_control_cluster.(group_name) = [];

%% Specify Coherence Parameters %%
epoch = [-800 1200];
freq1 = 3;  % frequency 1 (Hz)
freq2 = 8; % frequency 2 (Hz)
wavelet_spec = [3 0.5];
n_remove = 1; 

%% Load Dataset from Each Condition and Extract Subject IC Activation %%
for c = 1:size(n_combos)
    for subj = 1:size(subjects_common_1_7, 2) % loop through each subject
        subjectid = [subjects_common_1_7{subj}];
        subfield  = ['s', subjectid];
                       
        %% RT Condition 1 %%
        EEG = pop_loadset('filename', [subjectid, '_50C', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 1
        trials_1 = size(EEG.data, 3);


        for k_1 = 1:trials_1 % Loop Through Trials Block 1 %
            latency_index = 1:2:size(EEG.event,2);
            rt_index = 2:2:size(EEG.event,2);            
            if    k_1 == trials_1 && size(rt_index, 2) < trials_1 % account for scenarios in which final RT is cut off and replace with mean to make vector length equal
                  latency_raw_1(k_1, :) = getfield(EEG.event(latency_index(k_1)), 'latency');
                  rt_raw_1(k_1,:) = mean(rt_raw_1); % this line replaces missing RT with mean
                  sub_block = [subfield, '_50C', '_C','.set'];
                  remove_trials(n_remove, :) = sub_block;
                  n_remove = n_remove + 1;
                  remove_trials = string(remove_trials);
            else
                  latency_raw_1(k_1,:) = getfield(EEG.event(latency_index(k_1)), 'latency');
                  rt_raw_1(k_1,:) = getfield(EEG.event(rt_index(k_1)), 'latency');
                  rt(k_1,:) = rt_raw_1(k_1) - latency_raw_1(k_1);
            end            
        end

        cog_control_rt(c).cluster_1vs2(1).(subfield) = rt_raw_1 - latency_raw_1;  % store single trial reaction time data 
        disp(subjectid);
        disp('CONDITION 1 COMPLETE!!');
                        
        %% RT Condition 2 %%
        EEG = pop_loadset('filename',[subjectid, '_50C', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 2
        trials_2 = size(EEG.data, 3);

        for k_2 = 1:trials_2 % Loop Through Trials Block 1 %
            latency_index = 1:2:size(EEG.event,2);
            rt_index = 2:2:size(EEG.event,2);            
            if    k_2 == trials_2 && size(rt_index, 2) < trials_2 % account for scenarios in which final RT is cut off and replace with mean to make vector length equal
                  latency_raw_2(k_2, :) = getfield(EEG.event(latency_index(k_2)), 'latency');
                  rt_raw_2(k_2,:) = mean(rt_raw_2); % this line replaces missing RT with mean
                  sub_block = [subfield, '_50C', '_IC','.set'];
                  remove_trials(n_remove, :) = sub_block;
                  n_remove = n_remove + 1;
            else
                  latency_raw_2(k_2,:) = getfield(EEG.event(latency_index(k_2)), 'latency');
                  rt_raw_2(k_2,:) = getfield(EEG.event(rt_index(k_2)), 'latency');               
            end            
        end
          
        cog_control_rt(c).cluster_1vs2(2).(subfield) = rt_raw_2 - latency_raw_2;  % store single trial reaction time data 
        disp(subjectid);
        disp('CONDITION 2 COMPLETE!!');
            
        %% RT Condition 3 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 3               
        trials_3 = size(EEG.data, 3);

        for k_3 = 1:trials_3 % Loop Through Trials Block 1 %
            latency_index = 1:2:size(EEG.event,2);
            rt_index = 2:2:size(EEG.event,2);            
            if    k_3 == trials_3 && size(rt_index, 2) < trials_3 % account for scenarios in which final RT is cut off and replace with mean to make vector length equal
                  latency_raw_3(k_3, :) = getfield(EEG.event(latency_index(k_3)), 'latency');
                  rt_raw_3(k_3,:) = mean(rt_raw_3); % this line replaces missing RT with mean
                  sub_block = [subfield, '_50IC', '_C','.set']; 
                  remove_trials(n_remove, :) = sub_block; 
                  n_remove = n_remove + 1;
            else
                  latency_raw_3(k_3,:) = getfield(EEG.event(latency_index(k_3)), 'latency');
                  rt_raw_3(k_3,:) = getfield(EEG.event(rt_index(k_3)), 'latency');               
            end            
        end
          
        cog_control_rt(c).cluster_1vs2(3).(subfield) = rt_raw_3 - latency_raw_3;  % store single trial reaction time data 
        disp(subjectid);
        disp('CONDITION 3 COMPLETE!!');
            
        %% RT Condition 4 %%
        EEG = pop_loadset('filename',[subjectid, '_50IC', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 4               
        trials_4 = size(EEG.data, 3);

        for k_4 = 1:trials_4 % Loop Through Trials Block 1 %
            latency_index = 1:2:size(EEG.event,2);
            rt_index = 2:2:size(EEG.event,2);            
            if    k_4 == trials_4 && size(rt_index, 2) < trials_4 % account for scenarios in which final RT is cut off and replace with mean to make vector length equal
                  latency_raw_4(k_4, :) = getfield(EEG.event(latency_index(k_4)), 'latency');
                  rt_raw_4(k_4,:) = mean(rt_raw_4); % this line replaces missing RT with mean
                  sub_block = [subfield, '_50IC', '_IC','.set'];
                  remove_trials(n_remove, :) = sub_block;
                  n_remove = n_remove + 1;
            else
                  latency_raw_4(k_4,:) = getfield(EEG.event(latency_index(k_4)), 'latency');
                  rt_raw_4(k_4,:) = getfield(EEG.event(rt_index(k_4)), 'latency');               
            end            
        end
          
        cog_control_rt(c).cluster_1vs2(4).(subfield) = rt_raw_4 - latency_raw_4;  % store single trial reaction time data 
        disp(subjectid);
        disp('CONDITION 4 COMPLETE!!');
        
        rt_raw_1 = []; latency_raw_1 = []; 
        rt_raw_2 = []; latency_raw_2 = [];
        rt_raw_3 = []; latency_raw_3 = [];
        rt_raw_4 = []; latency_raw_4 = [];
    end
     subj = 1; % reinitialize subjects
end

disp('.....................SAVING .CSVs.........................'); % save data to CSV structure
struct2csv(cog_control_rt.cluster_1vs2(1), '50C_C_cluster_RT.csv'); 
struct2csv(cog_control_rt.cluster_1vs2(2), '50C_IC_cluster_RT.csv');
struct2csv(cog_control_rt.cluster_1vs2(3), '50IC_C_cluster_RT.csv');
struct2csv(cog_control_rt.cluster_1vs2(4), '50IC_IC_cluster_RT.csv');
disp('ITS DONE!!!');
