% buildstudy - Builds a study from a number of condition-separated
% datasets. You must define a number of parameters as shown below. You must
% also have already split your dataset into conditions

%%

%Define the main directory
maindir = 'I:\Lisa C\SimonTask\SimonEffectICAStudy\Sur_subjects_Young\EEGLab';

%Define the subject IDs, with separate string arrays for each group,
%respective to above (sub-sub-folders).
subjectid = {'180',	'181',	'182',	'183',	'217',	'218',	'219',	'272',	'273',	'274',	'292',	'294',	'305',	'306',	'307',	'308',	'309',	'310',	'311',	'312',	'313',	'317',	'319',	'321',	'322',	'325',	'326',	'328',	'329',	'330',	'990'};

%Define the total number of subjects (from all groups)
ns = 31;

%Define the filename suffixes based on conditions
cid = {'C','IC'};
cid2 = {'_C','_IC'};

%Define the condition IDs as they will be seen in the study
cname ={'C','IC'};
cname2 ={'_C','_IC'};

%Define the subfolder
subfolder = '1Hz64Ch-800to1600';

%%

%Initialize the cell
studycell = cell(1,ns*length(cid)*4);

%Initialize the indices
ii = 0; %This is the set index
jj = 0; %This is the   cell array index

%This loop constructs a string array of commands that build the STUDY.
for s = 1:length(subjectid)
    for c1 = 1:length(cid)
        for c2 = 1:length(cid2)
            ii = ii + 1;
            jj = jj + 1;
            %Load the filename
            studycell{1, jj} = {'index' ii 'load' [maindir,'\',...
                subjectid{s},'\',subfolder,'\',subjectid{s},'_',cid{c1},cid2{c2},'.set']};
            jj = jj+1;
            %Set the subject ID
            studycell{1, jj} = {'index' ii 'subject' subjectid{s}};
            jj = jj + 1;
            %Set the condition ID
            studycell{1, jj} = {'index' ii 'condition' cname{c1}};
            jj = jj + 1;
            %Set the group ID
            studycell{1, jj} = {'index' ii 'group' cname2{c2}};
        end
    end
end

%Define the study filename
name = 'Simon50sequenceeffects_ICA_Coherence_Sandeepa';

%Start eeglab
[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;

%Build the study
[STUDY ALLEEG] = std_editset( STUDY, ALLEEG, 'name',name,'commands',...
    studycell,'updatedat','on' );
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];

%Save the study
[STUDY EEG] = pop_savestudy( STUDY, EEG, 'filename',[name,'.study'],...
    'filepath',maindir);
CURRENTSTUDY = 1; EEG = ALLEEG; CURRENTSET = [1:length(EEG)];
eeglab redraw;
