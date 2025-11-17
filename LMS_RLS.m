randn('seed',0);
rand('seed',0);

No_Data = 8000;
Order = 32;
Mu = 0.01;

x = randn(No_Data, 1);
h = rand(Order, 1);
d = filter(h,1,x);

w = zeros(Order, 1);

for n = Order : No_Data
    D = x(n:-1:n-Order+1);
    d_hat(n) = w' * D;
    e1(n) = d(n) - d_hat(n);
    w = w + Mu * e1(n) * D;
    w_err1(n) = norm(h-w);
end

randn('seed', 0);
rand('seed',0);

No_Data = 8000;
Order = 32;
Lambda = 0.98;
Delta = 0.001;

x = randn(No_Data, 1);
h = rand(Order, 1);
d = filter(h,1,x);

P = Delta * eye(Order, Order);
w = zeros(Order, 1);

for n = Order: No_Data
    u = x(n:-1:n-Order+1);
    pi_ = u' * P;
    k = Lambda + pi_ * u;
    K = pi_' / k;
    e2(n) = d(n) - w' * u;
    w = w + K * e2(n);
    PPrime = K * pi_;
    P = (P - PPrime) / Lambda;
    w_err2(n) = norm(h-w);
end

% Plot Learning Curve for both methods
figure;
plot(20 * log10(abs(e1)), 'r', 'DisplayName', 'LMS'); % LMS in red
hold on;
plot(20 * log10(abs(e2)), 'b', 'DisplayName', 'RLS'); % RLS in blue
title('Learning Curve/Convergence');
xlabel('Iteration Number');
ylabel('Output Estimation Error in dB');
legend;
hold off;

% Plot Weight Estimation Error for both methods
figure;
semilogy(w_err1, 'r', 'DisplayName', 'LMS'); % LMS in red
hold on;
semilogy(w_err2, 'b', 'DisplayName', 'RLS'); % RLS in blue
title('Weight Estimation Error/Stability');
xlabel('Iteration Number');
ylabel('Weight Error in dB');
legend;
hold off;
