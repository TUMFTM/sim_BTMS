function alpha_channel = calc_alpha_channel(FluidPara, w_fluid, ch_width, ch_length, channel_inside)
% Calculate the heat transfer coefficient inside the cooling channels

% Assumption: Laminar flow

% Refer to paper linked in respository for further information


%% Get fluid parameters out of structure

kin_vis = FluidPara.kin_vis;    % kinematic viscosity in[m^2/s]
lambda  = FluidPara.lambda;     % Thermal conductivity in [W/mK]
Pr      = FluidPara.Pr;         % Prandtl number


%% Get system info and preallocate variable

num_channels = length(w_fluid);
alpha_channel = NaN(num_channels, 1);



% Iterate through the channels
for ii = 1:num_channels 


    %% Reynolds number (using approximation for planar channels)

    d_h = 2 * ch_width;      % Hydraulic diameter

    Re = (d_h * w_fluid(ii)) / kin_vis;


    %% Mean Nusselt number in the channel

    % Distinction of cases between channels at the outside of the system (heated
    % from one side) and modules at the inside of the system (heated from both
    % sides).

    switch channel_inside(ii)
        case true
            Nu_1 = 7.541;
        otherwise
            Nu_1 = 4.861;
    end

    Nu_2 = 1.841 * nthroot(Re * Pr * (d_h / ch_length(ii)), 3);

    Nu_mean = nthroot(Nu_1^3 + Nu_2^3 , 3);


    %% Heat transfer coefficient

    alpha_channel(ii) = (Nu_mean * lambda) / d_h;

end

end

