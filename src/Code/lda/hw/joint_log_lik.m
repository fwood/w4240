function ll = joint_log_lik(doc_counts,topic_counts, alpha, gamma)
%Gets the joint log likelihood of the model
%
%@param doc_counts       : n_docs x n_topics vector of counts per document
%of unique topics
%@param topic_counts     : n_topics x as vector of counts per topic of unique
%words
%@param alpha            : prior dirichlet parameter on document specific
%distributions over topics
%@param gamma            : prior dirichlet parameter on topic specific
%distribuitons over words.
%
%@return ll              : joint log likelihood of model
