% main_alarm_network
%
% This file is created to execute inference in the small alarm graphical
% model, presented in the homework part 1.  The file is currently
% configured to first set up the factor graph for the network and then
% execute message the message passing algorithm in order to find the
% marginal distribution at each node.  In this initial set up, it is
% assumed that none of the variables are observed.  To execute the
% algorithm with some observations observed you will need to set the value
% of the appropriate nodes before inference is performed.  Finally, the
% file is set up to display the marginal distribution in the variable node
% vn_j.

% make sure we are working with a clear workspace
clear
clear global

% define all the nodes as global
global vn_b vn_e vn_a vn_j vn_m fn_b fn_bea fn_e fn_aj fn_am;

% instantiate all the nodes in the factor graph, vn_ are variable nodes and
% fn_ are factor nodes.
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

% set the neighboring nodes and messages fields for all the nodes in the
% graph.
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

% do inference by first passing messages in from the edges to vn_b and then
% passing messages out from vn_b to the edges.
get_all_messages(vn_b);
pass_all_messages(vn_b);

% display the marginal distribution represented in variable node j
get_marginal_distribution(vn_j)