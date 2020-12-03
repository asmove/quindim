
radius_1 = w/2 + L/tan(delta_i);
radius_g = radius_1/cos(delta);
radius_l = radius_1 - w/2;
radius_r = radius_1 + w/2;
radius_i = radius_l/cos(delta_i);
radius_o = radius_r/cos(delta_o);

outer_wheel = phip_o*R*num_g*den_o - proj_vu*num_o*den_g;
inner_outer_wheel = phip_i*num_o*den_i - phip_o*num_i*den_o;
left_right_wheel = phip_l*num_r*den_l - phip_r*num_l*den_r;
left_inner_wheel = phip_i*num_r*den_i - phip_r*num_i*den_r;

subs(outer_wheel, [delta_i; delta_o], [0; 0])
subs(inner_outer_wheel, [delta_i; delta_o], [0; 0])
subs(left_right_wheel, [delta_i; delta_o], [0; 0])
subs(left_inner_wheel, [delta_i; delta_o], [0; 0])

C = sys.kin.C;
p = sys.kin.p{end};

C_p_io = subs(C*p, [delta_i; delta_o], [0; 0]);
