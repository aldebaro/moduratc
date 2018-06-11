%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

%read file
listOfcenvifFiles = [ff.myOutputDir ff.listOfIFComplexEnvelopes];
fp=fopen(listOfcenvifFiles,'r');
if fp < 0
    error(['Error reading ' listOfcenvifFiles]);
end
allFilesInList=textscan(fp,'%s'); %all goes to a unique cell!
fclose(fp);
disp(['Reading file ' listOfcenvifFiles])
for j=1:length(allFilesInList{1})
    inputFile=allFilesInList{1}{j};
    
    inputFile = strrep(inputFile,'\\',filesep);
    inputFile = strrep(inputFile,'//',filesep);
    inputFile = strrep(inputFile,'\',filesep);
    inputFile = strrep(inputFile,'/',filesep);
    
    x=read_complex_binary(inputFile);
    S=moduratc_calculatePSDs(x,dsp); %use pwelch to estimate the PSD
    %change the extension
    outputFile=strrep(inputFile,['.' ff.intermediateFreqEnvelopesFileExtension], ...
        ['.' ff.intermediateFreqPSDsFileExtension]);
    write_real_binary(outputFile, S); %write as a real-valued signal
    disp(['Wrote file ' outputFile]);
end
