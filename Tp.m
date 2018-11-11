function ans = Tp(T, diffs, vars)
    syms t;
    Tp_ = diff(T, t);
    ans = subs(Tp_, diffs, vars);
end