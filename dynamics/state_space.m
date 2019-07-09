function f = state_space(sys)
	identity = eye(size(sys.H));
    Hinv = sys.H\identity;
    qp = sys.C*sys.p;
    pp = Hinv*(-sys.h + sys.Z*sys.u);
    
    f = [qp; pp];
end