function frate = foward(spot,mat)

    frate = zeros(length(spot),1);
    frate(1) = spot(1);
    
    for i=2:length(spot)
        
        frate(i) = (1 + spot(i) * mat(i)) / (1+spot(i-1)*mat(i-1)) / (mat(i)-mat(i-1)); 
        
    end

end

