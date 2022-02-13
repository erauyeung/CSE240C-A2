function result = createCellArray(orig)
% new_base1 =
% 1×3 cell array
%
%   {51×1 cell}    {51×1 double}    {51×1 double}
result = {orig{1}{1}, orig{2}(1), orig{3}(1)};
for i = 2:51
    result = cat(1, result, {orig{1}{i}, orig{2}(i), orig{3}(i)});
end
end