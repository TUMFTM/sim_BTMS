%% Info

% Part 2 of the BTMS configuration: Analyze and simulate the systems

% To create the systems refer to 'main_sim_BTMS_1_system_setup'.


%% Initialization

close all
clc

% Add all relevant folders --> TODO in Simulink project

addpath(genpath('battery_system_simulation'));  % Data of battery system simulation (refer to https://github.com/TUMFTM/sim_battery_system)
% addpath(genpath('BTMS_simulation'));          % Data of BTMS simulation
addpath(genpath('BTMS_simulation_results'));    % Folder with simulation results

addpath(genpath('functions_sys_config'));                  % Functions and subroutines
addpath(genpath('coolprop'));                   % CoolProp data used to obtain fluid characteristics

addpath(genpath('functions_BTMS_sim'));         % Functions for BTMS setup and sim

addpath(genpath('input_and_parameters'));       % Input data for the system configuration


%% User Input: Select simulation modes

t_modes.plot_sys = true;        % Plot the system configuration
t_modes.sim_module = true;      % Electrical simulation of modules
t_modes.sim_sys = true;         % Electrical an thermal simulation of the whole system

t_config_file = 'configs_6_BTMS_passed';    % Select the mat-File with the configs for simulation

% Note: The steps above will be performed for all configs in the provided
% mat-file and therefore may take a long time!


%% Plotting of systems

if t_modes.plot_sys == true

    for ii = 1:1:size(configs_6_BTMS_passed, 2)

        config = configs_6_BTMS_passed(ii);
        plot_system_architecture(config);

    end
    
end




%% Electrical simulation on module level

% for ii = 1:1:size(configs_1_mod_all, 2)
%     
%     config = configs_6_BTMS_passed(ii);
%    
%     
% end


%% Electrical an thermal simulation on system level

% for ii = 1:1:size(configs_1_mod_all, 2)
%     
%     config = configs_6_BTMS_passed(ii);
%    
%     
% end


%% Postprocessing

clearvars *_t