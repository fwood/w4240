%This script outlines how you might create a MCMC sampler for the LDA model

load bagofwords_nips

%number of words
alphabet_size = max(WS);

document_assignment  = DS;
words = WS;

%subset data, edit this part out once you are confident the model is
%working properly in order to use the entire data set
document_assignment  = document_assignment(DS <= 100);
words = words(DS <= 100);

clear DS WS

%number of documents
n_docs = max(document_assignment);

%number of topics
n_topics = 20;

%initial topic assigments
topic_assignment = ceil(rand(size(words))*n_topics);

%within document count of topics
doc_counts = zeros(n_docs,n_topics);
for d = 1 : n_docs
    for k = 1 : n_topics
        doc_counts(d,k) = sum(topic_assignment(document_assignment == d) == k);
    end
end
doc_N = sum(doc_counts,2) - 1;

%within topic count of words
topic_counts = zeros(n_topics,alphabet_size);
for k = 1 : n_topics
    w_k = words(topic_assignment == k);
    for i = 1 : size(w_k,2)
        topic_counts(k,w_k(i)) = topic_counts(k,w_k(i)) + 1;
    end
end
topic_N = sum(topic_counts,2);

%prior parameters, alpha parameterizes the dirichlet to regularize the
%document specific distributions over topics and gamma parameterizes the 
%dirichlet to regularize the topic specific distributions over words.
%These parameters are both scalars and really we use alpha * ones() to
%parameterize each dirichlet distribution.
alpha = ?;
gamma = ?;
iters = ?;


jll = [];
for i = 1 : iters
jll = [jll joint_log_lik(doc_counts,topic_counts,alpha,gamma)];
plot(jll);
drawnow;

prm = randperm(length(words));
words = words(prm);     
document_assignment = document_assignment(prm);
topic_assignment = topic_assignment(prm);

[topic_assignment topic_counts doc_counts topic_N] =  ...
sample_topic_assignment(topic_assignment ...
                            ,topic_counts ...
                            ,doc_counts ...
                            ,topic_N ...
                            ,doc_N ...
                            ,alpha ...
                            ,gamma ...
                            ,words ...
                            ,document_assignment);
end
                        
jll = [jll joint_log_lik(doc_counts,topic_counts,alpha,gamma)];
plot(jll);
drawnow;
