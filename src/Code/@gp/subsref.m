function b = subsref(a,index)
%SUBSREF Define field name indexing for GP objects

% Copyright October, 2006, Brown University, Providence, RI.
% All Rights Reserved

% Permission to use, copy, modify, and distribute this software and its
% documentation for any purpose other than its incorporation into a commercial
% product is hereby granted without fee, provided that the above copyright
% notice appear in all copies and that both that copyright notice and this
% permission notice appear in supporting documentation, and that the name of
% Brown University not be used in advertising or publicity pertaining to
% distribution of the software without specific, written prior permission.

% BROWN UNIVERSITY DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
% INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR ANY
% PARTICULAR PURPOSE. IN NO EVENT SHALL BROWN UNIVERSITY BE LIABLE FOR ANY
% SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER
% RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF
% CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
% CONNECTION WITH THE USE.

% Author: Frank Wood fwood@cs.brown.edu
% if length(index) == 2
%     switch index(1).type
%         case '.'
%             switch index(2).type
%                 case '()'
%                     eval(['b = a.' index(1).subs '(' index(2).subs{1} ')']);
%                 otherwise
%                     error('Cannot index this object in that way, .<var>() only')
%             end
%         otherwise
%             error('Cannot index this object in that way, .<var>() only')
%     end
% else 
switch index.type
    % case '()'
    %     b = a.ps(index.subs{:});
    case '.'
        if(strcmp(index.subs,'kernel'))
            b = a.kernel;
        elseif(strcmp(index.subs,'kernel_hyps'))
            b = a.kernel_params;
        elseif(strcmp(index.subs,'kernel_params'))
            b = a.kernel_params;
        elseif(strcmp(index.subs,'input'))
            b = a.input(:,1:a.current_size);
        elseif(strcmp(index.subs,'output'))
            b = a.output(1:a.current_size);
        elseif(strcmp(index.subs,'Cinv'))
            b = a.Cinv;
        elseif(strcmp(index.subs,'C'))
            b = a.C;
        elseif(strcmp(index.subs,'current_size'))
            b = a.current_size;
        end
    otherwise
        error('Cell and array indexing not supported by Gaussian process objects')
end
% end