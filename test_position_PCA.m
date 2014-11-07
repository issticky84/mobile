function test_position_PCA()
    histo_mat = read_csv('BigData_20140330_0006/histo_BigData_20140330_0006_c25.csv');
    [eigenVector,score,eigenvalue,tsquare] = princomp(histo_mat); 
    cumsum(eigenvalue)./sum(eigenvalue)
    k = 1;
    transMatrix(:,1:k) = eigenVector(:,1:k);
    OutMatrix = histo_mat * transMatrix;    
    csvwrite('PCA_position.csv',OutMatrix);
end