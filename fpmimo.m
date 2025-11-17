clc;clear;close all;
tx=12;rx=12;L=10000;
ebno=0:5:20;B=30000;tx1=1/24300;
snr=ebno-10*log10(tx1*B);

A=randi([0 1],tx,L);
X=(-1).^(A+1);

H=sqrt(1/2)*(randn(rx,tx,L)+1i*randn(rx,tx,L));
h=sqrt(1/2)*(randn(rx,L)+1i*randn(rx,L));

berm=zeros(size(ebno));
for m=1:length(ebno)
    snr=10^(ebno(m)/10);
    rn=(zeros(rx,L));
    
    for t=1:L
        rn(:,t) = sqrt(1/tx) * H(:,:,t) * X(:,t) + sqrt(1/snr) * h(:,t);
    end
    
    x=zeros(tx,L);
    
    for t=1:L
        w=inv(H(:,:,t)'*H(:,:,t)+(1/snr)*eye(tx))*H(:,:,t)';
        x(:,t)=(w*rn(:,t))>=0;
    end
    
    a=reshape(x,[],1);
    berm(m)=biterr(A(:),a)/L;
end
semilogy(ebno,berm,'s-k');