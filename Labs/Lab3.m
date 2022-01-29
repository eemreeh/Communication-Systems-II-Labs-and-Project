clear all; clc; close all;

%% TRANSMITTER
%a
N = [1 0 0 1 1 0 0 1 0 1];

%b
Fs = 1000;
Ts = 1/Fs;
time = 0:Ts:(1-Ts);

%c
Tb = 1/length(N);

s0 = ones(1,Tb/Ts)*-1;
s1 = ones(1,Tb/Ts);

%d
s = [];

for i = N
   if(i == 0)
       s = [s s0];
   else
       s = [s s1];
   end
end

%% CHANNEL
%a %b
SNR = 15;
r = awgn(s,SNR);

%% RECEIVER
%a %b %c
Wb = Tb/Ts;

r0 = []; r1 = [];
for k = 1:length(N)
   n = ((k-1)*Wb+1):k*Wb;
   r0(k) =  sum(r(n).*s0((n-(k-1)*Wb)));
   r1(k) =  sum(r(n).*s1((n-(k-1)*Wb)));
end

%% PROBABILITY of ERROR
%a 
SNR_array = [-15:15];

jlen = 1000000;
Pe_ite = zeros(1, length(SNR_array));
for i = 1:length(SNR_array)
    for j = 1:jlen
        r = awgn(s, SNR_array(i));
        for k = 1:length(N)
           n = ((k-1)*Wb+1):k*Wb;
           r0(k) =  sum(r(n).*s0((n-(k-1)*Wb)));
           r1(k) =  sum(r(n).*s1((n-(k-1)*Wb)));
           if (r0(k)>r1(k))
               r3(k) = 0;
           else
               r3(k) = 1;
           end
        end
        
        Pe_ite(i) = Pe_ite(i) + sum(abs(N-r3));
        
    end
end
Pe_ite = Pe_ite/(length(N)*jlen);

%b

Pe = qfunc(sqrt(2*10.^(SNR_array/10)));

%% Plotting
%a
SNR1 = 0;
SNR2 = -15;

r_1 = awgn(s,SNR1);
r_2 = awgn(s,SNR2);

r0_1 = []; r1_1 = [];
r0_2 = []; r1_2 = [];
for k = 1:length(N)
   n = ((k-1)*Wb+1):k*Wb;
   r0_1(k) =  sum(r_1(n).*s0((n-(k-1)*Wb)));
   r1_1(k) =  sum(r_1(n).*s1((n-(k-1)*Wb)));
   r0_2(k) =  sum(r_2(n).*s0((n-(k-1)*Wb)));
   r1_2(k) =  sum(r_2(n).*s1((n-(k-1)*Wb)));
end

%b
figure(1)
subplot(211);
plot(time, s);
title('Transmitted signral s(t)');
xlabel('Time (s)'); ylabel('Amplitude');
legend('s(t)');
subplot(212);
plot(time, r);
title('Received signral r(t), SNR = 15');
xlabel('Time (s)'); ylabel('Amplitude');
legend('r(t)');

figure(2)
subplot(211);
plot(time, s);
title('Transmitted signral s(t)');
xlabel('Time (s)'); ylabel('Amplitude');
legend('s(t)');
subplot(212);
plot(time, r_1);
title('Received signral r(t), SNR = 0');
xlabel('Time (s)'); ylabel('Amplitude');
legend('r(t)');

figure(3)
subplot(211);
plot(time, s);
title('Transmitted signral s(t)');
xlabel('Time (s)'); ylabel('Amplitude');
legend('s(t)');
subplot(212);
plot(time, r_2);
title('Received signral r(t), SNR = -15');
xlabel('Time (s)'); ylabel('Amplitude');
legend('r(t)');

%c
figure(4)
scatter((1:10),r0);
hold on;
scatter((1:10),r1);
title('Receiver output r0(k) and r1(k), SNR = 15');
xlabel('k'); ylabel('Amplitude');
legend('r0(k)','r1(k)');

figure(5)
scatter((1:10),r0_1);
hold on;
scatter((1:10),r1_1);
title('Receiver output r0(k) and r1(k), SNR = 0');
xlabel('k'); ylabel('Amplitude');
legend('r0(k)','r1(k)');

figure(6)
scatter((1:10),r0_2);
hold on;
scatter((1:10),r1_2);
title('Receiver output r0(k) and r1(k), SNR = -15');
xlabel('k'); ylabel('Amplitude');
legend('r0(k)','r1(k)');

%d
figure(7)
semilogy(SNR_array, Pe);
hold on;
semilogy(SNR_array, Pe_ite);
title('Pe vs. SNR values');
xlabel('SNR Values'); ylabel('Pe');
legend('Theoritical','Iterative');

