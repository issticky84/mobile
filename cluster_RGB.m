function cluster_value = cluster_RGB(k)
    cluster_value(1:k) = 0;
    step = 1.0/k;
    for i=1:k
        cluster_value(i) = step * i;
    end
end