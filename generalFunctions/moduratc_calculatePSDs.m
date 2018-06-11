function S=rat_calculatePSDs(x,dsp,fe)
%convert time-domain complex envelopes to PSD. The PSD assumes the
%bandwidth is dsp.Fs_if.

%When running on Octave, be careful, pwelch has a different sintax
%regarding the third parameter (fe.pwelchOverlap)
S=pwelch(x,hamming(fe.Nfft),fe.pwelchOverlap,fe.Nfft,dsp.Fs_if,'twosided');
