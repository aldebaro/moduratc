%% This script opens an ARFF file, writes its header, and then
%continually invokes the front end specified by fe.frontEndMainFunction
%to write the features and their label (class) as one row of the ARFF
%file. When all cenvif files are processed, it closes the ARFF. It
%repeats the procedure for 3 ARFFs: train, test and validation.
%Note that one cenvif file can generate several ARFF rows.

%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

for k=1:3 %train, test and validation
    thisFilesList = [ff.myOutputDir ff.listWithCenvifsAndAssociatedLabels{k}];
    fp=fopen(thisFilesList,'r');
    if fp < 0
        error(['Error reading ' thisFilesList]);
    end
    
    currentWekaFile = [ff.myOutputDir ff.outputWekaFile{k}];
    
    %% Write Weak file header
    fpOutput=fopen(currentWekaFile,'wt');
    if fpOutput < 0
        error(['Error opening ' currentWekaFile]);
    end
    %% Write ARFF file header
    fprintf(fpOutput, '@relation %s\n', 'RATc');
    for i = 1:fe.numFeatures{fe.frontEndIndex}
        fprintf(fpOutput, '@attribute %s%d real\n', 'attribute', i);
    end
    fprintf(fpOutput, '@attribute class {');
    fprintf(fpOutput, '%s',['''' dsp.classLabels{1} '''']);
    numClasses = length(dsp.classLabels);
    if dsp.shouldSkipNoiseOnlyExamples == 1
        numClasses = numClasses-1; %do not take class "no" in account
    end
    for i=2:numClasses
        fprintf(fpOutput, ',');
        fprintf(fpOutput,'%s',['''' dsp.classLabels{i} '''']);
    end
    fprintf(fpOutput, '}\n');
    fprintf(fpOutput, '@data\n');
    
    allPairsInList=textscan(fp,'%s %s'); %all goes to a unique cell!
    fclose(fp);
    numFiles = length(allPairsInList{1});
    for i=1:numFiles
        cenvifFileName = [ff.myOutputDir allPairsInList{1}{i}];
        descriptionScript = allPairsInList{2}{i};
        run(descriptionScript);
        %descriptionScript provides information about:
        %centerFrequencies, labels and bandwidths
        %used for the respective cenvFileName
        thisComplexEnvelope = read_complex_binary(cenvifFileName);
        
        disp(['Processing ' cenvifFileName]);
        
        %invoke the chosen front end:
        frontEndCommand = [fe.frontEndMainFunction ...
            '(fpOutput,thisComplexEnvelope,centerFrequencies,'...
            'labels,bandwidths)'];
        %disp(frontEndCommand)
        eval(frontEndCommand);
    end
    fclose(fpOutput);
    disp(['Wrote ' currentWekaFile]);
end