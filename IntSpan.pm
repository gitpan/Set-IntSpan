# Copyright (c) 1996 Steven McDougall.  All rights reserved.  This
# module is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# $Id: IntSpan.pm,v 1.4 1996/02/22 20:06:04 swm Exp $

# $Log: IntSpan.pm,v $
# Revision 1.4  1996/02/22  20:06:04  swm
# added $Set::IntSpan::Empty_String
# made IntSpan an Exporter
# documentation fixes
#

require 5.001;
package Set::IntSpan;
$Set::IntSpan::VERSION = 1.01;

require Exporter;
@ISA = qw(Exporter);

use strict;
use integer;

=head1 NAME

Set::IntSpan - Manages sets of integers

=head1 SYNOPSIS

    use Set::IntSpan;

    $set = new Set::IntSpan $set_spec;
    
    copy $set $set_spec;
    
    $Set::IntSpan::Empty_String = $string;
    $run_list	= run_list $set;
    @elements	= elements $set;
    
    $u_set = union	$set $set_spec;
    $i_set = intersect	$set $set_spec;
    $x_set = xor	$set $set_spec;
    $d_set = diff	$set $set_spec;
    $c_set = complement	$set;
    
    equal	$set $set_spec;
    equivalent	$set $set_spec;
    superset	$set $set_spec;
    subset	$set $set_spec;
    
    $n = cardinality $set;
    
    empty	$set;
    finite	$set;
    neg_inf	$set;
    pos_inf	$set;
    infinite	$set;
    universal	$set;
    
    member	$set $n;
    insert	$set $n;
    remove	$set $n;


=head1 REQUIRES

Perl 5.001

=head1 EXPORTS

None

=head1 DESCRIPTION

Set::IntSpan manages sets of integers.
It is optimized for sets that have long runs of consecutive integers.
These arise, for example, in .newsrc files, which maintain lists of articles:

    alt.foo: 1-21,28,31
    alt.bar: 1-14192,14194,14196-14221

Sets are stored internally in a run-length coded form.
This provides for both compact storage and efficient computation.
In particular, 
set operations can be performed directly on the encoded representation.

Set::IntSpan is designed to manage finite sets.
However, it can also represent some simple infinite sets, such as {x | x>n}.
This allows operations involving complements to be carried out consistently, 
without having to worry about the actual value of MAXINT on your machine.

=head1 SET SPECIFICATIONS

Many of the methods take a I<set specification>.  
There are four kinds of set specifications.

=head2 Empty

If a set specification is omitted, then the empty set is assumed.
Thus, 

    $set = new Set::IntSpan;

creates a new, empty, set.  Similarly,

    copy $set;

removes all elements from $set.

=head2 Object reference

If an object reference is given, it is taken to be a Set::IntSpan object.

=head2 Array reference

If an array reference is given, 
then the elements of the array are taken to be the elements of the set.  
The array may contain duplicate elements.
The elements of the array may be in any order.

=head2 Run list

If a string is given, it is taken to be a I<run list>.
A run list specifies a set using a syntax similar to that in .newsrc files.

A run list is a comma-separated list of I<runs>.
Each run specifies a set of consecutive integers.
The set is the union of all the runs.

Runs may be written in any of several forms.

=over 8

=head2 Finite forms

=item n

{ n }

=item a-b

{x | a<=x && x<=b}

=back

=head2 Infinite forms

=over 8

=item (-n

{x | x<=n}

=item n-)

{x | x>=n}

=item (-)

The set of all integers

=back

=head2 Empty forms

The empty set is consistently written as '' (the null string).
It is also denoted by the special form '-' (a single dash).

=head2 Restrictions

The runs in a run list must be disjoint, 
and must be listed in increasing order.

Valid characters in a run list are 0-9, '(', ')', '-' and ','.
White space and underscore (_) are ignored.
Other characters are not allowed.

=head2 Examples

=over 15

=item 1

{ 1 }

=item 1-2

{ 1, 2 }

=item -5--1

{ -5, -4, -3, -2, -1 }

=item -

{ }

=item (-)

the integers

