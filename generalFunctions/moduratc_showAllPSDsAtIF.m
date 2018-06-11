%Show all PSD files in the 3 lists:
%ff.listWithCenvifsAndAssociatedLabels
%Before running this script, execute the simulation with runMain.m

%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

for k=1:3 %train, test and validation
    thisFilesList = [ff.myOutputDir ff.listWithCenvifsAndAssociatedLabels{k}];
    fp=fopen(thisFilesList,'r');
    if fp < 0
        error(['Error reading ' thisFilesList]);
    end
    
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
        [thisPSD,f] = ak_psd(thisComplexEnvelope, dsp.Fs_if);
        ak_psd(thisComplexEnvelope, dsp.Fs_if);
        %function S=rat_calculatePSDs(x,dsp) %<=== could also use
        %plot(f,fftshift(thisPSD)); 
        grid;
        %title(['...' descriptionScript(end-50:end)]);
        title([labels ' ' num2str(centerFrequencies/1000) ' (kHz)']);
        %title([num2str(centerFrequencies/1000)]);
        %dsp.classLabels(labels)
        xlabel('f (kHz)'); ylabel('PSD (dBW/Hz)');
        pause
    end
end