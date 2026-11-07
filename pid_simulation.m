%% Main Run

% simulation parameters
sim_time = 5;
steps_per_sec = 30;

% system parameters
M = 5;
m = 1;
g = 9.81;
L = 0.3;
c_p = 0.005;
c_c = 10;

% PID Parameters
Kp = -2414.0686;
Ki = -10705.6949;
Kd = -136.0894;

setpoint = 0;
u_min = -60;
u_max = 60;
% knob to turn the controller on or off
controller_on = 1;


% running the simulation
cart_pendulum_simulation(M,m,g,L,c_p,c_c,setpoint,Kp,Ki,Kd,u_min,u_max,controller_on,sim_time,steps_per_sec);



%% Function Declarations
function cart_pendulum_simulation(M,m,g,L,c_p,c_c,setpoint,Kp,Ki,Kd,u_min,u_max,controller_on,sim_time,steps_per_sec)
    % Example script to demonstrate the cart-pendulum visualization.
    % It generates a dummy trajectory and animates it over time.
    
    % Setup time and dummy trajectory arrays
    dt = 1/steps_per_sec;
    t = 0:dt:sim_time;

    % Setup the figure window
    fig = figure('Name', 'Cart-Pendulum Visualization', 'Color', 'w', ...
                 'Position', [100, 100, 800, 500]);
    
    x_k = [0;1.57;0;0];
    theta = zeros(1,length(t));
    x = zeros(1,length(t));
    force = zeros(1,length(t));

    fuel = 0;
     % PID Internal Variables
    integral_error = 0;
    prev_error = 0;
    

    % Animation loop
    for i = 1:length(t)
        if ~isvalid(fig)
            break; % Stop if user closes the figure
        end
        
        
        error = setpoint - wrapTo180(x_k(1)*(180/pi))*(pi/180);
        
        % Update Integral and Derivative
        integral_error = integral_error + error * dt;
        derivative_error = (error - prev_error) / dt;
        
        % Calculate PID control output signal
        u_t = (Kp * error) + (Ki * integral_error) + (Kd * derivative_error);
        u_t = clip(u_t,u_min,u_max)*controller_on;

        x_k = cart_pendulum_system(M,m,g,L,c_p,c_c,u_t,x_k,dt);
        fuel = fuel + abs(u_t)*dt;
        
        % Call the visualization function
        draw_cart_pendulum(x_k, t(i),u_t,fuel);
        theta(i) = x_k(1);
        x(i) = x_k(3);
        force(i) = u_t;
        

        
        pause(dt);
    end

    figure;
    subplot(3,1,1); plot(t, theta, 'b'); grid on; yline(0, '--k'); ylabel('theta');
subplot(3,1,2); plot(t, x, 'r'); grid on; yline(0, '--k'); ylabel('X');
subplot(3,1,3); plot(t, force, 'g'); grid on; yline(0, '--k'); ylabel('Force'); 

end

