function inertia_tensor = inertia_tensor(label, is_diag)
% Creates a symmetric inertia tensor
% Input: Label [int]: Label to the tensor
% Ourpur: inertia_tensor [matrix]: symbolic tensor
    
    if(nargin == 1)
        is_diag = false;
    end

    name = sprintf('I%s_', label);
    
    if(is_diag)
        inertia_tensor = diag(sym([name, '%d'], [3, 1]));
    else
        inertia_tensor = sym([name, '%d%d'], [3, 3]);
    end
    
    
    for m = 1:3
        for n = m:3
            inertia_tensor(m, n) = inertia_tensor(n, m);
        end
    end

end