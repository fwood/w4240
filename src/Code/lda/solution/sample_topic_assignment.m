function [topic_assignment topic_counts doc_counts topic_N] =  ...
     sample_topic_assignment(topic_assignment ...
                            ,topic_counts ...
                            ,doc_counts ...
                            ,topic_N ...
                            ,doc_N ...
                            ,alpha ...
                            ,gamma ...
                            ,words ...
                            ,document_assignment)

                        
                        
    alpha_sum = alpha * size(topic_N,1);
    gamma_sum = gamma * length(topic_counts);
    n_topics = size(doc_counts,2);
    
    for i = 1 : length(topic_assignment)
        %get word, document, topic
        doc = document_assignment(i);
        word = words(i);
        topic = topic_assignment(i);
        
        %decrement counts
        topic_counts(topic,word) = topic_counts(topic,word) - 1;
        topic_N(topic) = topic_N(topic) - 1;
        
        doc_counts(doc,topic) = doc_counts(doc,topic) - 1;
        
        %sample assignment
        p = (doc_counts(doc,:) + alpha) / (doc_N(doc) + alpha_sum);
        p = p .* (topic_counts(:,word) + gamma)' ./ (topic_N + gamma_sum)';
        
        topic = randsample(n_topics,1,true,p);    
        
        %increment counts
        topic_counts(topic,word) = topic_counts(topic,word) + 1;
        topic_N(topic) = topic_N(topic) + 1;
        
        doc_counts(doc,topic) = doc_counts(doc,topic) + 1;
        
        %assign topic
        topic_assignment(i) = topic;
    end