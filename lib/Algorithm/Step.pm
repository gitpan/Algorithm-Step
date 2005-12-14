package Algorithm::Step;

require Exporter;

our @ISA       = qw(Exporter);
our @EXPORT    = qw(step algorithm statistics end_algorithm);
our $VERSION   = 0.01;

$algs = {};
@algstack = ();
$curralg;

sub algorithm {
	my ($name, $desc) = @_;
	if (!exists $algs->{$name}) {
		$algs->{$name} = {};
		$algs->{$name}->{desc} = $desc;
		$algs->{$name}->{steps} = {};
	}
	push @algstack, $name;
	$curralg = $name;
}

sub step {
	my @args = @_;
	my $argc = @_;
	my $refstep = $algs->{$curralg};
	foreach (0 .. $argc-2) {
		if (!exists $refstep->{steps}) {
			$refstep->{steps} = {};
		}
		$refstep = $refstep->{steps};
		if (!exists $refstep->{@args[$_]}) {
			$refstep->{@args[$_]} = {};
			$refstep->{@args[$_]}->{desc} = @args[$argc-1];
			$refstep->{@args[$_]}->{count} = 0;
		}
		$refstep=$refstep->{@args[$_]};
	}
	$refstep->{count}++;
}

sub statistics {
	print "Statistics\n";
	foreach (keys %{$algs}) {
		print "Algorithm $_: $algs->{$_}->{desc}\n";
		my $name = $_;
		foreach (sort keys %{$algs->{$name}->{steps}}) {
			print_step($algs->{$name}->{steps}->{$_}, $_, 0); 
		}
	}
}

sub print_step {
	my ($step, $id, $indent) = @_;
	my $i;
	for ($i = 0; $i < $indent; $i++) {
		print "  ";
	}
	print "STEP $id. $step->{desc} ....... [$step->{count}]\n";
	if (exists $step->{steps}) {
		foreach (sort keys %{$step->{steps}}) {
			print_step($step->{steps}->{$_}, "$id.$_", $indent+1); 
		}
	}
}

sub end_algorithm {
	pop @algstack;
	$curralg = pop @algstack;
	push @algstack, $curralg;
}

1;

__END__

=head1 NAME

MyStep - Trace execution steps of an algorithm

=head1 SYNOPSIS
  
use Algorithm::Step;

=head1 DESCRIPTION


=head1 AUTHOR

  lichaoji@ict.ac.cn

=head1 BUGS


=head1 SEE ALSO
 

=head1 COPYRIGHT

=cut
