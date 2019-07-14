function sys = state_space(sys)
	identity = eye(size(sys.H));
    Hinv = sys.H\identity;
    qp = sys.C*sys.p;
    pp = Hinv*(-sys.h + sys.Z*sys.u);
    
    sys.states = [sys.q; sys.p];
    dstates = [qp; pp];
    sys.g = equationsToMatrix(dstates, sys.u);
    sys.f = subs(dstates, sys.u, zeros(size(sys.u)));
end