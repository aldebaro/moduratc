function x = read_real_binary(fileName, maxNumOfSamples)
%Read real-valued signal written as binary file.
%File is little-endian float values.
%Returns as column vector.
%maxNumOfSamples is the maximum number of complex samples.
%If maxNumOfSamples is not specified, all samples are read.
if (nargin < 2)
    maxNumOfSamples = Inf;
end
fp = fopen (fileName, 'rb');
if (fp < 0)
    error(['Could not open ' fileName]);
else
    x = fread (fp, [1, maxNumOfSamples], 'float');    
    x=x(:); %make it a column vector
end
fclose (fp);