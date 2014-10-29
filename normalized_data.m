function RGB_mat = normalized_data(RGB_mat)
    min_RGB_mat = min(RGB_mat);
    max_RGB_mat = max(RGB_mat);
    for s=1:3
        RGB_mat(:,s) = RGB_mat(:,s) - min_RGB_mat(1,s);
        RGB_mat(:,s) = RGB_mat(:,s) / (max_RGB_mat(1,s) - min_RGB_mat(1,s));
    end  
end