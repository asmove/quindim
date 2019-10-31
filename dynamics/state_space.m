function sys = state_space(sys)
	identity = eye(size(sys.dyn.H));
    Hinv = sys.dyn.H\identity;
    
    q = sys.kin.q; 
    p = sys.kin.p{end};
    C = sys.kin.C{1};
    
    qp = C*p;
    pp = Hinv*(-sys.dyn.h + sys.dyn.Z*sys.descrip.u);
    
    sys.dyn.states = [q; p];
    dstates = [qp; pp];
    
    sys.dyn.G = equationsToMatrix(dstates, sys.descrip.u);
    sys.dyn.f = subs(dstates, sys.descrip.u, ...
                     zeros(size(sys.descrip.u)));
end