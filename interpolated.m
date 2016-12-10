function [ecgit]=interpolated(datax,fs,fsResampled)
% [ecgit]=interpolated(data,fs)
% input:        data (.dat)
% fs:           sampling frequency
% fsResampled:  resampled frequency
% ecgit:        ECG normalized/resampling to resampled frequency

    
% Show signal
    tdata = 0:1/fs:(length(datax)-1)/fs;
    figure;
    plot(tdata,datax, 'k');
    title('Sampling rate: 240Hz')
    xlabel('Time (s)')
    ylabel('Amplitude')
    
% Interpolating: fs to fsResampled
    ecgit = resample(datax, fsResampled, fs);
    tecgit = 0:1/(fsResampled):(length(ecgit)-1)/(fsResampled);
    
% Plot between 3:00 and 3:10 minutes (180 - 190 min)
% Normalize data
    ecgit = ecgit(:,:)./max(ecgit);    
    figure;
%     plot(tecgit(1,(4000*180):(4000*190)),ecgit((4000*180):(4000*190),1),'k')
    plot(tecgit(1,(4000*18):(4000*28)),ecgit((4000*18):(4000*28),1),'k')
    title('Window: 180 - 190 min (4000Hz). Data normalized')
    xlabel('Time(s)')
    ylabel('Amplitude')  
    grid on;
