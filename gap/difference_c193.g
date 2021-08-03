
n := 193;
# Build field
g := GF(n);

# Get a primitive root
#q := PrimitiveRoot(g);
q := Z(193)^5;

# Sanity check order of root
Assert(0, Order(q) = n-1);

# Make the three sets in the EDF
s1 := List(Group(q^6));
s2 := List(s1, x -> q^2*x);
s3 := List(s1, x -> q^4*x);

# Make the whole EDF
edf := [s1,s2,s3];

diffs := [];

# Start by checking we have an EDF
for sets in [1,2,3] do
    for others in Difference([1,2,3], [sets]) do
        for i in edf[sets] do
            for j in edf[others] do
                Add(diffs, i-j);
                Add(diffs, j-i);
            od;
        od;
    od;
od;

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