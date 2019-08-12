function [R F] = VMS(sys,ews,P)

	% Zustandsraumdarstellung
	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	% Groesse der Matrizen
	[n,p] = size(B);
	[q,n] = size(C);

	% Transformation matrix and eigenvalues
	[V, diag] = eig(A);
	
	for ew = ews
	    if(imag(ew) ~= 0)
		posconj = find(conj(ews) == ew);
		if(length(posconj) ~= 1)
		    error('Imaginary and its conjugate MUST belong to control eigenvalues!');
		end	 
	    end
	end

	if (p~=q)
	   error('The system is not quadratic!'); 
	end

	% System controlability
	[ctb, ew_ctb] = ctrb_(sys);

	ctrb_idx = find(~ctb);
    nctrb = eq_ctb(ctrb_idx);
	
	if nargin==2
	    if (p==1)
		P = ones(1,n);
	    
	    else
		P = rand(p,n);
	    end
	end

	for i = 1:n
        if(~isempty(find(ewgesch == ewsi))));
        
		% Controllable eigenvalues
		if((find(ew_ctb == ews(i))))
		    P(:,i) = zeros(p,1);
		    Vr(:,i) = V(:,find(ewgesch == ews(i)));
	       
		% Not controllable eigenvalues
		else
		    aux = [ews(i)*eye(n)-A -B; C zeros(q,p)];
		    aux2 = null(aux);

		    Vr(:,i) = aux(1:n,1);
		    P(:,i) = aux(n+1:end,1);
		end     
	    
	    % Otherwise
	    else
		Vr(:,i) = inv(ews(i)*eye(n)-A)*B*P(:,i);
	    end
	end

	R = real(-P*inv(Vr));
	F = inv(C*inv(B*R-A)*B);

end
