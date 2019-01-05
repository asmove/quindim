function points = eval_points(mechanism, q0)
    q = [mechanism.eqdyn.q_bullet; mechanism.eqdyn.q_circ];
    
    points = {};
    points = {};

    for i = 1:3
        A = subs(mechanism.serials{i}.A, q, q0);
        O = subs(mechanism.serials{i}.O, q, q0);
        Bi = subs(mechanism.endeffector.B{i}, q, q0);

        points{end+1} = double(A);
        points{end+1} = double(O);
        points{end+1} = double(Bi);
    end    
end

