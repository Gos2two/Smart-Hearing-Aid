% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022

% Reference: Acoustic Beamforming Using a Microphone Array. The MathWorks Inc.
% URL: https://uk.mathworks.com/help/phased/ug/acoustic-beamforming-using-a-microphone-array.html

% MAIN
close all; clear; clc;

mP = getParameters;
mP = signalSimulationSetUp(mP);

% Initialize variables
Nele = mP.M;
fs = mP.fs;
c  = mP.c;
t_duration = mP.t_duration;  % Test duration
t = 0:1/fs:t_duration-1/fs;
% Incident direction of audio signals - no change in elevation
ang_1 = [-60; 0];
ang_2 = mP.angSteer;
ang_3 = [-10;0];
%ang_4 = [70; 0];

% Simulate a 3-second multichannel signal received by the array
collector = phased.WidebandCollector('Sensor',mP.array,'PropagationSpeed',c,...
    'SampleRate',fs,'NumSubbands',1000,'ModulatedInput', false);

% Noise signal with a power of 1e-4 watts to simulate the thermal noise for each sensor
prevS = rng(2008);
noisePwr = 1e-4; % noise power

% START SIMULATION:

% Initialize variables
NSampPerFrame = mP.Fs;
NTSample = t_duration*fs;
S = zeros(NTSample,Nele);
voice_dft = zeros(NTSample,1); % store for SINR improvement
voice_cleanspeech = zeros(NTSample,1); % store for SINR improvement
voice_laugh = zeros(NTSample,1); % store for SINR improvement

% Set up audio device writer
audioWriter = audioDeviceWriter('SampleRate',fs, ...
    'SupportVariableSizeInput', true);
isAudioSupported = (length(getAudioDevices(audioWriter))>1);

signal_1 = dsp.AudioFileReader('laughter_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_2 = dsp.AudioFileReader('dft_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
signal_3 = dsp.AudioFileReader('cleanspeech_voice_8kHz.wav',...
'SamplesPerFrame',NSampPerFrame);
%signal_4 = dsp.AudioFileReader('Voice3.wav',...
%'SamplesPerFrame',NSampPerFrame);

% Simulate
disp("Listening to original audio:")
for m = 1:NSampPerFrame:NTSample
    sig_idx = m:m+NSampPerFrame-1;
    x1 = 2*signal_1();   
    x2 = signal_2();               
    x3 = signal_3(); 
    %x4 = 3*signal_4();
    temp = collector([x1 x2 x3],...
        [ang_1 ang_2 ang_3]) + ...
        sqrt(noisePwr)*randn(NSampPerFrame,Nele);
    if isAudioSupported
        play(audioWriter,0.5*real(temp(:,3)));
    end
    S(sig_idx,:) = temp;
    voice_dft(sig_idx) = x2;
    voice_cleanspeech(sig_idx) = x3;
    voice_laugh(sig_idx) = x1;
end

% CONSTRUCT BEAMFORMER:
beamformer = constructBf(mP);
signalsource = dsp.SignalSource('Signal',S,...
'SamplesPerFrame',NSampPerFrame);

cbfOut = zeros(NTSample,1);
disp("Listening to beamformed audio:")
tic;
for m = 1:NSampPerFrame:NTSample
    temp = beamformer(signalsource());
    
    if isAudioSupported
        play(audioWriter,real(temp));
    end
    cbfOut(m:m+NSampPerFrame-1,:) = temp;

end
delay = toc;

% Plot audio: pre and post beamforming.

plot(t,S(:,3)); hold on;plot(t,cbfOut);
xlabel('Time (Sec)'); ylabel ('Amplitude (V)');
legend('Mixed Signal','Beamformed Signal');
title('Time Delay Beamformer'); ylim([-3 3]);

% Speech enhancement measure by the array gain.
arrayGain = pow2db(mean((voice_cleanspeech+voice_laugh).^2+noisePwr)/...
    mean((cbfOut - voice_dft).^2))

% Latancy.
latancy = (delay/(NTSample/NSampPerFrame)) + (NSampPerFrame/fs)

% Plot target signal
figure(3)
plot(t,voice_dft);
xlabel('Time (Sec)'); ylabel ('Amplitude (V)');
title('Target Signal: Speech'); ylim([-3 3]);

