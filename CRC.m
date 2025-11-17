clear all;
clc;
msg=[1 1 0 1 0 1 1 1 1 1];
divisor=[1 1];

[M,N] =size(divisor);
mseg=[msg zeros(1,N-1)];
[q,r] = deconv(mseg,divisor);
r=abs(r);

for i=1:length(r)
    a=r(i);
    if(mod(a,2)==0)
        r(i)=0;
    else
        r(i)=1;
    end
end
crc=r(length(msg)+1:end);
disp(crc);
frame=bitor(mseg,r);

[q1,r1]=deconv(frame,divisor);
for i=1:length(r1)
    b=r1(i);
    if (mod(b,2)==0)
        r1(i)=0;
    else
        r1(i)=1;
    end
end