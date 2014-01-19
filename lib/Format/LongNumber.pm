package Format::LongNumber;

$VERSION = '0.01';

=head1 NAME

Format::LongNumber - Format long numbers to human readable view.

=cut

=head1 SYNOPSIS

	use Format::LongNumber;

	my $seconds = 121;
	print short_time($seconds); # '2m 1s'

	my $bytes = 1025;
	print long_traffic($bytes); # '1Kb 1 Bytes'
	print short_traffic($bytes); # '1,00Kb'

=cut


use strict;
use warnings;


require Exporter;
our @ISA = qw| Exporter |;
our @EXPORT = (qw|
	full_time
	full_traffic
	full_number
	full_value
	short_time
	short_traffic
	short_value
	short_number
|);

my %_TIME_GRADE = (
	3600*24	=> " d",
	3600	=> " h",
	60		=> " m",
	1		=> " s"
);

my %_TRAFFIC_GRADE = (
	1024**4	=> "T",
	1024**3	=> "G",
	1024**2	=> "M",
	1024	=> "K",
	1		=> " Bytes"
);

my %_NUMBER_GRADE = (
	1000**3	=> "B",
	1000**2	=> "M",
	1000	=> "K",
	1		=> ""
);

=item full_value()

Abstract function of the final value 
Params: 
	grade_table - hash with dimensions, where the key is a value dimension, and the value is the symbol dimension 
	total - value to bring us to the desired mean

=cut

sub full_value {
	my ($grade_table, $total) = @_;
	$total ||= 0;
	my $result = "";
	my @grades = sort { $b <=> $a } keys %$grade_table;
	for my $grade (@grades) {
		my $value = int($total / $grade);
		if ($value) {
			$total = $total % $grade;
			$result .= $value. $grade_table->{$grade}. " ";
		}
	}

	unless ($result) {
		$result = "0". $grade_table->{$grades[$#grades]};
	} 
	else {
		chop $result;
	}

	return $result;
}
#
# Wrapper for full_value(time_value)
#
sub full_time {
	my $seconds = shift;

	return full_value(\%_TIME_GRADE, $seconds);
}
#
# Wrapper for full_value(traffic_value)
#
sub full_traffic {
	my $bytes = shift;
	
	return full_value(\%_TRAFFIC_GRADE, $bytes);
}
#
# Wrapper for full_value(number_value)
#
sub full_number {
	my $number = shift;
	
	return full_value(\%_NUMBER_GRADE, $number);
}

=item short_value() 

Converts the given value only to the largest grade-value

=cut

sub short_value {
	my ($grade_table, $total) = @_;
	$total ||= 0;
	my $result = "";
	my @grades = sort { $b <=> $a } keys %$grade_table;
	for my $grade (@grades) {
		my $value = sprintf("%.2f", $total / $grade);
		my $fraction = $total % $grade;
		if (int $value) {
			$value = int $value if ($fraction == 0);
			$result = $value. $grade_table->{$grade};
			last;
		}
	}

	unless ($result) {
		$result = "0". $grade_table->{$grades[$#grades]};
	} 

	return $result;
}	
#
# Wrapper for short_value(time_value)
#
sub short_time {
	my $seconds = shift;

	return short_value(\%_TIME_GRADE, $seconds);
}
#
# Wrapper for short_value(traffic_value) 
#
sub short_traffic {
	my $bytes = shift;
	
	return short_value(\%_TRAFFIC_GRADE, $bytes);
}
#
# Wrapper for short_value(number_value)�
#
sub short_number {
	my $number = shift;
	
	return short_value(\%_NUMBER_GRADE, $number);
}
#
# The End
#
1;

