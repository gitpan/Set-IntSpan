# -*- perl -*-
# $Id: unary.t,v 1.1 1996/06/03 18:34:02 swm Exp $

use strict;
use Set::IntSpan 1.02;

my $N;

my @Unaries = 
    (
     [qw{ -            (-)        }],
     [qw{ (-1          2-)        }],
     [qw{ 1            (-0,2-)    }],
     [qw{ 1-3          (-0,4-)    }],
     [qw{ 1-3,5-9,15-) (-0,4,10-14}],
     );


print "1..", 2 * @Unaries, "\n";
Complement();


sub Complement
{
    print "#complement\n";

    my $t;
    for $t (@Unaries)
    {
	Unary("complement", $t->[0], $t->[1]);
	Unary("complement", $t->[1], $t->[0]);
    }
}


sub Unary
{
    my($method, $operand, $expected) = @_;
    my $set = new Set::IntSpan $operand;
    my $setE = $set->$method();
    my $run_list = run_list $setE;

    printf "#%-12s %-10s -> %-10s\n", $method, $operand, $run_list;
    print "not " unless $run_list eq $expected;
    print "ok ", ++$N, "\n";
}

