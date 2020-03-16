function [Ms_s, fs_s] = Ms_fs(sys, alpha_)
    [n, m] = size(sys.dyn.Z);
    
    % Independent terms (gravitational, coriolis, friction)
    f = -sys.dyn.h;
    M = sys.dyn.H;
    
    U = sys.dyn.Z(1:m, :);
    
    % Mass Matrix
    M_aa = M(1:m, 1:m);
    M_au = M(1:m, m+1:end);
    M_uu = M(m+1:end, m+1:end);
    
    alpha_a = alpha_(:, 1:m);
    alpha_u = alpha_(:, m+1:end);
    
    % Partitioned independent terms
    f_a = f(1:m);
    f_u = f(m+1:end);
    
    if(~isempty(M_uu) && ~isempty(M_aa))
        M_aa_prime = M_aa + M_au*inv(M_uu)*M_au.';
        M_uu_prime = M_uu + M_au.'*inv(M_aa)*M_au;
        
        f_a_prime = f_a - M_au*inv(M_uu)*f_u;
        f_u_prime = f_u - M_au.'*inv(M_aa)*f_a;
        
        Ms_s = (alpha_a*inv(M_aa_prime) - ...
               alpha_u*inv(M_uu_prime)*M_au.'*inv(M_aa_prime))*U;
        
        fs_s = alpha_a*inv(M_aa_prime)*f_a_prime + ...
               alpha_u*inv(M_uu_prime)*f_u_prime;
    
    else
        M_aa_prime = M_aa;
        M_uu_prime = M_uu;
    
        f_a_prime = f_a;
        f_u_prime = f_u;
    
        Ms_s = alpha_a*inv(M_aa_prime)*U;
        fs_s = alpha_a*inv(M_aa_prime)*f_a_prime;
    end
    
end