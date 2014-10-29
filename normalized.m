function [Nmat] = normalized(Imat)
    %Normalize
    %check devided by 0
    mat_size = length(Imat);
    if max(abs(Imat(:)))==0
        %Nmat(:) = 0;
        Nmat = zeros(1,mat_size);
    else
        Nmat = Imat/max(abs(Imat(:)));
    end
end