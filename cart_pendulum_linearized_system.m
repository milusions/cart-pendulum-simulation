I = m*(L^2)
D = (M+m)*I -(m^2)*(L^2)
A = [0,1,0,0; 
    (M+m)*m*g*L/D, -(M + m)*c_p/D, 0, m*L*c_c/D;
    0,0,0,1;
    -(m^2)*g*(L^2)/D, m*L*c_p/D, 0, -I*c_c/D]
B = [0; -m*L/D; 0; I/D]