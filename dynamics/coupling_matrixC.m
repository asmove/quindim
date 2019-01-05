funcion [C, Chat, Cp] = coupling_matrixC(mechanism, q, qp)
    n_bullet = length(mechanism.eqdyn.q_bullet);
    n_circ = length(mechanism.eqdyn.q_circ);
    
    if(n_bullet + n_circ ~= length(q))
        error('The dimensions of q_bullet plus q_circ MUST be equal to dimension of provided q')        
    end
    
    q_sym = [mechanism.eqdyn.q_bullet; mechanism.eqdyn.q_circ];
    
    % Jacobian speed matrix
    [A, Ap] = coupling_matrixA(mechanism, q, qp);
    
    % Jacobians
    Jac_bullet = double(subs(mechanism.eqdyn.Jac_bullet, q_sym, q));
    Jac_circ = double(subs(mechanism.eqdyn.Jac_circ, q_sym, q));
   
    % Generalized speed to coordinates derivatives
    D_bullet = double(subs(mechanism.eqdyn.D_bullet, ...
                    mechanism.eqdyn.q_bullet, q(1:n_bullet)));
    D_circ = double(subs(mechanism.eqdyn.D_circ, ...
                    mechanism.eqdyn.q_circ, q(n_bullet+1:end)));
    
    Q_circ = mechanism.eqdyn.Q_circ;
    
    % Coupling matrix
    Chat = -(D_circ\Jac_circ)*Jac_bullet*pinv(D_bullet);
    C = [eye(n_bullet); Chat];
    
    % Couplingmatrix derivative
    Cp = -Q_circ*((A*Q_circ)\Ap*C);    
end
