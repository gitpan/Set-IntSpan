# -*- perl -*-

use strict;
use Set::IntSpan 1.04;

my $N = 1;
sub Not { print "not " }
sub OK  { print "ok ", $N++, "\n" }

print "1..3\n";
print "#_real_set\n";

my $set = new Set::IntSpan;
my $set_1 = union $set;
my $run_list_1 = run_list $set_1;

print "#_real_set:  union set -> $run_list_1\n";
empty $set_1 or Not; OK;

my $set_2 = union $set "1-5,8-9";
my $set_3 = union $set $set_2;
my $set_4 = union $set +[1, 5, 2, 8, 9, 1, 3, 4, 9];

my $run_list_2 = run_list $set_2;
my $run_list_3 = run_list $set_3;
my $run_list_4 = run_list $set_4;

print "#_real_set: $run_list_2 -> $run_list_3\n";
$set_2->equal($set_3) or Not; OK;

print "#_real_set: $run_list_2 -> $run_list_4\n";
$set_2->equal($set_4) or Not; OK;





