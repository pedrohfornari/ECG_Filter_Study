function  [pos, SigWindows, Position] = IdentBeats(ECGSignal,fs)
% [posBeats] = IdentBeats(ECGSignal)
% Input:
% ECGSignal: Signal
% fs:        Sampling frequency
% Output:
% pos:       Positions where occur beats
% SigWdn:    Separated signals 

ecgit = ECGSignal;
tecgit = 0:1/(fs):(length(ecgit)-1)/(fs);

% Obtain derivation (window between 180 to 190s)
%     ecgDiff = diff(ecgit((4000*180):(4000*190),1).^2);
    ecgDiff = diff(ecgit((4000*28):(4000*38),1).^2);
    ecgDiffAll = diff(ecgit(:,1).^2);   
%     ecgDiff= ecgDiffAll;

% Threshold
    th = abs(max(ecgDiffAll));
    th = th/2;

% Plot graph with derivation, also with the threshold used
    lineThAll = linspace(th,th,length(ecgDiffAll));
    figure;
    plot(tecgit(1,1:end-1),ecgDiffAll,'k');
    hold on
    plot(tecgit(1,1:end-1),lineThAll,'r--');
    grid on
    xlabel('Time(s)')
    ylabel('Amplitude')
    title('Derivate of the signal and threshold: All Signal')
    h = legend('Derivate of signal','Threshold = Max(Derivate)/2');
    set(h,'interpreter','none')    
    
% Count/detect the number of peaks
    SigWdn = cell(length(ecgit),1);      % Storage windowed signals(for each beat)
    StepWindow = 0.35;                   % trim signal over +/- 700ms around peak
    bts = 0;                             % count beat
    FlagUp = 0;                          % Flag that counts if signal is above the threshold
    posBeat = zeros(length(ecgDiff),1);  % Position where occur beat temporary
    beatsPosition = zeros(length(ecgDiff),1); %Position where occur beat
    for i=1400:1:length(ecgDiffAll)-2100        % Start count after 1400 samples
        if((ecgDiffAll(i))>th)&&(FlagUp == 0)
            
            % Counter number of beats
            bts = bts+1;
            FlagUp = 1;
            
            % Create vector of positions which indicate where occur beat
            posBeat(bts) = max(ecgit)-th;
            beatsPosition(i) = max(ecgit)-th;
            % Find when occur beat, then cut signal over 2800 samples between the peak
            % Cut signal in windows            
            % 4000Hz*700ms = 2800 samples
            SigWdn{bts} = (ecgit(((i-700)):((i+2100)),1));
            
        end 
        if((ecgDiffAll(i))<th)&&(FlagUp == 1)
            FlagUp = 0;
        end
    end
    
    % Get where occur beats
    pos = find(posBeat>0);
    Position = find(beatsPosition>0);
    SigWindows = cell(bts,1);
    for i = 1:bts
        SigWindows{i} = SigWdn{i, 1};
    end
    
% Get positions where occur beat, then plot windowed signals
    figure;plot(SigWindows{pos(3),1},'k--');
    hold on;plot(SigWindows{pos(4),1},'b--');
    hold on;plot(SigWindows{pos(5),1},'y--');
%     hold on;plot(SigWdn{pos(6),1},'r');
%     hold on;plot(SigWdn{pos(7),1},'g');
%     hold on;plot(SigWdn{pos(8),1},'k');
    title('Sample of separated complex PRSQT signals')
    xlabel('Samples')
    ylabel('Amplitude')
    
    