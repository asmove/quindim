function vers_u = versor_func(u)
    if(norm(u) == 0)
        vers_u = u;
    else
        vers_u = u/norm(u);
    end
end