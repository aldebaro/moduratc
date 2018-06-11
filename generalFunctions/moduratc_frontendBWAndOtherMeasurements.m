function x=moduratc_frontendBWAndOtherMeasurements(psdS,tones)
% function x=rat_frontendBWAndOtherMeasurements(psdS,tones)
%This front end estimates the bandwidth given a threshold.
global dsp;
global fe;
global verbosity;

threshold = 20; %threshold in dB

if length(tones) < 2
    error('length(tones) < 2')
end

x=zeros(1,3); %will calculate 3 parameters
psddB = 10*log10(psdS);
psddBThisBand = 10*log10(psdS(tones));
[maxPSDValue,tempMaxIndex] = max(psddBThisBand);
maxIndex=tones(tempMaxIndex); %this is the index in psdS
%search to the right:
indicesExceedThreshold=find(maxPSDValue-psddB > threshold);
leftIndices=indicesExceedThreshold(indicesExceedThreshold<=maxIndex);
if isempty(leftIndices)
    leftEndPoint=1;
else
    leftEndPoint=leftIndices(end); %take the right-most point
end
rightIndices=indicesExceedThreshold(indicesExceedThreshold>=maxIndex);
if isempty(rightIndices)
    rightEndPoint=length(psddB);
else
    rightEndPoint=rightIndices(1); %take the left-most point
end

if 0 %disable, loops are too slow in Matlab
    %search to the right:
    for rightEndPoint=maxIndex:length(psddB)
        if maxPSDValue-psddB(rightEndPoint) > threshold
            break %found it, interrupt
        end
    end
    %search to the left:
    for leftEndPoint=maxIndex:-1:1
        if maxPSDValue-psddB(leftEndPoint) > threshold
            break %found it, interrupt
        end
    end
end
if rightEndPoint-leftEndPoint+1 == length(psdS)
    %it means this band has a small PSD value and all the BW was "chosen"
    %change it by 0
    return %x is all zeros
else
    x(1) = (rightEndPoint-leftEndPoint+1)*dsp.Fs_if/fe.Nfft; %BW (for threshold) in Hz
end
tonesBW = leftEndPoint:rightEndPoint;
x(2) = max(psddB(tonesBW)) - min(psddB(tonesBW)); %peak within found band
%dctPSD = dct(psddB(tonesBW));
dctPSD = dct(psdS(tonesBW));
[maxDCTValue x(3)] = max(dctPSD); %index of maximum DCT coefficient
if verbosity.showPlots == 1
    x
    clf
    plot(psddB), hold on
    plot(tonesBW,psddB(tonesBW),'r')
    plot(tones,psddB(tones),'gx')
    plot(indicesExceedThreshold,psddB(indicesExceedThreshold),'ko');
    drawnow
end