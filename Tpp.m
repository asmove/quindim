function ans = Tpp(T, diffs, vars)
    syms t;
    Tp_= Tp(T, diffs, vars);
    Tpp_ = diff(Tp_, t);
    ans = subs(Tpp_, diffs, vars);
end