function [R, F] = entkopplungVMS(sys,ew)

	% Zustandsraumdarstellung
	A = sys.a;
	B = sys.b;
	C = sys.c;
	D = sys.d;

	% Größe der Matrizen
	[n,p] = size(B);
	[q,n] = size(C);

	% Überprüfung, ob das System quadratisch ist
	if p~=q
	   error('The system MUST be quadratic i.e. number of inputs = number of outputs!');
	end

	% Differenzordnung
	[d di] = differenzordnung(sys);

	% Differenzordnung ist gleich zu der Anzahl der Zustände des Systems
	if d == n 
	    
	    % Bestimmung der 'd' ersten Parameter- und Eigenvektoren
	    
	    % Anmerkung: Laufende Lage des Cursors
	    laufende_Lage = 0;
	    
	    for i = 1:q
		EW = ew{i};
		Anzahl_ew = length(EW);
		
		% Kanonische Vektor
		ei = zeros(q,1);
		ei(i) = 1;

		for j = 1:Anzahl_ew
		    P(:, j+laufende_Lage) = (C/(EW{j}*eye(n) - A)*B)\ei;
		    Vr(:, j+laufende_Lage) = (EW{j}*eye(n) - A)\B*P(:,i);
		end
		
		laufende_Lage = laufende_Lage + Anzahl_ew;
	    end
	    
	    Vr
	    
	    R = real(-P/(Vr));
	    F = real(inv(C/(B*R-A)*B));

	% Ansonst
	else
	    
	    % Berechnung der Nullstellen des Systems
	    [nst, x0, u0] = nulldynamik(sys);
	    
	    % Wenn die Gleichung nz = n - d erfüllt ist
	    if length(nst) == n-d
		
		% Bestimmung der 'd' ersten Parameter- und Eigenvektoren
		
		% Anmerkung: Laufende Lage des Cursors
		laufende_Lage = 0;
		
		for i = 1:q
		    EW = ew{i};
		    Anzahl_ew = length(EW); 
		    
		    ei = zeros(q,1);
		    ei(i) = 1;
		    
		    for j = 1:Anzahl_ew
		        P(:,j + laufende_Lage) = inv(C*inv(EW{j}*eye(n) - A)*B)*ei;
		        Vr(:,j + laufende_Lage) = inv(EW{j}*eye(n) - A)*B*P(:,i);
		    end
		    
		    laufende_Lage = laufende_Lage + Anzahl_ew;
		end
		
		% Anzahl der Nullstellen des Systems
		nz = length(nst);
		
		% Berechnung der Parametervektoren und Eigenvektoren des
		%   geschlossenen Regalkreises
		for i = 1:nz
		    Z = [nst(i)*eye(n)-A -B; C zeros(q,p)];
		    z0 = null(Z)
		    
		    Vr(:,d+i) = z0(1:n,1)
		    P(:,d+i) = z0(n+1:end,1)
		end
		
	    R = real(-P*inv(Vr));
	    F = real(inv(C*inv(B*R-A)*B));
	    
	    % Wenn die Gleichung nz = n - d nicht erfüllt ist 
	    else
		error('Das System ist nicht entkoppelbar!')
	    end
	end

end
