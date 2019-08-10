function IDs = get_IDs_cells_channels(layer, orientation, e_sys, pe_sys, s_sys)
% Get IDs of cells adjacent to a cooling channel.

%% Info

% Input:

% layer           layer the BTMS channel is in (scalar value 0-*sys)
% orientation     spacial direction the layer is perpendicular to ('x', 'y' or 'z')
% *_sys           number of cells in the respective direction
%     e:  z-direction
%     pe: y-direction
%     e:  x-direction

% Output

% IDs vector with cell IDs adjacent to the channel


%% Get cell IDs of system

p_sys = e_sys * pe_sys;     % Number of parallel cells
n_sys = p_sys * s_sys;      % Total number of cells

cell_IDs = 1:n_sys;

% Structure with cell IDs that corresponds to system geometry

ID_3d = reshape(cell_IDs, [pe_sys, e_sys, s_sys]);


%% Test if requested layer is outside of system

if layer == 0
    
    % Outside beginning (one layer of cells)
    index = 1;
    
elseif (layer == s_sys && orientation == 'x') || (layer == pe_sys && orientation == 'y') || (layer == e_sys && orientation == 'z')
    
    % Outside end (one layer of cells)
    index = layer;
    
else
    
    % Inside (between two layers of cells)
    index = [layer, layer+1];
    
end


%% Get cell IDs

switch orientation
    case 'x'
        IDs_mat = ID_3d(:,:,index);
    case 'y'
        IDs_mat = ID_3d(index,:,:);
    case 'z'
        IDs_mat = ID_3d(:,index,:);
end

%% Create output vector

IDs = reshape(IDs_mat,1,numel(IDs_mat));

end