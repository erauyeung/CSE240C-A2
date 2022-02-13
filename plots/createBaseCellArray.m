% concatenate the 3 base, multi, and ship config data together to form
% a giant cell array of:
% trace MPKIbase MPKImulti MPKIship
% (throw away IPC for now...)
function result = createBaseCellArray(tracenames, base, multi, ship)
result = {tracenames{1}, base(1), multi(1), ship(1)};
for i = 2:51
    result = cat(1, result, {tracenames{i}, base(i), multi(i), ship(i)});
end
end