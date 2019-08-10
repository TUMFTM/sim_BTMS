function A_heat_transfer = calc_total_A_heat_transfer(channel_num_adj_cells, channel_orientation, A_dir)

num_channels = length(channel_num_adj_cells);

A_heat_transfer = NaN(num_channels, 1);

A_x = A_dir(1);
A_y = A_dir(2);
A_z = A_dir(3);

for ii = 1:num_channels
    switch channel_orientation(ii)
        case 'x'
            A_heat_transfer(ii) = A_x * channel_num_adj_cells(ii);
        case 'y'
            A_heat_transfer(ii) = A_y * channel_num_adj_cells(ii);  
        case 'z'
            A_heat_transfer(ii) = A_z * channel_num_adj_cells(ii);
        otherwise
            error('Wrong orientation given!')
    end
end

end