function dq  = df(t, x, aux_syms, aux_vals, sys, ...
                  v_i, v_o, v_r, v_l, model_symbs, model_params)
    persistent is_persis_defined M_num Q_num A_delta_num A_num C_num;
    persistent C_delta_num dC_num dC_delta_num C_1delta_num;
    persistent Ap_1_num Ap_delta_num;
    
    x = double(x);
    
    syms mu_ b a_0 a_1 v_0i v_1i v_0o v_1o;
    syms mu_p1_s mu_p1_c mu_p1_v
    syms mu_p2_s mu_p2_c mu_p2_v
    syms mu_v_s mu_v_c mu_v_v
    syms sign_sym(a) versor(u)
    syms Fa(v) Ta1(w) Ta2(w)
    syms omega_s v_s

    % Symbolic variables
    syms kappa_1 alpha_1
    syms kappa_2 alpha_2
    syms kappa_3 alpha_3
    syms kappa_4 alpha_4

    syms dkappa_1 dalpha_1
    syms dkappa_2 dalpha_2
    syms dkappa_3 dalpha_3
    syms dkappa_4 dalpha_4
    
    disp(sprintf('Instante: %.5f', t));
    
    tf = tic;
    
    t0 = tic;
    
    n_q = length(sys.kin.q);
    n_p = length(sys.kin.p{end});
    
    % States and speeds
    pp = sys.kin.pp{end};
    p = sys.kin.p{end};
    q = sys.kin.q;
    qp = sys.kin.qp;

    mc = sys.descrip.syms(1);
    g = sys.descrip.syms(end-1);
    
    q_num = x(1:n_q);
    p_num = x(n_q+1:n_q+n_p);
    disp('Aqui 1');
    toc(t0)
    
    t0 = tic();
    symbs = aux_syms;
    params = [];
    for i = 1:length(aux_syms)
        aux_vals_i = aux_vals{i};
        params = [params; aux_vals_i(t)];
    end
    
    kqps_symbs = [symbs; sys.kin.q; sys.kin.p{end}; model_symbs];
    kqps_vals = [params; x; model_params];
    
    v_01_i = sqrt(v_0i^2 + v_1i^2);
    v_01_o = sqrt(v_0o^2 + v_1o^2);
    disp('Aqui 2');
    toc(t0)
    
    if(isempty(is_persis_defined))
        is_persis_defined = true;

        M_num = subs(sys.dyn.M, sys.descrip.syms, sys.descrip.model_params);
        
        % Constraints and virtual displacements
        delta = [0; 0;
                 -kappa_1*tan(alpha_1)*v_i;
                 -kappa_1*tan(alpha_1)*v_i;
                 -kappa_2*tan(alpha_2)*v_o;
                 -kappa_2*tan(alpha_2)*v_o;];

        Alpha = equationsToMatrix(delta, sys.kin.qp);
        A_delta_num = subs(-Alpha, sys.descrip.syms, sys.descrip.model_params);
        A_num = subs(sys.kin.A, sys.descrip.syms, sys.descrip.model_params);
        
        C_1delta = null(A_num + A_delta_num);
        C_num = null(A_num);
        C_delta_num = C_1delta - null(A_num);
        C_1delta_num = C_num + C_delta_num;
        
        qk1a1k2a2_syms = [q; kappa_1; alpha_1; kappa_2; alpha_2];
        qk1a1k2a2_vals = [C_1delta*p; dkappa_1; dalpha_1; dkappa_2; dalpha_2];
        
        dC_num = subs(dmatdt(C_num, qk1a1k2a2_syms, qk1a1k2a2_vals), ...
                      sys.descrip.syms, sys.descrip.model_params);
        dC_delta_num = subs(dmatdt(C_delta_num, qk1a1k2a2_syms, qk1a1k2a2_vals), ...
                            sys.descrip.syms, sys.descrip.model_params);
        dC_1delta_num = dC_num + dC_delta_num;

        % Constraints derivatives
        Ap_1_num = subs(dmatdt(A_num, qk1a1k2a2_syms, qk1a1k2a2_vals), ...
                               sys.descrip.syms, sys.descrip.model_params);
        Ap_delta_num = subs(dmatdt(A_delta_num, qk1a1k2a2_syms, qk1a1k2a2_vals), ...
                                   sys.descrip.syms, sys.descrip.model_params);
        Ap_1delta_num = Ap_1_num + Ap_delta_num;
        
        U = sys.dyn.U;
        u = sys.descrip.u;

        nu = sys.dyn.nu;
        g_ = sys.dyn.g;
        f_b = sys.dyn.f_b;
        f_k = sys.dyn.f_k;
        
        % Unconstrained forces
        p = sys.kin.p{end};
        qp = sys.kin.qp;
        
        Q_num = vpa(subs(U*u-nu-g_-f_b-f_k, sys.descrip.syms, sys.descrip.model_params));
    end
    Q_num = vpa(subs(Q_num, qp, C_1delta_num*p));
    
    t0 = tic();
    
    idxs = find_index(kqps_symbs, symvar(A_num));
    A_1 = double(subs(A_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    idxs = find_index(kqps_symbs, symvar(A_delta_num));
    A_delta = double(subs(A_delta_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    A_1delta = A_1 + A_delta;
    
    C_1 = double(null(A_1));
    C_1delta = double(null(A_1delta));
    C_delta = double(C_1delta - C_1);
    
    disp('Aqui 3.0');
    toc(t0);
    
    t0 = tic();
    
    idxs = find_index(kqps_symbs, symvar(dC_num));
    dC_1 = double(subs(dC_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    idxs = find_index(kqps_symbs, symvar(dC_delta_num));
    dC_delta = double(subs(dC_delta_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    dC_1delta = real(double(dC_1 + dC_delta));

    % Constraints derivatives
    idxs = find_index(kqps_symbs, symvar(Ap_1_num));
    Ap_1 = double(subs(Ap_1_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    idxs = find_index(kqps_symbs, symvar(Ap_delta_num));
    Ap_delta = double(subs(Ap_delta_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    Ap_1delta = double(Ap_1 + Ap_delta);
    
    disp('Aqui 3.1');
    toc(t0);
    
    t0 = tic();
    
    b_1delta = double(-Ap_1delta*C_1delta*p_num);
    
    disp('Aqui 3.2');
    toc(t0);
    
    t0 = tic();
    
    % Useful constraint
    idxs = find_index(kqps_symbs, symvar(M_num));
    M_ = double(subs(M_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    sqrt_M = sqrtm(M_);
    inv_M = inv(M_);
    M_12 = sqrtm(inv_M);
    
    B_1 = double(A_1*M_12);
    B_delta = double(A_delta*M_12);
    B_1delta = double(B_delta + B_1);
    
    pB_1 = double(pinv(B_1));
    pB_1delta = double(pinv(B_1delta));
    
    disp('Aqui 4.1');
    toc(t0);
    
    t0 = tic();
    
    % ideal constraint
    idxs = find_index(kqps_symbs, symvar(Q_num));
    Q_val = double(subs(Q_num, kqps_symbs(idxs), double(kqps_vals(idxs))));
    disp('Aqui 4.1.1');
    toc(t0);
    
    t0 = tic();
    
    a = inv_M*Q_val;
    
    Qc_i = sqrt_M*pB_1delta*(b_1delta - A_1delta*a);    
    
    qs = sys.kin.q;
    qps = sys.kin.qp;
    ps = sys.kin.p{end};
    
    delta_i = qs(4);
    delta_o = qs(5);
    theta = qs(3);
    w_theta = qps(3);
    w_delta_i = qps(4);
    w_delta_o = ps(1);

    w_phi_i = qps(6);
    w_phi_o = ps(2);

    w_phi_r = qps(end-1);
    w_phi_l = ps(3);

    R_th_i = rot2d(theta + delta_i);
    R_th_o = rot2d(theta + delta_o);
    R_th = rot2d(theta);

    p = [w_delta_o; w_phi_o; w_phi_l];
    qps = C_1*p_num;
    
    R = sys.descrip.syms(end-4);
    
    n = length(sys.kin.q);
    e_x = canon_Rn(n, 1);
    e_y = canon_Rn(n, 2);
    e_th = canon_Rn(n, 3);
    e_phi_i = canon_Rn(n, 6);
    e_phi_o = canon_Rn(n, 7);
    
    n = length(sys.kin.q);
    Iq_3 = eye(n-2);
    
    R6_th_i = blkdiag(R_th_i, Iq_3);
    R6_th_o = blkdiag(R_th_o, Iq_3);
    R6_th = blkdiag(R_th, Iq_3);
    
    mc = sys.descrip.model_params(1);
    mi = sys.descrip.model_params(2);
    g = sys.descrip.model_params(end-1);
    N_i = mc*g/4;
    N_o = mc*g/4;
    N_r = mc*g/4;
    N_l = mc*g/4;
    
    D = sys.descrip.model_params(end-4);
    perc = 0.3;
    a = double(perc*D);
    
    sigma_x_1 = kappa_1/(kappa_1 + 1);
    sigma_y_1 = tan(alpha_1)/(kappa_1 + 1);
    
    sigma_x_2 = kappa_1/(kappa_1 + 1);
    sigma_y_2 = tan(alpha_1)/(kappa_1 + 1);
    
    sigma_1 = terop((sigma_x_1 == 0)||(sigma_y_1 == 0), ...
                    sqrt(sigma_x_1^2 + sigma_y_1^2), 1);
    sigma_2 = terop((sigma_x_2 == 0)||(sigma_y_2 == 0), ...
                     sqrt(sigma_x_2^2 + sigma_y_2^2), 1);
    
    disp('Aqui 4.2');
    toc(t0);
    
    t0 = tic();
    
    Cp_1 = 60000;
    mu_1 = 1e-3;
    Fz_1 = g*(mc/4 + mi);
    
    Cp_2 = 60000;
    mu_2 = 1e-3;
    Fz_2 = g*(mc/4 + mi);
    
    disp('Aqui 4.2.1');
    toc(t0);
    
    t0 = tic();
    
    theta_1 = double((2/3)*(Cp_1*a^2/(mu_1*Fz_1)));
    theta_2 = double((2/3)*(Cp_2*a^2/(mu_2*Fz_2)));
    
    idxs = find_index(kqps_symbs, symvar(sigma_1));
    sigma_1 = subs(sigma_1, double(kqps_vals(idxs)), kqps_symbs(idxs));
    
    idxs = find_index(kqps_symbs, symvar(sigma_2));
    sigma_2 = subs(sigma_2, double(kqps_vals(idxs)), kqps_symbs(idxs));
    
    lambda_1 = double(1 - theta_1*sigma_1);
    lambda_2 = double(1 - theta_2*sigma_2);
    
    sigma_sl_1 = 1/theta_1;
    sigma_sl_2 = 1/theta_2;
    
    if(sigma_1 <= sigma_sl_1)
        F_1 = mu_1*Fz_1*(1 - lambda_1^3);
    else
        F_1 = mu_1*Fz_1;
    end
    
    if(sigma_2 <= sigma_sl_2)
        F_2 = mu_2*Fz_2*(1 - lambda_2^3);
    else
        F_2 = mu_2*Fz_2;
    end
    
    disp('Aqui 4.2.2');
    toc(t0);
    
    t0 = tic();
    
    F1_vec = F_1*[sigma_x_1; sigma_y_1]/sigma_1;
    idxs = find_index(kqps_symbs, symvar(F1_vec));
    F1_vec = subs(F1_vec, kqps_symbs(idxs), double(kqps_vals(idxs)));
    
    F2_vec = F_2*[sigma_x_2; sigma_y_2]/sigma_2;
    idxs = find_index(kqps_symbs, symvar(F2_vec));
    F2_vec = double(subs(F2_vec, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    t_lambda_1 = double((lambda_1^3/(1 + lambda_1 + lambda_1^2))*a);
    t_lambda_2 = double((lambda_2^3/(1 + lambda_2 + lambda_2^2))*a);
    
    Mz_1 = double(-t_lambda_1*F1_vec(2));
    Mz_2 = double(-t_lambda_1*F2_vec(2));
    
    e_compl = canon_Rn(n-2, 1);
    
    C_i = -R6_th_i*[F1_vec ; e_compl] + e_th*Mz_1;
    C_o = -R6_th_o*[F2_vec ; e_compl] + e_th*Mz_2;
    
    C_fric = C_i + C_o;
    
    disp('Aqui 4.3');
    toc(t0);
    
%     idxs = find_index(kqps_symbs, unique(symvar(kappa_1*v_i)));
%     vi_contact_val = subs(norm(kappa_1*v_i), kqps_symbs(idxs), double(kqps_vals(idxs)));
%     
%     idxs = find_index(kqps_symbs, unique(symvar(norm(kappa_2*v_o))));
%     vo_contact_val = subs(norm(kappa_2*v_o), kqps_symbs(idxs), double(kqps_vals(idxs)));
%     
%     idxs = find_index(kqps_symbs, unique(symvar(norm(kappa_4*v_l))));
%     vr_contact_val = subs(norm(kappa_3*v_r), kqps_symbs(idxs), double(kqps_vals(idxs)));
%     
%     idxs = find_index(kqps_symbs, unique(symvar(norm(kappa_4*v_l))));
%     vl_contact_val = subs(norm(kappa_4*v_l), kqps_symbs(idxs), double(kqps_vals(idxs)));
%     
%     fric_symbs_v = [mu_v_s mu_v_c mu_v_v omega_s v_s];
%     fric_symbs_p1 = [mu_p1_s mu_p1_c mu_p1_v omega_s v_s];
%     fric_symbs_p2 = [mu_p2_s mu_p2_c mu_p2_v omega_s v_s];
%     Fa_th_i = lin_friction(vi_contact_val, N_i, fric_symbs_v);
%     Ta_phii_i = rot_friction(w_phi_i, fric_symbs_p1);
%     Ta_th_i = rot_friction(w_theta, fric_symbs_p2);
%     
%     Fa_th_o = lin_friction(vo_contact_val, N_o, fric_symbs_v);
%     Ta_phii_o = rot_friction(w_phi_o, fric_symbs_p1);
%     Ta_th_o = rot_friction(w_theta, fric_symbs_p2);
%     
%     Fa_th_r = lin_friction(vr_contact_val, N_r, fric_symbs_v);
%     Ta_phii_r = rot_friction(w_phi_r, fric_symbs_p1);
%     Ta_th_r = rot_friction(w_theta, fric_symbs_p2);
%     
%     Fa_th_l = lin_friction(vl_contact_val, N_l, fric_symbs_v);
%     Ta_phii_l = rot_friction(w_phi_l, fric_symbs_p1);
%     Ta_th_l = rot_friction(w_theta, fric_symbs_p2);
%     
%     C_i = -R6_th_i*e_x*Fa_th_i - e_phi_i*Ta_phii_i - e_th*Ta_th_i;
%     C_o = -R6_th_o*e_x*Fa_th_o - e_phi_o*Ta_phii_o - e_th*Ta_th_o;
%     C_r = -R6_th*e_x*Fa_th_r - e_phi_i*Ta_phii_r - e_th*Ta_th_r;
%     C_l = -R6_th*e_x*Fa_th_r - e_phi_o*Ta_phii_l - e_th*Ta_th_l;
%     
%     C_fric = subs(C_i + C_o + C_r + C_l, kqps_vals, kqps_symbs);

    t0 = tic();    

    n = length(pB_1);
    
    disp('Aqui 4.4');
    toc(t0)
    
    t0 = tic();   
    
    Wc = eye(n) - pB_1delta*B_1delta;
    
    disp('Aqui 5');
    toc(t0)
    
    F = sqrt_M*Wc*M_12;
    Qc_ni = F*C_fric;
    idxs = find_index(kqps_symbs, symvar(Qc_ni));
    Qc_ni = double(subs(Qc_ni, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    Q_sum = Q_val + Qc_i + Qc_ni;
    
    disp('Aqui 6.1');
    toc(t0)
    
    H_sym = vpa(C_1delta.'*M_*C_1delta);
    
    idxs = find_index(kqps_symbs, symvar(H_sym));
    H = double(subs(H_sym, kqps_symbs(idxs), double(kqps_vals(idxs))));
    
    disp('Aqui 6.2');
    toc(t0)
    
    f = double(C_1delta.'*Q_val);
    
    disp('Aqui 6.3');
    toc(t0)
    
    f_i = double(-C_1delta.'*M_*dC_1delta*p_num + C_1delta.'*Qc_i);
    
    disp('Aqui 6.4');
    toc(t0)
    
    t0 = tic();
    
    f_ni = vpa(C_1delta.'*Wc*C_fric);
    idxs = find_index(kqps_symbs, symvar(f_ni));
    f_ni = subs(f_ni, kqps_symbs(idxs), kqps_vals(idxs));
    f_ni = double(f_ni);
    
    dq = double([C_1delta*p_num; inv(H)*(f + f_i + f_ni)]);
    
    vpa(dq, 5)
    disp('Aqui 7');
    toc(t0)
    disp('Final ');
    toc(tf);
    disp('-------------------------');
end

