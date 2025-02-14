function settingswav2xwav
% the settings that are needed to create an Xwav from a wav
%JAH 2-2025
%charnum 

global PARAMS

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

PARAMS.xhd.WavVersionNumber = charnum(WavVersionNumber,1);
PARAMS.xhd.FirmwareVersionNumber = charnum(FirmwareVersionNumber,10);
PARAMS.xhd.InstrumentID = charnum(InstrumentID,4);
PARAMS.xhd.SiteName = charnum(SiteName,4);
PARAMS.xhd.ExperimentName = charnum(ExperimentName,8);
PARAMS.xhd.DiskSequenceNumber = charnum(DiskSequenceNumber,1);
PARAMS.xhd.DiskSerialNumber = charnum(DiskSerialNumber,8);
PARAMS.xhd.Longitude = Longitude;
PARAMS.xhd.Latitude = Latitude;
PARAMS.xhd.Depth = Depth;
