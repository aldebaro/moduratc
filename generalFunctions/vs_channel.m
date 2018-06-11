function y=vs_channel(x,centerFrequency,txPosition,rxPosition)
global dsp
%corrigir
% C. Typical Rural
hb= txPosition(3);% hb eh a altura da antena do Tx
ahm = 3.2*(log10(11.75*rxPosition(3))).^2 - 4.97;
d = sqrt(sum(((txPosition-rxPosition)/1000).^2));
fc = (dsp.F_rf+centerFrequency)/(1e6);% fc  is the operating frequency im MHz

L50urban1 = 69.55 + 26.16*log10(fc) + (44.9 - 6.55*log10(hb))*log10(d) - 13.82*log10(hb) - ahm;
%L50rural = (69.55 + 26.16*log10(fc) + (44.9 - 6.55*log10(hb))*log10(d) - 13.82*log10(hb)) - 4.78*(log10(fc)).^2 + 18.33*log10(fc) - 40.94

L=L50urban1
L = 10^(0.1*L);
y1 = x/sqrt(L);% considerando um ganho de pot (ver livro)
y = y1;

% Fs=2e6;
% ts = 1/Fs; 
% fd = 200;
% chan = stdchan(ts, fd, 'cost207HTx6');
% chan.NormalizePathGains = 1;
% chan.StoreHistory = 1; %use for visualization, but disable for actual simulations
% y = filter(chan, y1);
