# -*- perl -*-
# $Id: creation.t,v 1.1 1996/06/03 18:34:02 swm Exp swm $

use strict;
use Set::IntSpan 1.03;

my $N;
my $Err = "elements: infinite set\n";

my @New = 
    ([     ''               ,     '-'     , ''              ],
     [    '     '           ,     '-'     , ''              ],
     [    ' ( - )  '        ,    '(-)'    , $Err            ],
     [    '-_2 -     -1  '  ,    '-2--1'  , '-2,-1'         ],
     [    '-'               ,     '-'     , ''              ],

     [qw{  1                      1         1              }],
     [qw{  1-1                    1         1              }],
     [qw{ -1                     -1         -1             }],
     [qw{  1-2                    1-2       1,2            }],
     [qw{ -2--1                  -2--1      -2,-1          }],
     [qw{ -2-1                   -2-1       -2,-1,0,1      }],

     [qw{  1,2-4                  1-4       1,2,3,4        }],
     [qw{  1-3,4,5-7              1-7       1,2,3,4,5,6,7  }],
     [qw{  1-3,4                  1-4       1,2,3,4        }],
     [qw{  1,2,3,4,5,6,7          1-7       1,2,3,4,5,6,7  }],

     [qw{  1,2-)                  1-)    }, $Err            ],
     [qw{  (-0,1-)                (-)    }, $Err            ], 
     [qw{  (-)                    (-)    }, $Err            ],
     [qw{  1-)                    1-)    }, $Err            ],
     [qw{  (-1                    (-1    }, $Err            ],
     [qw{ -3,-1-)                -3,-1-) }, $Err            ],
     [qw{  (-1,3                  (-1,3  }, $Err            ]);


print "1..", @New * 4, "\n";
New();
Elements();


sub New
{
    print "#new\n";

    my($test, $set, $copy, $result);

    for $test (@New)
    {
        $set    = new Set::IntSpan $test->[0];
	$result = $set->run_list();
	printf "#new %-14s -> %-12s\n", $test->[0], $result;
	print "not " unless $result eq $test->[1];
	print "ok ", ++$N, "\n"; 

	$copy   = new Set::IntSpan $set;
	$result = $copy->run_list();
	printf "#new %-14s -> %-12s\n", $test->[0], $result;
	print "not " unless $result eq $test->[1];
	print "ok ", ++$N, "\n"; 
    }
}


sub Elements
{
    print "#elements\n";

    my($t, $set, $expected, @elements, $elements, $result);

    for $t (@New)
    {
        $set      = new Set::IntSpan $t->[0];
	$expected = $t->[2];;

	eval { @elements = elements $set };
	$result = $@ ? $@ : join(',', @elements );
	printf "#elements %-14s -> %-20s\n", $t->[0], $result;
	print "not " unless $result eq $expected;
	print "ok ", ++$N, "\n"; 

	eval { $elements = elements $set };
	$result = $@ ? $@ : join(',', @$elements );
	printf "#elements %-14s -> %-20s\n", $t->[0], $result;
	print "not " unless $result eq $expected;
	print "ok ", ++$N, "\n"; 
    }
}


