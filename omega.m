function omega = omega(T, vars, diffs)
    syms t;

    T_ = formula(T);
    R = T_(1:3, 1:3);
    
    Rp = diff(R, t);    
     
    Rp = subs(Rp, diffs, vars);
    
    Somega = Rp*R.';
    Somega = formula(Somega);

    omega = unskew(Somega);

    omega = simplify(omega);
end