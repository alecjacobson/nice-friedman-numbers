function new_str = replace_first(old_str, old_sub, new_sub)
    % Find the start of the first occurrence of the old substring.
    idx = strfind(old_str, old_sub);
    if isempty(idx)
        % If the old substring is not found, return the old string unchanged.
        new_str = old_str;
    else
        % Replace the first occurrence of the old substring with the new one.
        new_str = [old_str(1:idx(1)-1) new_sub old_str(idx(1)+length(old_sub):end)];
    end
end
