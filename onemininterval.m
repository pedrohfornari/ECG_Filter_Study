function output = onemininterval(frequency, input, time)
%% Function to part a signal in time (seconds) domain into 
%  60 seconds slots
%
% frequency -> signal sample rate
% input -> Signal to be processed
% time -> time in seconds that will be slotted
    
%inicialize output vector
    output = zeros(time/60, frequency*60);


%we have time/60 minutes, so we need i = time/60 lines
%frequency samples/second * seconds = sample
%each line receive its respectively sample sequency
    for i = 1:1:(time/60)
        for j = 1:1:(frequency*60)
            output(i,j) = input(j+((i-1)*frequency*60));
        end 
    end
end