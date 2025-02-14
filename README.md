# Wav2XWav
MATLAB Code to convert sound files from wav to x.wav format used in Triton
Wav is a standard audio format, and it is assumed that the file name contains
the start time as: Year Month Day Hour Min Sec for example 20250214135300.wav

x.wav is the format used by Triton that includes additional information in the
header to allow metadata to be stored with the sound data.

Convertwav2xwav is the main routine.  It asks for a directory with wav files.
All these files will be converted in x.wav files and written to the same direction
but within a subdirectory called xwav.

settingswav2xwav is a file with information specific to the deployment. Here are 
the parameters required:
WavVersionNumber = '1';
FirmwareVersionNumber = '0123456789';
InstrumentID = 'SM2X';
SiteName = 'INYA';
ExperimentName = 'BIRDBUGS';
DiskSequenceNumber = '1';
DiskSerialNumber = '12345678';
Longitude = 32.8738;
Latitude = -117.2460;
Depth = -112;

charnum is called by settingswav2xwav to ensure that the entries have the correct number of 
characters for the xwav header.  They are entered into PARAMS.xhd.

wav2xwavX is the subroutine that reads the wav data and writes it to the x.wav file

wrxwavhdX is borrowed from Triton, code to write the xwav header
