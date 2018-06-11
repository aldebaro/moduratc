%main script for simulation_amqam
clear all

%1) Set variables and structures
disp('setSimulationVariables');
run('setSimulationVariables') %set variables

%2) Create directories in case they do not exist
mkdir(ff.myOutputDir);
mkdir(ff.myBasebandCenvTimeDomainDir)

%3) create baseband complex envelopes. This can be done in SystemVue,
%for example. Write files into a folder such as "complexBasebandEnvTimeDomain".
disp('3) create complex envelopes (at transmitter)')
if versionOfSystemVueFiles==1 %use first version of Systemvue files:
    disp('moduratc_generateAllComplexEnvelopesInBinary')
    moduratc_generateAllComplexEnvelopesInBinary
else %use second version of Systemvue files:
    disp('moduratc_generateAllComplexEnvelopesInBinaryVersion2')
    moduratc_generateAllComplexEnvelopesInBinaryVersion2
end

%4) describe each scenario and create associated files:
%setupDescription.m, testFilesList.txt and trainFilesList.txt
%inside each scenario directory
disp('4) Automatically describe each scenario and create associated files');
disp('moduratc_generateTrivialScenarioFiles')
moduratc_generateTrivialScenarioFiles

%5) Create multiplex signals
% It also creates the list you specied in:
%listOfIFComplexEnvelopes = [ff.myRATRootDir filesep 'filesToHavePSDCalculated.txt'];
disp('5) Create multiplex IF complex envelopes at receiver, in time domain and their list')
disp('moduratc_generateTrainTestSequences')
moduratc_generateTrainTestSequences

%6) Extract features and labels
disp('6) Extract features and labels')
disp('moduratc_generateAllFeaturesAndLabels')
moduratc_generateAllFeaturesAndLabels

%7) Invoke Weka from command line
disp('7) Invoke Weka from command line')
disp('moduratc_runWekaFromCommandLine')
moduratc_runWekaFromCommandLine
