% Smart Hearing Aid - Final Year Project
% Author: Sergio Gosalvez
% Imperial College London 2022

clc;clear; close all;

deviceReader = audioDeviceReader('');
release(deviceReader);
deviceReader.ChannelMappingSource = 'Property';
release(deviceReader);
deviceReader.ChannelMappingSource = 'Property';
deviceReader.ChannelMapping = [8,6,4,2,7,6,3,1,10,12,14,16,9,11,13,15];
release(deviceReader);
setup(deviceReader);
x = deviceReader();
