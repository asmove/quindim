function [A, Ap] = coupling_matrixA(mechanism, q, qp)
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);
    
    if(n_bullet + n_circ ~= length(q))
        error('The dimensions of q_bullet plus q_circ MUST be equal to dimension of provided q')        
    end
    
    q_sym = [mechanism.eqdyn.q_bullet; mechanism.eqdyn.q_circ];
    qp_sym = [mechanism.eqdyn.qp_bullet; mechanism.eqdyn.qp_circ];
    
    Ap = double(subs(mechanism.eqdyn.Ap, [q; qp], [q_sym; qp_sym]));
    A = double(subs(mechanism.eqdyn.Ap, [q; qp], [q_sym; qp_sym]));
end