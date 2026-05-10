%% Load a file created during the testbench and play/visualises it.
% Specify the path to the audio.dat file to load
%
% Assuming that x0.m is in the root folder of the project called <prj>
% the audio.dat file would be in <prj>.sim\sim_1\behav\xsim\audio.dat
a=load('lab7.sim\sim_1\behav\xsim\audio.dat');

%% No need to change below
% Keep only 2nd column
a=a(:,2);

%% Low-pass filter
% PWM sample rate is 10MHz
fs = 10000000;
% Cut at 16 KHz (same cut-off frequency as the hardware low-pass
% filter on the Nexys4 board).x0
%
% Design filter with inflection point below 16Hz (10KHz here)
fc = 10000;
%
% Design the filter: n coefficients, low pass. 
% wn: cut-off of 1 is fs/2 (i.e. no filtering). 
%
fcoef = fir1(600,2*fc/fs,'low');
% Filter
af = filter(fcoef,1,a);

%% Plot the frequency response of the filter
figure(1); clf;
freqz(fcoef,1);

%% Plot the original (binary) data and after filtering
figure(2);
clf;
ax(1) = subplot(2,1,1);
plot(a);
ylim([-1 2]);
title('Original (PWM) at 10MHz');
ax(2) = subplot(2,1,2);
plot(af);
ylim([-1 2]);
title('After filtering (10MHz)');
linkaxes(ax,'x');

%% Downsample the audio to 200KHZ
ad = downsample(af,10000000/200000);
figure(3);
clf;
plot(ad);
title(['Signal after filtering downsampled to ' num2str(2*fc) ' Hz']);

%% Play the sound
soundsc(ad,200000);