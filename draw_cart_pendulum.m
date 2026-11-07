function draw_cart_pendulum(state, sim_time, u_t,fuel)

    % Dimensions and constants
    cart_w = 1.2;             
    cart_h = 0.6;             
    wheel_r = 0.2;            
    pendulum_l = 2.0;         
    mass_r = 0.12;            
    hinge_r = 0.15;   

    % Extracts positions from the state vector
    theta = state(1);
    x = state(3);
    
    % Use persistent variables to fetch and store the logo only once, 
    % preventing massive performance drops from reading the file every frame.
    persistent logo_img logo_checked;
    if isempty(logo_checked)
        logo_filename = 'odoway_logo.png';
        if isfile(logo_filename)
            logo_img = imread(logo_filename);
            logo_img = flipud(logo_img); % Flip Y-axis for MATLAB plot compatibility
        else
            logo_img = [];
            warning('Logo file not found. Please ensure it is in the current directory.');
        end
        logo_checked = true;
    end
            
    
    % Colors 
    color_cart = [0.95, 0.05, 0.3]; 
    color_pole = [0.0, 0.5, 1.0];   
    color_ground = [0 0 0];         
    color_wheels = [0 0 0];         
    
    % Clear and setup axes
    cla;
    hold on;
    axis equal;
    axis([-5 5 -1 5]); 
    set(gca, 'Visible', 'off'); 
    
    % Draw Logo in the top left corner if loaded
    if ~isempty(logo_img)
        % Get image dimensions to maintain aspect ratio
        img_h = size(logo_img, 1);
        img_w = size(logo_img, 2);
        aspect_ratio = img_w / img_h;
        
        % Set desired visual width for the logo in the plot
        logo_plot_width = 2.5; 
        logo_plot_height = logo_plot_width / aspect_ratio;
        
        % Set coordinates (anchored to top-left)
        x_left = -4.8;
        x_right = x_left + logo_plot_width;
        y_top = 4.8;
        y_bottom = y_top - logo_plot_height;
        
        image('XData', [x_left x_right], 'YData', [y_bottom y_top], 'CData', logo_img);
        set(gca, 'YDir', 'normal'); % Keep the regular axis direction
    end
    
    % --- NEW: Draw Telemetry Text in Top Right ---
    % Format the text strings with 2 decimal places
    telemetry_str = sprintf('SimTime = %.2f s\nTheta = %.2f rad\nX = %.2f m\nF = %.2f N\nFuel = %.2f units', sim_time, theta, x,u_t,fuel);
    
    % Place the text at x=2.5, y=4.5 (adjust these coordinates if needed)
    % Interpreter set to 'none' to prevent underscore from causing a subscript
    % FontSize reduced from 12 to 10
    text(2.5, 4.5, telemetry_str, 'FontSize', 10, 'FontName', 'Arial', ...
         'HorizontalAlignment', 'left', 'VerticalAlignment', 'top', ...
         'Interpreter', 'none');
    % ---------------------------------------------

    % Draw Ground 
    fill([-10 10 10 -10], [-5 -5 0 0], color_ground, 'EdgeColor', 'none');
    
    % Draw Cart 
    cart_y = wheel_r * 1.8; 
    cart_x = x - cart_w/2;
    rectangle('Position', [cart_x, cart_y, cart_w, cart_h], ...
              'FaceColor', color_cart, 'EdgeColor', 'none');
          
    % Draw Wheels
    draw_circle(x - cart_w/3, wheel_r, wheel_r, color_wheels);
    draw_circle(x + cart_w/3, wheel_r, wheel_r, color_wheels);
    
    % Draw Hinge Base
    hinge_y = cart_y + cart_h;
    draw_circle(x, hinge_y, hinge_r, color_cart);
    
    % Calculate Pendulum Tip
    tip_x = x + pendulum_l * sin(theta);
    tip_y = hinge_y + pendulum_l * cos(theta);
    
    % Draw Pendulum Pole and Mass
    plot([x, tip_x], [hinge_y, tip_y], 'Color', color_pole, 'LineWidth', 4);
    draw_circle(tip_x, tip_y, mass_r, color_cart);
    
    hold off;
    drawnow;
end

function draw_circle(x, y, r, color)
    th = linspace(0, 2*pi, 50);
    x_unit = r * cos(th) + x;
    y_unit = r * sin(th) + y;
    fill(x_unit, y_unit, color, 'EdgeColor', 'none');
end