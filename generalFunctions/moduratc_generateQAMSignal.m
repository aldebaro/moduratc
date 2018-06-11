function rat_generateQAMSignal(outputFileName,Rsym,r,M,Fs,numSamples)
%Example:
%outputFileName = 'ce1.bin';
%Rsym=5e3; %symbol rate, in bauds
%r=0.5; %raised cosine roll-off factor
%M=32; %number of symbols in alphabet

%run('rat_setGlobalVariables')

%% Define more constants
useQAM=1; %use QAM or PAM
rcosineGroupDelayInSymbols=5;

%% Do the magic
L=floor(Fs/Rsym); %oversampling factor
Rsym=Fs/L; %adjust Rsym, if necessary
S=ceil(numSamples/L); %number of symbols

if useQAM==1
    const=ak_qamSquareConstellation(M); %QAM const.
else %PAM
    const=-(M-1):2:M-1;
end

%normal or sqrt raised cosine
%h_rc=ak_rcosine(1,L,'fir/normal',r,rcosineGroupDelayInSymbols);
h_rc=ak_rcosine(1,L,'fir/sqrt',r,rcosineGroupDelayInSymbols); 

symbolIndices=floor((M)*rand(1,S))+1;
symbols=const(symbolIndices); %random symbols
x=zeros(1,S*L); %pre-allocate space
x(1:L:end)=symbols; %complete upsampling operation
%If QAM, yce is the complex envelope:
yce=conv(h_rc,x); %convolution by shaping pulse
yce(1:floor(length(h_rc)/2))=[]; %take out transient
write_complex_binary(outputFileName, yce(1:numSamples)); %take out tail
disp(['Wrote ' outputFileName]);
