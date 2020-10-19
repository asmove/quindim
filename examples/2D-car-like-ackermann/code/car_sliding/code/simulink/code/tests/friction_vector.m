function C_fric = friction_vector(q, p, kappa_1, kappa_2, alpha_1, alpha_2, C_1delta, ...
                                 mc, mi, g, a, Cp_1, mu_1, Fz_1, Cp_2, mu_2, Fz_2)
                             
    delta_i = q(4);
    delta_o = q(5);
    theta = q(3);
    
    w_delta_o = p(1);
    w_phi_o = p(2);
    w_phi_l = p(3);
    
    qp = C_1delta*p;
    
    w_theta = qp(3);
    w_delta_i = qp(4);
    w_phi_i = qp(6);
    w_phi_r = qp(end-1);

    R_th_i = rot2d(theta + delta_i);
    R_th_o = rot2d(theta + delta_o);
    R_th = rot2d(theta);
    
    n = length(q);
    
    % Canonical vectors
    e_th = canon_Rn(n, 3);
    e_compl = zeros(n-2, 1);
    
    n = length(q);
    Iq_3 = eye(n-2);
    
    R6_th_i = blkdiag(R_th_i, Iq_3);
    R6_th_o = blkdiag(R_th_o, Iq_3);
    R6_th = blkdiag(R_th, Iq_3);
    
    sigma_x_1 = kappa_1/(kappa_1 + 1);
    sigma_y_1 = tan(alpha_1)/(kappa_1 + 1);
    
    sigma_x_2 = kappa_2/(kappa_2 + 1);
    sigma_y_2 = tan(alpha_2)/(kappa_2 + 1);
    
    sigma_1 = terop((sigma_x_1 == 0)||(sigma_y_1 == 0), ...
                    1, sqrt(sigma_x_1^2 + sigma_y_1^2));
    sigma_2 = terop((sigma_x_2 == 0)||(sigma_y_2 == 0), ...
                     1, sqrt(sigma_x_2^2 + sigma_y_2^2));
                 
    theta_1 = double((2/3)*(Cp_1*a^2/(mu_1*Fz_1)));
    theta_2 = double((2/3)*(Cp_2*a^2/(mu_2*Fz_2)));
    
    lambda_1 = 1 - theta_1*sigma_1;
    lambda_2 = 1 - theta_2*sigma_2;
    
    if(theta_1 ~= 0)
        sigma_sl_1 = 1/theta_1;
        Fz_1 = (mc/4 + mi)*g;
        
        if(sigma_1 <= sigma_sl_1)
            F_1 = mu_1*Fz_1*(1 - lambda_1^3);
        else
            F_1 = mu_1*Fz_1;
        end
        
        F1_vec = F_1*[sigma_x_1; sigma_y_1]/sigma_1;
        t_lambda_1 = (lambda_1^3/(1 + lambda_1 + lambda_1^2))*a;
    
        Mz_1 = -t_lambda_1*F1_vec(2);
    else
        F1_vec = [0; 0];
        Mz_1 = 0;
    end
    
    if(theta_2 ~= 0)
        sigma_sl_2 = 1/theta_2; 
        Fz_2 = (mc/4 + mi)*g;

        if(sigma_2 <= sigma_sl_2)
            F_2 = mu_2*Fz_2*(1 - lambda_2^3);
        else
            F_2 = mu_2*Fz_2;
        end
        sigma_2
        F2_vec = F_2*[sigma_x_2; sigma_y_2]/sigma_2;
        t_lambda_2 = (lambda_2^3/(1 + lambda_2 + lambda_2^2))*a;
        Mz_2 = -t_lambda_2*F2_vec(2);
    else
        F2_vec = [0; 0];
        Mz_2 = 0;
    end
    
    C_i = -R6_th_i*[F1_vec; e_compl] + e_th*Mz_1;
    C_o = -R6_th_o*[F2_vec; e_compl] + e_th*Mz_2;
    
    C_fric = C_i + C_o;