function [A_x, A_y, A_z, A] = calc_cell_surface(BatPara)


%% Get cell surface areas in the spacial dimensions

A_x = BatPara.physical.dim_y * BatPara.physical.dim_z;
A_y = BatPara.physical.dim_x * BatPara.physical.dim_z;
A_z = BatPara.physical.dim_x * BatPara.physical.dim_y;

A = 2* (A_x + A_y + A_z); 

end
