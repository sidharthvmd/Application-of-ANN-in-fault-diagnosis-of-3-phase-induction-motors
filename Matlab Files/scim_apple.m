% Parameters
Rs = 0.1;   % Stator resistance (ohms)
Rr = 0.15;  % Rotor resistance (ohms)
Ls = 0.5;   % Stator inductance (henrys)
Lr = 0.3;   % Rotor inductance (henrys)
Lm = 2;     % Mutual inductance (henrys)
J = 0.01;   % Moment of inertia (kg.m^2)
B = 0.1;    % Friction coefficient (N.m.s)

% Electrical parameters
V = 230;    % Line-to-line voltage (volts)
f = 60;     % Frequency (Hz)

% Simulation parameters
tspan = [0 2];  % Simulation time span

% Initial conditions
theta0 = 0;     % Initial rotor angle (radians)
omega0 = 0;     % Initial rotor angular velocity (rad/s)
i_s0 = [0; 0; 0]; % Initial stator current (amperes per phase)
i_r0 = [0; 0; 0]; % Initial rotor current (amperes per phase)

% Define the system of equations for 3-phase motor
motor_eqns_3phase = @(t, y) [
    (V - Rs*y(4:6) - Lm*y(7:9).*y(4:6))*cos(y(1)) - (y(7:9).*y(4:6) + Rr*y(7:9)).*y(4:6);
    (V - Rs*y(4:6) - Lm*y(7:9).*y(4:6))*sin(y(1)) - (y(7:9).*y(4:6) + Rr*y(7:9)).*y(4:6);
    (V - Rs*y(4:6) - Lm*y(7:9).*y(4:6)).*y(4:6) - f*y(4:6);
    (y(7:9).*(V - Rr*y(7:9) - Lm*y(4:6).*y(4:6))) - B*y(7:9) - Lr*y(4:6).*y(7:9)
];

% Solve the system of equations
[t, y] = ode45(motor_eqns_3phase, tspan, [theta0; omega0; i_s0(:); i_r0(:)]);

% Plot the results
figure;

subplot(3, 1, 1);
plot(t, y(:, 1));
title('Rotor Angle vs Time');
xlabel('Time (s)');
ylabel('Rotor Angle (rad)');

subplot(3, 1, 2);
plot(t, y(:, 2));
title('Rotor Angular Velocity vs Time');
xlabel('Time (s)');
ylabel('Angular Velocity (rad/s)');

subplot(3, 1, 3);
plot(t, y(:, 3:5));
title('Stator Current vs Time');
xlabel('Time (s)');
ylabel('Stator Current (A)');
legend('Phase A', 'Phase B', 'Phase C');
