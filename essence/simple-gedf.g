g := List(CyclicGroup(IsPermGroup, 9));
g_noid := Set(Filtered(g, x -> Order(x)>1));
sols := [];
for s1 in Combinations(g, 2) do
    for s2 in Combinations(g, 4) do
        if Intersection(s1,s2) = [] and Set(Flat(List(s1, x -> List(s2, y -> x^-1*y)))) = g_noid then
            
            Add(sols, [s1,s2]);
        fi;
    od;
od;