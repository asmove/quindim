function u_ = sat_sign(x, phi)
    if((x>-phi)&&(x<phi))
        u_ = x/phi;
    elseif(x<-phi)
        u_ = -1;
    else
        u_ = 1;
    end
end