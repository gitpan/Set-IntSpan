# -*- perl -*- 
# $Id: set_spec.t,v 1.1 1996/06/03 18:34:02 swm Exp swm $
    
use strict;
use Set::IntSpan 1.03;

print "1..3\n";
print "#set specification\n";

my $set = new Set::IntSpan;
my $run_list = run_list $set;
print "#set spec: new Set::IntSpan -> $run_list\n";
print "not " unless empty $set;
print "ok 1\n";

my $set_1 = new Set::IntSpan "1-5";
my $set_2 = new Set::IntSpan $set_1;
my $set_3 = new Set::IntSpan [1, 2, 3, 4, 5];

my $run_list_1 = run_list $set_1;
my $run_list_2 = run_list $set_2;
my $run_list_3 = run_list $set_3;

print "#set_spec: $run_list_1 -> $run_list_2\n";
print "not " unless $set_1->equal($set_2);
print "ok 2\n";

print "#set_spec: [1, 2, 3, 4, 5] -> $run_list_3\n";
print "not " unless $set_1->equal($set_3);
print "ok 3\n";
