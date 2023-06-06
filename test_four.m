%operations = [@plus, @minus, @times, @rdivide, @power, @ldivide, @mod];

%operations = {'+','-','.*','./','.^','%'};
%grammars = {  ...
%  '(A o1 B) o2 (C o3 D)', ...
%  'A o1 (B o2 (C o3 D))', ...
%  '((A o1 B) o2 C) o3 D', ...
%  'A o1 ((B o2 C) o3 D)', ...
%  '(A o1 (B o2 C)) o3 D'};

%  times(times(power(power(A,power(B,C)),D),E),F)
%    3 1 4 9 2 8 

% 4-(7-(8-(2-(9^7-1))))
  %minus(A,minus(minus(B,minus(power(C,D),E)),power(F,G)))
  %  4 8 4 8 4 9 7
  %4 - ((8 - (4^8 - 4)) - 9^7)

operations = {'plus','minus','times','rdivide','power','mod','logXY'};
k = 7;
grammars = generate_trees(k);
for gi = 1:numel(grammars)
  grammar = grammars{gi};
  for oi = 1:k
    % replace first instance of 'o' with 'o1'
    grammar = replace_first(grammar,'op',['o' num2str(oi)]);
    grammar = replace_first(grammar,'X',char('A'+(oi-1)));
  end
  grammars{gi} = grammar;
end

%grammars = {  ...
%  'o3(o1(A,B),o2(C,D))', ...
%  'o3(A,o2(B,o1(C,D)))', ...
%  'o3(o2(o1(A,B),C),D)', ...
%  'o3(A,o2(o1(B,C),D))', ...
%  'o3(o2(A,o1(B,C)),D)', ...
%  };

I = (0:9)';
ngrid_inputs = arrayfun(@(i) I((1*(i==1) + 1):(end-1)*(i<=k)+1),1:7,'UniformOutput',false);
[A,B,C,D,E,F,G] = ndgrid(ngrid_inputs{:});
[A,B,C,D,E,F,G] = deal(A(:),B(:),C(:),D(:),E(:),F(:),G(:));
J = [A(:) B(:) C(:) D(:) E(:) F(:) G(:)];
J = J(:,1:k);
X = sum(J.*(10.^(k-1:-1:0)),2);


% all k choices from n elements with replacement
n = numel(operations);
O = nmultichoosek(1:numel(operations),k-1);
O = unique(sortrows(reshape(O(:,reshape(perms(1:size(O,2))',1,[])),[],size(O,2))),'rows');

for gi = 1:numel(grammars)
  base_grammar = grammars{gi};
  fprintf('%d/%d: %s\n',gi,numel(grammars),base_grammar);
  for oi = 1:size(O,1)
    grammar = base_grammar;
    for oj = 1:size(O,2)
      grammar = strrep(grammar,['o' num2str(oj)],operations{O(oi,oj)});
    end
    g = str2func(['@(A,B,C,D,E,F,G) ' grammar]);
    Z = g(A,B,C,D,E,F,G);
    f = find(Z==X);
    if ~isempty(f)
      fprintf('  %s\n',grammar);
      fprintf(['    ' repmat('%d ',1,size(J,2)) '\n'],J(f,:)');
      fprintf('\n');
    end
  end
end


S = num2str(J,'%d');

