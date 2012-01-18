load bagofwords_nips

%number of words
alphabet_size = max(WS);

%subset the data
document_assignment  = DS; %(DS <= 25);
words = WS; %(DS <= 25);
clear DS WS

%number of documents
n_docs = max(document_assignment)

%number of topics
n_topics = 20
%n_topics = 10;

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
topic_N = sum(topic_counts,2);

alpha = 1;
gamma = 1;

mx_jll = -Inf;

mx_doc_counts = doc_counts;
mx_topic_counts = topic_counts;

n_iters = 10000;
ll = zeros(1,n_iters);

for i = 1 : n_iters

% plot(jll);
% drawnow;

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
                        
jll = joint_log_lik(doc_counts,topic_counts,alpha,gamma);
ll(i) = jll;

disp(['i = ' num2str(i)]);
disp(['joint log like = ' num2str(jll)]);

if jll > mx_jll
    mx_doc_counts = doc_counts;
    mx_topic_counts = topic_counts;
    mx_jll = jll;

    save('mx_sample','mx_doc_counts','mx_topic_counts')
end
                        
end



% jll = [jll joint_log_lik(doc_counts,topic_counts,alpha,gamma)];
% plot(jll);
% drawnow;
