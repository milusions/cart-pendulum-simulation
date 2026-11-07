function result = cart_pendulum_system(M,m,g,L,c_p,c_c,u_t,x_k,delta_t)

 
  k1 = get_delta_x(x_k ,M,m,g,L,c_p,c_c,u_t);
  k2 = get_delta_x(x_k + (delta_t/2)*k1,M,m,g,L,c_p,c_c,u_t);
  k3 = get_delta_x(x_k + (delta_t/2)*k2,M,m,g,L,c_p,c_c,u_t);
  k4 = get_delta_x(x_k + delta_t*k3,M,m,g,L,c_p,c_c,u_t);

  x_k_1 = x_k + (delta_t/6)*(k1 + 2*k2 + 2*k3 + k4);
  
  result = x_k_1;
end


function result = get_delta_x(x_k,M,m,g,L,c_p,c_c,u_t)
  I = m*(L^2);
  theta_dot_dot = ((M+m)*m*g*L*sin(x_k(1)) - (m^2)*(L^2)*(x_k(2)^2)*sin(x_k(1))*cos(x_k(1)) + m*L*c_c*x_k(4)*cos(x_k(1)) - (M+m)*c_p*x_k(2) - m*L*u_t*cos(x_k(1)))/((M+m)*I - (m^2)*(L^2)*(cos(x_k(1))^2));
  x_dot_dot = (I*m*L*(x_k(2)^2)*sin(x_k(1)) - I*c_c*x_k(4) - (m^2)*g*(L^2)*sin(x_k(1))*cos(x_k(1)) + m*L*c_p*x_k(2)*cos(x_k(1)) + I*u_t)/((M+m)*I - (m^2)*(L^2)*(cos(x_k(1))^2));
  delta_x = [x_k(2); 
             theta_dot_dot;
             x_k(4);
             x_dot_dot
             ];

  result = delta_x;
end