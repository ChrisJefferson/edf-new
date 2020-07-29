#!/usr/bin/gap -q
max := 100;
G := "";

Read("utils.g");

# Check if there is any valid Lambda value
validLambdas := function(n, sedf)
	local numsets, setsize, lambda, l;
	l := [];
	for numsets in [2..n-1] do
		for setsize in [2..n] do
			if numsets * setsize > n then
				continue;
			fi;

			if sedf then
				lambda := (setsize * setsize * (numsets - 1))/(n-1);
			else
				lambda := (setsize * setsize * numsets * (numsets - 1))/(n-1);
			fi;

			if IsInt(lambda) then
				Add(l, rec(setsize := setsize, numsets := numsets, lambda := lambda));
			fi;
		od;
	od;
	return l;
end;



outputEDFEssenceFile := function(filename, ordgrp, tables, symlist, setsize, numsets, lambda, sedf)
	local output;
	output := OutputTextFile( filename, false );
	SetPrintFormattingStatus(output, false);
	PrintToFormatted(output, "letting n = {}\n", Length(ordgrp));
	PrintToFormatted(output, "letting inverses = {}\n", tables.inverses);
	PrintToFormatted(output, "letting multable = {}\n", tables.multable);
	PrintToFormatted(output, "letting mulinvtable = {}\n", tables.mulinvtable);
	PrintToFormatted(output, "letting multuples = {}\n", tables.multuples);
	PrintToFormatted(output, "letting mulinvtuples = {}\n", tables.mulinvtuples);
	PrintToFormatted(output, "letting setsize = {}\n", setsize);
	PrintToFormatted(output, "letting setnum = {}\n", numsets);
	PrintToFormatted(output, "letting dups = {}\n", lambda);
	# The whole 'List(l, x -> x)' gets rid of any range notation, which savilerow doesn't understand
	PrintToFormatted(output, "letting syms = {}\n", List(symlist, l -> List(l, x -> x)));
	PrintToFormatted(output, "letting makeEDF = {}\n", not sedf);
	PrintToFormatted(output, "letting makeSEDF = {}\n", sedf);
	
	CloseStream(output);
	end;

makeSEDF := false;

for n in [2..30] do

	options :=  validLambdas(n, makeSEDF);
	if IsEmpty(options) then
		continue;
	fi;

	for i in [1 .. NumberSmallGroups(n)] do

		G := SmallGroup(n, i);
		ordG := OrderedElements(G);

		symlist := CollectSyms(ordG);
		
		for option in options do
			numsets := option.numsets;
			setsize := option.setsize;
			lambda := option.lambda;

			# Put any groups you want to skip here
			if IsAbelian(G) then
				continue;
			fi;

			Print(n,":",i,":",numsets,":",setsize,"!",lambda,"\n");

			name := StructureDescription(G);

			tables := BuildTables(ordG);

			# Remove spaces from name, e.g. "C2 x C4" => "C2xC4"
			RemoveCharacters(name," ");

			filename := StringFormatted("groups/{}_{}_{}_{}_{}.param", n, i, setsize, numsets, lambda);
			outputEDFEssenceFile(filename, ordG, tables, symlist, setsize, numsets, lambda, makeSEDF);
		od;
	od;
od;

