function [d di] = reldeg(sys)

% Zustandsraumdarstellung
A = sys.a;
B = sys.b;
C = sys.c;
D = sys.d;

% Größe der Matrizen
[n,p] = size(B);
[q,n] = size(C);

% Zuweisung des Vektors di, der die Differenzordnung jeder Zeile
%   der Ausgangsmatrix enthält
di = zeros(q,1);

% Schleife
for i = 1:q
    
    % Wenn D(i,:)==0, ist die Differenzordnung der entsprechenden Zeile
    %   berechnet
    if (~any(D(i,:)))
        for j = 0:n
            aux = C(i,:)*A^j*B;

            % Die Berechnung C(i,:)*A^j*B ist ungleich null
            if(any(aux))
                di(i) = j+1;
                break;
            end

            % Diese Zeile hat keine Differenzordnung
            if j==n
               di(i) = Inf; 
            end
        end
        
    % Ansonst ist die selbe null
    else
        di(i) = 0;
    end
end

% Summe der Differenzordnung jeder zeile
%   der Ausgangmatrix
d = 0;
for i = 1:q
   d = d + di(i);  
end

if isinf(d)
   d = []; 
end  

end
