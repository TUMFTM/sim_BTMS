function layers_out = starting_layers_mod_in(layers, cells_mod_dim, mods_sys_dim)

% Determine layers for BTMS inside modules for a given battery system

%% Check feasibilty of input

% 'layers' must not be 0 or cells_mod_dim --> that would be the outside of
% the module and this type of cooling is specified with the 'sys_inside_*'
% variables.

if (sum( layers == 0 )) || (sum( layers == cells_mod_dim ))
    error('Wrong definition of starting layers inside module! Check mod_inside_*_layers variables!')
end



%% Get starting layers

module_index = [];

for ii = 0:mods_sys_dim-1
    
    module_index = [module_index, repmat(ii, 1, length(layers))];
    
end

layers_mod = repmat(layers, 1, mods_sys_dim);

layers_out = layers_mod + (module_index * cells_mod_dim);


end