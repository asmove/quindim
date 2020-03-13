lines = ["-", "--", ":", "-."];
colors = ["r", "g", "b", "c", "m", "k"];

C = {lines, colors};
D = C;
[D{:}] = ndgrid(C{:});
Z = cell2mat(cellfun(@(m) m(:), D, 'uni', 0))