function is_invol = is_involutive(fs, x)
    [~, m] = size(fs);
    
    r_fs = rank(simplify_(fs));
    
    for i = 1:m
        for j = i+1:m
            lie_fi_fj = lie_bracket(fs(i), fs(j), x);
            r_fs_lie = rank(simplify_([fs, lie_fi_fj]));
            
            if(r_fs_lie ~= r_fs)
                is_invol = false;
                return
            end
        end
    end
    
    is_invol = true;
end