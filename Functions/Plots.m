% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022

close all; clear; clc;

% Array Gain values calculated from SINR at fs=8kHz,Fs=800
X = categorical({'ULA','URA','UCA'});
X = reordercats(X,{'ULA','URA','UCA'});

ulaArrayGain=[4.2667 12.9 7.9602 14.3087 13.3259];
uraArrayGain=[3.3409 6.5429 15.1793 11.4578 13.2134];
ucaArrayGain=[1.9788 9.0682 4.3751 13.6868 13.3012];
ArrayGain = [ulaArrayGain;uraArrayGain;ucaArrayGain];

figure(1);
bar(X,ArrayGain);
xlabel('Microphone Arrays'); ylabel ('Array Gain (dB)');
legend('TD','PS','SPS','Frost','GSC');
title('Signal-to-Interference-Noise Ratio Improvement: Microphone Arrays');


figure(2);
X = categorical({'TD','PS','SPS','Frost','GSC'});
X = reordercats(X,{'TD','PS','SPS','Frost','GSC'});
meanArrayGain = mean(ArrayGain);
bar(X,meanArrayGain);
xlabel('Beamformers'); ylabel ('Array Gain (dB)');
title('Signal-to-Interference-Noise Ratio Improvement: Beamformers');


%% Latency of beamformers at fs=8kHz,Fs=800

close all; clear; clc;

X = categorical({'ULA','URA','UCA'});
X = reordercats(X,{'ULA','URA','UCA'});

ulaLatency=[101.4  101.6 103.6 103 108.7];
uraLatency=[101.4 100.5 102 112.7 107.1];
ucaLatency=[101.3 100.6 101.8 104.8 106.6];
Latency = [ulaLatency;uraLatency;ucaLatency];

figure(1);
bar(X,Latency);
xlabel('Microphone Arrays'); ylabel ('Latency (ms)');
legend('TD','PS','SPS','Frost','GSC');
title('Latency: Microphone Arrays');


figure(2);
X = categorical({'TD','PS','SPS','Frost','GSC'});
X = reordercats(X,{'TD','PS','SPS','Frost','GSC'});
meanLatency = mean(Latency);
bar(X,meanLatency);
xlabel('Beamformers'); ylabel ('Latency (ms)');
title('Latency: Beamformers');

%% MOS of Audio Quality
close all; clear; clc;

X = categorical({'ULA','URA','UCA'});
X = reordercats(X,{'ULA','URA','UCA'});

ulaLatency=[1.8  1.5 1.5 3.2 3.5];
uraLatency=[1.7 1.3 1.3 3.4 3.3];
ucaLatency=[2.1 1.2 1.4 4.4 4];
MOS = [ulaLatency;uraLatency;ucaLatency];

figure(1);
bar(X,MOS);
xlabel('Microphone Arrays'); ylabel ('MOS');
legend('TD','PS','SPS','Frost','GSC');
title('MOS: Microphone Arrays');


figure(2);
X = categorical({'TD','PS','SPS','Frost','GSC'});
X = reordercats(X,{'TD','PS','SPS','Frost','GSC'});
meanLatency = mean(MOS);
bar(X,meanLatency);
xlabel('Beamformers'); ylabel ('MOS');
title('MOS: Beamformers');ylim([1 5]);
