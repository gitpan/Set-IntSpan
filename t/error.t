# -*- perl -*-
# $Id: error.t,v 1.1 1996/06/03 18:34:02 swm Exp $

use strict;
use Set::IntSpan 1.02;

my $N;

my @Errors =
    ([qw{ 1.2     syntax }],
     [qw{ 1-2-3   syntax }],
     [qw{ 1,,2    syntax }],
     [qw{ --      syntax }],
     [qw{ abc     syntax }],
     [qw{ 2,1     order  }],
     [qw{ 2-1     order  }],
     [qw{ 3-4,1-2 order  }],
     [qw{ 3,(-2   order  }],
     [qw{ 2-),3   order  }],
     [qw{ (-),1   order  }]);


print "1..", 2 * @Errors, "\n";
Errors();


sub Errors
{
    print "#errors\n";
    my($error, $message);

    for $error (@Errors)
    {
	my($run_list, $expected) = @$error;

	eval { new Set::IntSpan $run_list };
	printf "#%-20s %-12s -> %s", "new Set::Intspan", $run_list, $@;
	print "not " unless $@ =~ /$expected/;
	print "ok ", ++$N, "\n";

	my $valid = valid Set::IntSpan $run_list;
	printf "#%-20s %-12s -> %s", "valid Set::Intspan", $run_list, $@;
	print "not " if $valid or $@ !~ /$expected/;
	print "ok ", ++$N, "\n";
    }
}



