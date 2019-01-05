function ps_ = points(Ts, ps)
    % Guard
    if lenght(Ts) ~= lenght(ps)
       error('Number of transformations MUST be equal to points!'); 
    end       
    
    dimen = length(ps{1});
    n_bodies = length(Ts);
    
    ps_ = {};
    for i = 1:n_bodies
        T = Ts{i};
        p = ps{i};
        
        ps_h = T*[p; 1];
        
        ps_{end} = ps_h(1:dimen);
    end
end