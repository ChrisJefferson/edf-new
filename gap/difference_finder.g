

f := function(n, root, pow, step)
    local g,q, base, pairs, i, j, collected, edf, diffs;

    # Build field
    g := GF(n);

    # Get a primitive root
    #q := PrimitiveRoot(g);
    q := Z(n)*root;

    # Sanity check order of root
    if Order(q) <> n-1 then
        return [false,1];
    fi;

    base := List(Group(q^pow));

    if not IsInt(pow/step) or Size(base)*(pow/step) > n then
        return [false,2];
    fi;

    edf := List([0,step..pow-step], x -> List(base, y -> q^x*y ) );

    if Length(Set(Concatenation(edf))) <> Length(Concatenation(edf)) then
        return [false, 3];
    fi;

    diffs := [];

    # Start by checking we have an EDF
    for pairs in Combinations(edf, 2) do
            for i in pairs[1] do
                for j in pairs[2] do
                    Add(diffs, i-j);
                    Add(diffs, j-i);
                od;
            od;
    od;

    collected := Collected(diffs);
    if Length(collected) = n-1 and Size(Set(collected, x -> x[2])) = 1 then
        Assert(0, not(0*Z(n) in diffs));
        return [n,root,pow,step,Size(edf[1]), Size(Union(edf)), edf,collected];
    else
        return [false,4,n,root,pow,step,edf,collected];
    fi;


    # Now build the internal differences
    #internald := [];

    # For each set s in the edf (s1 and s2 in this case)
    #for s in edf do
        # Arrangements(s,2) gets us all pairs
        # of values from s
    #    for pair in Arrangements(s, 2) do        
    #        Add(internald, pair[1]-pair[2]);
    #    od;
    #od;

    #Print("Internal differences", Collected(internald), "\n");
end;