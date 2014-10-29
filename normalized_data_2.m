function RGB_mat = normalized_data_2(RGB_mat)
    min_RGB_mat = min(RGB_mat);
    max_RGB_mat = max(RGB_mat);
    max_value = max(max_RGB_mat(1,:));
    min_value = min(min_RGB_mat(1,:));
    for s=1:3
        RGB_mat(:,s) = RGB_mat(:,s) - min_value;
        RGB_mat(:,s) = RGB_mat(:,s) / (max_value - min_value);
     end     
end