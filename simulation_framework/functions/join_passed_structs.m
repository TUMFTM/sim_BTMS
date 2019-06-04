function passed_joined = join_passed_structs(passed_1, passed_2)

passed_joined = passed_1;

length_joined = length(passed_joined);

f = fieldnames(passed_2);
    
for jj = 1:length(f)
    passed_joined.(f{jj}) = passed_2.(f{jj});
end