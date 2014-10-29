function MDS_1D = histo_position(cluster_center,histo_mat,k)
    cluster_center_distance = zeros(k,k);
    for i=1:k
        for j=1:k
            if(i~=j)
               ci = cluster_center(i,:);
               cj = cluster_center(j,:);
               cluster_center_distance(i,j) = norm(ci-cj); %Eular Distance
            end
        end
    end
    %disp(cluster_center_distance);
    total_distance = sum(sum(cluster_center_distance));
    w(k) = 0;
    for i=1:k
        w(i) = sum(cluster_center_distance(:,i));
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
    MDS_1D = Y(:,1);
    csvwrite('histo_1D.csv',MDS_1D);
end