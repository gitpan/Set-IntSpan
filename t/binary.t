# -*- perl -*-
# $Id: binary.t,v 1.1 1996/06/03 18:34:02 swm Exp swm $

use strict;
use Set::IntSpan 1.03;

my $N;

my @Binaries =  (
#     A           B         U        I     X        A-B   B-A 
[qw{  -           -         -        -     -         -     -   }],
[qw{  -          (-)       (-)       -    (-)        -    (-)  }],
[qw{ (-)         (-)       (-)      (-)    -         -     -   }],
[qw{ (-)         (-1       (-)      (-1   2-)       2-)    -   }],


[qw{ (-0         1-)       (-)       -    (-)       (-0   1-)  }],
[qw{ (-0         2-)       (-0,2-)   -    (-0,2-)   (-0   2-)  }],
[qw{ (-2         0-)       (-)      0-2   (--1,3-)  (--1  3-)  }],

[qw{ 1           1         1        1      -         -     -   }],
[qw{ 1           2         1-2       -    1-2        1     2   }],
[qw{ 3-9         1-2       1-9       -    1-9       3-9   1-2  }],
[qw{ 3-9         1-5       1-9      3-5   1-2,6-9   6-9   1-2  }],
[qw{ 3-9         4-8       3-9      4-8   3,9       3,9    -   }],
[qw{ 3-9         5-12      3-12     5-9   3-4,10-12 3-4  10-12 }],
[qw{ 3-9        10-12      3-12      -    3-12      3-9  10-12 }],

[qw{ 1-3,5,8-11  1-6       1-6,8-11 1-3,5 4,6,8-11  8-11 4,6   }],
);


print "1..", 8 * @Binaries, "\n";
Union    ();
Intersect();
Xor      ();
Diff     ();


sub Union
{
    print "#union\n";

    my $t;

    for $t (@Binaries)
    {
	Binary("union", $t->[0], $t->[1], $t->[2]);
	Binary("union", $t->[1], $t->[0], $t->[2]);
    }
}


sub Intersect
{
    print "#intersect\n";

    my $t;

    for $t (@Binaries)
    {
	Binary("intersect", $t->[0], $t->[1], $t->[3]);
	Binary("intersect", $t->[1], $t->[0], $t->[3]);
    }
}


sub Xor
{
    print "#xor\n";

    my $t;

    for $t (@Binaries)
    {
	Binary("xor", $t->[0], $t->[1], $t->[4]);
	Binary("xor", $t->[1], $t->[0], $t->[4]);
    }
}


sub Diff
{
    print "#diff\n";

    my $t;

    for $t (@Binaries)
    {
	Binary("diff", $t->[0], $t->[1], $t->[5]);
	Binary("diff", $t->[1], $t->[0], $t->[6]);
    }
}


sub Binary
{
    my($method, $op1, $op2, $expected) = @_;
    my $set1 = new Set::IntSpan $op1;
    my $set2 = new Set::IntSpan $op2;
    my $setE = $set1->$method($set2);
    my $run_list = run_list $setE;

    printf "#%-12s %-10s %-10s -> %-10s\n", $method, $op1, $op2, $run_list;
    print "not " unless $run_list eq $expected;
    print "ok ", ++$N, "\n";
}


