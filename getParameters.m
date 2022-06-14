% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022

% MENU 

function modelParameters = getParameters

    modelParameters.N = 3;                  % Number of sources
    modelParameters.fs = 8000;              % Sampling frequency [Hz]
    modelParameters.Fs = 800;              % Samples per frame
    modelParameters.c = 343;                % Speed of sound [m/s]
    modelParameters.angSteer = [30; 0];    % Speed of sound [m/s]
    modelParameters.t_duration = 3;         % Test duration [s]

    % ---------------------- Geometries -----------------------------------
    modelParameters.ula = false;             % ReSpeaker 4-Mic Linear Array Kit for Raspberry Pi
    modelParameters.ura = true;            % UMA-16 Mic Array
    modelParameters.uca = false;            % UMA-8 USB Mic Array
    
    if (modelParameters.ula)
        modelParameters.M = 4;              % Number of microphones
        modelParameters.d = 0.05;           % Spacing between microphones [m]
    elseif (modelParameters.ura)
        modelParameters.M = 16;             % Number of microphones
        modelParameters.d = 0.042;          % Spacing between microphones [m]
    elseif (modelParameters.uca)
        modelParameters.M = 8;              % Number of microphones
        modelParameters.d = 0.045;          % Spacing between microphones [m]
    end

    % ---------------------- Beamformers -----------------------------------
    % Conventional:
    modelParameters.TimeDelay = false;      % Time Delay Beamformer
    modelParameters.PShift = false;         % Phase Shift Beamformer
    modelParameters.SPShift = false;        % Subband Phase Shift Beamformer
    % Optimal and Adaptive:
    modelParameters.Frost = true;           % Frost Beamformer
    modelParameters.GSC = false;            % GSC Beamformer

end