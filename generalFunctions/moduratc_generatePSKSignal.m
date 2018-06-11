function rat_generatePSKSignal(outputFileName,Rsym,r,M,Fs,numSamples)
L = round(Fs/Rsym); %oversampling factor
S=ceil(numSamples/L); %number of symbols
bits = round((rand(1,S)); % meus bits
N = length(bits); %number of random bits to be transmitted
n=0:L-1; %index to generate S samples of the waveforms

%Design the pair of waveforms to represent bits 0 and 1:
%switch modulation
%    case 'ASK'
%        A0 = 0; A1 = sqrt(8); w = pi/16;
%        s0 = A0 * cos(w * n); s1 = A1 * cos(w * n);
%    case 'FSK'
%        w0 = pi/16; w1 = 3*pi/16; A = 2;
%        s0 = A * cos(w0 * n); s1 = A * cos(w1 * n);        
%    case 'PSK'
        w = pi/16; A = 2; 
        s0 = A * cos(w * n); % os cossenos sao do tamanho do oversamplig factor
        s1 = -A * cos(w * n); %same as s1=A*cos(w*n + pi)
%end
%Generate whole waveform by selecting the waveform segment
outputWaveform = zeros(1,N*L); %pre-allocate space
for i=1:N
    bitTx = bits(i); %get one bit
    startSample = 1+(i-1)*L; %place to output signal
    if bitTx == 1 %choose segment for bit 1 or 0
        outputWaveform(startSample:startSample+L-1) = s1;
    else
        outputWaveform(startSample:startSample+L-1) = s0;        
    end
end


write_complex_binary(outputFileName, outputWaveform); 
disp(['Wrote ' outputFileName]);
