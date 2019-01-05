function [c, ceq] = const_q_circ(q_circ, consts, gradConst)
    maxq = pi;
    
    c = [abs(max(consts(q_circ))); abs(q_circ) - maxq];
    ceq = consts(q_circ);
    g = gradConst(q_circ);
    geq = []; 
end

