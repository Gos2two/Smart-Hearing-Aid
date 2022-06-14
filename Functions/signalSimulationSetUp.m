% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022
% Reference: Acoustic Beamforming Using a Microphone Array. The MathWorks Inc.
% URL: https://uk.mathworks.com/help/phased/ug/acoustic-beamforming-using-a-microphone-array.html

function mP = signalSimulationSetUp(mP)

    % SET UP MICROPHONE ELMENTS AND ARRAY GEOMETRY:

    % Model microphone elements with omnidirectional response pattern 
    microphone = phased.OmnidirectionalMicrophoneElement('FrequencyRange',[20 20e3]);

    % Arrange microphone elments into regular patterns ( Test different
    % geometries)
    Nele = mP.M;
    d    = mP.d;

    if (mP.ula)
        % Uniform linear array - based on ReSpeaker 4-Mic Linear Array Kit for Raspberry Pi
        mP.array = phased.ULA( Nele, d, 'Element',microphone);

    elseif (mP.ura)
        % Uniform linear array - based on ReSpeaker 4-Mic Linear Array Kit for Raspberry Pi
        mP.array = phased.URA( Nele/4, d, 'Element',microphone);

    elseif (mP.uca)
        % Uniform linear array - based on ReSpeaker 4-Mic Linear Array Kit for Raspberry Pi
        mP.array = phased.UCA( Nele, d, 'Element',microphone);
 
    end
    figure(1);
    plotResponse(mP.array, [20 2e3 20e3],mP.c,'RespCut','Az','Format','Polar','AzimuthAngles',[-90:.1:90])
    figure(2);
    plotFreq = linspace(20,20e3,100);
    pattern(mP.array,plotFreq,[-90:90],0,'CoordinateSystem','rectangular',...
    'PlotStyle','waterfall','Type','powerdb','PropagationSpeed',mP.c)
end