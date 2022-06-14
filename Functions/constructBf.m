% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022
% Reference: Acoustic Beamforming Using a Microphone Array. The MathWorks Inc.
% URL: https://uk.mathworks.com/help/phased/ug/acoustic-beamforming-using-a-microphone-array.html

function beamformer = constructBf(mP)

    % CONSTRUCT BEAMFORMER:
    
    % Initialize parameters

    angSteer        = mP.angSteer;
    fs              = mP.fs;
    array           = mP.array;
    c               = mP.c;

    % Construct selected beamformer:

    % Conventional:
    
    if (mP.TimeDelay) % Time Delay Beamformer
        beamformer = phased.TimeDelayBeamformer('SensorArray',array,...
        'SampleRate',fs,'Direction',angSteer,'PropagationSpeed',c);

    elseif (mP.PShift) % Phase Shift Beamformer
        beamformer = phased.PhaseShiftBeamformer('SensorArray',array,...
    'PropagationSpeed',c,'Direction',angSteer,'OperatingFrequency',20001,'WeightsNormalization','Preserve power');

    elseif (mP.SPShift) % Subband Phase Shift Beamformer
        beamformer = phased.SubbandPhaseShiftBeamformer('SensorArray',array,'SampleRate',fs,...
    'PropagationSpeed',c,'Direction',angSteer,'NumSubbands',80,'OperatingFrequency',4001);

    % Optimal and adaptive:
    
    elseif (mP.Frost) % Frost Beamformer
        beamformer = phased.FrostBeamformer('SensorArray',array,'SampleRate',fs,...
    'PropagationSpeed',c,'FilterLength',20,'Direction',angSteer);

    elseif (mP.GSC) % GSC Beamformer
        beamformer = phased.GSCBeamformer('SensorArray',array,'SampleRate',fs,...
    'PropagationSpeed',c,'FilterLength',20,'Direction',angSteer);
    end


end