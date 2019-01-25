function [q_circ_fun, is_ws_fun] = load_q_circ(mechanism)
    q_bullet = mechanism.eqdyn.q_bullet;
    
    qs = [];
    deltas = [];
    
    for i = 1:3
        L1i = mechanism.serials{i}.bodies{1}.params.L1;
        L2i = mechanism.serials{i}.bodies{2}.params.L2;
        betai = mechanism.serials{i}.base.params.beta;
        
        d = mechanism.eqdyn.q_bullet(1:2);
        
        Pi = [d; 0];
        Bi = mechanism.endeffector.B{i};
        Oi = mechanism.serials{i}.O;        
        ai = Bi - Oi;

        mi = 2*L1i*ai(1);
        ni = 2*L1i*ai(2);
        pi_ = ai.'*ai + L1i^2 - L2i^2;
        
        ai_ = pi_ + mi;
        bi_ = -2*ni;
        ci_ = pi_ - mi;
        
        deltai = bi_^2 - 4*ai_*ci_;
        u = (-bi_ + sqrt(deltai))/(2*ai_);

        cos_u = (1-u^2)/(1+u^2);
        sin_u = 2*u/(1+u^2);
        
        gammai = atan2(sin_u, cos_u);
        q1i = gammai - betai;
        
        R01i = mechanism.serials{i}.bodies{1}.T(1:3, 1:3);
        R01i = subs(R01i, mechanism.serials{i}.generalized.q(1), q1i);
        L1ivec = [L1i; 0; 0];
        
        q2i = q1i + acos((ai.'*R01i*L1ivec - L1i^2)/(L1i*L2i));
                
        qs = [qs; q1i; q2i];
        deltas = [deltas; deltai];
    end
    
    q_circ_fun = @(q) double(subs(qs, q_bullet, q));
    is_ws_fun = @(q) ~any(~(subs(deltas, q_bullet, q) >= 0));
end
