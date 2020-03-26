function ctb = ctrbKalman(sys)

	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	n = length(A);

	Ms = ctrb_k(A, B);

	if(rank(Ms) == n)
	    ctb = 1;
	    disp('The system is controllable according to Kalman criterium!');
	else
	    ctb = 0;
	    disp('The system is not controllable according to Kalman criterium!');
	end

end
