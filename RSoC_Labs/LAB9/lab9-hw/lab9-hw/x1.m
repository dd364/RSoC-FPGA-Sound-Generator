%% Generate a cos wave for the ROM
% Cos is generated between 0 and 255.
x=[0:255]/256*2*pi;
y = floor(cos(x)*127)+127;

% Plot
figure(1);
clf;
plot(x,y,'.');
% Generate ROM
dat2rom(y);





return;

