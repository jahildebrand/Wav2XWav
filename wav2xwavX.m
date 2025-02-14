function wav2xwavX(pathin, inpu, pathout, outpu)
global PARAMS DATA HANDLES

% Define paths
PARAMS.outpath = [pathout,'\'];
PARAMS.outfile = outpu;
output_xwav = fullfile(PARAMS.outpath, PARAMS.outfile);

PARAMS.inpath = [pathin,'\'];
PARAMS.infile = inpu;
input_wav = fullfile(PARAMS.inpath, PARAMS.infile);

% Read WAV file info (without loading full data)
rdwavhd
info = audioinfo(input_wav);
% 
% % Initialize global PARAMS
PARAMS.fs = info.SampleRate;
PARAMS.nch = info.NumChannels;
PARAMS.nBits = info.BitsPerSample;
PARAMS.samp.byte = PARAMS.nBits / 8;  % Bytes per sample
PARAMS.df = 1; % Decimation factor (default 1)
PARAMS.gain = 1; % Default gain
% 
% % Initialize PARAMS.xhd fields
PARAMS.xhd.NumSamples = info.TotalSamples;
PARAMS.xhd.SampleRate = PARAMS.fs;
PARAMS.xhd.BitsPerSample = PARAMS.nBits;
PARAMS.xhd.DataSize = PARAMS.xhd.NumSamples * PARAMS.nch * PARAMS.samp.byte;
PARAMS.xhd.sample_rate = PARAMS.fs;
PARAMS.xhd.ByteRate = PARAMS.xhd.SampleRate * PARAMS.nch * PARAMS.samp.byte;
PARAMS.xhd.NumOfRawFiles = 1;
PARAMS.xhd.byte_length = PARAMS.xhd.DataSize;
PARAMS.xhd.write_length = PARAMS.xhd.DataSize;
% 
% Extract date/time metadata from filename
[~, name, ~] = fileparts(input_wav);
date_pattern = '(\d{4})(\d{2})(\d{2})_(\d{2})(\d{2})(\d{2})';
tokens = regexp(name, date_pattern, 'tokens');

% Check if the pattern was found

if ~isempty(tokens)
    date_vals = str2double(tokens{1});
    PARAMS.xhd.year = date_vals(1);
    PARAMS.xhd.month = date_vals(2);
    PARAMS.xhd.day = date_vals(3);
    PARAMS.xhd.hour = date_vals(4);
    PARAMS.xhd.minute = date_vals(5);
    PARAMS.xhd.secs = date_vals(6);
    PARAMS.xhd.ticks = 0;
    PARAMS.plot.dnum = datenum([PARAMS.xhd.year ...
    PARAMS.xhd.month ...
    PARAMS.xhd.day ...
    PARAMS.xhd.hour ...
    PARAMS.xhd.minute ...
    PARAMS.xhd.secs]);
else
    warning('Filename does not contain a valid timestamp. Using default values.');
    PARAMS.xhd.year = 2000;
    PARAMS.xhd.month = 1;
    PARAMS.xhd.day = 1;
    PARAMS.xhd.hour = 0;
    PARAMS.xhd.minute = 0;
    PARAMS.xhd.secs = 0;
    PARAMS.xhd.ticks = 0;
end

% Additional metadata fields
settingswav2xwav % load settings specfic to this deployment

% 
% Compute required subchunk sizes
header_size = 64 + (32 * PARAMS.xhd.NumOfRawFiles) + 8;
PARAMS.xhd.nsubchunksize = sum(PARAMS.xhd.byte_length) + (header_size - 8);
PARAMS.xhd.dsubchunksize = sum(PARAMS.xhd.byte_length);
PARAMS.ch = 1;

DATA = audioread(input_wav, 'native'); % int16
num_samples = length( DATA );
data_bytes  = num_samples * 2; % 16 bits (2 bytes) per sample. Num bytes in
%     rf_byte_length = PARAMS.xhd.byte_length( 1 ); % we're trusting they stay
% consistent in xhd
% PARAMS.tseg.samp = PARAMS.fs * 60;  % 60 seconds * sample rate
PARAMS.tseg.samp = info.TotalSamples;
rf_byte_length = PARAMS.tseg.samp * PARAMS.samp.byte;
num_rf = ceil( data_bytes / rf_byte_length );
PARAMS.xhd.gain = ones(1, num_rf) * PARAMS.gain;
PARAMS.xhd.sample_rate = ones( 1, num_rf )*  PARAMS.fs;
PARAMS.xhd.byte_length = ones( 1, num_rf )* rf_byte_length;
PARAMS.xhd.NumOfRawFiles = 1;
% Call wrxwavhd to write the header
wrxwavhdX(1);
% wrxwavhd(3);
% xwav_file = (fullfile(pathout,outpu));
%  read_xwav_header(xwav_file)
% dump data to output file
% open output file
dtype = 'int16';
fod = fopen([PARAMS.outpath,PARAMS.outfile],'a');
DATA = reshape(DATA', 1, []); % Ensures row-wise order
fwrite(fod,DATA,dtype);
fclose(fod);

% 
% % Open the file after writing the header
% fid = fopen(output_xwav, 'a');
% if fid == -1
%     error('Failed to open output file after writing header: %s', output_xwav);
% end
% 
% % Process audio in chunks using audioread
% chunk_duration = 1;  % Process 1 second at a time
% chunk_samples = PARAMS.fs * chunk_duration;
% num_chunks = ceil(info.TotalSamples / chunk_samples);
% 
% % Open input WAV file for reading
% for i = 0:num_chunks-1
%     start_sample = i * chunk_samples + 1;
%     end_sample = min((i + 1) * chunk_samples, info.TotalSamples);
% 
%     % Read the chunk using audioread
%     [audio_chunk, ~] = audioread(input_wav, [start_sample, end_sample]);
% 
%     % Convert to 16-bit PCM
%     audio_chunk = int16(audio_chunk * 32767);
% 
%     % Ensure stereo data is interleaved correctly
%     audio_chunk = reshape(audio_chunk', [], 1);
% 
%     % Debugging: Print chunk size before writing
%     fprintf('Writing chunk %d/%d, samples: %d\n', i+1, num_chunks, length(audio_chunk));
% 
%     % Write data to the XWAV file
%     fwrite(fid, audio_chunk, 'int16');
% 
%     % Check file size after writing each chunk
%     file_info = dir(output_xwav);
%     fprintf('File size after writing chunk %d: %d bytes\n', i+1, file_info.bytes);
% end
% 
% 
% 
% % Close files
% fclose(fid);

fprintf('Successfully converted %s to %s\n', input_wav, output_xwav);
end
