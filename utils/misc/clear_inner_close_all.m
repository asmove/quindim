function [] = clear_inner_close_all()
    close all
    delete(findall(0,'type','figure','tag','TMWWaitbar'));
    for filepath = strsplit(ls, ':')
        clear filepath;
    end 
end