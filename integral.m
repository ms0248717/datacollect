function [nx, ny, nz] = integral(x, y, z, n, dt)
    nx = zeros(n+1, 1);
    ny = zeros(n+1, 1);
    nz = zeros(n+1, 1);
    for i=1:n
       nx(i+1) = nx(i) + (x(i) * dt); 
       ny(i+1) = ny(i) + (y(i) * dt);
       nz(i+1) = nz(i) + (z(i) * dt);
    end
end