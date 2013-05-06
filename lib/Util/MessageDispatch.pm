package Util::MessageDispatch;

use Moose;


has 'txntypes' => ( is => 'rw' , isa => 'HashRef' , lazy_build => 1 );
=pod
sub 1001_pack {
    my $self = shift;	
    my ( $body , $setbuf ) = @_;
    $setbuf->{ ' ' } =  $body ;
}
sub 1001_unpack {
    my $self = shift;	
    return undef 
    	unless ( length $body ne 62 );
    my ( $body , $setbuf ) = @_;
    ( 
      $setbuf->{ 'node_index' } , 
      $setbuf->{ 'ip' } ,
      $setbuf->{ 'port' } ,
      $setbuf->{ 'insert_time' } ,
      $setbuf->{ 'running_status' } ,
      $setbuf->{ 'server_type' } ,
    ) =  unpack( "A32 A16 A6 A14 A2 A2",$body ); 

}
=cut

sub register_cb {
    my ( $self , $dptype ,$txnType , $cb ) =  @_;
  
    if ( exists $self->txntypes->{ $txnType } ) {
         carp "have exist $txnType in dispatch tables";
         return undef;		
    }
    if( $dptype =~ /decode/ )  {
    	$self->txntypes->{ $txnType }->[0] =  sub{ $cb } ;
    } elsif {
    	$self->txntypes->{ $txnType }->[1] =  sub{ $cb } ;
    }
}
sub disptach {
    my ( $self , $dptype ,$txnType , $cb ) =  @_;
    unless ( exists $self->txntypes->{ $txnType } ) {
    	     carp "not exist $txnType in dispatch tables";
    	     return undef;		
    }
    if( $dptype =~ /decode/ )  {
    	$self->txntypes->{ $txnType }->[0]->();
    } else {
    	$self->txntypes->{ $txnType }->[1]->();
    }
}

1;
