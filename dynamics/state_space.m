function sys = state_space(sys)
	identity = eye(size(sys.dyn.H));
    Hinv = sys.dyn.H\identity;
    qp = sys.C*sys.p;
    pp = Hinv*(-sys.dyn.h + sys.dyn.Z*sys.u);
    
    sys.dyn.states = [sys.q; sys.p];
    dstates = [qp; pp];
    sys.dyn.g = equationsToMatrix(dstates, sys.u);
    sys.dyn.f = subs(dstates, sys.u, zeros(size(sys.u)));
end