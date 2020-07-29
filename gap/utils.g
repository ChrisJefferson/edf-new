# Generate the elements of 'g' with a "nice"
# ordering:
# * Cyclic groups are ordered in the "natural" way
# * The identity always comes first
OrderedElements := function(g)
    local l,p;
    l := Elements(g);
    if IsCyclic(g) then
        p := First(l, x -> Order(x)=Size(g));
        l := List([0..Size(g)-1], i -> p^i);
    fi;
    Assert(0, Order(l[1])=1);
    Assert(0, Set(l)=Set(g));
    return l;
end;


EDFSymGroup := function(l,g)
    local gens,n;
    n := Length(l);
    gens := [];

    Append(gens, List(GeneratorsOfGroup(AutomorphismGroup(g)),
                              gen -> PermList(List([1..n], z -> Position(l, Image(gen,l[z]))))));
    Append(gens, List([1..n], i -> PermList(List([1..n], z -> Position(l, l[i]*l[z])))));
    Append(gens, List([1..n], i -> PermList(List([1..n], z -> Position(l, l[z]*l[i])))));
    Append(gens, List([1..n], i -> PermList(List([1..n], z -> Position(l, l[z]^l[i])))));
    return Group(gens);
end;


# Choose some elements from the group.
# We cannot pass every element to the constraint solver, so we pick a subset which
# will break "lots" of symmetry. This set is derived from:
# 'Automatic Generation of Constraints for Partial Symmetry Breaking'
SomeElements := function(group)
	local retlist,i,j1,j2,subgroup,p;
	retlist := [];
	for i in [1..LargestMovedPoint(group)] do
		subgroup := Stabilizer(group, [1..i-1], OnTuples);
		# early exit
		if Size(subgroup) = 1 then return Set(retlist); fi;

		for j1 in [i+1..LargestMovedPoint(group)] do
            p := RepresentativeAction(group, [i], [j1], OnTuples);
            if p <> fail then
                Add(retlist, p);
            fi;
		od;
	od;
	return Set(retlist);
end;
		

CollectSyms := function(l)
	local g, group, syms;
	g := Group(l);
    group := EDFSymGroup(l,g);
	if Size(group) <= 2500 then
		syms := Elements(group);
	else
		syms := SomeElements(group);
	fi;
	return List(syms, x -> ListPerm(x,Length(l)));
end;


# Express the group, it's inverses, and "x*y^-1", as tables of integers
# for the constraint solver
BuildTables := function(ordelements)
    local r;
    r := rec();

    r.inverses := List(ordelements, x -> Position(ordelements, Inverse(x)));
    r.multable := MultiplicationTable(ordelements);
    r.mulinvtable := List(ordelements, x ->
                           List(ordelements, y ->
                            Position(ordelements, x*y^-1)));
    

    r.multuples := ListX([1..Length(ordelements)], [1..Length(ordelements)],
                         {x,y} -> [x,y,r.multable[x][y]]);

    r.mulinvtuples := ListX([1..Length(ordelements)], [1..Length(ordelements)],
                       {x,y} ->  [x,y,r.mulinvtable[x][y]]);
    
    return r;
end;
