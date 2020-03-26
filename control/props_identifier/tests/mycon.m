function [c, ceq] = mycon(x, Ms, T, )
     c = [];
     
     Ms_ = subs(Ms, T, x);
     [m, n] = size(Ms_);
     ceq = rank(Ms_) - m;
end