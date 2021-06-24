%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Concatenate ICA Coherence for Cluster: Extracts Independent 
%   Component Time Series from Corresponding Clusters Across Conditions for 
%   Subjects Common to the clusters and computes Coherence (for use with Cognitive Control Data)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Establish the Main Directory %%
maindir = 'E:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';

%% Identify Subjects in Each Cluster (predetermined during clustering) %% 
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
c_1 = 1; % name each cluster
c_2 = 2;
[subjects_common, index_c1, index_c2] = intersect(Cluster(c_1).subject, Cluster(c_2).subject); % finds and indexes subjects common to both clusters
subjects_common_ = subjects_common';
group_name = ['common_', num2str(c_1), 'vs', num2str(c_2)];
conditions = {'50C_C', '50C_IC', '50IC_C', '50IC_IC'};

%% Define Conditions %%
condition1 = {'_50C','_50IC'};
condition2 = {'_C','_IC'};

%% 
for condition = 1:size(conditions, 2) % one loop for each condition
    cond_id = [conditions{condition}];
    subfield  = ['c', cond_id];  
    coh_conditions.(subfield) = cog_control_coherence(c).cluster_1vs2(condition); % create structure with coherence data from each condition
    coh_data.concatenated.(subfield) = cell2mat(struct2cell(coh_conditions.(subfield))); % concatenate structure with coherence data from each condition
%   RT.trials.concatenated.(subfield) = cell2mat(struct2cell(cog_control_rt(c).cluster_1vs2(condition))); % concatenate structure with coherence data from each condition
end

disp('.....................SAVING .CSVs.........................'); % save data to CSV structure
% struct2csv(RT.trials.concatenated, 'CLUSTER_RT_1.csv'); 
disp('ITS DONE!!!');
