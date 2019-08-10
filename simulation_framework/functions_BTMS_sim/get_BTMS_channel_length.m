function channel_length = get_BTMS_channel_length(orientation, ratio, dim_x_sys, dim_y_sys, dim_z_sys)

channel_length = NaN(length(orientation), 1);

%% Get channel length in spacial direction

% Battery system top view: x dir: Bottom to top, y dir: right to left
%  _______
% |       |
% |       |
% |       |  <---- flow direction for 'y' channels
% |       |
% |_______|
% 
%    ^-- Flow direction for 'x' and '

for ii = 1:length(orientation)
    
    switch orientation(ii)
        case 'x'
            channel_length(ii) = dim_y_sys;
        case 'y'
            channel_length(ii) = dim_x_sys;
        case 'z'
            channel_length(ii) = dim_x_sys;
    end
    
end

channel_length = channel_length * ratio;


end
