clear all
close all
clc

[mediamuestral,TamRealizaciones]=GetAveragedNoise();

%% Initial Conditions
% Parameters for findpeaks Function
% MinPeakWidth
MinPeakWidthRest = 0.11;
MinPealWidthRun_2 = 0.11;
MinPealWidthRun_3 = 0.11;
MinPealWidthRun_4 = 0.11;
MinPealWidthRun_5 = 0.11;
% MaxWidthPeak
MaxWidthRest1 = 0.5;
MaxWidthRun2 = 0.5;
MaxWidthRun3 = 0.5;
MaxWidthRun4 = 0.5;
MaxWidthRun5 = 1;
MaxWidthRest6 = 0.5;
%Prominences
ProminenceInRest = 0.05;
ProminenceRunning = 0.15;
% MiN Width in ECG
MinWidthECGRest1 = 0.6;
MinWidthECGRun2 = 0.55;
MinWidthECGRun3 = 0.6;
MinWidthECGRun4 = 0.65;
MinWidthECGRun5 = 0.7;
MinWidthECGRest6 = 0.6;
%Min Dist in ECG
minDistRest1 = 0.15;
minDistRun2 = 0.15;
minDistRun3 = 0.15;
minDistRun4 = 0.15;
minDistRun5 = 0.15;
minDistRest6 = 0.15;%% PROOF 1: Cleaning corrupted signal with Savitzky-Golay filter.
% Random sample signal: 
ppg = load('DATA_07_TYPE02.mat');
ppgSig = ppg.sig;
ppgFullSignal = ppgSig(2,(1:length(mediamuestral)));% match sizes 
% Sample Frequency
Fs = 125;
% Normalize with min-max method
ppgFullSignal = (ppgFullSignal-128)./255;
ppgFullSignal = (ppgFullSignal-min(ppgFullSignal))./(max(ppgFullSignal)-min(ppgFullSignal));
t = (0:length(ppgFullSignal)-1);   
% Separate noise with its correspondent activity.
ruido1 = mediamuestral(1,(1:3750));
ruido2 = mediamuestral(1,(3751:11250));
ruido3 = mediamuestral(1,(11251:18750));
ruido4 = mediamuestral(1,(18751:26250));
ruido5 = mediamuestral(1,(26251:33750));
ruido6 = mediamuestral(1,(33751:min(TamRealizaciones)));

% Sectionally take off noise from each correspondent activity.
CleanedSignal1 = ppgFullSignal(1,(1:3750))-ruido1;
CleanedSignal2 = ppgFullSignal(1,(3751:11250))-ruido2;
CleanedSignal3 = ppgFullSignal(1,(11251:18750))-ruido3;
CleanedSignal4 = ppgFullSignal(1,(18751:26250))-ruido4;
CleanedSignal5 = ppgFullSignal(1,(26251:33750))-ruido5;
CleanedSignal6 = ppgFullSignal(1,(33751:min(TamRealizaciones)))-ruido6;

% 1. ORIGINAL en reposo vs sin ruido
[PKS1Original,LOCS1Original] = GetPeakPoints(ppgFullSignal(1,(1:3750)),...
    Fs,MinPeakWidthRest,MaxWidthRest1,ProminenceInRest);
[PKS1ruido,LOCS1ruido] = GetPeakPoints(CleanedSignal1,Fs,MinPeakWidthRest,MaxWidthRest1,ProminenceInRest);
% 2. CORRIENDO 1min se�al original vs sin ruido
[PKS2Original,LOCS2Original] = GetPeakPoints(ppgFullSignal(1,(3751:11250)),...
    Fs,MinPealWidthRun_2,MaxWidthRun2,ProminenceRunning);
[PKS2ruido,LOCS2ruido] = GetPeakPoints(CleanedSignal2,Fs,MinPealWidthRun_2,MaxWidthRun2,ProminenceRunning);
% 3. CORRIENDO 1min se�al original vs sin ruido
[PKS3Original,LOCS3Original] = GetPeakPoints(ppgFullSignal(1,(11251:18750)),...
    Fs,MinPealWidthRun_3,MaxWidthRun3,ProminenceRunning);
[PKS3ruido,LOCS3ruido] = GetPeakPoints(CleanedSignal3,Fs,MinPealWidthRun_3,MaxWidthRun3,ProminenceRunning);
% 4. CORRIENDO 1min se�al original vs sin ruido
[PKS4Original,LOCS4Original] = GetPeakPoints(ppgFullSignal(1,(18751:26250)),...
    Fs,MinPealWidthRun_4,MaxWidthRun4,ProminenceRunning);
[PKS4ruido,LOCS4ruido] = GetPeakPoints(CleanedSignal4,Fs,MinPealWidthRun_4,MaxWidthRun4,ProminenceRunning);
% 5. CORRIENDO 1min se�al original vs sin ruido
[PKS5Original,LOCS5Original] = GetPeakPoints(ppgFullSignal(1,(26251:33750)),...
    Fs,MinPealWidthRun_5,MaxWidthRun5,ProminenceRunning);
[PKS5ruido,LOCS5ruido] = GetPeakPoints(CleanedSignal5,Fs,MinPealWidthRun_5,MaxWidthRun5,ProminenceRunning);
% 6. REST 30s se�al original vs sin ruido
[PKS6Original,LOCS6Original] = GetPeakPoints(ppgFullSignal(1,(33751:end)),...
    Fs,MinPeakWidthRest,MaxWidthRest6,ProminenceInRest);
[PKS6ruido,LOCS6ruido] = GetPeakPoints(CleanedSignal6,Fs,MinPeakWidthRest,MaxWidthRest6,ProminenceInRest);

