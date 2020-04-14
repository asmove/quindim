function Pt = point2point(t_i, T, P0, P1)
    Pt = P0 + (t_i/T)*(P1 - P0);
end