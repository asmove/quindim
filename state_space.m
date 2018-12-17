function f = state_space(sys)
	identity = eye(size(sys.mass_matrix));
    Minv = sys.mass_matrix\identity;
    qpp = Minv*(sys.reqdyns - sys.coriolis - sys.gravitational);
    qp = sys.qp;
    
    f = [qp; qpp];
end