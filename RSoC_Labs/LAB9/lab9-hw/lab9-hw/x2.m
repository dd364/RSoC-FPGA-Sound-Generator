files=dir('*.wav');

for fi = 1:length(files)


    w{fi}=audioread(files(fi).name);
    % Repeat n times
    n=100;
    w2{fi}=repmat(w{fi},n,1);


    figure(fi);
    clf;
    subplot(3,1,1);
    plot(w{fi});
    subplot(3,1,2);
    plot(w2{fi});
    title(files(fi).name);

    % Frequency is 600 samples for 1/75hz, i.e. ~44100

    soundsc(w2{fi},44100);
    
    
    % Data must be downsampled to fit in 256 samples
    % 600 -> 256 samples
    x = w{fi};
    y=resample(x,256,600);
    % Rescale between 0-255
    y=y-min(y);
    y=floor(y/max(y)*255);
    %[min(y) max(y)]
    subplot(3,1,3);
    plot(y);
    
    fprintf(1,'----------------------------\n');
    fprintf(1,'-- File: %s\n',files(fi).name);
    fprintf(1,'--\n');
    
    dat2rom(y);
    fprintf(1,'\n\n');
    
    
end

    
fprintf(1,'----------------------------\n');
fprintf(1,'-- All zeros\n');
fprintf(1,'--\n');

dat2rom(zeros(1,256));
fprintf(1,'\n\n');
