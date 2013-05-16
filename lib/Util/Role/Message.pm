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
requires  'decode';
requires  'encode';


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

1;
