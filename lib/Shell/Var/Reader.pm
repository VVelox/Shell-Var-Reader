package Shell::Var::Reader;

use 5.006;
use strict;
use warnings;
use File::Slurp qw(read_file);

=head1 NAME

Shell::Var::Reader - The great new Shell::Var::Reader!

=head1 VERSION

Version 0.0.1

=cut

our $VERSION = '0.0.1';

=head1 SYNOPSIS

Quick summary of what the module does.

Perhaps a little code snippet.

    use Shell::Var::Reader;

    my $foo = Shell::Var::Reader->new();
    ...


=head1 SUBROUTINES/METHODS

=head2 function1

=cut

sub read_in_shell_vars {
	my $file = $_[1];

	if ( !defined($file) ) {
		die('No file specified');
	}

	if ( !-f $file ) {
		die( '"' . $file . '" does not exist or is not a file' );
	}

	# figure out if we are using bash or not
	my $raw_file  = read_file($file) or die 'Failed to read "' . $file . '"';
	my @raw_split = split( /\n/, $raw_file );
	my $shell      = 'sh';
	if ( defined( $raw_split[0] ) && ( $raw_split[0] =~ /^\#\!.*bash/ ) ) {
		$shell='bash';
	}

	#
	# figure out what variables already exist...
	#
	my $cmd=$shell." -c 'if [ -z \"\$BASH_VERSION\" ]; then set; else set -o posix; set; fi'";
	my $results=`$cmd`;
	my $base_vars={};
	my @results_split=split(/\n/, $results);
	foreach my $line (@results_split) {
		if ($line =~ /^[\_a-zA-Z]+[\_a-zA-Z0-9]\=/) {
			my @line_split=split(/=/,$line, 2);
			$base_vars->{$line_split[0]}=1;
		}
	}

	#
	# Figure out what has been set
	#
	$ENV{ShellVarReaderFile}=$file;
	$cmd=$shell." -c ' \"\$ShellVarReaderFile\" if [ -z \"\$BASH_VERSION\" ]; then set; else set -o posix; set; fi'";
	$results=`$cmd`;
	my $found_vars={};
	@results_split=split(/\n/, $results);
	foreach my $line (@results_split) {
		if ($line =~ /^[\_a-zA-Z]+[\_a-zA-Z0-9]\=/) {
			my @line_split=split(/=/,$line, 2);
		}
	}

}

=head1 AUTHOR

Zane C. Bowers-Hadley, C<< <vvelox at vvelox.net> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-shell-var-reader at rt.cpan.org>, or through
the web interface at L<https://rt.cpan.org/NoAuth/ReportBug.html?Queue=Shell-Var-Reader>.  I will be notified, and then you'll
automatically be notified of progress on your bug as I make changes.




=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Shell::Var::Reader


You can also look for information at:

=over 4

=item * RT: CPAN's request tracker (report bugs here)

L<https://rt.cpan.org/NoAuth/Bugs.html?Dist=Shell-Var-Reader>

=item * CPAN Ratings

L<https://cpanratings.perl.org/d/Shell-Var-Reader>

=item * Search CPAN

L<https://metacpan.org/release/Shell-Var-Reader>

=back


=head1 ACKNOWLEDGEMENTS


=head1 LICENSE AND COPYRIGHT

This software is Copyright (c) 2022 by Zane C. Bowers-Hadley.

This is free software, licensed under:

  The Artistic License 2.0 (GPL Compatible)


=cut

1;    # End of Shell::Var::Reader
