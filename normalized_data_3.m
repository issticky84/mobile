function RGB_mat = normalized_data_3(RGB_mat)
    mean_RGB_mat = mean(RGB_mat);
    std_RGB_mat = std(RGB_mat);
    for s=1:3
        RGB_mat(:,s) = RGB_mat(:,s) - mean_RGB_mat(1,s);
        RGB_mat(:,s) = RGB_mat(:,s) / std_RGB_mat(1,s);
    end  
%     min_RGB_mat = min(RGB_mat);
%     max_RGB_mat = max(RGB_mat);    
%     for s=1:3
%         RGB_mat(:,s) = RGB_mat(:,s) - min_RGB_mat(1,s);
%         RGB_mat(:,s) = RGB_mat(:,s) / (max_RGB_mat(1,s) - min_RGB_mat(1,s));        
%     end
end