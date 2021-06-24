%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   SINGLE TRIAL ICA Coherence for Subjects Common to Cluster: Extracts Independent 
%   Component Time Series from Corresponding Clusters Across Conditions for 
%   Subjects Common to the clusters and computes Coherence (for use with Cognitive Control Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Establish the Main Directory %%
% maindir = 'I:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';
maindir = 'D:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';
 
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

%% FOR 2 CLUSTERS %%
[subjects_common, index_c1, index_c2] = intersect(Cluster(c_1).subject, Cluster(c_2).subject); % finds and indexes subjects common to both clusters
group_name = ['common_', num2str(c_1), 'vs', num2str(c_2)];

%% FOR 7 CLUSTERS %%
subjects_common_1_7 = mintersect(Cluster(1).subject, Cluster(2).subject, Cluster(3).subject, Cluster(4).subject, Cluster(5).subject, Cluster(6).subject, Cluster(7).subject);

%% Specify Coherence Parameters %%
epoch = [-800 1200];
freq1 = 30;  % frequency 1 (Hz)
freq2 = 50; % frequency 2 (Hz)
wavelet_spec = [3 0.5];

%% Load Dataset from Each Condition and Extract Subject IC Activation %%
for c = 1:size(n_combos)
    for subj = 1:size(subjects_common_1_7, 2) % loop through each subject
        subjectid = [subjects_common_1_7{subj}];
        subfield  = ['s', subjectid];
               
%% CONDITION 1 %%
            EEG = pop_loadset('filename', [subjectid, '_50C', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 1
            trials_1 = size(EEG.data, 3);
        for k_1 = 1:trials_1 % Loop Through Trials Block 1 %
            % Cluster 1 %
            ic_index1a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index1a  = STUDY.cluster(c_1+2).comps(ic_index1a_);
            ic_data1a   = EEG.icaact(ic_index1a, :, k_1); % IC data vector

            % Cluster 2 %
            ic_index1b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index1b  = STUDY.cluster(c_2+2).comps(ic_index1b_);
            ic_data1b   = EEG.icaact(ic_index1b, :, k_1); % IC data vector

            cog_control_common(c).cluster_1vs2(1).(subfield) = ic_data1a;
            cog_control_common(c).cluster_1vs2(2).(subfield) = ic_data1b;

            %% Coherence for Condition 1 %%
            [coh1, cohangle1, timesout, freqsout] = newcrossf(ic_data1a, ic_data1b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index1a ic_index1b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
            input_1(k_1,:) = mean(coh1);
                           
        end
        cog_control_trials(c).cluster_1vs2(1).(subfield) = input_1;  % store single trial coherence data as 'input' 
        disp(subjectid);      
        disp('CONDITION 1 COMPLETE!!');
                        
%% CONDITION 2 %%
            EEG = pop_loadset('filename',[subjectid, '_50C', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 2
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            trials_2 = size(EEG.data, 3);

        for k_2 = 1:trials_2 % Loop Through Trials Block 2 %
            % Cluster 1 %
            ic_index2a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index2a  = STUDY.cluster(c_1+2).comps(ic_index2a_);
            ic_data2a   = EEG.icaact(ic_index2a, :, k_2); % IC data vector

            % Cluster 2 %
            ic_index2b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index2b  = STUDY.cluster(c_2+2).comps(ic_index2b_);
            ic_data2b   = EEG.icaact(ic_index2b, :, k_2); % IC data vector

            cog_control_common(c).cluster_1vs2(1).(subfield) = ic_data2a;
            cog_control_common(c).cluster_1vs2(2).(subfield) = ic_data2b;

            %% Coherence for Condition 2 %%
            [coh2, cohangle2, timesout, freqsout] = newcrossf(ic_data2a, ic_data2b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index2a ic_index2b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
            input_2(k_2,:) = mean(coh2);
                        
        end
        cog_control_trials(c).cluster_1vs2(2).(subfield) = input_2;  % store single trial coherence data as 'input'        
        disp(subjectid);
        disp('CONDITION 2 COMPLETE!!');
            
%% CONDITION 3 %%
            EEG = pop_loadset('filename',[subjectid, '_50IC', '_C','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 3               
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            trials_3 = size(EEG.data, 3);

        for k_3 = 1:trials_3 % Loop Through Trials Block 3%
            % Cluster 1 %
            ic_index3a_ = find(strcmp(Cluster(c_1).subject, subjectid));
            ic_index3a  = STUDY.cluster(c_1+2).comps(ic_index3a_);
            ic_data3a   = EEG.icaact(ic_index3a, :, k_3); % IC data vector

            % Cluster 2 %
            ic_index3b_ = find(strcmp(Cluster(c_2).subject, subjectid));
            ic_index3b  = STUDY.cluster(c_2+2).comps(ic_index3b_);
            ic_data3b   = EEG.icaact(ic_index3b, :, k_3); % IC data vector

            cog_control_common(c).cluster_1vs2(1).(subfield) = ic_data3a;
            cog_control_common(c).cluster_1vs2(2).(subfield) = ic_data3b;

            %% Coherence for Condition 3 %%
            [coh3, cohangle3, timesout, freqsout] = newcrossf(ic_data3a, ic_data3b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index3a ic_index3b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
            input_3(k_3,:) = mean(coh3);           
        end
        cog_control_trials(c).cluster_1vs2(3).(subfield) = input_3;  % store single trial coherence data as 'input'       
        disp(subjectid);
        disp('CONDITION 3 COMPLETE!!');
            
%% CONDITION 4 %%
            EEG = pop_loadset('filename',[subjectid, '_50IC', '_IC','.set'], 'filepath', [maindir,'\',subjectid,'\','ICA_Coherence\']); % Load file for condition 4               
            [ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
            trials_4 = size(EEG.data, 3);

            for k_4 = 1:trials_4 % Loop Through Trials Block 4%
                % Cluster 1 %
                ic_index4a_ = find(strcmp(Cluster(c_1).subject, subjectid));
                ic_index4a  = STUDY.cluster(c_1+2).comps(ic_index4a_);
                ic_data4a   = EEG.icaact(ic_index4a, :, k_4); % IC data vector

                % Cluster 2 %
                ic_index4b_ = find(strcmp(Cluster(c_2).subject, subjectid));
                ic_index4b  = STUDY.cluster(c_2+2).comps(ic_index4b_);
                ic_data4b   = EEG.icaact(ic_index4b, :, k_4); % IC data vector

                cog_control_common(c).cluster_1vs2(1).(subfield) = ic_data4a;
                cog_control_common(c).cluster_1vs2(2).(subfield) = ic_data4b;

                %% Coherence for Condition 4 %%
                [coh4, cohangle4, timesout, freqsout] = newcrossf(ic_data4a, ic_data4b, 500, epoch, EEG.srate, wavelet_spec, 'type', 'phasecoher', 'topovec', EEG.icawinv(:, [ic_index4a ic_index4b])', 'elocs', EEG.chanlocs, 'chaninfo', EEG.chaninfo, 'freqs', [freq1 freq2], 'timesout', 400, 'padratio', 8, 'maxamp', 0.5, 'plotamp', 'off', 'plotphase', 'off');
                input_4(k_4,:) = mean(coh4);
                
            end         
            cog_control_trials(c).cluster_1vs2(4).(subfield) = input_4;  % store single trial coherence data as 'input'
            disp(subjectid);
            disp('CONDITION 4 COMPLETE!!');
            
            input_1 = []; input_2 = []; input_3 = []; input_4 = [];   
            rt_raw_1 = []; latency_raw_1 = []; 
            rt_raw_2 = []; latency_raw_2 = [];
            rt_raw_3 = []; latency_raw_3 = [];
            rt_raw_4 = []; latency_raw_4 = [];
    end
    subj = 1; % reinitialize subjects
end

disp('.....................SAVING .CSVs.........................'); % save data to CSV structure
struct2csv(cog_control_trials.cluster_1vs2(1), '50C_C_cluster_1vs2.csv');   
struct2csv(cog_control_trials.cluster_1vs2(2), '50C_IC_cluster_1vs2.csv');  
struct2csv(cog_control_trials.cluster_1vs2(3), '50IC_C_cluster_1vs2.csv');  
struct2csv(cog_control_trials.cluster_1vs2(4), '50IC_IC_cluster_1vs2.csv');
disp('ITS DONE!!!');
