% 1. Define system parameters
M = 1.0;    % Mass of the cart
m = 0.1;    % Mass of the pendulum
L = 0.5;    % Length to pendulum center of mass
g = 9.81;   % Gravity
c_p = 0.1;  % Damping coefficient (pendulum)
c_c = 0.5;  % Damping coefficient (cart)

% 2. Calculate intermediate variables
I = m * (L^2);
D = (M + m) * I - (m^2) * (L^2);

% 3. Define State-Space Matrices (A and B)
A = [0, 1, 0, 0; 
     (M+m)*m*g*L/D, -(M + m)*c_p/D, 0, m*L*c_c/D;
     0, 0, 0, 1;
     -(m^2)*g*(L^2)/D, m*L*c_p/D, 0, -I*c_c/D];
     
B = [0; -m*L/D; 0; I/D];

% 4. Define C and D matrices for the output (Controlling the 1st state)
C = [1, 0, 0, 0]; 
D_ss = 0; 

% 5. Create the state-space model
sys = ss(A, B, C, D_ss);

% 6. Launch the Interactive PID Tuner GUI
disp('Launching the PID Tuner App...');
disp('Use the "Response Time" and "Transient Behavior" sliders to adjust bandwidth and phase.');
pidTuner(sys, 'PID');

Kp = C.Kp;
Ki = C.Ki;
Kd = C.Kd;

fprintf('\nOptimized PID Gains:\n');
fprintf('Kp = %.4f;\n', Kp);
fprintf('Ki = %.4f;\n', Ki);
fprintf('Kd = %.4f;\n', Kd);