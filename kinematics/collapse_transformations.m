function T = collapse_transformations(Ts)
    T = eye(4, 4);
    
    for i = 1:length(Ts)
        T_ = Ts{i};
        T = simplify_(T*T_);
    end
end