function MDS_1D = histo_position_LAB(lab_mat,histo_mat,k) %change "cluster center" weighting to "LAB distance" weighting
    lab_distance = zeros(k,k);
    for i=1:k
        for j=1:k
            if(i~=j)
               ci = lab_mat(i,:);
               cj = lab_mat(j,:);
               lab_distance(i,j) = norm(ci-cj); %Eular Distance
            end
        end
    end
    %disp(lab_distance);
    total_distance = sum(sum(lab_distance));
    w(k) = 0;
    for i=1:k
        w(i) = sum(lab_distance(:,i));
    end
    for i=1:k
        w(i) = w(i) / total_distance;
    end
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
    size(Y)
    MDS_1D = Y(:,1);
    csvwrite('histo_1D.csv',MDS_1D);
end