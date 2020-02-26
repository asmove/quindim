function v = velocity(Tp, d)

    v_ = Tp*[d; 1];
    
    v = formula(v_);
    v = v(1:3);
end