=item (--1

the negative integers

=item 1-3, 4, 18-21

{ 1, 2, 3, 4, 18, 19, 20, 21 }

=back

=head1 METHODS

=head2 Creation

=over 4

=item new Set::IntSpan $set_spec;

Creates and returns a new set.  
The initial contents of the set are given by $set_spec.

=item copy $set $set_spec;

Copies $set_spec into $set.
The previous contents of $set are lost.
For convenience, copy() returns $set.

=item $run_list = run_list $set

Returns a run list that represents $set.  
The run list will not contain white space.
$set is not affected.

By default, the empty set is formatted as '-'; 
a different string may be specified in $Set::IntSpan::Empty_String.

=item @elements = elements $set;

Returns an array containing the elements of $set.
The elements will be sorted in numerical order.
In scalar context, returns an array reference.
$set is not affected.

=back

=head2 Set operations

=over 4

=item $u_set = union $set $set_spec;

returns the set of integers in either $set or $set_spec

=item $i_set = intersect $set $set_spec;

returns the set of integers in both $set and $set_spec

=item $x_set = xor $set $set_spec;

returns the set of integers in $set or $set_spec, but not both

=item $d_set = diff $set $set_spec;

returns the set of integers in $set but not in $set_spec

=item $c_set = complement $set;

returns the complement of $set.

=back

For all set operations, a new Set::IntSpan object is created and returned.  
The operands are not affected.

=head2 Comparison

=over 4

=item equal $set $set_spec;

Returns true if $set and $set_spec contain the same elements.

=item equivalent $set $set_spec;

Returns true if $set and $set_spec contain the same number of elements.
All infinite sets are equivalent.

=item superset $set $set_spec

Returns true if $set is a superset of $set_spec.

=item subset $set $set_spec

Returns true if $set is a subset of $set_spec.

=back

=head2 Cardinality

=over 4

=item $n = cardinality $set

Returns the number of elements in $set.
Returns -1 for infinite sets.

=item empty $set;

Returns true if $set is empty.

=item finite $set

Returns true if $set if finite.

=item neg_inf $set

Returns true if $set contains {x | x<n} for some n.

=item pos_inf $set

Returns true if $set contains {x | x>n} for some n.

=item infinite $set

Returns true if $set is infinite.

=item universal $set

Returns true if $set contains all integers.

=back

=head2 Membership

=over 4

=item member $set $n

Returns true if the integer $n is a member of $set.

=item insert $set $n

Inserts the integer $n into $set.
Does nothing if $n is already a member of $set.

=item remove $set $n

Removes the integer $n from $set.
Does nothing if $n is not a member of $set.

=back

=head1 CLASS VARIABLES

=over 4

=item $Set::IntSpan::Empty_String

$Set::IntSpan::Empty_String contains the string that is returned when
run_list() is called on the empty set.
$Empty_String is initially '-'; 
alternatively, it may be set to ''.
Other values should be avoided,
to ensure that run_list() always returns a valid run list.

run_list() accesses $Empty_String through a reference
stored in $set->{empty_string}.
Subclasses that wish to override the value of $Empty_String can
reassign this reference.

=back

=head1 DIAGNOSTICS

Any method will die() if it is passed an invalid run list.
Possible messages are:

=over 15

=item Bad syntax 

$run_list has bad syntax

=item Bad order

$run_list has overlapping runs or runs that are out of order.

=back

elements $set will die() if $set is infinite.  
    
elements $set can generate an "Out of memory!" 
message on sufficiently large finite sets.

=head1 TESTING

To test IntSpan.pm, run it as a stand-alone perl program:

    %perl IntSpan.pm
    OK
    %

Normal output is "OK"; anything else indicates a problem.
Add B<-v> flags for verbose output; the more flags, the more output.

=head1 NOTES

Beware of forms like

    union $set [1..5];

This passes a slice of @set to union, which is probably not what you want.
To force interpretation of $set and [1..5] as separate arguments, 
use forms like

    union $set +[1..5];

or

    $set->union([1..5]);
    

Calling elements() on a large, finite set can generate an "Out of
memory!" message, which cannot be trapped.
Applications that must retain control after an error can use intersect() to 
protect calls to elements():

    @elements = elements { intersect $set "-1_000_000 - 1_000_000" };

or check the size of $set first:

    cardinality $set < 2_000_000 and @elements = elements $set;

Although Set::IntSpan can represent some infinite sets, 
it does I<not> perform infinite-precision arithmetic.  
Therefore, 
finite elements are restricted to the range of integers on your machine.

The sets implemented here are based on Macintosh data structures called 
"regions".
See Inside Macintosh for more information.

=head1 AUTHOR

Steven McDougall <swm@cric.com>

=head1 COPYRIGHT

Copyright (c) 1996 Steven McDougall. 
All rights reserved.
This module is free software; 
you can redistribute it and/or modify it under the same terms as Perl itself.

=cut


$Set::IntSpan::Empty_String = '-';


sub new
{
    my($class, $set_spec) = @_;
   
    my $set = bless { }, $class;
    $set->{empty_string} = \$Set::IntSpan::Empty_String;
    copy $set $set_spec;
}


sub copy
{
    my($set, $set_spec) = @_;

  SWITCH: 
    {
	    $set_spec             or  _copy_empty   ($set           ), last;
	ref $set_spec             or  _copy_run_list($set, $set_spec), last;
	ref $set_spec eq 'ARRAY'  and _copy_array   ($set, $set_spec), last;
				      _copy_set     ($set, $set_spec)      ;
    }    

    $set;
}


sub _copy_empty			# makes $set the empty set
{
    my $set = shift;
    
    $set->{negInf} = 0;
    $set->{posInf} = 0;
    $set->{edges } = [];
}


sub _copy_array			# copies an array into a set
{
    my($set, $array) = @_;
    my($element, @edges);

    $set->{negInf} = 0;
    $set->{posInf} = 0;

    for $element (sort { $Set::IntSpan::a <=> $Set::IntSpan::b } @$array)
    {
	next if @edges and $edges[-1] == $element; # skip duplicates

	if (@edges and $edges[-1] == $element-1)
	{
	    $edges[-1] = $element;
	}
	else
	{
	    push @edges, $element-1, $element;
	}
    }
    
    $set->{edges} = \@edges;
}


sub _copy_set			# copies one set to another
{
    my($dest, $src) = @_;
    
    $dest->{negInf} =     $src->{negInf};
    $dest->{posInf} =     $src->{posInf};
    $dest->{edges } = [ @{$src->{edges }} ];
}


sub _copy_run_list		# parses a run list
{
    my($set, $runList) = @_;
    my(@edges);

    _copy_empty($set);

    $runList =~ s/\s|_//g;
    return if $runList eq '-';	# empty set
  
    my($first, $last) = (1, 0);	# verifies order of infinite runs

    for (split(/,/ , $runList))
    {
    	die "Bad order: $runList\n" if $last;
    	
      SWITCH: 
    	{	    	
	    /^ (-?\d+) $/x and do
	    {
		push(@edges, $1-1, $1);
		last;
	    };

	    /^ (-?\d+) - (-?\d+) $/x and do
	    {
		die "Bad order: $runList\n" if $1 > $2;
		push(@edges, $1-1, $2);
		last;
	    };

	    /^ \( - (-?\d+) $/x and do
	    {
		die "Bad order: $runList\n" unless $first;
		$set->{negInf} = 1;
		push @edges, $1;
		last;
	    };

	    /^ (-?\d+) - \) $/x and do
	    {
		push @edges, $1-1;
		$set->{posInf} = 1;
		$last = 1;
		last;
	    };

	    /^ \( - \) $/x and do
	    {
		die "Bad order: $runList\n" unless $first;
		$last = 1;
		$set->{negInf} = 1;
		$set->{posInf} = 1;
		last;
	    };

	    die "Bad syntax: $runList\n";
	}

	$first = 0;
    }
    
    $set->{edges} = [ @edges ];
    
    _cleanup $set or die "Bad order: $runList\n";
}


# check for overlapping runs
# delete duplicate edges
sub _cleanup
{
    my $set = shift;
    my $edges = $set->{edges};	

    my $i=0;
    while ($i < $#$edges)
    {
	my $cmp = $$edges[$i] <=> $$edges[$i+1];
	{
	    $cmp == -1 and $i++                  , last;
	    $cmp ==  0 and splice(@$edges, $i, 2), last;
	    $cmp ==  1 and return 0;
	}
    }
    
    1;
}


sub run_list
{
    my $set = shift;
    
    return ${$set->{empty_string}} if empty $set;

    my @edges = @{$set->{edges}};
    my @runs;

    $set->{negInf} and unshift @edges, '(';
    $set->{posInf} and push    @edges, ')';

    while(@edges)
    {
	my $lower = shift @edges;
	my $upper = shift @edges;

	if ($lower ne '(' and $upper ne ')' and $lower+1==$upper)
	{
	    push @runs, $upper;
	}
	else
	{
	    $lower ne '(' and $lower++;
	    push @runs, "$lower-$upper";
	}
    }
    
    join(',', @runs);
}


sub elements
{
    my $set = shift;

    ($set->{negInf} or $set->{posInf}) and die "elements: infinite set\n";

    my @elements;
    my @edges = @{$set->{edges}};
    while (@edges)
    {
	my $lower = shift(@edges) + 1;
	my $upper = shift(@edges);
	push @elements, $lower..$upper;
    }

    wantarray ? @elements : \@elements;
}


sub _real_set			# converts a set specification into a set
{
    my($set_spec) = shift;

  SWITCH: 
    {
	    $set_spec             or  return new Set::IntSpan;
        ref $set_spec             or  return new Set::IntSpan $set_spec;
        ref $set_spec eq 'ARRAY'  and return new Set::IntSpan $set_spec;
    }    

    $set_spec;
}


sub union
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);

    my $s = new Set::IntSpan;	
    $s->{negInf} = $a->{negInf} || $b->{negInf};
    
    my $eA = $a->{edges};
    my $eB = $b->{edges};
    my $eS = $s->{edges};
    
    my $inA = $a->{negInf};
    my $inB = $b->{negInf};
    
    my $iA = 0;
    my $iB = 0;
    while ($iA<@$eA and $iB<@$eB)
    {
	my $xA = $$eA[$iA];
	my $xB = $$eB[$iB];
	
	if ($xA < $xB)
	{
	    $iA++;
	    $inA = ! $inA;
	    not $inB and push(@$eS, $xA);
	}
	elsif ($xB < $xA)
	{
	    $iB++;
	    $inB = ! $inB;
	    not $inA and push(@$eS, $xB);
	}
	else
	{
	    $iA++;
	    $iB++;
	    $inA = ! $inA;
	    $inB = ! $inB;
	    $inA == $inB and push(@$eS, $xA);
	}
    }

    $iA < @$eA and ! $inB and push(@$eS, @$eA[$iA..$#$eA]);
    $iB < @$eB and ! $inA and push(@$eS, @$eB[$iB..$#$eB]);

    $s->{posInf} = $a->{posInf} || $b->{posInf};
    $s;
}


sub intersect
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);
    
    my $s = new Set::IntSpan;	
    $s->{negInf} = $a->{negInf} && $b->{negInf};
    
    my $eA = $a->{edges};
    my $eB = $b->{edges};
    my $eS = $s->{edges};
    
    my $inA = $a->{negInf};
    my $inB = $b->{negInf};
    
    my $iA = 0;
    my $iB = 0;
    while ($iA<@$eA and $iB<@$eB)
    {
	my $xA = $$eA[$iA];
	my $xB = $$eB[$iB];
	
	if ($xA < $xB)
	{
	    $iA++;
	    $inA = ! $inA;
	    $inB and push(@$eS, $xA);
	}
	elsif ($xB < $xA)
	{
	    $iB++;
	    $inB = ! $inB;
	    $inA and push(@$eS, $xB);
	}
	else
	{
	    $iA++;
	    $iB++;
	    $inA = ! $inA;
	    $inB = ! $inB;
	    $inA == $inB and push(@$eS, $xA);
	}
    }

    $iA < @$eA and $inB and push(@$eS, @$eA[$iA..$#$eA]);
    $iB < @$eB and $inA and push(@$eS, @$eB[$iB..$#$eB]);

    $s->{posInf} = $a->{posInf} && $b->{posInf};
    $s;
}


sub diff
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);
    
    my $s = new Set::IntSpan;	
    $s->{negInf} = $a->{negInf} && ! $b->{negInf};
    
    my $eA = $a->{edges};
    my $eB = $b->{edges};
    my $eS = $s->{edges};
    
    my $inA = $a->{negInf};
    my $inB = $b->{negInf};
    
    my $iA = 0;
    my $iB = 0;
    while ($iA<@$eA and $iB<@$eB)
    {
	my $xA = $$eA[$iA];
	my $xB = $$eB[$iB];
	
	if ($xA < $xB)
	{
	    $iA++;
	    $inA = ! $inA;
	    not $inB and push(@$eS, $xA);
	}
	elsif ($xB < $xA)
	{
	    $iB++;
	    $inB = ! $inB;
	    $inA and push(@$eS, $xB);
	}
	else
	{
	    $iA++;
	    $iB++;
	    $inA = ! $inA;
	    $inB = ! $inB;
	    $inA != $inB and push(@$eS, $xA);
	}
    }

    $iA < @$eA and not $inB and push(@$eS, @$eA[$iA..$#$eA]);
    $iB < @$eB and     $inA and push(@$eS, @$eB[$iB..$#$eB]);

    $s->{posInf} = $a->{posInf} && ! $b->{posInf};
    $s;
}


sub xor
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);
    
    my $s = new Set::IntSpan;	
    $s->{negInf} = $a->{negInf} ^ $b->{negInf};
    
    my $eA = $a->{edges};
    my $eB = $b->{edges};
    my $eS = $s->{edges};
    
    my $iA = 0;
    my $iB = 0;
    while ($iA<@$eA and $iB<@$eB)
    {
	my $xA = $$eA[$iA];
	my $xB = $$eB[$iB];
	
	if ($xA < $xB)
	{
	    $iA++;
	    push(@$eS, $xA);
	}
	elsif ($xB < $xA)
	{
	    $iB++;
	    push(@$eS, $xB);
	}
	else
	{
	    $iA++;
	    $iB++;
	}
    }

    $iA < @$eA and push(@$eS, @$eA[$iA..$#$eA]);
    $iB < @$eB and push(@$eS, @$eB[$iB..$#$eB]);

    $s->{posInf} = $a->{posInf} ^ $b->{posInf};
    $s;
}


sub complement
{
    my $set = shift;
    my $comp = new Set::IntSpan $set;
    
    $comp->{negInf} = ! $comp->{negInf};
    $comp->{posInf} = ! $comp->{posInf};
    $comp;
}


sub superset
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);

    empty(diff($b, $a));
}


sub subset
{
    my($a, $b) = @_;

    empty(diff($a, $b));
}


sub equal
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);
    
    return 0 unless $a->{negInf} == $b->{negInf};
    return 0 unless $a->{posInf} == $b->{posInf};
    
    my $aEdge = $a->{edges};
    my $bEdge = $b->{edges};
    return 0 unless @$aEdge == @$bEdge;
    
    my $i;
    for ($i=0; $i<@$aEdge; $i++)
    {
	return 0 unless $$aEdge[$i] == $$bEdge[$i];
    }
    
    1;
}


sub equivalent
{
    my($a, $set_spec) = @_;
    my $b = _real_set($set_spec);

    cardinality($a) == cardinality($b);
}


sub cardinality
{
    my $set = shift;

    ($set->{negInf} or $set->{posInf}) and return -1;

    my $cardinality;
    my @edges = @{$set->{edges}};
    while (@edges)
    {
	my $lower = shift @edges;
	my $upper = shift @edges;
	$cardinality += $upper - $lower;
    }

    $cardinality;
}


sub empty
{
    my $set = shift;
    
    not $set->{negInf} and not @{$set->{edges}} and not $set->{posInf};
}


sub finite
{
    my $set = shift;
    
    not $set->{negInf} and not $set->{posInf};
}


sub neg_inf
{
    my $set = shift;
    
    $set->{negInf};
}


sub pos_inf
{
    my $set = shift;
    
    $set->{posInf};
}


sub infinite
{
    my $set = shift;
    
    $set->{negInf} or $set->{posInf};
}


sub universal
{
    my $set = shift;
    
    $set->{negInf} and not @{$set->{edges}} and $set->{posInf};
}


sub member
{
    my($set, $n) = @_;
    
    my $inSet = $set->{negInf};
    
    my $edge = $set->{edges};
    my $i;
    
    for ($i=0; $i<@$edge; $i++)
    {
	if ($inSet)
	{
	    return 1 if $n <= $$edge[$i];
	    $inSet = 0;
	}
	else
	{
	    return 0 if $n <= $$edge[$i];
	    $inSet = 1;
	}
    }
    
    $inSet;
}


sub insert
{
    my($set, $n) = @_;

    my $inSet = $set->{negInf};
    
    my $edge = $set->{edges};
    my $i;
    
    for ($i=0; $i<@$edge; $i++)
    {
	if ($inSet)
	{
	    return if $n <= $$edge[$i];
	    $inSet = 0;
	}
	else
	{
	    last if $n <= $$edge[$i];
	    $inSet = 1;
	}
    }

    return if $inSet;

    splice @{$set->{edges}}, $i, 0, $n-1, $n;
    _cleanup($set);
}

sub remove
{
    my($set, $n) = @_;

    my $inSet = $set->{negInf};
    
    my $edge = $set->{edges};
    my $i;
    
    for ($i=0; $i<@$edge; $i++)
    {
	if ($inSet)
	{
	    last if $n <= $$edge[$i];
	    $inSet = 0;
	}
	else
	{
	    return if $n <= $$edge[$i];
	    $inSet = 1;
	}
    }

    return unless $inSet;

    splice @{$set->{edges}}, $i, 0, $n-1, $n;
    _cleanup($set);
}


eval join('',<main::DATA>) or die $@ unless caller();

1;
__END__

package main;

my $Verbose;

sub test
{
    test_new();
    test_elements();
    test_set_spec();
    test_real_set();

    test_union();
    test_intersect();
    test_xor();
    test_diff();

    test_complement();

    test_equal();
    test_equivalent();
    test_superset();
    test_subset();

    test_cardinality();

    test_empty();
    test_finite();
    test_neg_inf();
    test_pos_inf();
    test_infinite();
    test_universal();

    test_member(); 
    test_insert();
    test_remove();

    test_new_errors();
    test_elements_errors();
}


my @New = 
    ([     ''               ,     '-'     , []              ],
     [    '     '           ,     '-'     , []              ],
     [    ' ( - )  '        ,    '(-)'    ],
     [    '-2 -     -1  '   ,    '-2--1'  , [-2,-1]         ],

     [qw{   -                      -     }, []              ],
     [qw{  1                      1      }, [1]             ],
     [qw{  1-1                    1      }, [1]             ],
     [qw{ -1                     -1      }, [-1]            ],
     [qw{  1-2                    1-2    }, [1,2]           ],
     [qw{ -2--1                  -2--1   }, [-2,-1]         ],
     [qw{ -2-1                   -2-1    }, [-2,-1,0,1]     ],

     [qw{  1,2-4                  1-4    }, [1,2,3,4]       ],
     [qw{  1-3,4,5-7              1-7    }, [1,2,3,4,5,6,7] ],
     [qw{  1-3,4                  1-4    }, [1,2,3,4]       ],
     [qw{  1,2,3,4,5,6,7          1-7    }, [1,2,3,4,5,6,7] ],
     [qw{  1,2-)                  1-)    }                  ],
     [qw{  (-0,1-)                (-)    }],

     [qw{  (-)                    (-)    }],
     [qw{  1-)                    1-)    }],
     [qw{  (-1                    (-1    }],
     [qw{ -3,-1-)                -3,-1-) }],
     [qw{  (-1,3                  (-1,3  }]);


sub test_new
{
    print "new\n" if $Verbose;

    my $test;
    for $test (@New)
    {
        my $set   = new Set::IntSpan $test->[0];
	my $copy  = new Set::IntSpan $set;
	my $result_1 = $set ->run_list();
	my $result_2 = $copy->run_list();
	my $message = sprintf("new: %-14s -> %-12s -> %-12s\n",
			      $test->[0], $result_1, $result_2);
	die $message unless 
	    $result_1 eq $test->[1] and $result_2 eq $test->[1];
	print $message if $Verbose > 1;
    }
}


sub test_elements
{
    print "elements\n" if $Verbose;

    my $t;
    for $t (@New)
    {
        my $set = new Set::IntSpan $t->[0];
	next if infinite $set;
	my @elements = elements $set;
	my $elements = elements $set;
	my $message = sprintf("elements %-14s -> %-20s : %-20s\n", 
			      $t->[0], 
			      join(',', @elements), 
			      join(',', @$elements) );
	die $message unless join(',', @elements ) eq join(',', @{$t->[2]});
	die $message unless join(',', @$elements) eq join(',', @{$t->[2]});
	print $message if $Verbose > 1;
    }
}


sub test_set_spec
{
    print "set specification\n" if $Verbose;

    my $set = new Set::IntSpan;
    my $run_list = run_list $set;
    my $message = "set spec: new Set::IntSpan -> $run_list\n";
    die $message unless empty $set;
    print $message if $Verbose > 1;

    my $set_1 = new Set::IntSpan "1-5";
    my $set_2 = new Set::IntSpan $set_1;
    my $set_3 = new Set::IntSpan [1, 2, 3, 4, 5];

    my $run_list_1 = run_list $set_1;
    my $run_list_2 = run_list $set_2;
    my $run_list_3 = run_list $set_3;

    my $message = "set_spec: $run_list_1 -> $run_list_2 -> $run_list_3\n";
    die $message unless $set_1->equal($set_2) and $set_1->equal($set_3);
    print $message if $Verbose > 1;
}


sub test_real_set
{
    print "real_set\n" if $Verbose;

    my $set = new Set::IntSpan;
    my $set_1 = union $set;
    my $run_list_1 = run_list $set_1;
    my $message = "_real_set:  union set -> $run_list_1\n";
    die $message unless empty $set_1;
    print $message if $Verbose > 1;

    my $set_2 = union $set "1-5,8-9";
    my $set_3 = union $set $set_2;
    my $set_4 = union $set +[1, 5, 2, 8, 9, 1, 3, 4, 9];

    my $run_list_2 = run_list $set_2;
    my $run_list_3 = run_list $set_3;
    my $run_list_4 = run_list $set_4;

    my $message = "real_set: $run_list_2 -> $run_list_3 -> $run_list_4\n";
    die $message unless $set_2->equal($set_3) and $set_2->equal($set_4);
    print $message if $Verbose > 1;
}


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


sub test_union
{
    print "union\n" if $Verbose;

    my $t;

    for $t (@Binaries)
    {
	test_binary("union", $t->[0], $t->[1], $t->[2]);
	test_binary("union", $t->[1], $t->[0], $t->[2]);
    }
}


sub test_intersect
{
    print "intersect\n" if $Verbose;

    my $t;

    for $t (@Binaries)
    {
	test_binary("intersect", $t->[0], $t->[1], $t->[3]);
	test_binary("intersect", $t->[1], $t->[0], $t->[3]);
    }
}


sub test_xor
{
    print "xor\n" if $Verbose;

    my $t;

    for $t (@Binaries)
    {
	test_binary("xor", $t->[0], $t->[1], $t->[4]);
	test_binary("xor", $t->[1], $t->[0], $t->[4]);
    }
}


sub test_diff
{
    print "diff\n" if $Verbose;

    my $t;

    for $t (@Binaries)
    {
	test_binary("diff", $t->[0], $t->[1], $t->[5]);
	test_binary("diff", $t->[1], $t->[0], $t->[6]);
    }
}


sub test_binary
{
    my($method, $op1, $op2, $expected) = @_;
    my $set1 = new Set::IntSpan $op1;
    my $set2 = new Set::IntSpan $op2;
    my $setE = $set1->$method($set2);
    my $run_list = run_list $setE;
    my $message = sprintf("%-12s %-10s %-10s -> %-10s\n", 
			  $method, $op1, $op2, $run_list);
    die $message unless $run_list eq $expected;
    print $message if $Verbose > 1;
}


sub test_unary
{
    my($method, $operand, $expected) = @_;
    my $set = new Set::IntSpan $operand;
    my $setE = $set->$method();
    my $run_list = run_list $setE;
    my $message = sprintf("%-12s %-10s -> %-10s\n", 
			  $method, $operand, $run_list);
    die $message unless $run_list eq $expected;
    print $message if $Verbose > 1;
}


sub test_complement
{
    print "complement\n" if $Verbose;

    my @test = 
	(
	 [qw{ -            (-)        }],
	 [qw{ (-1          2-)        }],
	 [qw{ 1            (-0,2-)    }],
	 [qw{ 1-3          (-0,4-)    }],
	 [qw{ 1-3,5-9,15-) (-0,4,10-14}],
	 );

    my $t;
    for $t (@test)
    {
	test_unary("complement", $t->[0], $t->[1]);
	test_unary("complement", $t->[1], $t->[0]);
    }
}


my $Rel_sets = [ qw{ - (-) (-0 0-) 1 5 1-5 3-7 1-3,8,10-23 } ];

my $Equal = 
    [[qw( 1 0 0 0 0 0 0 0 0 )],
     [qw( 0 1 0 0 0 0 0 0 0 )],
     [qw( 0 0 1 0 0 0 0 0 0 )],
     [qw( 0 0 0 1 0 0 0 0 0 )],
     [qw( 0 0 0 0 1 0 0 0 0 )],
     [qw( 0 0 0 0 0 1 0 0 0 )],
     [qw( 0 0 0 0 0 0 1 0 0 )],
     [qw( 0 0 0 0 0 0 0 1 0 )],
     [qw( 0 0 0 0 0 0 0 0 1 )]];

my $Equivalent = 
    [[qw( 1 0 0 0 0 0 0 0 0 )],
     [qw( 0 1 1 1 0 0 0 0 0 )],
     [qw( 0 1 1 1 0 0 0 0 0 )],
     [qw( 0 1 1 1 0 0 0 0 0 )],
     [qw( 0 0 0 0 1 1 0 0 0 )],
     [qw( 0 0 0 0 1 1 0 0 0 )],
     [qw( 0 0 0 0 0 0 1 1 0 )],
     [qw( 0 0 0 0 0 0 1 1 0 )],
     [qw( 0 0 0 0 0 0 0 0 1 )]];

my $Superset = 
    [[qw( 1 0 0 0 0 0 0 0 0 )],
     [qw( 1 1 1 1 1 1 1 1 1 )],
     [qw( 1 0 1 0 0 0 0 0 0 )],
     [qw( 1 0 0 1 1 1 1 1 1 )],
     [qw( 1 0 0 0 1 0 0 0 0 )],
     [qw( 1 0 0 0 0 1 0 0 0 )],
     [qw( 1 0 0 0 1 1 1 0 0 )],
     [qw( 1 0 0 0 0 1 0 1 0 )],
     [qw( 1 0 0 0 1 0 0 0 1 )]];

my $Subset = 
    [[qw( 1 1 1 1 1 1 1 1 1 )],
     [qw( 0 1 0 0 0 0 0 0 0 )],
     [qw( 0 1 1 0 0 0 0 0 0 )],
     [qw( 0 1 0 1 0 0 0 0 0 )],
     [qw( 0 1 0 1 1 0 1 0 1 )],
     [qw( 0 1 0 1 0 1 1 1 0 )],
     [qw( 0 1 0 1 0 0 1 0 0 )],
     [qw( 0 1 0 1 0 0 0 1 0 )],
     [qw( 0 1 0 1 0 0 0 0 1 )]];


sub test_equal      { test_relation("equal"     , $Rel_sets, $Equal     ) }
sub test_equivalent { test_relation("equivalent", $Rel_sets, $Equivalent) }
sub test_superset   { test_relation("superset"  , $Rel_sets, $Superset  ) }
sub test_subset     { test_relation("subset"    , $Rel_sets, $Subset    ) }


sub test_relation
{
    my($method, $sets, $expected) = @_;
    print "$method\n" if $Verbose;

    my($i, $j);
    for ($i=0; $i<@{$sets}; $i++)
    {
	for ($j=0; $j<@{$sets}; $j++)
	{
	    test_relation_1($method, $sets->[$i], $sets->[$j], 
			    $expected->[$i][$j]);
	}
    }
}


sub test_relation_1
{
    my($method, $op1, $op2, $expected) = @_;
    my $result;
    my $set1 = new Set::IntSpan $op1;
    my $set2 = new Set::IntSpan $op2;
    $result = $set1->$method($set2);
    my $message = sprintf("%-12s %-12s %-12s -> %d\n", 
			  $method, $op1, $op2, $result);
    die $message unless $result ? $expected : ! $expected;
    print $message if $Verbose > 1;
}


my @Cardinality = 
#		  C E F N P I U
    ([qw{  -	  0 1 1 0 0 0 0 }],
     [qw{ (-)    -1 0 0 1 1 1 1 }],
     [qw{ (-0    -1 0 0 1 0 1 0 }],
     [qw{ 0-)    -1 0 0 0 1 1 0 }],
     [qw{  1      1 0 1 0 0 0 0 }],
     [qw{  5      1 0 1 0 0 0 0 }],
     [qw{ 1,3,5   3 0 1 0 0 0 0 }],
     [qw{ 1,3-5   4 0 1 0 0 0 0 }],
     [qw{ 1-5     5 0 1 0 0 0 0 }],
     );


sub test_cardinality
{
    print "cardinality\n" if $Verbose;
    my $t;

    for $t (@Cardinality)
    {
	my $operand = $t->[0];
	my $set = new Set::IntSpan $operand;
	my $expected = $t->[1];

	my $result = $set->cardinality();
	my $message = sprintf("%-12s %-12s -> %d\n", 
			      'cardinality', $operand, $result);
	die $message unless $result == $expected;
	print $message if $Verbose > 1;
    }
}


sub test_empty     { test_size("empty"    , 2) }
sub test_finite    { test_size("finite"   , 3) }
sub test_neg_inf   { test_size("neg_inf"  , 4) }
sub test_pos_inf   { test_size("pos_inf"  , 5) }
sub test_infinite  { test_size("infinite" , 6) }
sub test_universal { test_size("universal", 7) }

sub test_size
{
    my($method, $column) = @_;
   
    print "$method\n" if $Verbose;
    my $t;

    for $t (@Cardinality)
    {
	my $operand = $t->[0];
	my $set = new Set::IntSpan $operand;
	my $expected = $t->[$column];

	my $result = $set->$method();
	my $message = sprintf("%-12s %-12s -> %d\n", 
			      $method, $operand, $result);
	
	die $message unless $result ? $expected : ! $expected;
	print $message if $Verbose > 1;
    }
}


my @Member_sets = ( qw{ - (-) (-3 3-) 3 3-5 3-5,7-9 } );
my @Member_ints = ( 1..7 );

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


sub test_member
{
    print "member\n" if $Verbose;

    my($s, $i);

    for $s (0..$#Member_sets)
    {
	for $i (0..$#Member_ints)
	{
	    my $run_list = $Member_sets[$s];
	    my $set = new Set::IntSpan $run_list;
	    my $int = $Member_ints[$i];
	    my $result = member $set $int;
	    my $message = sprintf("%-12s %-12s %d -> %d\n", 
				  "member", $run_list, $int, $result);
	    my $expected = $Member->[$s][$i];
	    die $message unless $result ? $expected : ! $expected;
	    print $message if $Verbose > 1;
	}
    }
}


sub test_insert { test_delta("insert", $Insert) }
sub test_remove { test_delta("remove", $Remove) }

sub test_delta
{
    my($method, $expected) = @_;

    my($s, $i);

    for $s (0..$#Member_sets)
    {
	for $i (0..$#Member_ints)
	{
	    my $run_list = $Member_sets[$s];
	    my $set = new Set::IntSpan $run_list;
	    my $int = $Member_ints[$i];
	    $set->$method($int);
	    my $result = run_list $set;
	    my $message = sprintf("%-12s %-12s %d -> %s\n", 
				  $method, $run_list, $int, $result);
	    die $message unless $result eq $expected->[$s][$i];
	    print $message if $Verbose > 1;
	}
    }
}


my @New_errors =
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


sub test_new_errors
{
    print "new_errors\n" if $Verbose;
    my $error;

    for $error (@New_errors)
    {
	my($run_list, $expected) = @$error;

	eval { new Set::IntSpan $run_list };
	my $message = sprintf("%-20s %-12s -> %s", 
			      "new Set::Intspan", $run_list, $@);
	die $message unless $@ =~ /$expected/;
	print $message if $Verbose > 1;
    }
}


my @Elements_errors =
    ([qw{ (-0 infinite }],
     [qw{ 0-) infinite }],
     [qw{ (-) infinite }]);


sub test_elements_errors
{
    print "elements_errors\n" if $Verbose;
    my $error;

    for $error (@Elements_errors)
    {
	my($run_list, $expected) = @$error;

	my $set = new Set::IntSpan $run_list;
	eval { elements $set };
	my $message = sprintf("%-20s %-12s -> %s", 
			      "elements", $run_list, $@);
	die $message unless $@ =~ /$expected/;
	print $message if $Verbose > 1;
    }
}


for (@ARGV) { /-v/ and $Verbose++ }
test();
print "OK\n";

