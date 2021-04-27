Read("funcs.g");
# Load all known EDFs
ReadEDFDatabase();

# This creates a list called 'EDFDatabase', which is a bunch of GAP records. The important members are:

# - type: "sedf" or "edf"
# - grp := [x,y] - which means this is SmallGroup(x,y);
# - grpobj - The actual group
# - edfs - a list of the edfs
# - numsets - number of sets
# - setsize - size of set


# First get the edfs
objs := Filtered(EDFDatabase, x -> x.type = "sedf");;
PrintFormatted("Found {} EDF types, {} EDFs\n", Length(objs), Sum(objs, e -> Length(e.edfs)));
# Then get ones which do not partition the group
objs := Filtered(objs, x -> Size(x.grpobj) - 1 > x.numsets * x.setsize);;
PrintFormatted("Found {} EDF types, {} EDFSs which do not partition the group", Length(objs), Sum(objs, e -> Length(e.edfs)));


for edftype in objs do
    Print(edftype,"\n");
    for edf in edftype.edfs do
        diffs := [];
        for set in edf do
            for pair in Arrangements(set, 2) do
                Add(diffs, pair[1]*(pair[2]^(-1)));
            od;
        od;
        diffcounts := Collected(List(Collected(diffs), x -> x[2]));
        Print(Size(edftype.grpobj), ":", diffcounts,  ":", edftype.grp,  ":", Collected(diffs), "\n");
    od;
od;
