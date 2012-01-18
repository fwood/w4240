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
% Sample the topic assignment for each word in the corpus, one at a time.
%
% @param topic_assignment   : 1 x n vector of topic assignments
% @param topic_counts       : n_topics x alphabet_size vector of counts per 
%                           topic of unique words
% @param doc_counts         : n_docs x n_topics vector of counts per document
%                           of unique topics
%@param topic_N             : n_topics x 1 count of total words assigned to 
%                           each topic
% @param doc_N              : n_docs x 1 count of total words in each
%                           document, minus 1
% @param alpha              : prior dirichlet parameter on document specific
%                           distributions over topics
% @param gamma              : prior dirichlet parameter on topic specific
%                           distribuitons over words.
% @param words              : 1 x n list of words (integers)
% @param document_assignment: 1 x n list of assignments of words to
%                           documents
%
% @return topic_assignment  : updated topic_assignment vector
% @return topic_counts      : updated topic counts matrix
% @return doc_counts        : updated doc_counts matrix
% @return topic_N           : updated count of words assigned to each topic
