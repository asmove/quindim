function Ms = ctrb_k(A, B)
    n = length(A);
    Ms = B;
	for i = 2:n
	    Ms = [Ms A^(i-1)*B];
	end
end