syms g;
syms f_phi_i f_phi_o f_phi_r f_phi_l;

% Body 1
syms mc mi mo mr ml R real;
syms w L real;

syms w Lc Li Lo Lr Ll real;

syms xi_g yi_g real;
syms xo_g yo_g real;
syms xr_g yr_g real;
syms xl_g yl_g real;
syms xc_g yc_g real;

syms x_pos y_pos theta delta_i delta_o phi_i phi_o phi_r phi_l real;
syms xp yp thetap deltap_i deltap_o phip_i phip_o phip_r phip_l real;
syms xpp ypp thetapp deltapp_i deltapp_o phipp_i phipp_o phipp_r phipp_l real;

I_i = inertia_tensor('i', false);
I_o = inertia_tensor('o', false);
I_r = inertia_tensor('r', false);
I_l = inertia_tensor('l', false);
I_c = inertia_tensor('c', false);

% Generalized coordinates
sys.kin.q = [x_pos; y_pos; theta; 
             delta_i; delta_o; 
             phi_i; phi_o; 
             phi_r; phi_l];
sys.kin.qp = [xp; yp; thetap; 
              deltap_i; deltap_o; 
              phip_i; phip_o; 
              phip_r; phip_l];
sys.kin.qpp = [xpp; ypp; thetapp; 
               deltapp_i; deltapp_o; 
               phipp_i; phipp_o; 
               phipp_r; phipp_l];
