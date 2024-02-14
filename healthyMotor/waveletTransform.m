clc
t = tout;% for transferring simulation time data to useful
signalData = rotorBrokenFault;
statorR = signalData(:, 1); %arbitrary value taken to fix transient38360:end
statorY = signalData(:, 2);
statorB = signalData(:, 3);

% Set wavelet parameters
wavelet_name = 'db1';  % Choose the wavelet type (Daubechies wavelet in this case)
level = 5;             % Set the decomposition level

% Perform one-dimensional wavelet decomposition
[c1, l1] = wavedec(signal1, level, wavelet_name);

% Reconstruct approximation and detail coefficients
phase1details1 = detcoef(c1, l1, 1);
phase1details2 = detcoef(c1, l1, 2);
phase1details3 = detcoef(c1, l1, 3);
phase1details4 = detcoef(c1, l1, 4);
phase1details5 = detcoef(c1, l1, 5);

% Adjust the time vectors to match the minimum length
t_details1 = linspace(0, 1, min(length(phase1details1), length(signal1)));


figure;
subplot(6, 1, 1);
plot(t(1:min(length(t), length(signal1))), signal1(1:min(length(t), length(signal1))));


title('Original Signal - Phase 1');

subplot(6, 1, 2);
plot(t_details1, phase1details1(1:length(t_details1)));
title('Detail Coefficients 1 - Phase 1');

subplot(6, 1, 3);
plot(t_details1(1:min(length(t_details1), length(phase1details2))), phase1details2(1:min(length(t_details1), length(phase1details2))));

title('Detail Coefficients 2 - Phase 1');

subplot(6, 1, 4);
plot(t_details1(1:min(length(t_details1), length(phase1details3))), phase1details3(1:min(length(t_details1), length(phase1details3))));

title('Detail Coefficients 3 - Phase 1');

subplot(6, 1, 5);
plot(t_details1(1:min(length(t_details1), length(phase1details4))), phase1details4(1:min(length(t_details1), length(phase1details4))));

title('Detail Coefficients 4 - Phase 1');

subplot(6, 1, 6);
plot(t_details1(1:min(length(t_details1), length(phase1details5))), phase1details5(1:min(length(t_details1), length(phase1details5))));

title('Detail Coefficients 5 - Phase 1');