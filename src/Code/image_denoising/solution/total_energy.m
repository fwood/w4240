function[total_energy] = total_energy(clean_img, noisy_img, h, beta, eta)

total_energy = 0.0;

for row = 1 : size(clean_img,1)
    for col = 1 : size(clean_img,2)
        total_energy = total_energy + h * clean_img(row,col) - eta * clean_img(row,col) * noisy_img(row, col);
        
        if row > 1
            total_energy = total_energy - beta * clean_img(row,col) * clean_img(row-1,col);
        end
        
        if col > 1
            total_energy = total_energy - beta * clean_img(row,col) * clean_img(row, col-1);
        end
    end
end