function x=rat_frontendDCT(psdS,tones)
% function x=rat_frontendDCT(psdS,tones)
%Uses the DCT to compress the spectrum information. It is a form
%of cepstrum.
if 0
    x=dct(psdS(tones));
else
    x=dct(log10(psdS(tones)+eps));
end
x=x(2:end); %only coefficients other than DC