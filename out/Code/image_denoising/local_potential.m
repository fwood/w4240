function [choice loc_pot_minus_1, loc_pot_plus_1] = local_potential(clean_img, noisy_img, row, column, h, beta, eta)

loc_energy_minus_1 = h * (-1) - eta * (-1) * noisy_img(row,column);
loc_energy_plus_1 = h - eta * noisy_img(row, column);

markov_blanket = zeros(3,3);

i = 1;
j = 1;

row_start = row-1;
row_end = row + 1;
col_start = column -1;
col_end = column + 1;

if row_start < 1
    row_start = row;
    i = 2;
elseif row_end > size(clean_img,1)
    row_end = row;
end

if col_start < 1
    col_start = column;
    j = 2;
elseif col_end > size(clean_img,2)
    col_end = column; 
end

j_start = j;
for r = row_start : row_end
    j = j_start;
    for c = col_start : col_end
        markov_blanket(i,j) = clean_img(r,c);
        j = j + 1;
    end
    i = i + 1;
end


s = markov_blanket(1,2) + markov_blanket(2,1) + markov_blanket(2,3) + markov_blanket(3,2);
loc_energy_minus_1 = loc_energy_minus_1 + beta * s;
loc_energy_plus_1 = loc_energy_plus_1 - beta * s;

%zeta part
s = markov_blanket(1,1) + markov_blanket(1,3) + markov_blanket(3,1) + markov_blanket(3,3);
zeta = 0;
loc_energy_minus_1 = loc_energy_minus_1 + zeta * s;
loc_energy_plus_1 = loc_energy_plus_1 - zeta * s;


loc_pot_minus_1 = exp(-loc_energy_minus_1);
loc_pot_plus_1 = exp(-loc_energy_plus_1);

if loc_pot_minus_1 > loc_pot_plus_1
    choice = -1;
else 
    choice = 1;
end
    