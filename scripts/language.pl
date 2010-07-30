#!/usr/bin/perl

open F, '../lib/marker/language.treetop';
open O, '>language.dot';
print O "digraph language {\n";

sub arc {
	my ($from, $to) = @_;
	next if $done{"$from -> $to"}++;
	print "$from -> $to\n";
	print O node($from), " -> ", node($to), ";\n";
}

sub node {
	my ($node) = @_;
	$node =~ s/"/\\"/g;
	$node =~ s/\\n/\\\\n/g;
	$node =~ s/\\r/\\\\r/g;
	$node =~ s/\\t/\\\\t/g;
	$node =~ s/([a-z])_([a-z])/$1\\n$2/g;
	"\"$node\"";
}

for (<F>) {
	next if /^\s*#/;
	next if /^\s*$/;
	next if /^\s*(module|grammar|end|\/)/;
	s/\w+://g;
	s/\s*<\w+>//;
	s/\s+#.*//;
	s/\((.*?)\)(\+|\*)/$1/;
	if (/^\s*rule\s+(\w+)/) {
		$rule = $1;
		print "\n";
		next;
	}
	$def = 0 if s/^\s*}//;
	next if $def;
	$def = 1 if s/ {$//;

	# print;
	s/\[ /\[_/;
	for (/(\S+)/g) {
		s/\[_/\[ /;
		next if $rule =~ /_word$/;
		s/(\*|\+)$//;
		arc $rule, $_;
		arc $_, $2 if /^(&|!)(.*)/;
	}
}

print O "}\n";

