function LAP_1D = histo_position_LAPBIN_kNNMAsk(cluster_center,histo_mat,k,Knn)
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
    
    %Knn = 8;
    N = size(histo_coefficient,1);
    W = Mask_adjac_time(N, Knn);
    for i=1:time_step
       for j=1:time_step
           if W(i,j)==0
                histo_coefficient(i,j) = histo_coefficient(i,j)*10;
           end
       end
    end    
    %csvwrite('histo_coeff.csv',histo_coefficient);
    %[Y,eigvals] = cmdscale(histo_coefficient);
    %MDS_1D = Y(:,1);
    %[E,V] = lapbin(histo_coefficient,1);
    [E,V] = lapbin(histo_coefficient,1,Knn);
    %[E,V] = lapheat(histo_coefficient,1);
    LAP_1D = E(:,1);
    csvwrite('histo_1D.csv',LAP_1D);
end