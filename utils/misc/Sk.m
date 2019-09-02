function  Sk_ = Sk(Sk_1, i, t, y)
    Sk_ = Sk_1 + 0.5*(t(i) - t(i-1))*(y(i) + y(i-1));
end