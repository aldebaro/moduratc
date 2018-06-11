%% Creates multiplex IF complex envelopes at the receiver. The signals
%are in time domain and the script also creates some lists as text files.
% It outputs 3 types of files:
% 1) all the cenvif files (written to the "output" directory)
% 2) 1 list with all cenvif files (e.g. listOfIFComplexEnvelopes.txt)
% 3) 3 lists with cenvif files and their corresponding scenarios (e.g.
% trainCeinvsAndScenariosList.txt, test..., validation ...)
%
% Details:
% The script obtains the list of files to be created from text (ASCII)
% files for each Scenario. An example of list is
% trainScriptsPerScenarioList.txt. The software knows the
% baseband envelopes that compose this multiplex IF signal 
% based on this information. 
%
% A list (ff.listOfIFComplexEnvelopes) is also created by this
% routine with all cenvif files. An example of its contents follows:
%simpleTrain_1.cenvif
%...
%simpleTest_1.cenvif
%
%The third kind of output of this script are 3 lists, specified by
%ff.listWithCenvifsAndAssociatedLabels, for train, test and validation.
% For them, the script creates an output list such as:
%simpleTest_1.cenvif C:\simulation_amqam\scenarioSimple\scenarioDescription.m
%simpleTest_2.cenvif C:\simulation_amqam\scenarioSimple\scenarioDescription.m
%...
% In the above example, simpleTest_1.cenvif is the file that will
% be created, with the complex envelope in IF. The classes corresponding
% to this file are informed in its corresponding scenarioDescription.m
% such that, later, supervised learning can be used.

%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

%the list below lists all (train, test and validation) cenvif files
%that will be later converted to PSDs
listOfcenvifFiles = [ff.myOutputDir ff.listOfIFComplexEnvelopes];
fpCenvOut=fopen(listOfcenvifFiles,'wt');
if fpCenvOut < 0
    error(['Error opening ' listOfcenvifFiles])
end

for k=1:3 %execute for sets: train, test and validation
    %each set has a corresponding list of files:
    thisFilesList = [ff.myOutputDir ff.listWithCenvifsAndAssociatedLabels{k}];
    fpOutput=fopen(thisFilesList,'wt');
    if fpOutput < 0
        error(['Error opening ' thisFilesList])
    end
    for i=1:ff.numScenarios        
        %setup variable for this scenario
        description=[ff.myRATRootDir ff.directoriesWithScenarios{i} ...
            filesep 'scenarioDescription.m'];
        run(description);
        
        %each set has a corresponding list of files. Get file:
        thisFilesList=[ff.myRATRootDir ff.directoriesWithScenarios{i} ...
            filesep ff.nameListWithTrainScriptsPerScenario{k}];
        %read file
        fp=fopen(thisFilesList,'r');
        if fp < 0
            disp(['Error reading ' thisFilesList '.'])
            error('Does this file exist? If not, you have to create it!');
        end
        allFilesInList=textscan(fp,'%s'); %all goes to a unique cell!
        fclose(fp);
                
        for j=1:length(allFilesInList{1})
            complexEnvelopes=[]; %let it to be defined by thisScript
            thisScript=[ff.myRATRootDir ff.directoriesWithScenarios{i} ...
                filesep allFilesInList{1}{j}];
            
            run(thisScript); %this script will define: complexEnvelopes
            %outputFileName, bandwidths and txpositions
            
            %Check values
            if min(centerFrequencies-bandwidths/2) < -dsp.Fs_if/2
                error([thisScript 'has too small centerFrequencies'])
            end
            if max(centerFrequencies+bandwidths/2) > dsp.Fs_if/2
                error([thisScript 'has too large centerFrequencies'])
            end
            
            %compose signal for that scenario. Modify the file
            %separation
            outputFileName = strrep(outputFileName,'\\',filesep);
            outputFileName = strrep(outputFileName,'//',filesep);
            outputFileName = strrep(outputFileName,'\',filesep);
            outputFileName = strrep(outputFileName,'/',filesep);
            
            %upconvert and sum all signals
            cenvIFOutputFileName = [outputFileName '.' ff.intermediateFreqEnvelopesFileExtension];
            %rat_upconvertAndSumComplexEnvelopes(ff,dsp,complexEnvelopes,dsp.Fs_bb, ...
            %dsp.Fs_if,centerFrequencies,cenvOutputFileName,numSamples, ...
            %    noisePowerPerDimension,basebandEnvelopesFileExtension);
            moduratc_upconvertAndSumComplexEnvelopes(ff,dsp,complexEnvelopes,...
            centerFrequencies,[ff.myOutputDir cenvIFOutputFileName],txPositions);
            
            %write lines corresponding to output complex envelope
            fprintf(fpOutput,'%s %s\n',cenvIFOutputFileName,description);
            fprintf(fpCenvOut,'%s\n',[ff.myOutputDir cenvIFOutputFileName]);
        end
    end
    fclose(fpOutput);
    disp(['Wrote text file: ' thisFilesList]);
    
end
fclose(fpCenvOut);
disp(['Wrote text file:' listOfcenvifFiles]);