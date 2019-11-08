function paths_code = genpath_code(filepath)
    paths = strsplit(genpath(filepath), ':');

    paths_code = {};
    for i = 1:length(paths)
        phrase = paths{i};

        if(~contains(phrase, 'images') && ~contains(phrase, 'imgs') && ...
            contains(phrase, 'code') && ~strcmp(phrase, '.'))
            paths_code{end+1} = phrase;
        end
    end

end