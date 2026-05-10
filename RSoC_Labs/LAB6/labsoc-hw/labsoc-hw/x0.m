a=load('labcpu3.sim\sim_1\behav\xsim\audio.dat');
% Keep only 2nd column
a=a(:,2);

%% Low-pass filter
% PWM sample rate is 200KHz
fs = 200000;
% Cut at 16 KHz (same cut-off frequency as the hardware low-pass
% filter on the Nexys4 board).x0
%
% Design filter with inflection point below 16Hz (10KHz here)
fc = 10000;
%
% Design the filter: n coefficients, low pass. 
% wn: cut-off of 1 is fs/2 (i.e. no filtering). 
%
fcoef = fir1(75,2*fc/fs,'low');
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
title('Original (PWM');
ax(2) = subplot(2,1,2);
plot(af);
ylim([-1 2]);
title('After filtering');
linkaxes(ax,'x');

%% Play the sound
soundsc(a,200000);