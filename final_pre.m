clearvars;
clc
close all;
[x,Fs] = audioread('fvoice.wav');
N = size(x,1);     %x-rows and 1-column
f = Fs*(0:N-1)*N;
T = 1/Fs;
L = N;
t = (0:L-1)*T;

%filterDesigner
%fstop1=300
%fpass1=400
%fpass2=1700
%fstop2=1800

%filterDesigner
load('coefficients_pre.mat')
filtered_signal = filter(coefficients_pre,1,x);
audiowrite('foutput.wav',filtered_signal,Fs);

figure
title('Frequency Response');
freqz(coefficients_pre,1,N) 
figure
title('Pole Zero Plot');
zplane(coefficients_pre,1) 
figure
title('Impulse Response');
impz(coefficients_pre,1) 

[x,Fs]=audioread('fvoice.wav');
L=length(x);
df=Fs/L;
frequency_audio=-Fs/2:df:Fs/2-df;
X=fftshift(fft(x))/length(fft(x));
figure
subplot(2,1,1)
plot(frequency_audio,abs(X));
axis([-4000 4000 0 0.005]);
title('FFT of Input Audio');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

[y,audio_freq_sampl]=audioread('foutput.wav');
L=length(y);
df=audio_freq_sampl/L;
frequency_audio=-Fs/2:df:Fs/2-df;
Y=fftshift(fft(y))/length(fft(y));
subplot(2,1,2)
plot(frequency_audio,abs(Y));
axis([-4000 4000 0 0.005]);
title('FFT of Output');
xlabel('Frequency(Hz)');
ylabel('Amplitude');

figure
subplot(2,1,1)
plot(t, x);axis([0 12 -0.4 0.4]);title('Original: Time-domain'); xlabel('time(seconds)');
subplot(2,1,2)
plot(t, filtered_signal , 'g');axis([0 12 -0.4 0.4]);title('Output'); xlabel('time(seconds)');

Pow= (abs (X).^2)/N^2; 
figure
subplot(2,1,1)
plot((frequency_audio), Pow*4);
axis([-4000 4000 0 10*10^(-15)]);
xlabel('frequency') 
ylabel('power spectral')
title('power spectrum of input signal')

Pow= (abs (Y).^2)/N^2;
subplot(2,1,2)
plot((frequency_audio), Pow*4);
axis([-4000 4000 0 10*10^(-15)]);
xlabel('frequency')     
ylabel('power spectral')
title('power spectrum of output filtered signal ')


soundsc(x,Fs);

soundsc(y,Fs);