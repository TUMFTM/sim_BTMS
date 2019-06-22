function [m] = get_cell_mass(dim_x, dim_y, dim_z, rho, cell_type)

% This function calculates the cell's mass from its dimensions, type and
% density 'rho'

dim_vec = [dim_x, dim_y, dim_z];

if strcmp(cell_type, 'Pouch') || strcmp(cell_type, 'Pris')
    % Pouch and prismatic cell
    m = prod(dim_vec) * rho;
    
elseif strcmp(cell_type, 'Cyl')
    % Cylindrical cell. 
    
    %First we need to find out what is the length and what the diameter
    dim_unique = unique(dim_vec); % Reduce vector to unique elements and sort it, starting with the smallest value (we assume this is always the diameter)
    
    if length(dim_unique) == 1  % Length and diameter are the same
        l_cyl = dim_unique;
        r_cyl = dim_unique/2;
    elseif length(dim_unique) == 2 % Length > diameter
        l_cyl = dim_unique(2);
        r_cyl = dim_unique(1)/2;
    else    % User provided wrong values...
        error('Wrong dimensions for cylindrical cell! Two of the dim_x, dim_y & dim_z values must be identical')
    end
    
    % Calculate cell mass
    m = r_cyl^2 * pi * l_cyl * rho;
    
else
    error('Unknown cell type!')
end

end

