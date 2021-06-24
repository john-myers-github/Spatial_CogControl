% split_simon - Splits cleaned, ICA-decomposed datasets into conditions.
% Does dipole fitting with the auto-fit procedure before splitting.

% Author: Michael Seay, GCNL, 2015
% Author: Lisa Chinn, GCNL, 2015
% Author: John Myers, 2018

%%

%Define the main directory
maindir='I:\Lisa C\SimonTask\SimonEffectICAStudy';

%Define the subject IDs in nested curly brackets like {{}{}} respective to
%the groups above. These are also sub-sub-directories of the above
subjectid={'583','585','590','591','594','595','631','657','658','659','665','681','690','707','710','712','714','715','716','717','720','724','725','731','732','733','734','736','AE','AF','CH','DQ','JF','JL','JM','KC','KM','LF','MS','NJ','PK','RM','RN','SB','SS','WB','ZU'};

%Define the condition names (for naming purposes inside eeglab)
cname={'50C_C','50IC_C','50C_IC','50IC_IC'};

%Define the filename suffixes of each condition (respective to above)
cid={'50C_C','50IC_C','50C_IC','50IC_IC'};

%Define the type codes for each condition
ccodes={{'11_50','14_50','41_50','44_50','110_50','219_50','119_50','210_50'},...
    {'21_50','31_50','24_50','34_50','130_50','239_50','139_50','230_50'},...
    {'12_50','13_50','42_50','43_50','120_50','229_50','129_50','220_50'},...
    {'22_50','23_50','32_50','33_50','140_50','249_50','149_50','240_50'}};

%Define the subfolder name
subfolder='1Hz64Ch-800to1200';

%%

for s=1:length(subjectid)
	%Start eeglab
	[ALLEEG EEG CURRENTSET ALLCOM] = eeglab;
	%Load the master rejected ICA dataset
	EEG = pop_loadset('filename',[subjectid{s},'_c0_64ch_-800to1200_pruned with ICA.set'],'filepath',[maindir,'\','setFiles\',subjectid{s},'\']);
	[ALLEEG, EEG, CURRENTSET] = eeg_store( ALLEEG, EEG, 0 );
	EEG = eeg_checkset( EEG );
    %Do the dipole fitting settings (pop up)
    EEG = pop_dipfit_settings(EEG, 'hdmfile','C:\\Users\\Admin\\Documents\\MATLAB\\eeglab13_6_5b\\plugins\\dipfit2.3\\standard_BEM\\standard_vol.mat','coordformat','MNI','mrifile','C:\\Users\\Admin\\Documents\\MATLAB\\eeglab13_6_5b\\plugins\\dipfit2.3\\standard_BEM\\standard_mri.mat','chanfile','C:\\Users\\Admin\\Documents\\MATLAB\\eeglab13_6_5b\\plugins\\dipfit2.3\\standard_BEM\\elec\\standard_1005.elc','coord_transform',[0.043335 -0.026564 -0.015953 -0.00029761 -1.1642e-05 -1.5715 0.99987 0.99981 1.0002] ,'chansel', 1:length(EEG.chanlocs(1,:)));
    [ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
	%Use the auto-fit procedure
	EEG = pop_multifit(EEG, [1:size(EEG.icawinv,2)] , 'threshold', 100, 'plotopt', {'normlen' 'on'});
	[ALLEEG EEG] = eeg_store(ALLEEG, EEG, CURRENTSET);
    %Make Directory for new file
    mkdir([maindir,'\','setFiles\',subjectid{s},'\', 'ICA_Coherence\'])
	for c=1:length(cid)
		%Split, name, and save.
		EEG = pop_selectevent(EEG, 'type',ccodes{c},'deleteevents','off','deleteepochs','on','invertepochs','off');
		[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 1,'setname',[subjectid{s},' ',cname{c}],'savenew',[maindir,'\','setFiles\',subjectid{s},'\', 'ICA_Coherence\', subjectid{s},'_',cid{c},'.set'],'gui','off'); 
		%Switch back
		[ALLEEG EEG CURRENTSET] = pop_newset(ALLEEG, EEG, 2,'retrieve',1,'study',0); 
		EEG = eeg_checkset( EEG );
	end
end

%Refresh the eeglab GUI
eeglab redraw;