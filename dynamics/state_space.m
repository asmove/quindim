function [f, g] = state_space(sys)
	identity = eye(size(sys.H));
    Hinv = sys.H\identity;
    qp = sys.C*sys.p;
    pp = Hinv*(-sys.h + sys.Z*sys.u);
    
    dstates = [qp; pp];
    g = equationsToMatrix(dstates, sys.u);
    f = subs(dstates, sys.u, zeros(size(sys.u)));
end