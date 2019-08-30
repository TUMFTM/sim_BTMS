
# sim_BTMS

A framework for the design and simulation of lithium-ion battery systems including the consideration of battery thermal management systems (BTMS).

**Developed at:** [Institute of Automotive Technology](https://www.ftm.mw.tum.de/en/home/), [Technical University of Munich](https://www.tum.de/nc/en/).
**Contact:** [Christoph Reiter](mailto:christoph.reiter@tum.de)


* * *


## What does this framework do?

This framework aims to facilitate the complex process of developing a feasible concept for a battery system for an electric vehicle. 

The algorithms takes the target specifications and constraints of the full battery system as input and then tries to find a feasible solution from different available lithium-ion battery (LIB) cells and different approaches for the battery thermal management (BTMS). The idea is to build the system from the bottom up with the following steps:

 1. ***User Input:* Specify LIB model and corresponding BTMS method.** Any number of different LIB parameter set and BTMS methods and combinations thereof is possible.
 2. ***User Input:* Specify the required module and pack parameters.** These include values like capacity, max. current and constraints like dimensions or max weight.
 3. **Calculate the number of serial and parallel cells and their three dimensional geometric arrangement in a module.** 
 4. **Test the feasibilty of the modules.** The modules are tested for compliance to the requirements and constraints by the user. Excluded modules are saved together with information which criteria they did not meet.
 5. **Build a battery system from the modules.** The number of serial and parallel and their three dimensional geometric arrangement in the battery pack is calculated.
 6. **Test the feasibility of the battery system architecture.** The battery packs built from the modules are tested for compliance to the requirements and constraints by the user. Excluded battery packs are saved together with information which criteria they did not meet.
 7. **Design the BTMS on the module level.** According to the user input different BTMS architectures are created and again the compliance to the requirements is tested.
 8. **Coupled electrical and thermal simulation of the BTMS on the module level.** All feasible BTMS solutions are simulated for a fast-charging load cycle (if needed also other load cycles can be used) to check the electrical and thermal load for every individual LIB in the module.
 9. If needed: **Coupled electrical and thermal simulation of the BTMS on the pack level.** Simulate the complete battery system.

Further information about the modelling approach and the validation of the model can be found in the following publication:

*Reiter Et al.: Finding the ideal automotive battery concept: A model-based approach on cell selection, modularization and thermal management. In: Forsch Ingenieurwes (2019) [https://doi.org/10.1007/s10010-019-00316-x](https://doi.org/10.1007/s10010-019-00316-x)* 

Also available at [Springer Link](https://link.springer.com/article/10.1007/s10010-019-00316-x) and [ResearchGate](https://www.researchgate.net/publication/333181648_Finding_the_ideal_automotive_battery_concept_A_model-based_approach_on_cell_selection_modularization_and_thermal_management).


* * *


## Features

Here is a list of everything already included and features planned for the future.

 - [x] Specify different cell models (cylindrical, prismatic, pouch) and their physical, thermal and electric parameters (static and dynamic) and implications for the system level
 - [x] Specifying different basic BTMS configurations and their thermal properties (liquid, air cooling)
 - [x] Comprehensive way of defining different LIB/BTMS combinations from which the algorithm will try to build a battery system
 - [x] Determination of serial and parallel cell interconnection and three-dimensional arrangement of the cells within a battery module
 - [x] Basic testing on the module level (dimensions, weight, energy, capacity, ...)
 - [x] Determination of serial and parallel module interconnection and three-dimensional arrangement of the modules within a battery pack
 - [x] Basic testing on the pack level (dimensions, weight, energy, capacity, ...)
 - [x] Implementing an approach to keep track of the configurations and if and why they got excluded from the solution space.
 - [x] Create BTMS architecture on the module level
 - [x] Basic testing on the module and pack level with included BTMS
 - [x] Electrical and thermal simulation of the modules including the BTMS
 - [x] Electrical and thermal simulation of the pack including the BTMS


* * *


## Use and expansion of the framework

We are very happy is you choose this framework for your projects and research! We are looking forward to hear your feedback and kindly ask you to share bugfixes, improvements and updates in this repository.

**Please cite the [paper above](https://doi.org/10.1007/s10010-019-00316-x) if you use the framework for your publications!**

The model is released under the GNU LESSER GENERAL PUBLIC LICENSE Version 3 (29 June 2007). Please refer to the license file for any further questions about incorporating this framework into your projects.


* * *


## Requirements


### Matlab

The model was created with **MATLAB 2018b**. If you want to commit an updated version using another toolbox please give us a short heads-up. 

Required Toolboxes:
- Simulink 9.2
- DSP Systems Toolbox 9.7
- Simulink Coder 9.0

The insitute usually follows the 'b' releases of Mathworks, so the framework may get updated to 2019b in the future.


### Other open-source software

The electrical and thermal simulation on the cell level build upon the Simulink framework **[sim_battery_system](https://github.com/TUMFTM/sim_battery_system)** by some of the same authors and also created at  [Institute of Automotive Technology](https://www.ftm.mw.tum.de/en/home/). 


* * *


## How To Use


### Disclamer

All cell, system, and BTMS data *currently included* in this release is for debugging and testing purposes only and has nothing to do with the real world. Use at your own risk! **To get valid results out of this framework you have to provide your own data!**


### Basic steps

 - All the individual steps get called from the script *main_sim_BTMS_1_system_setup.m* and also are documented there.

 - During the simulation some info is written to the command window. This looks like this (except): 
	```
	There are 26 configuratons in configs_1_mod_all.
	There are 7 configuratons in configs_2_mod_passed.
	There are 28 configuratons in configs_3_sys_all.
	There are 3 configuratons in configs_4_sys_passed.
	```
	Use this to see how many different configurations are found during each step. A short description of what the subscrits mean:
	- **_all* is everything  created in a step without any tests applied. E.g. the line `There are 28 configuratons in configs_3_sys_all.` Shows there were 28 different possible battery pack configurations created from the  different feasible module configurations of the last step.
	- **_passed* are all configurations from **_all* that passed all tests. E.g. the line `There are 3 configuratons in configs_4_sys_passed.` means that only 3 of the 28 configs in `configs_3_sys_all` met all criteria in our example.

- If your criteria are too strict it also may be the case that no valid concepts are found. Then the output looks something like this:
	```
	There are 14 concepts in configs_1_mod_all.
	There are 2 concepts in configs_2_mod_passed.
	There are 8 concepts in configs_3_sys_all.
	Warning: No feasible concepts in configs_4_sys_passed! 
	```
	
 - After every step the configurations found are saved to *BTMS_simulation_results\*. The folder may look like this:
	**`configs_1_mod_all.mat` 			<-- Created from user input**
	`configs_2_mod_failed.mat`	*<-- Excluded configs because one or more critera were not met*
	**`configs_2_mod_passed.mat` 	<-- Will get used for the next step.**
	**`configs_3_mod_all.mat`			<-- Created using the configs in `configs_2_mod_passed.mat`**
	`configs_4_mod_failed.mat`    *<-- Excluded configs because one or more critera were not met*
	**`configs_4_mod_passed.mat`	<-- Will get used for the next step.**
	
 - Every `*_passed.mat` includes everything needed for the next step, so you don't have to run the full algorithm everytime. Use "Run section" in Matlab to pick up where you left off.
 
 - One the complete system and BTMS setup is complete and valid configs have been found (this is the case it a `configs_6_BTMS_passed.mat`) exits you can move over to *main_sim_BTMS_1_system_simulation.m* to test your systems with an electrical and/or thermal  simulation.
 
 - In those simulation a CCCV charge cycle is applied to see if the system can withstand those stresses. Especially the coupled electricl and thermal simulation of the whole system takes a lot of time so take it easy and don't test too many systems at once. Refer to *main_sim_BTMS_1_system_simulation.m* and *functions_BTMS_sim/sim_module.m* or *functions_BTMS_sim/sim_system.m* for further information.
 

### How to adapt the framework to your LIBs and battery system

 - Provide your cell dataset(s) in *input_and_parameters\01_cell_data*. Refer to the documentation in the dummy data already provided in this folder or see the documentation at [sim_battery_system](https://github.com/TUMFTM/sim_battery_system). Of course you can specify more than one LIB. Every dataset needs its own script/MAT-File since they will be called individually during the configuration process. This is also valid for the other steps in this list.
 - Provide basic system information in *input_and_parameters\02_system_data*.
 - Provide information about the BTMS strategy/-ies you want to use in *input_and_parameters\03_BTMS_configs*.
 - Provide the required system specifications in *input_and_parameters\04_system_specifications\*.


* * *


## Authors and Maintainers

- [Christoph Reiter](mailto:christoph.reiter@tum.de)
	- Idea, structure, underlying concepts and algorithms except where noted otherwise.
	- Supervision of the underlying student's theses.
	- Final implementation, revision and benchmarking.


* * *


## Contributions

- [Lars-Eric Schlereth](Lars.Schlereth@hotmail.de)
	- Initial implementation in MATLAB/Simulink
	- Research of theoretical background of thermal BTMS simulation
	- Test and discussion of the algorithm as part of his master's thesis.