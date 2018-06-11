function modurat_upconvertAndSumComplexEnvelopes(ff,dsp,complexEnvelopes,...
    centerFrequencies,cenvOutputFileName,txPositions)
%function modurat_upconvertAndSumComplexEnvelopes(ff,dsp,complexEnvelopes,...
%            centerFrequencies,cenvOutputFileName,txPositions)
global verbosity;

numComplexEnvelopes = length(complexEnvelopes);
xallSignals=zeros(dsp.minNumSamplesIFSignals,1); %use column vectors
n=transpose(0:dsp.minNumSamplesIFSignals-1); %use column vectors
for i=1:numComplexEnvelopes
    inputFileName = [ff.myBasebandCenvTimeDomainDir complexEnvelopes{i}];
    inputFileName = strrep(inputFileName,'\\',filesep);
    inputFileName = strrep(inputFileName,'//',filesep);
    inputFileName = strrep(inputFileName,'\',filesep);
    inputFileName = strrep(inputFileName,'/',filesep);
   
    inputFileName = [inputFileName '.' ff.basebandEnvelopesFileExtension];
   
    %leio os bbs
    x=read_complex_binary(inputFileName);
    if verbosity.showPlots == 1
        pwelch(x); 
    end
    if length(x) ~= dsp.minNumSamplesBBSignals
        disp(['Maybe you changed the front end and forgot to update ' ...
            'the number of files available?']);
        error(['File ' inputFileName ' has ' ...
            num2str(length(x)) ' samples. It should have ' ...
            num2str(dsp.minNumSamplesBBSignals) ' samples.'])
    end
  
    %resample the baseband signal if necessary
    %after that, it will have dsp.minNumSamplesIFSignals samples
    %note that resampling may create replicas with significant power
    %if dsp.Fs_if ~= dsp.Fs_bb
    %    if dsp.Fs_if < dsp.Fs_bb
    %        warning('dsp.Fs_if < dsp.Fs_bb');
    %    end
    %  
    %    x = resample(x,dsp.Fs_bb,dsp.Fs_if);
    %   
    %end
   
    %pass signal through baseband equivalent channel
    centerFrequency = centerFrequencies(i);
    txPosition = txPositions{i}; %assume the receiver is at (0,0,0)
      
   %x = (x/(dsp.N0/2)); % ganho no transmissor
   channelCommand = ['y=' dsp.channelFunction '(x,centerFrequency,txPosition);'];
   eval(channelCommand);
   
    carrier=exp(1j * 2*pi * (centerFrequencies(i)/dsp.Fs_if) * n);

    xallSignals = xallSignals +  carrier .* y;
    
    if verbosity.showPlots == 1
        pwelch(xallSignals); pause
    end
end

%% Add WGN noise. This is done once, to mimic what happens at the receiver
if dsp.addWhiteGaussianNoise == 1
    noise = sqrt(dsp.noisePowerPerDimension)*(randn(size(xallSignals)) + ...
        1j*randn(size(xallSignals)));
    xallSignals = xallSignals+noise;
end
%% FINALMENTE GRAVO 
write_complex_binary(cenvOutputFileName, xallSignals);

%%
if verbosity.showPlots == 1
    subplot(211), pwelch(xallSignals);
    subplot(212), pwelch(noise); pause
    pwelch(xallSignals+noise); pause
end
disp(['Wrote ' cenvOutputFileName]);      