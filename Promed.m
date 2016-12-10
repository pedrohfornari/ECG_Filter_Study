function [SignalPromediated] = Promed(posBeats,SigWdn)
% [SignalPromediated] = Promedation(posBeats,ECGSignal)
% Input:
% posBeats:              Identificated position of each beat
% SigWdn:                ECG separated signals (cell format)
% Output:
% SignalPromediated:     Promediated Signal

    pos = posBeats;

    SignalPromediates = cell(length(pos),1);
    j = 1;
        for i=1:length(pos)
            [COR,lagsCOR]=xcorr(SigWdn{pos(3),1},SigWdn{pos(i),1});
            COR = COR./max(COR);
            [posMaxCor, LAG] = max(abs(COR));
            if(posMaxCor > 0.995) % If correlation in 0 higher than 95%
                % Coordinates where occur more correlation
                TempSig = SigWdn{pos(i),1};
                SignalPromediates{j,1} = circshift(TempSig, lagsCOR(LAG));
                j = j+1;
            end
        end
           
% Promediate correlated signals
SigPromed = zeros(length(TempSig),1);
SignalsPrm = cell(length(pos),1);
N = 0;
    for i=1:j-1
        SigPromed = SigPromed + SignalPromediates{i,1};
        SignalsPrm{i} = SignalPromediates{i,1};
        N = N+1;  % Number of signals used in promediation
    end
    
% Divide by the number of signals
    SigPromed = SigPromed./N;
    SignalPromediated = SigPromed;
    
% Promediate Signal 
    figure;plot(SigPromed,'k')
    title('Signal obtained from Promed.')
    xlabel('Samples')
    ylabel('Amplitude')
    grid on
    hold on
    axis([-200 3001 -.8 1.05])    
    