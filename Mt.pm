# Mt package
# Copyright 2001-2002 Roman M. Parparov <romm@empire.tau.ac.il>
#
# This library is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.

package Mt;

use strict;
use Carp;
require 5.006;

our $VERSION = '0.01';
our $DEBUG = 0;
our $MTPROGRAM = `which mt 2> /dev/null`; chomp $MTPROGRAM;
our $DEVICE = '/dev/tape';

sub new {

    my $class = shift;
    my $self = {};
    my ($key,$value);
    my %attr = @_;
    while (($key,$value) = each %attr) {
	$self->{$key} = $value;
    }
    if (! $self->{-device}) {
	$self->{-device} = $DEVICE;
    }
    if (! $self->{-mtprogram}) {
	$self->{-mtprogram} = $MTPROGRAM;
    }
    if (! $self->{-mtprogram}) {
	warn "No mt program detected on your system, aborting\n";
	return -1;
    }
    if (! $self->{DEBUG}) {
	$self->{DEBUG} = $DEBUG;
    }
    bless $self;
    return $self;
}
sub command {

    my $mt = shift;
    my %hasharg = @_;
    my $command;

    if (! $hasharg{-command}) {
	warn "Missing command\n";
	return -1;
    }
    $command = join ' ',($mt->{-mtprogram},'-f',$mt->{-device},$hasharg{-command});
    if ($hasharg{-count}) {
	$command .= ' '.$hasharg{-count};
    }
    if ($hasharg{-args}) {
	my @args = @{$hasharg{-args}};
	my $arg;
	for $arg (@args) {
	    $command .= ' ' . $arg;
	}
    }
    if ($mt->{DEBUG} == 1) {
	print $command;
	print "\n";
    }
    my $mtresponse = system($command);
    if ($mtresponse != 0) {
	print "Command failed\n";
	return -1;
    }
    else {
	return 1;
    }
}
1;

__END__

=head1 NAME

Mt - Provide a wrapper for the tape manager 'mt' program

=head1 SYNOPSIS

  use Mt;

  # initialize
  $mt = Mt->new;
  $mt = Mt->new(-device=>'/dev/st0',
                -mtprogram=>'/usr/local/bin/mt');

  # send command to tape
  $mt->command(-command=>'status');
  $mt->command(-command=>'fsf',
               -count=>1);

=head1 DESCRIPTION

The C<Mt> module provides a wrapper to the tape manager B<mt>
program. It doesn't use any library calls, but rather wraps
around the program 'mt' that should be installed on your system.
The output of the runs of 'mt' is passed to the user along with
system() return code to indicate success or failure.

=head1 METHODS

The following methods are defined in the module:

=over 2

=item new([Attributes]);

The constructor returns a newly created object which points at a
specific tape device and a specific tape manager B<mt> program.

Attributes:

-device : Tape device (defaults to I</dev/tape>)


-mtprogram : path to the B<mt> program (defaults to B<`which mt`> output)


DEBUG : set to 1 for additional output


=item command(-command=>$command,-count=>$count,-args=>[ @args ]);

The object executes the given I<command> through set B<mt> program
and tape device

Attributes:

-command : a valid mt command

-count : count argument for the commands requiring it

-args : reference to an array containing arguments for some commands

=back

=head1 BUGS

When reporting bugs/problems please include as much information as
possible.  It may be difficult for me to reproduce the problem as
almost every setup is different.

Include the OS version you have, the mt version, and the tape
specification. The module has only been tested so far with
RedHat Linux 7.1 and the 'mt' that comes with
I<mt-st-0.5b-10.i386.rpm> package.

=head1 AUTHOR

Roman M. Parparov <romm@empire.tau.ac.il>

=head1 SEE ALSO

L<mt>, L<st>

=head1 COPYRIGHT

Copyright 2001-2002 Roman M. Parparov <romm@empire.tau.ac.il>

This library is free software; you can redistribute it and/or
modify it under the same terms as Perl itself.

=cut
