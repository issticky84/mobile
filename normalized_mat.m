function [Nmat] = normalized_mat(Imat)
    %Normalize
    %check devided by 0
    %Imat = n x 1
    mat_size = size(Imat,1);
    Nmat = Imat;
    max_value = max(Imat);
    min_value = min(Imat);
    range = max_value - min_value;
    for i=1:mat_size
        if Imat(i,1) == 0
            Nmat(i,1) = 0;
        else
            Nmat(i,1) = (Imat(i,1)-min_value)/range;
        end
    end
end