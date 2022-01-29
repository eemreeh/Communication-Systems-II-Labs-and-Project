clear all; clc; close all;

%% 1.1 SAMPLING
%a
Fs = 5000;
Ts = 1/Fs;

n = 0:Ts:(0.2-Ts);  

C = 3;
A = [1, 3, 2];
f = [60, 20, 150];
theta = [0, pi/2, pi/4];

x = 0;
for i = 1:C
   x = x + A(i)*sin(2*pi*f(i)*n+theta(i));  
end

figure(1)
plot(n,x);
title('x[n]');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x[n]');

%b
xs1 = x(mod((1:length(n)), 10) == 1);
xs2 = x(mod((1:length(n)), 20) == 1);

n_1 = 0:(Ts*10):(0.2-Ts); 
n_2 = 0:(Ts*20):(0.2-Ts); 

%c
figure(2)
subplot(211);
stem(n_1, xs1);
title('Downsampled x[n] by 10');
ylabel('Amplitude');
xlabel('Time (s)');
legend('xs1[n]');
subplot(212);
stem(n_2, xs2);
title('Downsampled x[n] by 20');
ylabel('Amplitude');
xlabel('Time (s)');
legend('xs2[n]');

%d
N = length(n);
N_1 = length(n_1);
N_2 = length(n_2);

FVec = linspace(-Fs/2, Fs/2, N);
FVec_1 = linspace(-Fs/2, Fs/2, N_1);
FVec_2 = linspace(-Fs/2, Fs/2, N_2);

%I decided my frequency axis by creating my frequency vector with N/10 and 
%N/20 points. In this way, my array of fft of downsampled signals fit with
%their frequency vectors.

%By normalization, we are pulling the amplitude of the frequency response
%to the actual levels by dividing it to number of points. Also, while
%applying fftshif, we are putting the origin to the center.

X = abs(fftshift(fft(x,N)))/N;
XS1 = abs(fftshift(fft(xs1,N_1)))/N;
XS2 = abs(fftshift(fft(xs2,N_2)))/N;

figure(3)
subplot(211);
plot(FVec_1, XS1);
title('Normalized Frequency Spectrum of xs1[n]');
ylabel('Amplitude');
xlabel('Freq. (f)');
legend('Xs1[f]');
subplot(212);
plot(FVec_2, XS2);
title('Normalized Frequency Spectrum of xs2[n]');
ylabel('Amplitude');
xlabel('Freq. (f)');
legend('Xs2[f]');

%e
xs1_lin = interp1(n_1,xs1,n,'linear');
xs1_cub = interp1(n_1,xs1,n,'PCHIP');

xs2_lin = interp1(n_2,xs2,n,'linear');
xs2_cub = interp1(n_2,xs2,n,'PCHIP');

figure(4)
plot(n,x);
hold on;
plot(n,xs1_lin);
hold on;
plot(n,xs1_cub);
title('Original and reconstructed signals xs1[n]');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x[n]','xs1Linear','xs1Cubic');

figure(5)
plot(n,x);
hold on;
plot(n,xs2_lin);
hold on;
plot(n,xs2_cub);
title('Original and reconstructed signals xs2[n]');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x[n]','xs2Linear','xs2Cubic');

%% 1.2 QUANTIZATION
%a
Fs = 5000;
Ts = 1/Fs;

n = 0:Ts:(0.2-Ts);

C = 5;
A = [5, 4, 3, 2, 1];
f = [50, 60, 70, 80, 90];
theta = [0, pi/5, 2*pi/5, 3*pi/5, 4*pi/5];

x2 = 0;
for i = 1:C
   x2 = x2 + A(i)*sin(2*pi*f(i)*n+theta(i));  
end

figure(6)
plot(n, x2);
title('x2[n]');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x2[n]');

%b
f_quant = @(x, a, b, N) floor((x-a)/(b-a)*(2^N-1))*(b-a)/(2^N-1) + a;

qua4 = f_quant(x2, min(x2), max(x2), 4); 
qua8 = f_quant(x2, min(x2), max(x2), 8); 

%c
figure(7)
subplot(211);
plot(n, x2);
hold on;
plot(n, qua4);
title('Original x2[n] and quantized xq4 signal');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x2[n]','xq4');
subplot(212);
plot(n, x2);
hold on;
plot(n, qua8);
title('Original x2[n] and quantized xq8 signal');
ylabel('Amplitude');
xlabel('Time (s)');
legend('x2[n]','xq8');

%d
MSE = @(x, xq) mean((x - xq).^2);
SQNR = @(x, xq) mean((x).^2)/mean((x - xq).^2);

MSE4_linear = MSE(x2, qua4);
MSE8_linear = MSE(x2, qua8);

MSE4_dB = 10*log10(MSE4_linear);
MSE8_dB = 10*log10(MSE8_linear);

SQNR4_linear = SQNR(x2, qua4);
SQNR8_linear = SQNR(x2, qua8);

SQNR4_dB = 10*log10(SQNR4_linear);
SQNR8_dB = 10*log10(SQNR8_linear);






