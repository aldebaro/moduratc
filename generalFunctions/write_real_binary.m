function write_real_binary(file_name, signal)
% function write_real_binary(file_name, signal)
%   Save the vector of real samples given as to a file
%   called 'file_name'.

% Create vector to be written
if ~isreal(signal)
    error('Signal is complex!');
end

% Write data to the file
fp = fopen(file_name, 'wb');
fwrite(fp, signal, 'float32');
fclose(fp);

