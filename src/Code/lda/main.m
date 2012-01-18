load bagofwords_nips

%number of words
alphabet_size = max(WS);

%subset the data
document_assignment  = DS; %(DS <= 100);
words = WS; %(DS <= 100);
clear DS WS

%number of documents
n_docs = max(document_assignment);

%number of topics
n_topics = 50;

%topic assigments
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
topic_N = sum(topic_counts,2) - 1;

alpha = 1;
gamma = 1;

jll = [];
for i = 1 : 1000
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

                        %sum(topic_counts,2)









%%
%create document word freq counts
documents = cell(M,1);
for m = 1 : M
    doc_words = WS(DS == m);
    doc = zeros(length(doc_words),A);
    for i = 1 : length(doc_words);
        doc(i,doc_words(i)) = 1;
    end
    documents{m} = sparse(doc);
end

%%
K = 25;
alpha = 25;
beta = 1;

%document distributions over topics
theta = cell(M,1);
for m = 1 : M
    theta{m} = gamrnd(alpha, 1,K,1);
    theta{m} = theta{m} / sum(theta{m});
end
clear m

%topic distributions over words
gamma = zeros(A, K);
for k = 1 : K
    gamma(:,k) = gamrnd(beta,1,A,1);
    gamma(:,k) = gamma(:,k) / sum(gamma(:,k));
end
clear k

%assignments
iters = 1000;
ll = [];
for i = 1 : iters
    Z = sample_assignments(documents,theta, gamma,A,M,K);
    gamma = sample_gamma(documents, Z, beta, A,M,K);
    theta = sample_theta(Z,alpha,A,M,K);
    
    ll = [ll joint_log_lik(documents,Z,theta,gamma,alpha, beta, A,M,K)];
    plot(ll)
    drawnow
end






%Z = sample_assignments(theta,gamma,WS,DS);
%Z = ceil(rand(size(WS)) * K);


%load words_nips