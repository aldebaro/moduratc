%This script gives an example on how to make automatic the process
%of creating the scenario files.

mkdir([ff.myRATRootDir 'scenarioTrivial']) %directory for the scenrio

fp2=fopen([ff.myRATRootDir 'scenarioTrivial' filesep 'scenarioDescription.m'],'w');
fprintf(fp2,'%s\n',['labels={''GSM'',''LTE'',''WCDMA''};']);
%define the bandwidths below:
if versionOfSystemVueFiles == 1
    bandwidthsLabel = 'bandwidths=[200 1400 200]*1e3;';
else
    bandwidthsLabel = 'bandwidths=[200 3000 5000]*1e3;';
end
eval(bandwidthsLabel);

%Define center frequencies.
%Recall that IF bandwidth is counted from -Fs/2 to Fs/2
fprintf(fp2,'%s\n',['centerFrequencies=[-3000 100 6000]*1e3; %center frequencies']);
fprintf(fp2,'%s\n',['txPositions={[0 10e3 30], [20e3 0 10], [10e3 0 10]}; %transmitter positions (x,y,z)']);

fprintf(fp2,'%s\n',bandwidthsLabel);
fclose(fp2);
disp(['Wrote ' [ff.myRATRootDir 'scenarioTrivial' filesep 'scenarioDescription.m']])

allSets={'train','test','validation'};
%Number of files for each set:
numTrain=3;
numTest=3;
numVali=3;
filesForEachSet = [0 numTrain numTest+numTrain numTest+numTrain+numVali];
for ii=1:3
    id = allSets{ii};
    fp2=fopen([ff.myRATRootDir 'scenarioTrivial' filesep id 'ScriptsPerScenarioList.txt'],'w');
    for j=filesForEachSet(ii)+1:filesForEachSet(ii+1)
        fp=fopen([ff.myRATRootDir 'scenarioTrivial' filesep ...
            'gsmltecdmSignals_' id '_' num2str(j) '.m'],'w');
        fprintf(fp,'%s\n',['outputFileName = ''gsmltecdma_' num2str(j) ''';']);
        
        fprintf(fp,'%s\n',['complexEnvelopes{1}=''gsm_' num2str(j) ''';']);
        fprintf(fp,'%s\n',['complexEnvelopes{2}=''lte_' num2str(j) ''';']);
        fprintf(fp,'%s\n',['complexEnvelopes{3}=''wcdma_' num2str(j) ''';']);
     
        %I am not going to include Fs and BW in the file names because
        %we have two sets (versions) of files from Systemvue.
%         fprintf(fp,'%s\n',['complexEnvelopes{1}=''gsmFs' ...
%             num2str(dsp.Fs_bb/1e3) 'kHzBw' num2str(bandwidths(1)/1e3) 'kHz_' num2str(j) ''';']);
%         fprintf(fp,'%s\n',['complexEnvelopes{2}=''lteFs' ...
%             num2str(dsp.Fs_bb/1e3) 'kHzBw' num2str(bandwidths(2)/1e3) 'kHz_' num2str(j) ''';']);
%         fprintf(fp,'%s\n',['complexEnvelopes{3}=''wcdmaFs' ...
%             num2str(dsp.Fs_bb/1e3) 'kHzBw' num2str(bandwidths(3)/1e3) 'kHz_' num2str(j) ''';']);
        
        fclose(fp);
        
        fprintf(fp2,'%s\n',['gsmltecdmSignals_' id '_' num2str(j) '.m']);
    end    
    fclose(fp2);   
    disp(['Wrote ' [ff.myRATRootDir 'scenarioTrivial' filesep id 'ScriptsPerScenarioList.txt']])
end
