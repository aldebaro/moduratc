function x=rat_frontendPSD(psdS,tones)
% function x=rat_frontendPSD(psdS,tones)
%Simple front end: return the PSD values in dB for the given analysis
%bandwidth. The inputs are the whole PSD (psdS) and its indices for
%the analysis band (tones).
x=10*log10(psdS(tones)); %convert to dB