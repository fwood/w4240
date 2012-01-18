function ln_b = lnB(W,v)

D = size(W,1);

ln_b = (-v / 2) * log(det(W)) - v  * D / 2 * log(2) - D * (D-1) / 4 * log(pi);
for d = 1 : D
    ln_b = ln_b - gammaln((v + 1 - d) / 2);
end