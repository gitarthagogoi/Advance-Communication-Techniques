clc;clear;close all;

M1=16;
tx1=randi([0 M1-1],1,16);
qs1=qammod(tx1,M1);
qs1=qs1/sqrt(mean(abs(qs1).^2));
figure;
scatterplot(qs1);

M2=4;
tx2=randi([0 M2-1],1,16);
qs2=pskmod(tx2,M2,pi/4);
qs2=qs1/sqrt(mean(abs(qs2).^2));
figure;
scatterplot(qs2);

snr=1:2:20;
b1=zeros(size(snr));
b2=zeros(size(snr));

for n=1:length(snr)
    rxs1=awgn(qs1,snr(n),'measured');
    rx1=qamdemod(rxs1,M1);
    [~,b1(n)]=biterr(tx1,rx1);
    
    rxs2=awgn(qs2,snr(n),'measured');
    rx2=pskdemod(rxs2,M2,pi/4);
    [~,b2(n)]=biterr(tx2,rx2);
end

figure;
semilogy(snr,b1,'r');
hold on;
semilogy(snr,b2,'b');
hold off;