%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

N=4; %number of DSB-SC (supressed carrier)
%The input files are named amFile1_Fs44100Hz.wav, amFile2_Fs44100Hz.wav, ...
inputPath=[ff.myRATRootDir 'externalFiles' filesep]; %directory where the files can be found, e.g. 'c:/mydir'
outputPath=ff.myBasebandCenvTimeDomainDir; %output directory for files
inputFileName=[inputPath 'amFile1_Fs44100Hz.wav']; %name of first file
[x,Fsoriginal]=wavread(inputFileName); %Fsoriginal is the sampling frequency (Hz)
%soundsc(x,Fsoriginal); disp('Press a key'); pause
%% Resample and make sure all files have same length
%Obs: Fs_bb is the chosen baseband sampling frequency, specified in setSimulationVariables
U=round(dsp.Fs_bb/Fsoriginal); %upsampling factor (must be an integer) to increase Fsoriginal
M=ceil(dsp.minNumSamplesBBSignals/U); %number of samples assumed for the input signal

BWam = 7500; %same as QAM
h=fir1(50,BWam/Fsoriginal); %lowpass filter
y=zeros(dsp.minNumSamplesBBSignals,1); %pre-allocate space for output signal
n=transpose(0:dsp.minNumSamplesBBSignals-1);
for i=1:N
    inputFileName=[inputPath 'amFile' num2str(i) '_Fs44100Hz.wav'];
    disp(['Processing ' inputFileName])
    [x,Fs_temp]=wavread(inputFileName);
    x=conv(x,h);
    x(1:floor(length(x)/2))=[]; %take out transient
    x=x(1:M); %force all signals to have the same duration (length)
    xup=resample(x,U,1);
    %clf, plot(x,'r'); hold on; plot(xup); pause
    outputFileName=[outputPath 'dsbscFs' num2str(dsp.Fs_bb/1e3) ...
        'kHzBw' num2str(BWam/1e3) 'kHz_' num2str(i) '.' ff.basebandEnvelopesFileExtension];
    write_complex_binary(outputFileName, xup(1:dsp.minNumSamplesBBSignals));
    disp(['Wrote ' outputFileName]);
end
