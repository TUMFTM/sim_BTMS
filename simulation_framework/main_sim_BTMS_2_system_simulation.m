%% Info

% Part 2 of the BTMS configuration: Analyze and simulate the systems

% To create the configurations refer to 'main_sim_BTMS_1_system_setup'.


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

modes.plot_sys = false;        % Plot the system configuration
modes.sim_module = false;      % Electrical simulation of modules
modes.sim_sys = true;          % Electrical an thermal simulation of the whole system

config_file_mod_sim = 'configs_6_BTMS_passed';   % Select the mat-File with the configs for module simulation
config_file_sys_sim = 'configs_6_BTMS_passed';   % Select the mat-File with the configs for module simulation

% Note: The steps above will be performed for all configs in the provided
% mat-file and therefore may take a long time!

% For further system specifications and simulation parameters go to:
%  - functions_BTMS_sim/sim_module
%  - functions_BTMS_sim/sim_module


%% Plotting of systems

if modes.plot_sys == true

    load(config_file_mod_sim)
    
    for ii = 1:1:size(configs_6_BTMS_passed, 2)

        config = configs_6_BTMS_passed(ii);
        plot_system_architecture(config);

    end
    
end


%% Electrical simulation and evaluation on module level

clear sim_module % Clear persistent variable

if modes.sim_module == true
    
    load(config_file_mod_sim)
    
    t_count_res_passed = 1;
    t_count_res_failed = 1;

    for ii = 1:1:size(configs_6_BTMS_passed, 2)

        config = configs_6_BTMS_passed(ii);
        
        results = sim_module(config);
        
        if isempty(results) == false
        
            [results, passed_mod_el] = check_results_mod(results, config);  

            if check_for_failed_tests(passed_mod_el)
                
                results_mod_failed(t_count_res_failed) = results;
                t_count_res_failed = t_count_res_failed + 1;
                fprintf('Warning: The module with mod_ID %i failed the electrical tests and should be excluded from further consideration.\n\n', results.mod_ID)
                
            else
                
                results_mod_passed(t_count_res_passed) = results;
                t_count_res_passed = t_count_res_passed + 1;
                
            end
        end
    end
    
    clearvars results config t_* SimPara ii
    save('BTMS_simulation_results\configs_7_mod_sim', 'results_*')  % Save results of this run in a MAT-File
end


%% Electrical and thermal simulation and evaluation on system level

clear sim_system % Clear persistent variable

if modes.sim_sys == true
    
    load(config_file_sys_sim)
    clearvars results_mod_failed
    
    t_count_res_passed = 1;
    t_count_res_failed = 1;

    for ii = 1:1:size(configs_6_BTMS_passed, 2)

        config = configs_6_BTMS_passed(ii);
        
        results = sim_system(config);
        
        if isempty(results) == false
        
            [results, passed_sys_el] = check_results_sys(results, config);  

            if check_for_failed_tests(passed_sys_el)
                
                results_sys_failed(t_count_res_failed) = results;
                t_count_res_failed = t_count_res_failed + 1;
                fprintf('Warning: The system with sys_ID %i failed the electrical tests and should be excluded from further consideration.\n\n', results.sys_ID)
                
            else
                
                results_sys_passed(t_count_res_passed) = results;
                t_count_res_passed = t_count_res_passed + 1;
                
            end
        end
    end
    
    clearvars results config t_* SimPara ii
    save('BTMS_simulation_results\configs_8_sys_sim', 'results_*')  % Save all possible configurations of this run in a MAT-File
end