%For the simulation simulation_amqam. The goal is to classify
%among three radio access technologies (RATs): AM, AM DSB-SC and QAM.
%% There are three global structures that control the simulations:
global ff; %structure with files, folders and lists names
global dsp; %structure with signal processing constants
global fe; %structure with constants specific to each front end
%Other parameters to control simulation:
global verbosity; %control the output / debug information

%% First part: things you *must* change or at least check
% 1) Define structure ff. Specify your main directories, etc.
%NOTE: end all directories with filesep ('/' or '\' depending on
%if you are using Windows or Linux) otherwise concatenation is wrong

% Choose the user (a convenience)
%user='Patricio';
user='Vitoria';
%user='Aldebaro';
%Recall that directories need to end with filesep
switch user
    case 'Patricio' %Windows user
        ff.myModuRatCDir = 'C:\svns\laps\telecom\2014RadioAccessTechnologyClassification\';
        ff.pathToAldebarosCode = 'C:\svns\laps\latex\dslbook\'; %modify to match your system
    case 'Aldebaro' %Windows (argh) user
        ff.myModuRatCDir = 'C:\svns\laps\telecom\2014RadioAccessTechnologyClassification\';
        ff.pathToAldebarosCode = 'C:\svns\laps\latex\dslbook\'; %modify to match your system
    case 'Vitoria' %Linux user
        ff.myModuRatCDir = 'C:\Users\v\Telecom\2014RadioAccessTechnologyClassification\';
        ff.pathToAldebarosCode = 'C:\Users\v\dslbook\'; %modify to match your system
end

%Specify directories:
ff.myRATRootDir = [ff.myModuRatCDir 'simulation_digmods' filesep];

%Specify all scenarios of this simulation
%ff.directoriesWithScenarios{1}='scenarioSimple';
%ff.directoriesWithScenarios{2}='scenario3Classes';

 ff.directoriesWithScenarios{1}='scenario3Classes1';
 ff.directoriesWithScenarios{2}='scenario3Classes2';
 ff.directoriesWithScenarios{3}='scenario3Classes3';
 ff.directoriesWithScenarios{4}='scenario3Classes4';
 ff.directoriesWithScenarios{5}='scenario3Classes5';
 ff.directoriesWithScenarios{6}='scenario3Classes6';
 ff.directoriesWithScenarios{7}='scenario3Classes7';
 ff.directoriesWithScenarios{8}='scenario3Classes8';
 ff.directoriesWithScenarios{9}='scenario3Classes9';


% 2) Define structure dsp with technical values, etc.
%Always include 'no' as the last class, which corresponds to noise
%only or no signal. Include it even if you are not going
%to use it by shouldSkipNoiseOnlyExamples!
dsp.classLabels = {'AM','QAM','DSBSC','no'};
%A "no" will be generated whenever tha analysis band does not contain
%a signal of interest.
%In case you do not want to include the "no" in ARFF files, enable:
dsp.shouldSkipNoiseOnlyExamples = 1; %use 1 to enable or 0 otherwise

dsp.F_rf = 1.8e9; %RF center frequency (in Hz)
%The two sampling frequencies below must be integers (to enable their
%use in resample function, later on):
dsp.Fs_bb = 1200e3; %sampling frequency in Hz of baseband signals
dsp.Fs_if = 2e6; %sampling frequency in Hz of signals at IF
%The two sampling frequencies below must be integers (to enable their
%use in resample function, later on):

%The two sampling frequencies below must be integers (to enable their
%use in resample function, later on):
%dsp.Fs_bb = 500e3; %sampling frequency in Hz of baseband signals
%dsp.Fs_if = 500e3; %sampling frequency in Hz of signals at IF





dsp.minNumSamplesBBSignals=450000; %minimum number of samples in BB signal
dsp.minNumSamplesIFSignals=dsp.minNumSamplesBBSignals; %minimum number of samples in IF signal

dsp.addWhiteGaussianNoise = 1; %use 1 for AWGN or 0 for no adding it
dsp.N0_dBmHz = -130; %unilateral noise PSD in dBm/Hz, if AWGN is used
dsp.channelFunction = 'channel_freeSpace'; %you can use your function here
%do not use AWGN in your function because this is done in another command.
%The input parameters for all channel functions are the same:
%channelCommand = ['y=' dsp.channelFunction '(x,centerFrequency,txPosition);'];

%the code below must initialize the front end structure called fe
dsp.frontEndInitializationFunction='moduratc_initializeBottomUpPSDBasedFrontEnd';

%% Second part: things you do not need to change
verbosity.showPlots = 0; %use 1 to show plots or 0 otherwise

ff.myOutputDir = [ff.myRATRootDir 'output' filesep];
ff.myBasebandCenvTimeDomainDir = [ff.myRATRootDir 'complexBasebandEnvTimeDomain' filesep];

%define names for lists and files
ff.nameListWithTrainScriptsPerScenario{1}='trainScriptsPerScenarioList.txt';
ff.nameListWithTrainScriptsPerScenario{2}='testScriptsPerScenarioList.txt';
ff.nameListWithTrainScriptsPerScenario{3}='validationScriptsPerScenarioList.txt';

ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';


ff.listWithCenvifsAndAssociatedLabels{1}='trainCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{2}='testCeinvsAndScenariosList.txt';
ff.listWithCenvifsAndAssociatedLabels{3}='validationCeinvsAndScenariosList.txt';




ff.listOfIFComplexEnvelopes = 'listOfIFComplexEnvelopes.txt';

ff.outputWekaFile{1}='train.arff';
ff.outputWekaFile{2}='test.arff';
ff.outputWekaFile{3}='validation.arff';

ff.numScenarios=length(ff.directoriesWithScenarios);

%% Extensions
ff.basebandEnvelopesFileExtension = 'cenvbb';
ff.intermediateFreqEnvelopesFileExtension = 'cenvif';

%% Third part: Pre-calculated and useful variables
if 1 %add folder with functions to path
    P=path;
    path(P,[ff.pathToAldebarosCode 'Code' filesep 'MatlabOctaveFunctions']);
    addpath([ff.myModuRatCDir 'generalFunctions'],'-end');
end

%Convert noise PSD to discrete-time power
dsp.N0 = 1e-3 * 10^(0.1*dsp.N0_dBmHz); %N0 in Watts/Hz
dsp.noisePowerPerDimension = dsp.N0 * dsp.Fs_if; %power in Watts, discrete-time

%% Fourth part: check for consistency
if dsp.Fs_if ~= round(dsp.Fs_if)
    error('dsp.Fs_if must be an integer');
end
if dsp.Fs_bb ~= round(dsp.Fs_bb)
    error('dsp.Fs_bb must be an integer');
end

%initialize chosen front end
eval(dsp.frontEndInitializationFunction);