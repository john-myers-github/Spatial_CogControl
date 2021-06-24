% buildstudy_pws - Builds a study from a number of condition-separated
% datasets. You must define a number of parameters as shown below. You must
% also have already split your dataset into conditions as in step 5.1.
% This version was designed to build a study based on Jeff's People Who
% Stutter Cue-Target task.

% Author: Michael Seay, GCNL, 2014
% Editor: John Myers, 2018

%%

%Define the main directory
maindir='I:\Lisa C\SimonTask\SimonEffectICAStudy/setFiles';

%Define the subject IDs, with separate string arrays for each group,
%respective to above (sub-sub-folders).
subjectid={'583','585','590','591','594','595','631','657','658','659','665','681','690','707','710','712','714','715','716','717','720','724','725','731','732','733','734','736','AE','AF','CH','DQ','JF','JL','JM','KC','KM','LF','MS','NJ','PK','RM','RN','SB','SS','WB','ZU'};

%Define the total number of subjects (from all groups)
ns=47;

%Define the filename suffixes based on conditions
cid={'50C','50IC'};
cid2={'_C','_IC'};

%Define the condition IDs as they will be seen in the study
%(respective to above).
cname={'50C','50IC'};
cname2={'_C','_IC'};

%Define the subfolder
subfolder= 'ICA_Coherence';

%%

%Initialize the cell
studycell=cell(1,ns*length(cid)*4);

%Initialize the indices
i=0; %This is the set index
j=0; %This is the   cell array index

%This loop constructs a string array of commands that build the STUDY.
for s=1:length(subjectid)
    for c1=1:length(cid)
        for c2=1:length(cid2)
            i=i+1;
            j=j+1;
            %Load the filename
            studycell{1,j}={'index' i 'load' [maindir,'\',...
                subjectid{s},'\',subfolder,'\',subjectid{s},'_',cid{c1},cid2{c2},'.set']};
            j=j+1;
            %Set the subject ID
            studycell{1,j}={'index' i 'subject' subjectid{s}};
            j=j+1;
            %Set the condition ID
            studycell{1,j}={'index' i 'condition' cname{c1}};
            j=j+1;
            %Set the group ID
            studycell{1,j}={'index' i 'group' cname2{c2}};
        end
    end
end


%Define the study filename
name='Simon50sequenceeffects_ICA_Coherence';

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
