clc;
clear all;
close all;
% Initialization
randn('seed', 0); rand('seed', 0);
No_Data = 8000; Order = 32;

% Generate input signal and desired output
x = randn(No_Data, 1);
h = rand(Order, 1);
d = filter(h, 1, x);

% LMS Parameters
Mu = 0.01; 
w_LMS = zeros(Order, 1);
e_LMS = zeros(No_Data, 1);
w_err1 = zeros(No_Data, 1);

% RLS Parameters
Lambda = 0.98; Delta = 0.001; 
P = Delta * eye(Order);
w_RLS = zeros(Order, 1);
e_RLS = zeros(No_Data, 1);
w_err2 = zeros(No_Data, 1);

% Adaptive Filtering for LMS and RLS
for n = Order:No_Data
    u = x(n:-1:n-Order+1);
    
    % LMS
    d_hat_LMS = w_LMS' * u;
    e_LMS(n) = d(n) - d_hat_LMS;
    w_LMS = w_LMS + Mu * e_LMS(n) * u;
    w_err1(n) = norm(h - w_LMS);
    
    % RLS
    pi_ = P * u;
    k = Lambda + u' * pi_;
    K = pi_ / k;
    e_RLS(n) = d(n) - w_RLS' * u;
    w_RLS = w_RLS + K * e_RLS(n);
    P = (P - K * pi_') / Lambda;
    w_err2(n) = norm(h - w_RLS);
end

% Plot Learning Curve
figure;
plot(20 * log10(abs(e_LMS(Order:end))), 'r', 'DisplayName', 'LMS');
hold on;
plot(20 * log10(abs(e_RLS(Order:end))), 'b', 'DisplayName', 'RLS');
title('Learning Curve/Convergence');
xlabel('Iteration Number'); ylabel('Output Estimation Error (dB)');
legend; hold off;

% Plot Weight Estimation Error
figure;
semilogy(w_err1(Order:end), 'r', 'DisplayName', 'LMS');
hold on;
semilogy(w_err2(Order:end), 'b', 'DisplayName', 'RLS');
title('Weight Estimation Error/Stability');
xlabel('Iteration Number'); ylabel('Weight Error (dB)');
legend; hold off;
