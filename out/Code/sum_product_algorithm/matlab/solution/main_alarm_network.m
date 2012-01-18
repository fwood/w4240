clear

%initialize model
m = [.001 ; .999];
f_b = factor(m);

m = [.002; .998];
f_e = factor(m);

m = zeros(2,2,2);
m(:,1,1) = [.95 .05];
m(:,1,2) = [.94 .06];
m(:,2,1) = [.29 .71];
m(:,2,2) = [.001 .999];
f_abe = factor(m);

m = zeros(2,2);
m(:,1) = [.9 .1];
m(:,2) = [.05 .95];
f_ja = factor(m);

m = zeros(2,2);
m(:,1) = [.7 .3];
m(:,2) = [.01 .99];
f_ma = factor(m);

fn_b = factor_node('fn:b',f_b);
fn_e = factor_node('fn:e',f_e);
fn_abe = factor_node('fn:abe',f_abe);
fn_ja = factor_node('fn:ja',f_ja);
fn_ma = factor_node('fn:ma',f_ma);

vn_b = variable_node('vn:b',2);
vn_e = variable_node('vn:e',2);
vn_a = variable_node('vn:a',2);
vn_j = variable_node('vn:j',2);
vn_m = variable_node('vn:m',2);

fn_b.addNode(vn_b);
fn_e.addNode(vn_e);
fn_abe.addNode(vn_a);
fn_abe.addNode(vn_b);
fn_abe.addNode(vn_e);
fn_ja.addNode(vn_j);
fn_ja.addNode(vn_a);
fn_ma.addNode(vn_m);
fn_ma.addNode(vn_a);

vn_b.addNode(fn_b);
vn_b.addNode(fn_abe);
vn_e.addNode(fn_e);
vn_e.addNode(fn_abe);
vn_a.addNode(fn_abe);
vn_a.addNode(fn_ja);
vn_a.addNode(fn_ma);
vn_j.addNode(fn_ja);
vn_m.addNode(fn_ma);

%find marginal probability of alarm
vn_b.passMessagesIn
disp(' ');
vn_b.passMessagesOut
%%

vn_a.getMarginalDistribution

vn_b.setValue(1);
vn_m.setValue(1);

for i = 1 : 2
    vn_b.loopy_bp;
    vn_b.setNotUpdated;
end

vn_a.getMarginalDistribution

vn_b.passMessagesIn
disp(' ');
vn_b.passMessagesOut
vn_a.getMarginalDistribution