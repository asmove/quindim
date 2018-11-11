function a = acceleration(Tpp, d)
    a_ = Tpp*[d; 1];
    a = formula(a_);
    a = simplify(a);
    a = a(1:2);
end