function text = str2latex(text, latex_from, latex_to)
    for i = 1:length(latex_from)
        latex_from_i = latex_from{i};

        for j = 1:length(latex_from_i)
            latex_from_ij = latex_from_i{j};
            latex_from_ij = char(latex_from_ij);
            
            idxs = findstr(text, latex_from_ij);

            if(~isempty(idxs))
                latex_snippet = latex_to(i);

                text = strrep(text, latex_from_ij, latex_snippet);                        
                if(iscell(text))
                    text = text{1};
                end
            end
        end
    end
end