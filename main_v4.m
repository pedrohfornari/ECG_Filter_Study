clc
close all
clear all

%% Trabalho 1 - EEL510291 - PSD
%% 1. Interpolate signal to 4000Hz and plot

%%% Data 1
dataRead = 'ECG01_5min@240Hz.dat';
data1 = csvread(dataRead);
fs = 240;
[ecgit1]=interpolated(data1,fs,4000);

%%% Data 2
dataRead = 'ECG02_5min@240Hz.dat';
data2 = csvread(dataRead);
[ecgit2]=interpolated(data2,fs,4000);

%%% Data 3
dataRead = 'ECGxyzData.dat';
datax = csvread(dataRead);
datax = (datax(1:round(end/3),2)+datax(1:round(end/3),3)+datax(1:round(end/3),4))/3;
% datax = (datax(1:end,2)+datax(1:end,3)+datax(1:end,4))/3;
fs = 1000;
[ecgit3]=interpolated(datax,fs,4000);

    
%% 2. 
% 2.1: Detection of each beat/Promediate/Filter
   
    %%% Identificate peaks, using derivative method
    ecgit = ecgit3;   % Define which signal will be analysed
    fs = 4000;
    [pos, SigWdn, Position] = IdentBeats(ecgit,fs);
    

    %%% Get cell representing separated signals and identified peaks
    [SigPromed] = Promed(pos,SigWdn);
    

    %%% Define IIR parameter, then call filter function
    Type = 'Low';
    order = 8;
    fs = 4000;
    fc = 25;
    ECGIIRFilter(ecgit,fs,fc,order,'Low');
    
    
%% 3.     
% Determinacao intervalos RR consecutivos (Grafico: RR x batimento)   
    RRtimes = zeros(length(Position)+1,1);
    RRtimes(1)=0;

    for i=1:length(Position)-1
        time = Position(i+1)/4000 - Position(i)/4000;
        RRtimes(i) = time;
    end
    
    figure;
    plot(1000.*RRtimes(1:length(Position)-1))
    xlabel('Batimentos')
    ylabel('Distancia RR (ms)')
    title('Distancia RR x Batimentos')
    grid on
%% 6   
    MeanRR = mean(RRtimes);
    stdRR = std(RRtimes);
    j = 1;
    for i=1:length(Position)-1
        time = Position(i+1)/4000 - Position(i)/4000;
        if((time < MeanRR + 2*(stdRR))||(time > MeanRR - 2*(stdRR)))
            posRRfine(j) = Position(i);
            RRtimeok(j) = time;
            j = j + 1;
        end
    end

%% 4
    
    %%% Function which returns QT, QTCc (Bazzet and Framingham method)
    [RR, RRMean, QT, QTB, QTF]=QTdetect(ecgit,fs-100);



%% Media movel - 5 e 6

% Leitura dos dados
    datax = csvread('ECG02_5min@240Hz.dat');
    fs = 240;

% Sinal
    tdata = 0:1/fs:(length(datax)-1)/fs;
    %figure;
    %plot(tdata,datax, 'k');
    %title('Sampling rate: 240Hz')
    
% Interpolacao: frequencia de amostragem de 240Hz para 4000Hz 
    ecgit = resample(datax,4000,240);
    fsN = 4000;
    Nfs = round(4000/240);
    tecgit = 0:1/(fsN):(length(ecgit)-1)/(fsN);
    
% Sinal entre 3:00 and 3:10 minutos (180 - 190s)
% Intervalo de amostras: 4000samples/second*180seconds to 4000samples/second*190
    figure;
    plot(tecgit(1,(4000*180):(4000*181)),ecgit((4000*180):(4000*181),1),'k')
    xlabel('Time(s)')
    ylabel('Amplitude')
    title('Before MA')
    grid on;
    disp('Data without MA filter')

% Filtro de media movel
    MAecgit = Moving_Avarage_Filter(ecgit, 200);
    figure;
    plot(tecgit(1,(4000*180):(4000*181)),MAecgit((4000*180):(4000*181),1),'k')
    xlabel('Time(s)')
    ylabel('Amplitude')
    title('After MA')
    grid on;
    disp('Data filtered')
% Separa sinal de ecg sem filtro em intervalos de 1 minuto
    minute_interval_samples = onemininterval(4000, ecgit, 5*60);
    MA_minute_interval_samples = onemininterval(4000, MAecgit, 5*60);
    figure('Name','Intervalos de 1 minuto do sinal nao filtrado');
    subplot(5, 1, 1);
    plot(tecgit(1,1:240000),minute_interval_samples(1,:),'g')
    subplot(5, 1, 2);
    plot(tecgit(1,1:240000),minute_interval_samples(2,:),'k')
    subplot(5, 1, 3);
    plot(tecgit(1,1:240000),minute_interval_samples(3,:),'r')
    subplot(5, 1, 4);
    plot(tecgit(1,1:240000),minute_interval_samples(4,:),'y')
    subplot(5, 1, 5);
    plot(tecgit(1,1:240000),minute_interval_samples(5,:),'b')
 % Separa sinal de ecg sem filtro em intervalos de 1 minuto
    figure('Name','Intervalos de 1 minuto do sinal filtrado');
    subplot(5, 1, 1);
    plot(tecgit(1,1:240000),MA_minute_interval_samples(1,:),'g')
    subplot(5, 1, 2);
    plot(tecgit(1,1:240000),MA_minute_interval_samples(2,:),'k')
    subplot(5, 1, 3);
    plot(tecgit(1,1:240000),MA_minute_interval_samples(3,:),'r')
    subplot(5, 1, 4);
    plot(tecgit(1,1:240000),MA_minute_interval_samples(4,:),'y')
    subplot(5, 1, 5);
    plot(tecgit(1,1:240000),MA_minute_interval_samples(5,:),'b')
    
% Calcula estatísticas de cada intervalo com e sem filtro

for i = 1:5
    Media(i) = mean(minute_interval_samples(i,:));
    Variancia(i) = var(minute_interval_samples(i,:));
    Desvio_Padrao(i) = std(minute_interval_samples(i,:));
    RMS(i) = rms(minute_interval_samples(i,:));
    MAMedia(i) = mean(MA_minute_interval_samples(i,:));
    MAVariancia(i) = var(MA_minute_interval_samples(i,:));
    MADesvio_Padrao(i) = std(MA_minute_interval_samples(i,:));
    MARMS(i) = rms(MA_minute_interval_samples(i,:));
end


    
    