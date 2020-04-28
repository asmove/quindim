function [] = clear_inner_close_all(base_leaf)
    close all
    
    if(nargin == 0)
        base_leaf = '~';
    end
    
    leaf_paths = genpath(base_leaf);
    
    clean_path = ['Cleaning paths on ', base_leaf];
    wb = my_waitbar(clean_path);
    
    leaf_paths = strsplit(leaf_paths, ':');
    for i = 1:length(leaf_paths)
        leaf_path = leaf_paths{i};

        if(~isempty(leaf_path))
            ls_paths = strsplit(ls(leaf_path), ':');
            for filepaths = ls_paths
                for filepath = filepaths
                    filepath = filepath{1};
                    clear(filepath)
                end
            end   
        end
        wb.update_waitbar(i, length(leaf_paths));
    end
    delete(wb.wb);
end