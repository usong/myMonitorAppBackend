package Util::MessageDispatch;


use MooseX::Singleton;
use namespace::autoclean;

with qw/Util::Role::Message Util::Role::MonitorSvrSerial Util::Role::MsgSocket/;
use 5.010;
my $meta = __PACKAGE__->meta;

has 'txntypes'    => ( is => 'rw' , isa => 'HashRef' , lazy_build => 1 );
sub _build_txntypes {
    my $self = shift;	
    my $hash = {};
    for my $method ( $meta->get_all_methods ) {
	my $mtd = $method->fully_qualified_name;
	my $txntype;
	if(  $mtd =~ m/::encode_(\d.*)/g   ) {
		$txntype = $1;
		$hash->{ $txntype }->[0] = $method  ;
	} elsif( $mtd =~ m/::decode_(\d.*)/g ) {
		$txntype = $1;
		$hash->{ $txntype }->[1] = $method ;
	}
    } 
    return $hash;
}

sub register_cb {
    my ( $self , $dptype ,$txnType , $cb ) =  @_;
    if ( exists $self->txntypes->{ $txnType } ) {
         confess "have exist $txnType in dispatch tables";
         return undef;		
    }
    if( $dptype =~ /decode/ )  {
    	$self->txntypes->{ $txnType }->[1] =  sub{ $cb } ;
    } else {
    	$self->txntypes->{ $txnType }->[0] =  sub{ $cb } ;
    }
}

sub disptach {
    my ( $self , $dptype , $txnType, $data ) =  @_;
    unless ( exists $self->txntypes->{ $txnType } ) {
        confess "not exist $txnType in dispatch tables";
        return undef;		
    }
    my $buf = $self->txntypes->{ $txnType }->[0]->execute( $self, $data );
    
    $self->package( $buf );
    #say '>>>>>>',$self->package;
    #say '>>>>>>', length( $self->package );
    return undef unless( $self->comm( $buf ) ) ;
    return  $self->package;
    #return $self->txntypes->{ $txnType }->[1]->( $self );
}

sub setting {
    my ( $self , $ip , $port ) =  @_;
    $self->server_ip( $ip );
    $self->port( $port );
}


1;
