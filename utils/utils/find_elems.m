function idxs = find_elems(sym_list, elems)
% Description: Find elements on a symbolic list
% If elem belongs to sym_list, it returns the 
% respective index. If not, returns 0
% Input:
%   - sym_list : Symbolic list of elements
%   - elems    : Elements to find
% Output: 
    idxs = [];
    for i = 1:length(sym_list)
        svar = sym_list(i);
        
        idx = find(elems == svar);
        if(isempty(idx))
            idxs = [idxs; 0];
        else
            idxs = [idxs; idx];
        end
    end
end