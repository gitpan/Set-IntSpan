# -*- perl -*-
# $Id: real_set.t,v 1.1 1996/06/03 18:34:02 swm Exp $

use strict;
use Set::IntSpan 1.02;

print "1..3\n";
print "#_real_set\n";

my $set = new Set::IntSpan;
my $set_1 = union $set;
my $run_list_1 = run_list $set_1;

print "#_real_set:  union set -> $run_list_1\n";
print "not " unless empty $set_1;
print "ok 1\n";

my $set_2 = union $set "1-5,8-9";
my $set_3 = union $set $set_2;
my $set_4 = union $set +[1, 5, 2, 8, 9, 1, 3, 4, 9];

my $run_list_2 = run_list $set_2;
my $run_list_3 = run_list $set_3;
my $run_list_4 = run_list $set_4;

print "#_real_set: $run_list_2 -> $run_list_3\n";
print "not " unless $set_2->equal($set_3);
print "ok 2\n";

print "#_real_set: $run_list_2 -> $run_list_4\n";
print "not " unless $set_2->equal($set_4);
print "ok 3\n";




