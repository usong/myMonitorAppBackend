use utf8;
package Util::Role::MsgSocket;
use Moose::Role;
#use AnyEvent;
#use AnyEvent::Socket;
#use AnyEvent::Handle;
use LWP::Socket;
#use Data::Dump qw/dump/;
use 5.010;
has 'condition' => ( is => 'rw' , isa => 'AnyEvent::CondVar'  );
has 'sock'      => ( is => 'rw'  );
has 'handle'    => ( is => 'rw'  ); 
has 'package'   => ( is => 'rw' , isa => 'Str'  );
has 'server_ip' => ( is => 'rw'  );
has 'port' 	=> ( is => 'rw' );

has HeadSize => ( is => 'rw' ,default =>  5 );

sub comm {
	my $self      = shift;
	my $sendbuf   = shift;
	#my $port = shift;
	my $handle;
	my $buf ;
	my $data ;
	eval {
		my $socket = new LWP::Socket;
		$socket->connect( $self->server_ip, $self->port ); # echo
		$socket->write( $sendbuf."\015\012" );
		$socket->read( \$buf , 5 ,15 );
		$socket->read( \$data ,  $buf ,15 );
		
	#$socket->read( \$data ,  $buf - 5 ,15 );
		$self->package( $data );
		
		$socket = undef;  # close
	};
	if( $@ ) { 
	    return undef;
	}
	return 1;
}
#sub comm {
#	my $self      = shift;
#	my $sendbuf   = shift;
#	#my $port = shift;
#	my $handle;
#
#	$self->condition(AnyEvent->condvar); 
#
#	tcp_connect( $self->server_ip , $self->port ,
#        sub {
#	      my ($fh) = @_
#	         or die "unable to connect: $!";
#	      $handle =  AnyEvent::Handle->new(
#   	      		fh     => $fh,
#   	      		on_error => sub {
#   	      		   AE::log error => $_[2];
#   	      		   $_[0]->destroy;
#   	      		},
#   	      		on_eof => sub {
#   	      		   $handle->destroy; # destroy handle
#   	      		   AE::log info => "Done.";
#   	                }
#		);
#
#	      $self->handle( $handle );
#	      $self->handle->push_write ( $sendbuf );
#	      
#	      $self->handle->push_read ( chunk => $self->HeadSize,  sub {
#	         my (undef, $line) = @_;
#		 #$self->handle->push_read ( chunk => int( $line ) - $self->HeadSize,  sub { 
#		 $self->handle->push_read ( chunk => int( $line ) ,  sub { 
#	                my (undef, $line) = @_;
#	         	# print response header
#	        	say "$line\n";
#	        	$self->package( $line );
#	        	$self->condition->broadcast; 
#	        });
#	      });
#	   },,sub {
#	      my ($fh) = @_;
#	      # could call $fh->bind etc. here
#	      15
#	   });
#	$self->condition->wait;
#}
#
1;


