clear all; clc; close all;

%% MESSAGE
%1
Fs = 27000;
Ts = 1/Fs;
Rb = 18000;
Tb = 1/Rb;
N = 1000;
%2
m = randi(4,1,N); 
for i = 1:N
   if(m(i) == 1)
       m(i) = -3;
   elseif (m(i) == 2)
       m(i) = -1;
   elseif (m(i) == 3)
       m(i) = 1;
   else
       m(i) = 3;
   end
end
%3
sps = Fs/Rb*2; 
Rs = 1/sps;
%4
rolloff = [0 0.5 1];
span = 10;
rcos1 = rcosdesign(rolloff(1), span, sps, 'sqrt');
rcos2 = rcosdesign(rolloff(2), span, sps, 'sqrt');
rcos3 = rcosdesign(rolloff(3), span, sps, 'sqrt');
%5
FVec = linspace(-Fs/2, Fs/2, N);

RCOS1 = abs(fftshift(fft(rcos1, N)))/N;
RCOS2 = abs(fftshift(fft(rcos2, N)))/N;
RCOS3 = abs(fftshift(fft(rcos3, N)))/N;

figure(1)
subplot(231);
plot(rcos1);
title('sqrt RCos rolloff = 0');
xlabel('time (s)');ylabel('Amplitude');
subplot(232);
plot(rcos2);
title('sqrt RCos rolloff = 0.5');
xlabel('time (s)');ylabel('Amplitude');
subplot(233);
plot(rcos3);
title('sqrt RCos rolloff = 1');
xlabel('time (s)');ylabel('Amplitude');
subplot(234);
plot(FVec, RCOS1);
title('f domain sqrt RCos rolloff = 0');
xlabel('Freq. (Hz)');ylabel('Amplitude');
subplot(235);
plot(FVec, RCOS2);
title('f domain sqrt RCos rolloff = 0.5');
xlabel('Freq. (Hz)');ylabel('Amplitude');
subplot(236);
plot(FVec, RCOS3);
title('f domain sqrt RCos rolloff = 1');
xlabel('Freq. (Hz)');ylabel('Amplitude');
%% TRANSMIT/RECEIVE
%6
tx1 = upfirdn(m, rcos1, sps, 1);
tx2 = upfirdn(m, rcos2, sps, 1);
tx3 = upfirdn(m, rcos3, sps, 1);
%7
SNR = 20;
txn1 = awgn(tx1, SNR);
txn2 = awgn(tx2, SNR);
txn3 = awgn(tx3, SNR);
%8
y1 = upfirdn(txn1, rcos1, 1, sps);
y2 = upfirdn(txn2, rcos2, 1, sps);
y3 = upfirdn(txn3, rcos3, 1, sps);
%9
yout1 = y1(span:(end-span));
yout2 = y2(span:(end-span));
yout3 = y3(span:(end-span));

%% Eye Diagrams
%10
eyediagram(yout1,sps,Ts,0);
title('Eye Diagram Rolloff = 0');
eyediagram(yout2,sps,Ts,0);
title('Eye Diagram Rolloff = 0.5');
eyediagram(yout3,sps,Ts,0);
title('Eye Diagram Rolloff = 1');





