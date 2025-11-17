clc;clear;close all;

msg=[1 1 1 1 0 1 1 1 1 0];
divisor=[1 0 0 1];

mseg=[msg,zeros(1,length(divisor)-1)];
[~,r]=deconv(mseg,divisor);
crc=mod(r,2);
disp('CRC');
disp(crc(end-length(divisor)+2:end));
frame=[msg,crc(end-length(divisor)+2:end)];
disp('TX');
disp(frame);
[~,r1]=deconv(frame,divisor);
r1=mod(r1,2);
disp('check');
disp(r1);