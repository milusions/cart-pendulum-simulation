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

% linearzed system model
I = m*(L^2);
D = (M+m)*I -(m^2)*(L^2);
A = [0,1,0,0; 
    (M+m)*m*g*L/D, -(M + m)*c_p/D, 0, m*L*c_c/D;
    0,0,0,1;
    -(m^2)*g*(L^2)/D, m*L*c_p/D, 0, -I*c_c/D];
B = [0; -m*L/D; 0; I/D];

% targetable eigen values
 eigen_target = [-1;-2;-3;-4];
% eigen_target = [-3;-4;-5;-6];
% eigen_target = [-10;-11;-12;-13];

% pole place methodology
K =  place(A,B,eigen_target);

% knob to turn the controller on or off
controller_on = 1;

% running the simulation using the paramaters
cart_pendulum_simulation(M,m,g,L,c_p,c_c,K,controller_on,sim_time,steps_per_sec);




%% Function Declarations
function cart_pendulum_simulation(M,m,g,L,c_p,c_c,K,controller_on,sim_time,steps_per_sec)
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
    
    % Animation loop
    for i = 1:length(t)
        if ~isvalid(fig)
            break; % Stop if user closes the figure
        end
        
        % State vector: [theta, theta_dot, x, x_dot]
        
        u_t = -K*(x_k)*controller_on;
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