%% Error using HeartBeats from findpeaks
ErrorFindP1 = 100*abs(length(LOCS1ruido(1,:))-length(LOCS1Original(1,:)))./length(LOCS1Original(1,:));
ErrorFindP2 = 100*abs(length(LOCS2ruido(1,:))-length(LOCS2Original(1,:)))./length(LOCS2Original(1,:));
ErrorFindP3 = 100*abs(length(LOCS3ruido(1,:))-length(LOCS3Original(1,:)))./length(LOCS3Original(1,:));
ErrorFindP4 = 100*abs(length(LOCS4ruido(1,:))-length(LOCS4Original(1,:)))./length(LOCS4Original(1,:));
ErrorFindP5 = 100*abs(length(LOCS5ruido(1,:))-length(LOCS5Original(1,:)))./length(LOCS5Original(1,:));
ErrorFindP6 = 100*abs(length(LOCS6ruido(1,:))-length(LOCS6Original(1,:)))./length(LOCS6Original(1,:));
ErrorFromFindPeaks = [ErrorFindP1 ErrorFindP2 ErrorFindP3 ErrorFindP4 ErrorFindP5 ErrorFindP6];
%% Error from BPM 
% bpm stores the bpm in the matrix 6x12, where 1-6 represents the type of
% activity and 1-12 represents the number of realizations. Since the bpm is
% taken from 8 windows size and is overlapping every 6s, there are 2
% effective seconds and therefore, the activity 1 (Rest per 30s)
% corresponds to 15 effective seconds
bpm = CompareBPM();
realizacion = 10;
% Separate peaks from findpeaks detection 
FindPeaks1 = length(LOCS1ruido);
FindPeaks2 = length(LOCS2ruido);
FindPeaks3 = length(LOCS3ruido);
FindPeaks4 = length(LOCS4ruido);
FindPeaks5 = length(LOCS5ruido);
FindPeaks6 = length(LOCS6ruido);
% For computational reasons, we separate the 30s-activities
bpm1 = bpm(1,realizacion)./2;
bpm6 = bpm(6,realizacion)./2;
%
EBPM1 = 100*abs(FindPeaks1-bpm1)./bpm1;
EBPM2 = 100*abs(FindPeaks2-bpm(2,realizacion))./bpm(2,realizacion);
EBPM3 = 100*abs(FindPeaks3-bpm(3,realizacion))./bpm(3,realizacion);
EBPM4 = 100*abs(FindPeaks4-bpm(4,realizacion))./bpm(4,realizacion);
EBPM5 = 100*abs(FindPeaks5-bpm(5,realizacion))./bpm(5,realizacion);
EBPM6 = 100*abs(FindPeaks6-bpm6)./bpm6;
ErrorFromBPM = [EBPM1 EBPM2 EBPM3 EBPM4 EBPM5 EBPM6];


%% PROOF 2: ECG peaks detection
% Random sample signal: 
ecg = load('DATA_07_TYPE02.mat');
ecgSig = ecg.sig;
ecgFullSignal = ecgSig(1,(1:length(mediamuestral)));% match sizes 
% Normalize with min-max method
ecgFullSignal = (ecgFullSignal-128)./255;
ecgFullSignal = (ecgFullSignal-min(ecgFullSignal))./(max(ecgFullSignal)-min(ecgFullSignal));
% Squared signal to 
ecgF = (abs(ecgFullSignal)).^2;
t = (0:length(ecgFullSignal)-1)/Fs;   

[ECG1Peaks,ECG1Locs] = GetECGPeakPoints(ecgF(1,(1:3750)),MinWidthECGRest1,minDistRest1);
[ECG2Peaks,ECG2Locs] = GetECGPeakPoints(ecgF(1,(3751:11250)),MinWidthECGRun2,minDistRun2);
[ECG3Peaks,ECG3Locs] = GetECGPeakPoints(ecgF(1,(11251:18750)),MinWidthECGRun3,minDistRun3);
[ECG4Peaks,ECG4Locs] = GetECGPeakPoints(ecgF(1,(18751:26250)),MinWidthECGRun4,minDistRun4);
[ECG5Peaks,ECG5Locs] = GetECGPeakPoints(ecgF(1,(26251:33750)),MinWidthECGRun5,minDistRun5);
[ECG6Peaks,ECG6Locs] = GetECGPeakPoints(ecgF(1,(33751:end)),MinWidthECGRest6,minDistRest1);

peaksECG1 = length(ECG1Locs);
peaksECG2 = length(ECG2Locs);
peaksECG3 = length(ECG3Locs);
peaksECG4 = length(ECG4Locs);
peaksECG5 = length(ECG5Locs);
peaksECG6 = length(ECG6Locs);

ECGERROR1 = 100*abs(FindPeaks1-peaksECG1)./peaksECG1;
ECGERROR2 = 100*abs(FindPeaks2-peaksECG2)./peaksECG2;
ECGERROR3 = 100*abs(FindPeaks3-peaksECG3)./peaksECG3;
ECGERROR4 = 100*abs(FindPeaks4-peaksECG4)./peaksECG4;
ECGERROR5 = 100*abs(FindPeaks5-peaksECG5)./peaksECG5;
ECGERROR6 = 100*abs(FindPeaks6-peaksECG6)./peaksECG6;

ErrorFromECG = [ECGERROR1 ECGERROR2 ECGERROR3 ECGERROR4 ECGERROR5 ECGERROR6];

disp('CALCULO % ERRORES: Fila 1 (FindPeaks), Fila 2 (BPM), Fila 3 (ECG)')
ErroresTotales = [ErrorFromFindPeaks;ErrorFromBPM;ErrorFromECG]