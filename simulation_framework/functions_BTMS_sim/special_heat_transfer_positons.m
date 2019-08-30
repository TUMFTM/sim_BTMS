function [layer, dir, alpha] = special_heat_transfer_positons(alpha_mod_gap, ModInfo, SysInfo)

num_mod_x = ModInfo.num_serial_cells_mod;
num_mod_y = ModInfo.num_parallel_cells_per_layer_mod;
num_mod_z = ModInfo.num_layers_mod;

num_sys_x = SysInfo.num_serial_mods_sys;
num_sys_y = SysInfo.num_parallel_mods_per_layer_sys;
num_sys_z = SysInfo.num_layers_sys;

%% x-dir

layer_x = find_layers(num_mod_x, num_sys_x);
dir_x   = dirs(layer_x, 'x');
alpha_x = dirs(layer_x, alpha_mod_gap);


%% x-dir

layer_y = find_layers(num_mod_y, num_sys_y);
dir_y   = dirs(layer_y, 'y');
alpha_y = dirs(layer_y, alpha_mod_gap);


%% x-dir

layer_z = find_layers(num_mod_z, num_sys_z);
dir_z   = dirs(layer_z, 'z');
alpha_z = dirs(layer_z, alpha_mod_gap);


%% Put everything together and create output.

layer = [layer_x, layer_y, layer_z];
dir   = [dir_x, dir_y, dir_z];
alpha = [alpha_x, alpha_y, alpha_z];


end

function layer_dir = find_layers(mod, sys)

layer_dir = mod .* (1:sys);
layer_dir = layer_dir(1:end-1); % remove last element, because that is at the outside of the system

end

function dir = dirs(layer_dir, dir_in)

    dir = repmat(dir_in, 1, length(layer_dir));

end
