function is  = is_postive_semi_definite(A)

[m n] = size(A);
is = m == n;
if is
    d = eig(A);
    if isreal(d)
        i  = sum(d < 0.001);
        if i > 0
            is = 0;
        end
    else
        is = 0;
    end
end