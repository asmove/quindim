clear all
clc

syms T;

A = eig_to_matrix([-1, -2, -3]);
B = [1; 1; 1];

phi_ = exp(A*T);
gamma_ = Gamma(A, B, T);

Ms = ctrb_k(phi_, gamma_);

Ts0 = 0.1;
n = length(A);

Ts_prev = 0;
Ts_curr = Ts0;

ERROR = 0.1;
THRESHOLD = 1000;

is_end = false;

while ~is_end
    Ms_ = subs(Ms, T, Ts_curr);
    
    if(rank(Ms_) < n)
        temp = Ts_curr;
        Ts_curr = (Ts_curr + Ts_prev)/2;
        Ts_prev = temp;
    else
        temp = Ts_curr;
        Ts_curr = 2*Ts_curr;
        Ts_prev = temp;
    end
    
    if((Ts_curr > THRESHOLD) || ...
       (abs(Ts_curr - Ts_prev) < ERROR))
        is_end = true;
    end
end

disp(sprintf('Loss of observbility for %.2f', Ts_curr));
