package Util::Role::Message;

use Moose::Role;
use 5.010;
use constant HEAD_LEN => 5; 



has 'MsgHead'     => ( is => 'rw' , isa => 'Str');

has 'Head_Format' => ( is => 'rw' , isa => 'Str');

has 'MsgBody' => ( is => 'rw' , isa => 'Str' );

has 'Body_Format' => ( is => 'rw' , isa => 'Str' );

has 'MsgType' => ( is => 'rw' , isa => 'Str'   );

requires  'pre_headpack';
requires  'pre_bodypack';
requires  'pre_headunpack';
requires  'pre_bodyunpack';


sub datadump {
    my  $self = shift; 
    my  $buf = $self->MsgHead.$self->MsgBody;
    my  $len = length( $self->MsgHead.$self->MsgBody ) + 5;
    #say '>>>>>len=' , $len;
    #say '>>>>>len=' , length($len);
    #say '>>>>>Head=' , $self->MsgHead;
    #say '>>>>>Body=' , $self->MsgBody;
    #say '>>>>>Result=',  5 - int( length( $len ) ) ;
    #say '>>>>>Result=','0' x ( 5 - length( $len ) ) . $len . $buf ;
    return '0' x ( 5 - length( $len ) ) . $len . $buf;
}

sub decode {
    my ( $self , $content ) = @_; 
    #my ( $head , $body ) = unpack( "A5 A*" , $content);
    #my $txnypte =   unpack( "A4" $body );
    #$self->MsgType( $txnypte );
    #$self->MsgHead( $head );
    #return ( '9999' , 'msg dispatch failed' )  
    #	 unless $self->dispatch( 'decode', $self->MsgType , $content , $self->MsgBody, $self->MsgBody  );
}
sub encode {
    my ( $self , $txntype , $content ) = @_; 
    #$self->MsgType( $txntype );
#return ( '9999' , 'msg dispatch failed' )  
#   	 unless $self->dispatch( 'encode' , $self->MsgType  , $content ,$self->MsgHead , $self->MsgBody  );
}


1;
