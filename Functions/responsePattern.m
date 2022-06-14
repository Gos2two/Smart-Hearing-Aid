% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022

%% Plot patterns: different microphones

clc;close all; clear;

%Omnidirectional
figure(1);
microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',[20 20e3]);
pattern(microphone,20000,[-180:180],0,'CoordinateSystem','polar','Type','powerdb');
%Cardioid
figure(2);
cardiod = phased.CustomMicrophoneElement;
cardiod.PolarPatternFrequencies = [500];
cardiod.PolarPattern = mag2db(0.5+0.5*cosd(cardiod.PolarPatternAngles));
fc = 500;
pattern(cardiod,fc,[-180:180],0,...
    'CoordinateSystem','polar',...
    'Type','powerdb');

%% Subband Phase Shift Beamformer
clc;close all; clear;

c = 343;
freq = [20 20e3];
fs = 8e3;
fo = 4001;
% 1) MICROPHONE:
microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',freq);
% 2) MICROPHONE ARRAY:
array = phased.ULA(4,0.05,'Element',microphone);
%array = phased.URA(4, 0.041,'Element',microphone);
%array = phased.UCA(8,0.045,'Element',microphone);

% Simulate a 3-second multichannel signal received by the array
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'NumSubbands',1000,'ModulatedInput', false);
% Noise signal with a power of 1e-4 watts to simulate the thermal noise for each sensor
prevS = rng(2008);
noisePwr = 1e-4; % noise power

% START SIMULATION:

% Initialize variables
NSampPerFrame = 800;
NTSample = 3*fs;
S = zeros(NTSample,4);% ! Change according to Mic Array num elementa

signal_1 = dsp.AudioFileReader('laughter_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_2 = dsp.AudioFileReader('dft_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_3 = dsp.AudioFileReader('cleanspeech_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
%signal_4 = dsp.AudioFileReader('Voice3.wav',...
%'SamplesPerFrame',NSampPerFrame);

% Simulate
for m = 1:NSampPerFrame:NTSample
    sig_idx = m:m+NSampPerFrame-1;
    x1 = 3*signal_1();   
    x2 = signal_2();               
    x3 = signal_3(); 
    temp = collector([x1 x2 x3],...
        [-10 60 30]) + ...
        sqrt(noisePwr)*randn(NSampPerFrame,4);% ! Change according to Mic Array num elements
    S(sig_idx,:) = temp;
end

direction = [60;0];
beamformer = phased.SubbandPhaseShiftBeamformer('SensorArray',array,...
   'Direction',direction,...
   'PropagationSpeed',c,...
   'SampleRate',fs,...
   'OperatingFrequency',fo,...
   'WeightsOutputPort',true,'SubbandsOutputPort',true);
[y,w,centerfreqs] = beamformer(S);
pattern(array,centerfreqs.',[-90:90],0,'Weights',w,'CoordinateSystem','rectangular',...
    'PlotStyle','waterfall','Type','powerdb','PropagationSpeed',c)

%% Time Delay Beamformer
clc;close all; clear;

c = 343;
freq = [20 20e3];
fs = 8e3;
fo = 4001;
numels = 4;

% 1) MICROPHONE:
microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',freq);
% 2) MICROPHONE ARRAY:
array = phased.ULA(4,0.05,'Element',microphone);
%array = phased.URA(4, 0.041,'Element',microphone);
%array = phased.UCA(8,0.045,'Element',microphone);

% Simulate a 3-second multichannel signal received by the array
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'NumSubbands',1000,'ModulatedInput', false);
% Noise signal with a power of 1e-4 watts to simulate the thermal noise for each sensor
prevS = rng(2008);
noisePwr = 1e-4; % noise power

% START SIMULATION:

% Initialize variables
NSampPerFrame = 80;
NTSample = 3*fs;
S = zeros(NTSample,4);% Change according to Mic Array

signal_1 = dsp.AudioFileReader('laughter_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_2 = dsp.AudioFileReader('dft_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_3 = dsp.AudioFileReader('cleanspeech_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
%signal_4 = dsp.AudioFileReader('Voice3.wav',...
%'SamplesPerFrame',NSampPerFrame);

% Simulate
for m = 1:NSampPerFrame:NTSample
    sig_idx = m:m+NSampPerFrame-1;
    x1 = 3*signal_1();   
    x2 = signal_2();               
    x3 = signal_3(); 
    temp = collector([x1 x2 x3],...
        [-30 60 10]) + ...
        sqrt(noisePwr)*randn(NSampPerFrame,4);% Change according to Mic Array
    S(sig_idx,:) = temp;
end

direction = [60;0];
numbands = 80;
beamformer = phased.TimeDelayBeamformer('SensorArray',array,...
'SampleRate',fs,'Direction',direction,'PropagationSpeed',c,'WeightsOutputPort',true);
rx = ones(numbands,8);
plotFreq = linspace(20,20000,80);
[y,w] = beamformer(S);
pattern(array,plotFreq,[-90:90],0,'Weights',w,'CoordinateSystem','rectangular',...
    'PlotStyle','waterfall','Type','powerdb','PropagationSpeed',c)

%% Phase Shift Beamformer
clc;close all; clear;

c = 343;
freq = [20 20e3];
fs = 8e3;
fo = 4001;

% 1) MICROPHONE:
microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',freq);
% 2) MICROPHONE ARRAY:
array = phased.ULA(4,0.05,'Element',microphone);
%array = phased.URA(4, 0.041,'Element',microphone);
%array = phased.UCA(8,0.045,'Element',microphone);

