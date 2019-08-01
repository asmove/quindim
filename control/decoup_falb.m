function [R,F] = decoupFalb(sys,ew)

	% Zustandsraumdarstellung
	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	% Gr��e der Matrizen
	[n,p] = size(B);
	[q,n] = size(C);

	% �berpr�fung, ob das System quadratisch ist
	if p~=q
	   error('The system is not quadratic!');
	end

	% Differenzordnung
	[d di] = reldeg(sys);

	% �berpr�fung der Existenz der Differenzordnung des Systems
	if(isempty(d))
	    error('The system has not a relative degree!');
	end

	% Berechnung des Parameters q_ij
	for i = 1:q
	    EW = ew{i};
	    qi = poly(EW);
	    Q{i} = fliplr(qi);
	end

	% Berechnung der Matrix D_stern
	for i = 1:q
	    D_stern(i,:) = C(i,:)*A^(di(i)-1)*B;
	end

	if(abs(det(D_stern))<eps)
	   error('Th system is not decouplable because det(D_stern) = 0!');
	end

	% Berechnung der Matrix 'aux' zur Bestimmung des Reglers
	for i = 1:q
	    auxR(i,:) = C(i,:)*A^(di(i));
	    
	    qi = Q{i};
	    
	    for j = 0:di(i)-1
		auxR(i,:) = auxR(i,:) + qi(j+1)*C(i,:)*A^j;
	    end
	end

	% Berechnung der Matrix 'aux' zur Bestimmung des Vorfilters
	for i = 1:q
	    qi = Q{i};
	    qi0(i) = qi(1);
	end

	auxF = diag(qi0);

	R = inv(D_stern)*auxR;
	F = inv(D_stern)*auxF;
  
end
