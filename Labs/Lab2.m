clear all; clc; close all;

%% 1 LABWORK
%a 
Am = 2;
fm = 4;
Fs = 80;
Ts = 1/80;
time = 0:Ts:(1-Ts);

m = Am*cos(2*pi*fm*time);

%b
n = length(time);

for i = 1:(n-1)  % I took derivative of m
    m_der(i) = (m(i+1) - m(i))/Ts;
end

delta_min = max(m_der)*Ts; % maximum value of the derivative m times Ts

%c
delta = delta_min;

mq(1) = 0;
for i = 1:n
    err = m(i) - mq(i);
    errq(i) = sign(err);
    mq(i+1) = mq(i) + errq(i)*delta;
    
    if (errq(i) > 0)
        en_out(i) = 1;
    else
        en_out(i) = 0;
    end 
end
mq = mq(1:(end-1));

%d
figure(1)
plot(time, m);
hold on;
stairs(time, mq);
title('m(t) and mq(nTs) delta = delta min');
xlabel('time(s)');
ylabel('Amplitude');
legend('m(t)','mq(nTs)');

%e
P = delta^2*fm/(3*Fs);

%f
MSE = mean((m - mq).^2);

%g
delta_new = [0.2, 0.4, 1.4];

mq1(1) = 0;
for i = 1:n
    err = m(i) - mq1(i);
    errq(i) = sign(err);
    mq1(i+1) = mq1(i) + errq(i)*delta_new(1);
    
    if (errq(i) > 0)
        en_out1(i) = 1;
    else
        en_out1(i) = 0;
    end 
end
mq1 = mq1(1:(end-1));

mq2(1) = 0;
for i = 1:n
    err = m(i) - mq2(i);
    errq(i) = sign(err);
    mq2(i+1) = mq2(i) + errq(i)*delta_new(2);
    
    if (errq(i) > 0)
        en_out2(i) = 1;
    else
        en_out2(i) = 0;
    end 
end
mq2 = mq2(1:(end-1));

mq3(1) = 0;
for i = 1:n
    err = m(i) - mq3(i);
    errq(i) = sign(err);
    mq3(i+1) = mq3(i) + errq(i)*delta_new(3);
    
    if (errq(i) > 0)
        en_out3(i) = 1;
    else
        en_out3(i) = 0;
    end 
end
mq3 = mq3(1:(end-1));

figure(2)
plot(time, m);
hold on;
stairs(time, mq1);
title('m(t) and mq(nTs) delta = 0.2');
xlabel('time(s)');
ylabel('Amplitude');
legend('m(t)','mq(nTs)');

figure(3)
plot(time, m);
hold on;
stairs(time, mq2);
title('m(t) and mq(nTs) delta = 0.4');
xlabel('time(s)');
ylabel('Amplitude');
legend('m(t)','mq(nTs)');

figure(4)
plot(time, m);
hold on;
stairs(time, mq3);
title('m(t) and mq(nTs) delta = 1.4');
xlabel('time(s)');
ylabel('Amplitude');
legend('m(t)','mq(nTs)');



P1 = delta_new(1)^2*fm/(3*Fs);
P2 = delta_new(2)^2*fm/(3*Fs);
P3 = delta_new(3)^2*fm/(3*Fs);

MSE1 = mean((m - mq1).^2);
MSE2 = mean((m - mq2).^2);
MSE3 = mean((m - mq3).^2);

P
P1
P2
P3

MSE
MSE1
MSE2
MSE3

%h
figure(5)
subplot(211);
plot([delta_new(1), delta_new(2), delta, delta_new(3)],[MSE1, MSE2, MSE, MSE3]);
title('MSE values with respect to Delta');
xlabel('Delta');
ylabel('MSE');
subplot(212);
plot([delta_new(1), delta_new(2), delta, delta_new(3)],[P1, P2, P, P3]);
title('P values with respect to Delta');
xlabel('Delta');
ylabel('Average Granular Noise');


