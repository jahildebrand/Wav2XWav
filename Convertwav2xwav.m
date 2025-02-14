%Convert a directory of wav files to xwav file
% use settingswav2xwav to hold deployment specfic information
%JAH 2-2025
% Prompt user for the input directory
pathin = uigetdir('', 'Select the folder containing WAV files');
if pathin == 0
    disp('No folder selected. Exiting.');
    return;
end

% Define output directory
pathout = fullfile(pathin, 'xwav');

% Create output directory if it does not exist
if ~exist(pathout, 'dir')
    mkdir(pathout);
end

% Get a list of all .wav files in the directory
wav_files = dir(fullfile(pathin, '*.wav'));

% Loop through each .wav file and process it
for i = 1:length(wav_files)
    inpu = wav_files(i).name;
    outpu = strrep(inpu, '.wav', '.x.wav'); % Change file extension

    % Display processing information
    fprintf('Processing: %s -> %s\n', inpu, outpu);
    
    % Call the function to convert wav to xwav
    wav2xwavX(pathin, inpu, pathout, outpu);
end

disp('Processing complete!');