% Simulate a 3-second multichannel signal received by the array
collector = phased.WidebandCollector('Sensor',array,'PropagationSpeed',c,...
    'SampleRate',fs,'NumSubbands',1000,'ModulatedInput', false);
% Noise signal with a power of 1e-4 watts to simulate the thermal noise for each sensor
prevS = rng(2008);
noisePwr = 1e-4; % noise power

% START SIMULATION:

% Initialize variables
NSampPerFrame = 8000;
NTSample = 3*fs;
S = zeros(NTSample,4);% ! Change according to Mic Array

signal_1 = dsp.AudioFileReader('laughter_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_2 = dsp.AudioFileReader('dft_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_3 = dsp.AudioFileReader('cleanspeech_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
%signal_4 = dsp.AudioFileReader('Voice3.wav',...
%'SamplesPerFrame',NSampPerFrame);

% Simulate
for m = 1:NSampPerFrame:NTSample
    sig_idx = m:m+NSampPerFrame-1;
    x1 = 3*signal_1();   
    x2 = signal_2();               
    x3 = signal_3(); 
    temp = collector([x1 x2 x3],...
        [-20 60 30]) + ...
        sqrt(noisePwr)*randn(NSampPerFrame,4);% ! Change according to Mic Array
    S(sig_idx,:) = temp;
end

direction = [60;0];
numbands = 8000;
beamformer = phased.PhaseShiftBeamformer('SensorArray',array,...
'PropagationSpeed',c,'Direction',direction,'WeightsOutputPort',true,'OperatingFrequency',fo,'WeightsNormalization','Distortionless');
rx = ones(numbands,8);
plotFreq = linspace(20,20000,80);
[y,w] = beamformer(S);
pattern(array,plotFreq,[-90:90],0,'Weights',w,'CoordinateSystem','rectangular',...
    'PlotStyle','waterfall','Type','powerdb','PropagationSpeed',c)
%% Frost Beamformer

clear; close all; clc;
c = 343;
freq = [20 20e3];
fs = 8e3;


% 1) MICROPHONE:
microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',freq);
% 2) MICROPHONE ARRAY:
%h = phased.ULA(4,0.05,'Element',microphone);
%h = phased.URA(4, 0.041,'Element',microphone);
h = phased.UCA(8,0.045,'Element',microphone);

% Simulate a 3-second multichannel signal received by the array
collector = phased.WidebandCollector('Sensor',h,'PropagationSpeed',c,...
    'SampleRate',fs,'NumSubbands',1000,'ModulatedInput', false);
% Noise signal with a power of 1e-4 watts to simulate the thermal noise for each sensor
prevS = rng(2008);
noisePwr = 1e-4; % noise power

% START SIMULATION:

% Initialize variables
NSampPerFrame = 800;
NTSample = 3*fs;
S = zeros(NTSample,8);% ! Change according to Mic Array

signal_1 = dsp.AudioFileReader('laughter_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_2 = dsp.AudioFileReader('dft_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_3 = dsp.AudioFileReader('cleanspeech_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
%signal_4 = dsp.AudioFileReader('Voice3.wav',...
%'SamplesPerFrame',NSampPerFrame);

% Simulate
for m = 1:NSampPerFrame:NTSample
    sig_idx = m:m+NSampPerFrame-1;
    x1 = 3*signal_1();   
    x2 = signal_2();               
    x3 = signal_3(); 
    temp = collector([x1 x3 x2],...
        [-60 -10 30]) + ...
            sqrt(noisePwr)*randn(NSampPerFrame,8);% ! Change according to Mic Array
    S(sig_idx,:) = temp;
end


direction = [40;0];

beamformer = phased.FrostBeamformer('SensorArray',h,...
    'PropagationSpeed',c,'SampleRate',fs,...
    'Direction',direction,'FilterLength',5,...
    'WeightsOutputPort',true);
[y,yweights] = step(beamformer,S);

% plot pattern
% consider 16 bands and pick the band corresponding to 2 kHz
M = 16;
wfreq = fft(reshape(yweights,8,[]).',M);%! Change according to Mic Array
freqvec = [0:7 -8:-1]*fs/M;
bandidx = 5;  % corresponding to 2kHz
freqbin = 2e3;
hstv = phased.SteeringVector('SensorArray',h,'PropagationSpeed',c);
sv = step(hstv,freqbin,direction);
figure
pattern(h,freqvec(2:3:8),-90:90,0,'PropagationSpeed',c,'Weights',sv.*wfreq(2:3:8,:).',...
    'CoordinateSystem','polar','Type','powerdb');