# -*- perl -*-

use strict;
use Set::IntSpan 1.04;

my $N = 1;
sub Not { print "not " }
sub OK  { print "ok ", $N++, "\n" }

sub Table { map { [ split(' ', $_) ] } split(/\s*\n\s*/, shift) }

my $Err = "Set::IntSpan::elements: infinite set\n";

my @New = 
    ([''                ,    '-'      , ''              ],
     ['     '           ,    '-'      , ''              ],
     [' ( - )  '        ,    '(-)'    , $Err            ],
     ['-_2 -     -1  '  ,    '-2--1'  , '-2,-1'         ],
     ['-'               ,    '-'      , ''              ],

     Table <<TABLE,
       1                      1          1              
       1-1                    1          1              
       -1                     -1         -1             
       1-2                    1-2        1,2            
       -2--1                  -2--1      -2,-1          
       -2-1                   -2-1       -2,-1,0,1      
       1,2-4                  1-4        1,2,3,4        
       1-3,4,5-7              1-7        1,2,3,4,5,6,7  
       1-3,4                  1-4        1,2,3,4        
       1,2,3,4,5,6,7          1-7        1,2,3,4,5,6,7  
TABLE

     ['1,2-)'           ,    '1-)'     , $Err            ],           
     ['(-0,1-)'         ,    '(-)'     , $Err            ],
     ['(-)'             ,    '(-)'     , $Err            ],
     ['1-)'             ,    '1-)'     , $Err            ],
     ['(-1'             ,    '(-1'     , $Err            ],
     ['-3,-1-)'         ,    '-3,-1-)' , $Err            ], 
     ['(-1,3'           ,    '(-1,3'   , $Err            ]); 


print "1..", @New * 4, "\n";
New();
Elements();


sub New
{
    print "#new\n";

    for my $test (@New)
    {
        my $set    = new Set::IntSpan $test->[0];
	my $result = $set->run_list();
	printf "#new %-14s -> %-12s\n", $test->[0], $result;
	$result eq $test->[1] or Not; OK

	my $copy = new Set::IntSpan $set;
	$result = $copy->run_list();
	printf "#new %-14s -> %-12s\n", $test->[0], $result;
	$result eq $test->[1] or Not; OK;
    }
}


sub Elements
{
    print "#elements\n";

    my($set, $expected, @elements, $elements, $result);

    for my $t (@New)
    {
        $set      = new Set::IntSpan $t->[0];
	$expected = $t->[2];;

	eval { @elements = elements $set };
	$result = $@ ? $@ : join(',', @elements );
	printf "#elements %-14s -> %-20s\n", $t->[0], $result;
	$result eq $expected or Not; OK;

	eval { $elements = elements $set };
	$result = $@ ? $@ : join(',', @$elements );
	printf "#elements %-14s -> %-20s\n", $t->[0], $result;
	$result eq $expected or Not; OK;
    }
}


