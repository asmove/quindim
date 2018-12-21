function [nulls, poles, ctrb, obsv] = plant_behaviour(sys)   
    % Nullvalues and eigenvalues
    nulls = tzero(sys.a, sys.b, sys.c, sys.d);
    poles = pole(ss(sys.a, sys.b, sys.c, sys.d));
       
    [ctrb.eigs, ctrb.is_ctrb] = ctrb_hautus(sys);
    [obsv.eigs, obsv.is_obsv] = obsv_hautus(sys);
end