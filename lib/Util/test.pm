package Util::Test;

use Moose;
with "Util::Role::MsgSocket";

sub do {
	my $self = shift;
	$self->server_ip( '127.0.0.1' ), 
	$self->port( '8888' );
	$self->package('111');
	$self->comm( $buf );
}
1;


