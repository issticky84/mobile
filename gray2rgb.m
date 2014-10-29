function result = gray2rgb(gray)
    result = [0 0 0];
    if gray > 1.0 
        result = [1 0 0];
    end
    if gray < 0.0
        result = [0 0 1];
    end
    
    if gray < 0.333333
       result(3) = 1.0 - gray * 3.0;
       result(2) = gray * 3.0;
    elseif gray < 0.666666
        result(1) = (gray - 0.33333) * 3.0;
        result(2) = 1.0;
    else
        result(1) = 1.0;
        result(2) = 1.0 - (gray - 0.66666) * 3.0;
    end

end