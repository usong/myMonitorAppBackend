package Util::Tools;

use Moose;

sub Array_Merge (\@\@) {
    my $self = shift;
    my @tmp = @_; #first array item length
    return undef 
    	unless ( scalar @tmp == 2 ) ;
    return undef
    	unless( $#{ $tmp[0] } eq $#{ $tmp[1] } ) ; 
     map { 
    	my $ix = $_;
  	map  { $_->[$ix] } @tmp;
    } 0..$#{ $tmp[0] }; 
}

sub GetBitValue (\@) {
    my $self  = shift;
    my %hash  = @_; 
    my $value = 0;
    foreach  my $item ( keys %hash ) {
	 if( $hash{ $item } ) {
	     $value += 	2**($item-1);
	 }	 
    }
    return $value;
}


1;


