function p_circ_ = p_circ(mechanism, q_bullet, qp_bullet)
    n_bullet = length(q_bullet);
    C = coupling_matrixC(mechanism, q_bullet);
    
    p_bullet = mechanism.D_bullet*qp_bullet;
    
    A = C(n_bullet+1:end, :);
    p_circ_ = A*p_bullet;
end