function y=channel_freeSpace(x,centerFrequency,txPosition)
% function y=channel_freeSpace(x,centerFrequency,txPosition)
%Corresponds to a simple free-space path loss. In dB it is:
%Lfs_dB = 32.45 + 20 log10(d) + 20 log10(f),
%where d is given in Km and f in MHz.
%Obs, it is assumed that rxPosition=[0;0;0];

%distance = sqrt(sum((txPosition-rxPosition).^2))
distance = sqrt(sum((txPosition).^2));
lightSpeed = 299792458; %constant value
lambda = lightSpeed/centerFrequency;
attenuation = ((4*pi*distance/lambda)^2);
%the attenuation is frequency-dependent but it is here assumed as
%a single value
y = x/attenuation;
