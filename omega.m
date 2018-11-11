function omega = omega(T, vars, diffs)
    syms t;

    T_ = formula(T);
    R = T_(1:3, 1:3);
    
    Rp = diff(R, t);    
     
    Rp = subs(Rp, diffs, vars);
    
    Somega = Rp*R.';
    Somega = formula(Somega);

    omega = [-Somega(2, 3); Somega(1, 3); -Somega(1, 2)];

    omega = simplify(omega);
end