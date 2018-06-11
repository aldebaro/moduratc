%Note: setSimulationVariables.m must have been executed first to
%setup two globals ff and dsp

Rsym=5e3; %symbol rate, in bauds
r=0.5; %raised cosine roll-off factor
M=32; %number of symbols in alphabet
bwQAM=Rsym*(1+r); %theoretical null-to-null BW. TODO: use another definition
numOutputFiles=10;
outputPath=ff.myBasebandCenvTimeDomainDir; %output directory for files
for i=1:numOutputFiles
    outputFileName=[outputPath 'qamFs' num2str(dsp.Fs_bb/1e3) ...
        'kHzBw' num2str(bwQAM/1e3) 'kHz_' num2str(i) '.' ff.basebandEnvelopesFileExtension];
    moduratc_generateQAMSignal(outputFileName,Rsym,r,M,dsp.Fs_bb,dsp.minNumSamplesBBSignals)
end
