function p = point(T, d)
    p_ = T*[d; 1];
    p = formula(p_);
    p = simplify(p);
    p = p(1:3);
end