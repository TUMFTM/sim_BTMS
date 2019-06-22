SimPara.t_step = 0.01;     % Simulation step-size in s. Obviously this has a huge impact on simulation time, but note the simulation may get unstable if set too high.
SimPara.t_sim  = 2500;     % Total simulation time in s

I_diff = 2e-4;             % Magnitude of charging current reduction per simulation step of fast-charging control