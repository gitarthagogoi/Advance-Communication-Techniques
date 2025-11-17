clc;clear;close all;

L=64;M=16;Ncp=L*0.0625;
tx=randi([0 M-1],L,1);
md=qammod(tx,M);
ifftd=ifft(md,L);

cp=[ifftd(end-Ncp+1:end);ifftd];

S=0:1:20;
r=zeros(size(S));

for snr=S
    noisy=awgn(cp,snr,'measured');
    dm=qamdemod(fft(noisy(Ncp+1:end)),M);
    [~,r(snr+1)]=biterr(tx,dm);
end
semilogy(S,r,'-ok');grid on