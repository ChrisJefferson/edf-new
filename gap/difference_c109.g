
n := 109;
# Build field
g := GF(n);

# Get a primitive root
q := PrimitiveRoot(g);

# Sanity check order of root
Assert(0, Order(q) = n-1);

# Make the two sets in the EDF
s1 := List(Group(q^6));
s2 := List(s1, x -> q^3*x);

# Make the whole EDF
edf := [s1,s2];

# Start by checking we have an EDF
diffs := [];
for i in s1 do
    for j in s2 do
        Add(diffs, i-j);
        Add(diffs, j-i);
    od;
od;

# Collected prints how many of each value a
# list contains
Print("EDF:", Collected(diffs),"\n");


# Now build the internal differences
internald := [];

# For each set s in the edf (s1 and s2 in this case)
for s in edf do
    # Arrangements(s,2) gets us all pairs
    # of values from s
    for pair in Arrangements(s, 2) do        
        Add(internald, pair[1]-pair[2]);
    od;
od;

Print("Internal differences", Collected(internald), "\n");