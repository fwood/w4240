clear
clear global

global vn_b vn_e vn_a vn_j vn_m fn_b fn_bea fn_e fn_aj fn_am;

vn_b = node('vn_b');
fn_b = node('fn_b');
fn_bea = node('fn_bea');
vn_e = node('vn_e');
fn_e = node('fn_e');
vn_a = node('vn_a');
fn_aj = node('fn_aj');
vn_j = node('vn_j');
fn_am = node('fn_am');
vn_m = node('vn_m');

vn_b.setcm({fn_b, fn_bea},{ones(2,1), ones(2,1)});
fn_b.setcm({vn_b},{ones(2,1)});
vn_e.setcm({fn_e,fn_bea},{ones(2,1),ones(2,1)});
fn_e.setcm({vn_e},{ones(2,1)});
vn_a.setcm({fn_aj,fn_am,fn_bea},{ones(2,1), ones(2,1),ones(2,1)});
fn_aj.setcm({vn_j,vn_a},{ones(2,1),ones(2,1)});
vn_j.setcm({fn_aj},{ones(2,1)});
fn_am.setcm({vn_m,vn_a},{ones(2,1),ones(2,1)});
fn_bea.setcm({vn_a,vn_e,vn_b},{ones(2,1), ones(2,1),ones(2,1)});
vn_m.setcm({fn_am},{ones(2,1)});

%do inference
get_all_messages(vn_b);
pass_all_messages(vn_b);

%display some marginal distributions
get_marginal_distribution(vn_j)