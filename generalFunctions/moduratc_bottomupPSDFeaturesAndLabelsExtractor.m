function moduratc_bottomupPSDFeaturesAndLabelsExtractor(fpOutput,thisComplexEnvelopIF,centerFrequencies,...
    theseLabels,bandwidths)
%function moduratc_bottomupPSDFeaturesAndLabelsExtractor(fpOutput,thisComplexEnvelopIF,centerFrequencies,...
%    theseLabels,bandwidths)
%Inputs:
%fpOutput - is a file pointer to write the Weka file
%centerFrequencies,theseLabels,bandwidths - identity the modulations or RATs in this PSD
%IMPORTANT: RAT is here considered to be completely within the analysis
%band. In other words, an "example" is labeled as GSM only if both its start
%and end indices are within the range of indices associated to the RAT.
%Example (with only one RAT in this PSD, which is GSM). Assume that
%analysisBWInTones = 10;
%ratStarts = [40];
%ratEnds = [150];
%assume that for a given "example":
%k=firstToneIndex:firstToneIndex+analysisBWInTones-1;
%generated
%k=[35 36 37 38 39 40 41 42];
%This example is NOT labeled as GSM (it will be labeled as noRAT)
%because 35 36 37 38 39 is not part of the RAT and
%if ratStarts(j)<=k(1) && ratEnds(j)>=k(end)
%will not be true. But if
%k=[40 41 42 43 44];
%then this example would be labeled as GSM. 
%This is simply a heuristic that can be changed.
global fe;
global dsp;
global verbosity;

if 0 %debugging
    clear all
    run('amqam_setSimulationVariables')
    
    labels=[2 1];
    centerFrequencies=[10e3 60e3];
    bandwidths=[5e3 8e3];
    analysisBW=2e3;
    frequencyShift=analysisBW;
    Fs=200e3;
    psd=1:2000;
end
%% Constants
%% Pre-compute values
numRats=length(centerFrequencies);
deltaF = dsp.Fs_if/fe.Nfft;
analysisBWInTones = round(fe.analysisWindowBW/deltaF);
frequencyShiftInTones = round(fe.analysisWindowFrequencyShift/deltaF);
%get indices that indicate where a RAT starts and ends
ratStarts = round((centerFrequencies-bandwidths/2)/deltaF);
ratEnds = round((centerFrequencies+bandwidths/2)/deltaF);
%the convention is to use the frequencies from -Fs/2 to Fs/2
%so the indices here can be negative numbers. Correct that:
ratStarts = ratStarts + fe.Nfft/2;
ratEnds = ratEnds + fe.Nfft/2;
ratStarts(ratStarts<1)=1; %truncate
ratEnds(ratEnds>fe.Nfft)=fe.Nfft; %truncate

%calculate the PSD
psdS=moduratc_calculatePSDs(thisComplexEnvelopIF,dsp,fe); %use pwelch to estimate the PSD

%the number of examples (feature vectors + class) that is contained
%in this PSD
numExamples = floor((fe.Nfft-analysisBWInTones)/frequencyShiftInTones)+1;

%pre-allocate
allFeatures=zeros(numExamples,fe.numFeatures{fe.frontEndIndex});
%initialize with "no" class index, always the last index.
%note that numClasses can be smaller than length(classLabels)
%but this will not impact
allLabels=length(dsp.classLabels)*ones(1,numExamples); 

firstToneIndex=1; %initialize
for i=1:numExamples;
    %update:
    k=firstToneIndex:firstToneIndex+analysisBWInTones-1;
    firstToneIndex=firstToneIndex+frequencyShiftInTones; %update for next iteration
    %% Extract features for each analysisBW    
    %all PSD-based front ends have psdS and k as inputs
    commandLine = ['x=' fe.allFrontEnds{fe.frontEndIndex} '(psdS,k);'];
    eval(commandLine) %evaluate previous command line: run front end
    if length(x) ~= fe.numFeatures{fe.frontEndIndex}
        disp(['#### Command line was: ' commandLine ' ####'])
        disp(['#### Front end calculated ' num2str(length(x)) ' features ####'])
        disp(['### instead of ' num2str(fe.numFeatures{fe.frontEndIndex})])
        disp(['#### Update this value by editing script ' dsp.frontEndInitializationFunction '.m ####'])
        error('Number of features does not match numFeatures{frontEndIndex}')
    end
    allFeatures(i,:)=x; %store features of this example
    %% Find all labels
    for j=1:numRats
        if ratStarts(j)<=k(1) && ratEnds(j)>=k(end)
            %RAT is completely within analysis band
            thisLabel = theseLabels{j};
            allLabels(i)=find(ismember(dsp.classLabels,thisLabel));
            break; %assume only one RAT can be the correct one
        end
    end
    %% Write example on output file pointer fpOutput (file was already open)
    if dsp.shouldSkipNoiseOnlyExamples == 1
        if allLabels(i) ~= length(dsp.classLabels)
            %write only if it is a RAT or modulation of interest (it is not a "no" noise class)
            moduratc_writeToWekaARFF(fpOutput,allFeatures(i,:),dsp.classLabels{allLabels(i)})
            if verbosity.showPlots == 1
                plot(allFeatures(i,:)); title(dsp.classLabels{allLabels(i)}); pause
            end            
        end
    else %write all examples
        writeToWekaARFF(fpOutput,allFeatures(i,:),dsp.classLabels{allLabels(i)})
    end
end
