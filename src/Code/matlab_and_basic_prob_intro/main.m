%% very, very short introduction to matlab

X = 1; % rv in {1...M}
Y = 1; % rv in (1...L}

M = 5;
L = 3;

n = ceil(rand(M,L)*10); % random counts
imagesc(n); % look at counts
colorbar; 

N = sum(n(:)); % sum all elements of n
sum(sum(n));

N_slow = 0;
for i =1:M
    for j = 1:L
        N_slow = N_slow + n(i,j);
    end
end

i = 1;
j = 3;

n(i,j) % index an element of an array

PXY = n/N; % normalize to produce distribution

imagesc(PXY); % look at joint distribution
colorbar;

c = sum(n,2); % "marginalize" (nearly), Y out (columns)

PX = c/N; % PX = \sum_Y PXY = c/N

bar(PX); % plot discrete distribution
sum(PX) % is X actualy marginal distribution

%% this is the sum rule of probability PX = \sum_Y PXY

% ??? how to get P(Y)?
sum(PXY)

%% conditional probability

i=2;
PYgivenXequalsi = n(i,:)/sum(n(i,:))
bar(PYgivenXequalsi)

%% product rule

PYgivenX = n./repmat(sum(n,2),1,L);
PX = sum(n,2)/sum(n(:));
PXYproductrule = PYgivenX.*repmat(PX,1,L);
n % original counts
PXYproductrule*N % "reconstituting" counts

%% Bayes theorem P(X|Y) = P(Y|X)*P(X) / P(Y)
% sometimes model is given in terms of likelihood P(Y|X) and prior P(X)
% and the joint must be calculated
joint = PYgivenX.*repmat(PX,1,L);
PY = sum(joint,1);
posterior = joint ./ repmat(PY,M,1); 

% check normalization
sum(posterior)

%% apple and orange example

% model specification
r = 1;
b = 2;
PB = [.4 .6];

a = 1;
o = 2;

PFgivenB = zeros(2,2); % fruit rows, baskect (red, blue) columns
PFgivenB(a,r) = 1/4;
PFgivenB(o,r) = 3/4;
PFgivenB(a,b) = 3/4;
PFgivenB(o,b) = 1/4;

% what's the marginal distribution of picking a fruit, regardless of the
% basket from which it came
PFapple = PB(r)*PFgivenB(a,r) + PB(b)*PFgivenB(a,b)
PForange = 1-PFapple
PF = PFgivenB*(PB')

% what's the posterior probability of the fruit having been drawn from the
% red basket given that the observed fruit was an orange
PBredGivenForange = PFgivenB(o,r)*PB(r) / (PFgivenB(o,r)*PB(r) + PFgivenB(o,b)*PB(b) )

% calculate the joint distribution 
PBandF = PFgivenB.*repmat(PB,2,1)
% marginalize to get marginal over fruits
PF = sum(PBandF,2)
PB = sum(PBandF)

PBgivenF = (PBandF./repmat(PF,1,2))' %transpose for indexing purposes

PBgivenF(r,o) % posterior probability of the red basket (same at 10 lines above)