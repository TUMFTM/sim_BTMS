function [BatPara_scaled] = scale_BatPara(BatPara, target_capacity)

% Approximate the dynamic behavior of cells with a different capacity from
% a sample parameter set.

% Note: This can be used for an INITIAL ASSESSMENT of the impact of
% different cell sizes on the battery system and BTMS concept. Of course,
% in reality there are other, non neglectable influences on dynamic cell
% behavior that must not be neglected. If you use this framework for
% anything other that basic comparisons you must provide your own cell
% data!

scaling_factor = BatPara.electrical.C_A / target_capacity;

BatPara.electrical.dyn.R_0 = BatPara.electrical.dyn.R_0 * scaling_factor;
BatPara.electrical.dyn.R1  = BatPara.electrical.dyn.R1  * scaling_factor;
BatPara.electrical.dyn.R2  = BatPara.electrical.dyn.R2  * scaling_factor;
BatPara.electrical.dyn.R3  = BatPara.electrical.dyn.R3  * scaling_factor;
BatPara.electrical.dyn.R4  = BatPara.electrical.dyn.R4  * scaling_factor;

BatPara.electrical.dyn.C1  = BatPara.electrical.dyn.C1  / scaling_factor;
BatPara.electrical.dyn.C2  = BatPara.electrical.dyn.C2  / scaling_factor;
BatPara.electrical.dyn.C3  = BatPara.electrical.dyn.C3  / scaling_factor;
BatPara.electrical.dyn.C4  = BatPara.electrical.dyn.C4  / scaling_factor;

BatPara.electrical.C_A = BatPara.electrical.C_A / scaling_factor;

BatPara_scaled = BatPara;

end

