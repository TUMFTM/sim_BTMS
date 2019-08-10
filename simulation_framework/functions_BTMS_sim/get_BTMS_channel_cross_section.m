function channel_crosss = get_BTMS_channel_cross_section(orientation, ratio, dim_x_sys, dim_y_sys, dim_z_sys, channel_width)

channel_crosss = NaN(length(orientation), 1);

%% Get channel height in spacial direction

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
            channel_crosss(ii) = dim_z_sys;
        case 'y'
            channel_crosss(ii) = dim_z_sys;
        case 'z'
            channel_crosss(ii) = dim_y_sys;
    end
    
end

% Caculate cross section including ratio

channel_crosss = channel_crosss * channel_width * ratio;


end
