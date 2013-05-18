package Util::Role::Message;

use Moose::Role;
use 5.010;
use constant HEAD_LEN => 5; 


has 'MsgHead'     => ( is => 'rw' , isa => 'Str');

has 'MsgBody' => ( is => 'rw' , isa => 'Str' );

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
    my  $len = length( $buf ) + 5;
    #say '>>>>>buf=' ,    $buf;
    #say '>>>>>buflen=' , length($buf);
    #say '>>>>>pkglen=' , $len;
    #say '>>>>>len=' , length($len);
    #say '>>>>>Headlen=' , length($self->MsgHead);
    #say '>>>>>Bodylen=' , length($self->MsgBody);
    #say '>>>>>Body=' , $self->MsgBody,'...';
    #say '>>>>>Result=',  5 - int( length( $len ) ) ;
    #say '>>>>>Result=','0' x ( 5 - length( $len ) ) . $len . $buf ;
    return '0' x ( 5 - length( $len ) ) . $len . $buf;
}

1;
