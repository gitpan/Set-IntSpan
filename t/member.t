# -*- perl -*-
# $Id: member.t,v 1.1 1996/06/03 18:34:02 swm Exp $

use strict;
use Set::IntSpan 1.02;

my $N;
my @Sets     = ( qw{ - (-) (-3 3-) 3 3-5 3-5,7-9 } );
my @Elements = ( 1..7 );

my $Member = 
    [[qw( 0 0 0 0 0 0 0 )],
     [qw( 1 1 1 1 1 1 1 )],
     [qw( 1 1 1 0 0 0 0 )],
     [qw( 0 0 1 1 1 1 1 )],
     [qw( 0 0 1 0 0 0 0 )],
     [qw( 0 0 1 1 1 0 0 )],
     [qw( 0 0 1 1 1 0 1 )]];

my $Insert = 
    [[qw{  1         2       3       4       5       6     7      }],
     [qw{ (-)       (-)     (-)     (-)     (-)     (-)   (-)     }],
     [qw{ (-3       (-3     (-3     (-4     (-3,5   (-3,6 (-3,7   }],
     [qw{ 1,3-)     2-)     3-)     3-)     3-)     3-)   3-)     }],
     [qw{ 1,3       2-3     3       3-4     3,5     3,6   3,7     }],
     [qw{ 1,3-5     2-5     3-5     3-5     3-5     3-6   3-5,7   }],
     [qw{ 1,3-5,7-9 2-5,7-9 3-5,7-9 3-5,7-9 3-5,7-9 3-9   3-5,7-9 }]];

my $Remove = 
    [[qw{ -       -       -       -       -       -       -       }],
     [qw{ (-0,2-) (-1,3-) (-2,4-) (-3,5-) (-4,6-) (-5,7-) (-6,8-) }],
     [qw{ (-0,2-3 (-1,3   (-2     (-3     (-3     (-3     (-3     }],
     [qw{ 3-)     3-)     4-)     3,5-)   3-4,6-) 3-5,7-) 3-6,8-) }],
     [qw{ 3       3       -       3       3       3       3       }],
     [qw{ 3-5     3-5     4-5     3,5     3-4     3-5     3-5     }],
     [qw{ 3-5,7-9 3-5,7-9 4-5,7-9 3,5,7-9 3-4,7-9 3-5,7-9 3-5,8-9 }]];


print "1..", 3 * @Sets * @Elements, "\n";
Member(); 
Insert();
Remove();


sub Member
{
    print "#member\n";

    my($s, $i);
    for $s (0..$#Sets)
    {
	for $i (0..$#Elements)
	{
	    my $run_list = $Sets[$s];
	    my $set = new Set::IntSpan $run_list;
	    my $int = $Elements[$i];
	    my $result = member $set $int;

	    printf "#%-12s %-12s %d -> %d\n", 
	    "member", $run_list, $int, $result;
	    my $expected = $Member->[$s][$i];
	    print "not " unless $result ? $expected : ! $expected;
	    print "ok ", ++$N, "\n";
	}
    }
}


sub Insert { Delta("insert", $Insert) }
sub Remove { Delta("remove", $Remove) }

sub Delta
{
    my($method, $expected) = @_;
    my($s, $i);

    print "#$method\n";

    for $s (0..$#Sets)
    {
	for $i (0..$#Elements)
	{
	    my $run_list = $Sets[$s];
	    my $set = new Set::IntSpan $run_list;
	    my $int = $Elements[$i];
	    $set->$method($int);
	    my $result = run_list $set;

	    printf "#%-12s %-12s %d -> %s\n", 
	    $method, $run_list, $int, $result;
	    print "not " unless $result eq $expected->[$s][$i];
	    print "ok ", ++$N, "\n";
	}
    }
}


