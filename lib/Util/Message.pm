package Util::Message;

use Moose::Role;

use constant HEAD_LEN => 5; 


has 'MsgHead' => ( is => 'rw' , isa => 'Str' , lazy_build => 1  );
=pod
has 'MsgHead' => ( is => 'rw' , isa => 'HashRef' , lazy_build => 1  );
sub _build_MsgHead {
    my ( $self , $msgbuf ) = @_ ;

    ( $self->MsgHead->{'TxnType'} , 
      $self->MsgHead->{'Version'} ,
      $self->MsgHead->{'Record_amount'} ,
      $self->MsgHead->{'Response_code'} , 
      $self->MsgHead->{'Record_length'}  
    )  = unpack( "A4 A2 A4 A6 A4" , $msgbuf );
}
=cut
has 'MsgBody' => ( is => 'rw' , isa => 'Str' , lazy_build => 1  );

has 'MsgType' => ( is => 'rw' , isa => 'Str' , lazy_build => 1  );

sub decode {
    my ( $self , $content ) = @_; 
    my ( $head , $body ) = unpack( "A5 A*" , $content);
    my $txnypte =   unpack( "A4" $body );
    $self->MsgType( $txnypte );
    $self->MsgHead( $head );
    return ( '9999' , 'msg dispatch failed' )  
   	 unless $self->dispatch( 'decode', $self->MsgType , $content , $self->MsgBody, $self->MsgBody  );
}
sub encode {
    my ( $self , $txntype , $content ) = @_; 
    $self->MsgType( $txnypte );
    return ( '9999' , 'msg dispatch failed' )  
   	 unless $self->dispatch( 'encode' , $self->MsgType  , $contetn ,$self->MsgHead , $self->MsgBody  );
}


