function []=ECGIIRFilter(ECGSignal,fs,fc,order,Type)
% []=ECGIIRFilter(ECGSignal,fs,fc,order)
% Input:
% ECGSignal: Signal
% fs:        Sampling frequency
% fc:        Cuttof frequency
% order:     Order of filter


% Initial definitions
    ecgit = ECGSignal;
	tecgit = 0:1/(fs):(length(ecgit)-1)/(fs);
    
% Butter Filter    
    [b,a] = butter(order,fc/(fs/2),Type);
    xx=filtfilt(b,a,ecgit);
    
% Plot figures    
    figure;
%     plot(tecgit(1,(4000*180):(4000*181)),ecgit((4000*180):(4000*181),1),'r');
    plot(tecgit(1,(4000*17):(4000*20)),ecgit((4000*17):(4000*20),1),'r');
    hold on;
%     plot(tecgit(1,(4000*180):(4000*181)),xx((4000*180):(4000*181),1),'k');
    plot(tecgit(1,(4000*17):(4000*20)),xx((4000*17):(4000*20),1),'k');
    h=legend('Original ECG','Filtered');
    set(h);
    xlabel('Time(s)')
    ylabel('Amplitude')
    hold off;
