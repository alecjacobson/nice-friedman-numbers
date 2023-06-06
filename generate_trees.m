function trees = generate_trees(N)
    if (N == 1)
        % There is only one tree with 1 leaf: the leaf itself.
        trees = {'X'}; % Using 'X' as a placeholder leaf.
    else
        % A cell array to contain all trees we generate
        trees = {};
        for i = 1:N-1
            % All trees are built from smaller trees.
            % We take all possible pairs of smaller trees such that
            % the total number of leaves is N.
            left_subtrees = generate_trees(i);
            right_subtrees = generate_trees(N-i);
            for j = 1:length(left_subtrees)
                for k = 1:length(right_subtrees)
                    % Build a new tree with 'op' and left and right subtrees
                    new_tree = strcat('op(', left_subtrees{j}, ', ', right_subtrees{k}, ')');
                    % Add the new tree to our cell array of trees
                    trees{end+1} = new_tree;
                end
            end
        end
    end
end
