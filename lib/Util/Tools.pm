package Util::Tools;

use Moose;
=pod
{
   { hd_no => '' } 
   { 
}
=cut
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
1;


