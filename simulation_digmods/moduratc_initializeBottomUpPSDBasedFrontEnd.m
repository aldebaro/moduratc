%Define the function that will run the front end:
fe.frontEndMainFunction='moduratc_bottomupPSDFeaturesAndLabelsExtractor';
%Note that all front ends will have the following input parameters
%        frontEndCommand = [dsp.frontEndMainFunction ...
%            '(fpOutput,thisComplexEnvelope,centerFrequencies,'...
%            'labels,bandwidths)'];
%This command is executed with:
%        eval(frontEndCommand);

fe.analysisWindowBW = 4e3; %analysis band in Hz. Important: for each band
%a labeled example is generated. This value is typically chosen
%to be smaller than the minimum bandwidth of interest

%The main PSD front end function relies on one of these functions:
fe.allFrontEnds{1}='moduratc_frontendPSD'; %simply calculates PSD
fe.allFrontEnds{2}='moduratc_frontendDCT'; %takes the DCT of the PSD
fe.allFrontEnds{3}='moduratc_frontendBWAndOtherMeasurements'; %measures BW
fe.numFeatures{1}=26; %number of features of each front end
fe.numFeatures{2}=32;
fe.numFeatures{3}=3;
fe.frontEndIndex = 1; %index of chosen front end

%You need to specify the FFT size Nfft to have a reasonable resolution
%Below is a possible heuristic. You can adapt it to your needs.
minNumberOfBinsWithinBW=24; %minimum FFT bins for an analysis bandwidth
df = fe.analysisWindowBW/minNumberOfBinsWithinBW; %needed frequency
%spacing in order to have minNumberOfBinsWithinBW within analysisWindowBW
M = ceil(dsp.Fs_if/df); %find the number of points to achieve df
b=nextpow2(M); %use a power of 2
fe.Nfft=2^b; %choose a power of 2 for FFT-length

%Choose parameters to estimate fe. Assuming Welch's algorithm here:
fe.numberOfPSDBlocks = 8; %number of blocks for Welch's
fe.pwelchOverlap=floor(fe.Nfft/2); %use 50% of overlapping

fe.analysisWindowFrequencyShift = ceil(fe.analysisWindowBW/2); %shift between examples in PSD domain

%S=pwelch(x,hamming(M),fe.pwelchOverlap,Nfft,Fs_if,'twosided'); %overlap is M/2

fe.minNumSamplesIFSignals = fe.numberOfPSDBlocks*fe.pwelchOverlap+fe.Nfft;
fe.durationIFSignal=fe.minNumSamplesIFSignals/dsp.Fs_if; %seconds
fe.minNumSamplesBBSignals = ceil(fe.minNumSamplesIFSignals*dsp.Fs_bb/dsp.Fs_if);
