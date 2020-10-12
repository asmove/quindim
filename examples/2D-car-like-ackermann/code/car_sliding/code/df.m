function dq  = df(t, x, aux_syms, aux_vals, sys, ...
                  v_i, v_o, v_r, v_l, ...
                  model_symbs, model_params)
    persistent is_persis_defined M_num Q_num A_delta_num A_num C_num;
    persistent C_delta_num dC_num dC_delta_num dC_1delta_num;
    persistent Ap_1_num Ap_delta_num;
    
    syms mu_ b a_0 a_1 v_0i v_1i v_0o v_1o;
    syms mu_p1_s mu_p1_c mu_p1_v
    syms mu_p2_s mu_p2_c mu_p2_v
    syms mu_v_s mu_v_c mu_v_v
    syms sign_sym(a) versor(u)
    syms Fa(v) Ta1(w) Ta2(w)
    syms omega_s v_s

    % Symbolic variables
    syms kappa_1 alpha_1
    syms dkappa_1 dalpha_1
    syms kappa_2 alpha_2
    syms dkappa_2 dalpha_2
    
    syms kappa_3 alpha_3
    syms dkappa_3 dalpha_3
    syms kappa_4 alpha_4
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
    
    kqps_vals = [symbs; sys.kin.q; sys.kin.p{end}; model_symbs];
    kqps_symbs = [params; x; model_params];
    
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
        C_num = subs(null(A_num), sys.descrip.syms, sys.descrip.model_params);
        C_delta_num = subs(C_1delta - null(A_num), sys.descrip.syms, sys.descrip.model_params);
        C_1delta_num = C_num + C_delta_num;
        
        qk1a1k2a2_syms = [q; kappa_1; alpha_1; kappa_2; alpha_2];
        qk1a1k2a2_vals = [C_1delta*p; dkappa_1; dalpha_1; dkappa_2; dalpha_2];
        
        dC_num = subs(dmatdt(C_num, qk1a1k2a2_syms, qk1a1k2a2_vals), kqps_vals, kqps_symbs);
        dC_delta_num = subs(dmatdt(C_delta_num, qk1a1k2a2_syms, qk1a1k2a2_vals), kqps_vals, kqps_symbs);
        dC_1delta_num = dC_num + dC_delta_num;

        % Constraints derivatives
        Ap_1_num = subs(dmatdt(A_num, qk1a1k2a2_syms, qk1a1k2a2_vals), kqps_vals, kqps_symbs);
        Ap_delta_num = subs(dmatdt(A_delta_num, qk1a1k2a2_syms, qk1a1k2a2_vals), kqps_vals, kqps_symbs);
        Ap_1delta_num = Ap_1_num + Ap_delta_num;
        
        U = sys.dyn.U;
        u = sys.descrip.u;

        nu = sys.dyn.nu;
        g_ = sys.dyn.g;
        f_b = sys.dyn.f_b;
        f_k = sys.dyn.f_k;
        
        % Unconstrained forces
        Q_num = subs(U*u-nu-g_-f_b-f_k, sys.descrip.syms, sys.descrip.model_params);
        
        p = sys.kin.p{end};
        qp = sys.kin.qp;
        Q_num = subs(Q_num, qp, C_1delta*p);
    end
    
    t0 = tic();
    
    qps = sys.kin.qp;
    ps = sys.kin.p{end};
    
    A_1 = double(subs(A_num, kqps_vals, kqps_symbs));
    A_delta = double(subs(A_delta_num, kqps_vals, kqps_symbs));
    A_1delta = A_1 + A_delta;
    
    C_1 = double(null(A_num));
    C_delta = double(subs(C_delta_num, kqps_vals, kqps_symbs));
    C_1delta = C_1 + C_delta;
    
    dC_1 = double(dC_num);
    dC_delta = double(dC_delta_num);
    dC_1delta = dC_1 + dC_delta;

    % Constraints derivatives
    Ap_1 = double(Ap_1_num);
    Ap_delta = double(Ap_delta_num);
    
    b_1delta = -Ap_1*C_1delta*p_num + Ap_delta*C_1delta*p_num;
    
    disp('Aqui 3');
    toc(t0);
    
    t0 = tic();
    
    % Useful constraint
    M_ = double(subs(M_num, kqps_vals, kqps_symbs));
    sqrt_M = sqrtm(M_); 
    inv_M = inv(M_);
    M_12 = sqrtm(inv_M);
    
    B_1 = double(A_1*M_12);
    B_delta = double(A_delta*M_12);
    pB_1 = pinv(B_1);
    
    B_delta = double(B_delta);
    pB_delta = double(pinv(B_delta));
    
    disp('Aqui 4.1');
    toc(t0);
    
    % ideal constraint
    Q_val = subs(Q_num, kqps_vals, kqps_symbs);
    a = double(inv_M*Q_val);
    
    
    B_1delta = double(B_delta + B_1);
    
    pB_1delta = double(pinv(B_1delta));
    
    t0 = tic();
    
    Qc_i = sqrt_M*pB_1delta*(b_1delta - A_1delta*a);    
    
    disp('Aqui 4.2');
    toc(t0);
    
    t0 = tic();
    
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
    qps = C_num*p;
    
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
    
    vi_contact_val = subs(norm(kappa_1*v_i), kqps_vals, kqps_symbs);
    vo_contact_val = subs(norm(kappa_2*v_o), kqps_vals, kqps_symbs);
    vr_contact_val = subs(norm(kappa_3*v_r), kqps_vals, kqps_symbs);
    vl_contact_val = subs(norm(kappa_4*v_l), kqps_vals, kqps_symbs);
    
    fric_symbs_v = [mu_v_s mu_v_c mu_v_v omega_s v_s];
    fric_symbs_p1 = [mu_p1_s mu_p1_c mu_p1_v omega_s v_s];
    fric_symbs_p2 = [mu_p2_s mu_p2_c mu_p2_v omega_s v_s];
    
    mc = sys.descrip.model_params(1);
    g = sys.descrip.model_params(end-1);
    N_i = mc*g/4;
    N_o = mc*g/4;
    N_r = mc*g/4;
    N_l = mc*g/4;
    
    Fa_th_i = lin_friction(vi_contact_val, N_i, fric_symbs_v);
    Ta_phii_i = rot_friction(w_phi_i, fric_symbs_p1);
    Ta_th_i = rot_friction(w_theta, fric_symbs_p2);
    
    Fa_th_o = lin_friction(vo_contact_val, N_o, fric_symbs_v);
    Ta_phii_o = rot_friction(w_phi_o, fric_symbs_p1);
    Ta_th_o = rot_friction(w_theta, fric_symbs_p2);
    
    Fa_th_r = lin_friction(vr_contact_val, N_r, fric_symbs_v);
    Ta_phii_r = rot_friction(w_phi_r, fric_symbs_p1);
    Ta_th_r = rot_friction(w_theta, fric_symbs_p2);
    
    Fa_th_l = lin_friction(vl_contact_val, N_l, fric_symbs_v);
    Ta_phii_l = rot_friction(w_phi_l, fric_symbs_p1);
    Ta_th_l = rot_friction(w_theta, fric_symbs_p2);
    
    C_i = -R6_th_i*e_x*Fa_th_i - e_phi_i*Ta_phii_i - e_th*Ta_th_i;
    C_o = -R6_th_o*e_x*Fa_th_o - e_phi_o*Ta_phii_o - e_th*Ta_th_o;
    C_r = -R6_th*e_x*Fa_th_r - e_phi_i*Ta_phii_r - e_th*Ta_th_r;
    C_l = -R6_th*e_x*Fa_th_r - e_phi_o*Ta_phii_l - e_th*Ta_th_l;
    
    C_fric = subs(C_i + C_o + C_r + C_l, kqps_vals, kqps_symbs);
    
    disp('Aqui 5');
    toc(t0)
    
    t0 = tic();
    
    n = length(pB_1);
    Wc = subs(eye(n) - pB_1delta*B_1delta, kqps_symbs, kqps_vals);
    
    F = sqrt_M*Wc*M_12;
    Qc_ni = F*C_fric;

    Q_sum = Q_val + Qc_i + Qc_ni;
    
    disp('Aqui 6.1');
    toc(t0)
    
    H_sym = vpa(C_1delta.'*M_*C_1delta);
    H = double(subs(H_sym, kqps_vals, kqps_symbs));
    
    disp('Aqui 6.2');
    toc(t0)
    
    f = double(C_1delta.'*Q_val);
    
    disp('Aqui 6.3');
    toc(t0)
    
    f_i = double(-C_1delta.'*M_*dC_1delta*p_num + C_1delta.'*Qc_i);
    
    disp('Aqui 6.4');
    toc(t0)
    
    t0 = tic();
    
    qp = sys.kin.qp;
    
    f_ni = C_1delta.'*Wc*C_fric;
    f_ni = subs(f_ni, qp, C_1delta*p_num);
    f_ni = subs(f_ni, kqps_vals, kqps_symbs);
    f_ni = double(f_ni);
    
    plant = [double(C_1delta*p_num); inv(H)*(f + f_i + f_ni)];
    plant = subs(plant, sys.descrip.syms, sys.descrip.model_params);
    dq = double(subs(plant, ...
                  [symbs; sys.kin.q; sys.kin.p{end}; model_symbs], ...
                  [params; x; model_params]));
    vpa(dq, 5)
    disp('Aqui 7');
    toc(t0)
    disp('Final ');
    toc(tf);
    disp('-------------------------');
end