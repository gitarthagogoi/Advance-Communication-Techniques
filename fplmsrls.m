clc;clear;close all;

randn('seed',0);rand('seed',0);
data=8000;order=32;
x=randn(data,1);
h=rand(order,1);
d=filter(h,1,x);

mu=0.01;
w1=zeros(order,1);
e1=zeros(data,1);
err1=zeros(data,1);

lamda=0.98;delta=0.001;
P=delta*eye(order);
w2=zeros(order,1);
e2=zeros(data,1);
err2=zeros(data,1);

for n=order:data
    u=x(n:-1:n-order+1);
    d1=w1'*u;
    e1(n)=d(n)-d1;
    w1=w1+mu*e1(n)*u;
    err1(n)=norm(h-w1);
    
    pi_=P*u;
    k=lamda+u'*pi_;
    K=pi_/k;
    e2(n)=d(n)-w2'*u;
    w2=w2+K*e2(n);
    P=(P-K*pi_')/lamda;
    err2(n)=norm(h-w2);
end
figure;
plot(20*log10(abs(e1(order:end))),'r');
hold on;
plot(20*log10(abs(e2(order:end))),'b');
hold off;