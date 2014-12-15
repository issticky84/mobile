function MDS_1D = histo_position_RGB(rgb_mat,histo_mat,k) %change "cluster center" weighting to "LAB distance" weighting
    rgb_distance = zeros(k,k);
    for i=1:k
        for j=1:k
            if(i~=j)
               ci = rgb_mat(i,:);
               cj = rgb_mat(j,:);
               rgb_distance(i,j) = norm(ci-cj); %Eular Distance
            end
        end
    end
    %disp(lab_distance);
    total_distance = sum(sum(rgb_distance));
    w(k) = 0;
    for i=1:k
        w(i) = sum(rgb_distance(:,i));
    end

    for i=1:k
        w(i) = w(i) / total_distance;
    end
    %disp(w);
    w(i) = w(i) * 5;
    %disp(w);
    
    time_step = size(histo_mat,1);
    histo_coefficient = zeros(time_step,time_step);
    for i=1:time_step
       for j=1:time_step
           for t=1:k
                histo_coefficient(i,j) = histo_coefficient(i,j) + w(t)*abs(histo_mat(i,t) - histo_mat(j,t));
           end
       end
    end
    %csvwrite('histo_coeff.csv',histo_coefficient);
    [Y,eigvals] = cmdscale(histo_coefficient);
    MDS_1D = Y(:,1);
    csvwrite('histo_1D.csv',MDS_1D);
end