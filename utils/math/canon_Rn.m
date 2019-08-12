function  ei = canon_Rn(n, i)
    if(i > n)
        error('Index MUST be lesser than n!');
    end
    ei = zeros(n, 1);
    ei(i) = 1;
end