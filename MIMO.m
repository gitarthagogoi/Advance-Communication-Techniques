clc;
clear all;
close all;
tx=12;rx=20;
L=10000;
EbNo=[0:5:20];
B=30000;Tx=1/24300;

SNR=EbNo-10*log10(Tx*B);

%A=randi(tx*L,1);
A = randi([0 1], tx, L);
X=zeros(tx,L);
for k=1:tx
    X(k,:)=((-1).^(A(k:tx:end)+1))';
end

H=sqrt(1/2)*(randn(rx,tx,L)+i*randn(rx,tx,L));

n=sqrt(1/2)*(randn(rx,L)+i*randn(rx,L));

r=zeros(rx,L);

for k=1:L
    R(:,k)=sqrt(1/tx)*H(:,:,k)*X(:,k);
end

berm=[];
for m=SNR
    m;
    snr=10^(m/10);
    R_noised=R+sqrt(1/snr)*n;
    x=[];
    a=zeros(tx*L,1);
    for t=1:L
        r=R_noised(:,t);
        HH=H(:,:,t);
        xtemp=zeros(tx,1);
        w=inv(HH'*HH+(1/snr)*eye(tx))*HH';%MMSE Receiver
        y=w*r;
        xtemp=(y>=0)-(y<0)+0;
        x=[x,xtemp];
    end
    for k=1:tx
        a(k:tx:end)=(x(k:tx:end)+1)/2;
    end
    [errbit,temp_ber]=biterr(A(:),a);
    berm=[berm,temp_ber];
end
semilogy(EbNo,berm,'s- k');grid on;hold on;
grid on;
xlabel('SNR');
ylabel('BER (dB)');
title('BER Vs SNR');