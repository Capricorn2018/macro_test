function frate = forward(spot,mat)

    frate = zeros(length(spot),1);
    frate(1) = spot(1);
    
    for i=2:length(spot)
        
        frate(i) = (mat(i)*spot(i)-mat(i-1)*spot(i-1))/(mat(i)-mat(i-1)); %(((1 + spot(i) * mat(i) / 100) / (1+spot(i-1)*mat(i-1) / 100)) - 1 )/ (mat(i)-mat(i-1)) * 100; 
        
    end

end

