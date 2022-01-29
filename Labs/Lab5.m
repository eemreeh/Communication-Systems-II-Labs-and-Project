clear all; clc; close all;

%% 5.1 Modulation 
%a
Fs = 45000;
Ts = 1/Fs;
fc = 3000;
Tb = 0.002;
bitSample = Tb/Ts;
b = randi([0 1],10,1);
b2 = repmat(b,1,bitSample)';
b2 = b2(:)';

duration = length(b)*Tb;
time = 0:Ts:(duration-Ts);
tim = 0:Ts:(Tb-Ts);

bask_mod = [];
for i = 1:length(b)
    if (b(i) == 0) 
        bask_mod = [bask_mod 0*cos(2*pi*fc*(((i-1)*Tb)+tim))];
    else 
        bask_mod = [bask_mod 1*cos(2*pi*fc*(((i-1)*Tb)+tim))];
    end
end


%b
bask_dmd = [];
for i = 1:length(b)
    L0 = sum(bask_mod((1:bitSample)+bitSample*(i-1)).*(0*cos(2*pi*fc*(((i-1)*Tb)+tim))));
    L1 = sum(bask_mod((1:bitSample)+bitSample*(i-1)).*(1*cos(2*pi*fc*(((i-1)*Tb)+tim))));
    L = L1-L0;
    if (L > 0)
        bask_dmd = [bask_dmd 1];
    else 
        bask_dmd = [bask_dmd 0];
    end 
end

bask_dmd = repmat(bask_dmd',1,bitSample)';
bask_dmd = bask_dmd(:)';

figure(1) 
subplot(311);
plot(time,b2);
title('Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(312);
plot(time,bask_mod);
title('Binary ASK Modulation');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(313);
plot(time,bask_dmd);
title('Demodulated Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');

%c BFSK
f1 = 3000;
f2 = 1500;

bfsk_mod = [];
for i = 1:length(b)
    if (b(i) == 0) 
        bfsk_mod = [bfsk_mod cos(2*pi*f1*(((i-1)*Tb)+tim))];
    else 
        bfsk_mod = [bfsk_mod cos(2*pi*f2*(((i-1)*Tb)+tim))];
    end
end

bfsk_dmd = [];
for i = 1:length(b)
    L0 = sum(bfsk_mod((1:bitSample)+bitSample*(i-1)).*(cos(2*pi*f1*(((i-1)*Tb)+tim))));
    L1 = sum(bfsk_mod((1:bitSample)+bitSample*(i-1)).*(cos(2*pi*f2*(((i-1)*Tb)+tim))));
    L = L1-L0;
    if (L > 0)
        bfsk_dmd = [bfsk_dmd 1];
    else 
        bfsk_dmd = [bfsk_dmd 0];
    end
end

bfsk_dmd = repmat(bfsk_dmd',1,bitSample)';
bfsk_dmd = bfsk_dmd(:)';

figure(2) 
subplot(311);
plot(time, b2);
title('Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(312);
plot(time,bfsk_mod);
title('Binary FSK Modulation');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(313);
plot(time,bfsk_dmd);
title('Demodulated Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');

%d

bpsk_mod = [];
for i = 1:length(b)
    if (b(i) == 0) 
        bpsk_mod = [bpsk_mod cos(2*pi*fc*(((i-1)*Tb)+tim))];
    else 
        bpsk_mod = [bpsk_mod cos(2*pi*fc*(((i-1)*Tb)+tim)+pi)];
    end
end

bpsk_dmd = [];
for i = 1:length(b)
    L0 = sum(bpsk_mod((1:bitSample)+bitSample*(i-1)).*(cos(2*pi*fc*(((i-1)*Tb)+tim))));
    L1 = sum(bpsk_mod((1:bitSample)+bitSample*(i-1)).*(cos(2*pi*fc*(((i-1)*Tb)+tim)+pi)));
    L = L1-L0;
    if (L > 0)
        bpsk_dmd = [bpsk_dmd 1];
    else 
        bpsk_dmd = [bpsk_dmd 0];
    end
end

bpsk_dmd = repmat(bpsk_dmd',1,bitSample)';
bpsk_dmd = bpsk_dmd(:)';

figure(3) 
subplot(311);
plot(time, b2);
title('Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(312);
plot(time,bpsk_mod);
title('Binary PSK Modulation');
xlabel('Time (s)'); ylabel('Amplitude');
subplot(313);
plot(time,bpsk_dmd);
title('Demodulated Bit Stream');
xlabel('Time (s)'); ylabel('Amplitude');
