%% Initialation

clearvars
close all
clc

% Add all relevant folders --> TODO in Simulink project

addpath(genpath('battery_system_simulation'));  % Data of battery system simulation (refer to https://github.com/TUMFTM/sim_battery_system)
% addpath(genpath('BTMS_simulation'));            % Data of BTMS simulation
addpath(genpath('BTMS_simulation_results'));    % Folder with simulation results

addpath(genpath('functions'));                  % Functions and subroutines

addpath(genpath('input_and_parameters'));       % Input data for the system configuration



%% User Input: Overall simulation parameters

SimPara.t_step = 0.01;                          % Simulation step-size in s. Obviously this has a huge impact on simulation time, but note the simulation may get unstable if set too high.
SimPara.t_sim  = 2500;                          % Total simulation time in s


%% User Input: Cells and BTMS-method combinations in cosideration

% Specify LIB parameters and corresponding BTMS method in the following format:

% configurations = {
%     'Cell_1', 'SysInfo_1', 'BTMS_1';
%     'Cell_2', 'SysInfo_2', 'BTMS_2';
%     'Cell_3', 'SysInfo_3', 'BTMS_3';
%     'Cell_4', 'SysInfo_4', 'BTMS_4';
%     'Cell_5', 'SysInfo_5', 'BTMS_5';
%     };

% Every row corresponds to a variant that gets considered for the battery
% system configuration. The input data should be saved in
% 'input_and_parameters/cell_data', '/BTMS_configs' and 'system_data', respectively.

input_configs = {
    'Pouch_10Ah_air', 'system_parameters', 'liquid_Pouch', ;
    };

% Provide the required system specification

run input_and_parameters\04_system_specifications\system_specifcations.m;



%% Step 1: Creating the modules

clear append_configs_1_mod_all  % Clear persistent variable in function

% This section iterates through each configuration and creates the basic
% information about the modules. In the next step the modules are tested
% against the relevant criteria.

% Every possible configuration is stored in an array with all auxilary data
% needed for simulation. This is course creates somewhat of an overhead,
% but makes it easier to just pick up a configuration and start simulating.

for ii = 1:size(input_configs,1)
    
    configs_1_mod_all = preallocate_configs_1_mod_all; % Preallocating the cell-array with all possible configurations
    
    run(input_configs{ii,1});  % Load cell data

    % Determine max size serial connection on module level
    
    % Take minimum of either specified maximum number of serially connected
    % cells or the maximum inplied by nominal module and nom. cell voltage
    
    s_max_mod_raw = min(SysSpec.s_max_mod, ceil(SysSpec.U_mod_nom / BatPara.electrical.U_nom));
    
    % We only want to consider an even number of cells as an option -->
    % Round to the next even integer.
    
    s_max_mod = 2*ceil(s_max_mod_raw/2);
    
    
    % Determine min size of parallel connection
    
    % This is either defined by the max. individual cell current and the 
    % requested fast-charging capability or the module capacity.
    
    p_min_mod = max(ceil(SysSpec.I_sys_max / BatPara.electrical.I_max), ceil(SysSpec.C_mod_min / BatPara.electrical.C_A));
   
    
    % Spatial arrangement of the parallel connection
    
    % We not only can arrange the cells in a simple one dimensional 's*p'
    % grid, but can arrange the cells in all three dimensions. Therefore in
    % this step we create an 'e*pe' connection from the p cells in
    % parallel so that p = e*pe. Those are arranged next to each other so
    % the total number of cells in the battery system is n = e*pe*s.
    
    epe = epe_distribution(p_min_mod, SysSpec.num_higher_p);   
   
    run(input_configs{ii,3});  % Load BTMS data
    
    
    % More parallel connections may be considered for a given configuration
    % --> Interrate through all p's
    
    for jj = 1:1:size(epe,2)   
        
        % To comply to https://github.com/TUMFTM/sim_battery_system as much
        % as possible we resuse the specifications of the serial and
        % parallel connection in 'system_data'
        
        p = epe(jj).p;  
        s = s_max_mod;
        
        run(input_configs{ii,2});  % Load system data
        
        % For every p several combinations of e-pe may be found. --> We
        % iterate through them as well
        
        for kk = 1:1:size(epe(jj).pe, 2)
            SysPara.pe = epe(jj).pe(kk);
            SysPara.e = epe(jj).e(kk);
          
            configs_1_mod_all = append_configs_1_mod_all(BatPara, BTMS, SimPara, SysPara, SysSpec, configs_1_mod_all); % Save everything in a cell-array 
        end
    end
end 

% Check if feasible configurations have been found 

check_feasible_configs(configs_1_mod_all)


% Save resuls of this step

save('BTMS_simulation_results\configs_1_mod_all', 'configs_1_mod_all')  % Save all possible configurations of this run in a MAT-File

clearvars -except configs*  % Clear everything instead the array with the configs.



%% Step 2: Basic Testing of Modules

clear append_configs_2_mod  % Clear persistent variable in function

% In this step we take the configurations from the last sections and test
% them for some basic critera. Here we only perform basic tests to decrease
% the solutions space as much as possible before we start with the
% computationally heaviers stuff.

load('configs_1_mod_all');  % Load the configurations from last step if not already in workspace

% TODO: Allocation of structure with excluded and included configs -->
% Reuse preallocate_configs_1_mod_all

configs_2_mod_passed = preallocate_configs_2_mod; % Preallocating the cell-array with all configuations that passed the module tests
configs_2_mod_failed = preallocate_configs_2_mod; % Preallocating the cell-array with all configuations that failed the module tests

% Iterate through the configurations


for ii = 1:1:size(configs_1_mod_all, 2)
    
    config = configs_1_mod_all(ii);

    % Exclude Configs that violate the max. dimensions (without consideration of BTMS)

    [config, passed_dim] = mod_test_dimensions_no_BTMS(config);


    % Exclude Configs that violate the energy content criteria

    [config, passed_energy] = mod_test_energy(config);


    % Create joint structure of criteria

    passed_mod = join_passed_structs(passed_dim, passed_energy);


    % Exclude configs that did not pass the tests from further consideration,
    % pass on working configs to the next steps.

    if size(cell2mat(struct2cell(passed_mod)), 1) > sum(cell2mat(struct2cell(passed_mod)))  % Test if any test has failed
        configs_2_mod_failed = append_configs_2_mod(configs_2_mod_failed, config, passed_mod, 'fail');

    else    % Those configurations have passed
        configs_2_mod_passed = append_configs_2_mod(configs_2_mod_passed, config, passed_mod, 'pass');
    end
end

% Check if feasible configurations have been found 

check_feasible_configs(configs_2_mod_passed);


% Save results of this step

save('BTMS_simulation_results\configs_2_mod_passed', 'configs_2_mod_passed')  % Save all possible configurations of this run in a MAT-File
save('BTMS_simulation_results\configs_2_mod_failed', 'configs_2_mod_failed')  % Save all failed configurations of this run in a MAT-File

clearvars -except configs*  % Clear everything instead the array with the configs.



