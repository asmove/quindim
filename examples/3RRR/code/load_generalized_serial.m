function generalized = load_generalized_serial(i)
    generalized = struct();

    % Generalized coordinates
    q1_name = sprintf('q1%d', i);
    q2_name = sprintf('q2%d', i);
   
    q1i = sym(q1_name, 'real');
    q2i = sym(q2_name, 'real');
    
    % Generalized velocities
    p1_name = sprintf('p1%d', i);
    p2_name = sprintf('p2%d', i);
    
    p1i = sym(p1_name, 'real');
    p2i = sym(p2_name, 'real');

    % Generalized accelerations  
    pp1_name = sprintf('pp1%d', i);
    pp2_name = sprintf('pp2%d', i);
    
    pp1i = sym(pp1_name, 'real');
    pp2i = sym(pp2_name, 'real');
    
    % Generalized variables
    generalized.q = [q1i; q2i];
    generalized.qp = [p1i; p2i];
    generalized.p = [p1i; p2i];
    generalized.pp = [pp1i; pp2i];
end