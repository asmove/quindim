function sys = state_space(sys)
	identity = eye(size(sys.dyn.H));
    Hinv = sys.dyn.H\identity;
    qp = sys.kin.C*sys.kin.p;
    pp = Hinv*(-sys.dyn.h + sys.dyn.Z*sys.descrip.u);
    
    sys.dyn.states = [sys.kin.q; sys.kin.p];
    dstates = [qp; pp];
    sys.dyn.G = equationsToMatrix(dstates, sys.descrip.u);
    sys.dyn.f = subs(dstates, sys.descrip.u, ...
                     zeros(size(sys.descrip.u)));
end