clear all;
clc;
close all;

% QAM (16-QAM)
M = 16; % Modulation order
tx_qam = randi([0 M-1], 1, 16); % Random data symbols

% QAM modulation
qamSig = qammod(tx_qam, M);
qamSig = qamSig / sqrt(mean(abs(qamSig).^2)); % Normalize power
figure;
scatterplot(qamSig);
title('16-QAM Signal Constellation');
grid on;

% QPSK
M1 = 4; % Modulation order for QPSK
tx_qpsk = randi([0 M1-1], 1, 16); % Random data symbols

% QPSK modulation
qpskSig = pskmod(tx_qpsk, M1, pi/4); % QPSK modulation
qpskSig = qpskSig / sqrt(mean(abs(qpskSig).^2)); % Normalize power
figure;
scatterplot(qpskSig);
title('QPSK Signal Constellation');
grid on;

% SNR range
SNR = 1:2:20;

% Initialize BER arrays
BER_qam = zeros(size(SNR));
BER_qpsk = zeros(size(SNR));

% Loop over different SNR values
for n = 1:length(SNR)
    % Add noise to QAM signal
    rxSig_qam = awgn(qamSig, SNR(n), 'measured');
    rx_qam = qamdemod(rxSig_qam, M); % Demodulate QAM
    [~, BER_qam(n)] = biterr(tx_qam, rx_qam); % Calculate BER for QAM
    
    % Add noise to QPSK signal
    rxSig_qpsk = awgn(qpskSig, SNR(n), 'measured');
    rx_qpsk = pskdemod(rxSig_qpsk, M1, pi/4); % Demodulate QPSK
    [~, BER_qpsk(n)] = biterr(tx_qpsk, rx_qpsk); % Calculate BER for QPSK
end

% Plot BER vs SNR
figure;
semilogy(SNR, BER_qam, 'r-');% 'LineWidth', 1.5); % BER for QAM
hold on;
semilogy(SNR, BER_qpsk, 'b-');%, 'LineWidth', 1.5); % BER for QPSK
grid on;
xlabel('SNR (dB)');
ylabel('Bit Error Rate (BER)');
legend('16-QAM', 'QPSK');
title('BER vs. SNR');
hold off;
