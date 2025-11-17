clc;
clear all;
close all;

L=64; %lenth of the OFDM Data
M=16; %Modulation Order
Ncp=L*0.0625;

%tx
Tx_data=randi([0 15],L,Ncp); %data generation

%%QAM
mod_data=qammod(Tx_data,M);
s2p=mod_data.';%Serial to Parallel
am=ifft(s2p); %ifft
p2s=am.'; %p2s

%cyclic prefixing
CP_part=p2s(:,end-Ncp+1:end); %cyclic prefix part to be appended
cp=[CP_part p2s];

%rx
SNRrange=[0:1:20];
c=0;
r=zeros(size(SNRrange));

for snr=SNRrange
    c=c+1;
    noisy=awgn(cp,snr,'measured');
%remove cyclic prefix
    cpr=noisy(:,Ncp+1:Ncp+Ncp);
    parallel=cpr.';%s2p
    amdemod=fft(parallel);%fft
    rserial=amdemod.'; %p2s
    Umap=qamdemod(rserial,M);%QAM demod
    [n,r(c)]=biterr(Tx_data,Umap); %calc BER
end
snr=SNRrange;
semilogy(snr,r,'-ok');
grid;
title('OFDM: BER .VS. SNR');
ylabel('BER (dB)');
xlabel('SNR');