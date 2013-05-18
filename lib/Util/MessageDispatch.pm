package Util::MessageDispatch;
use Moose;
use Moose::Util qw( apply_all_roles );
use Util::MessagePlugin;
with qw/Util::Role::MsgSocket/;
use 5.010;
use Data::Dump qw/dump/;
has 'pluginroom'  => ( is => 'rw' , isa => 'Object'  , default => sub { Util::MessagePlugin->new } );

#my $meta = __PACKAGE__->meta;
#has 'txntypes'    => ( is => 'rw' , isa => 'HashRef' , lazy_build => 1 );
#sub _build_txntypes {
#    my $self = shift;	
#    my $hash = {};
#    my $libpath = "$Bin/../lib";
#    for my $method ( $meta->get_all_methods ) {
#	my $mtd = $method->fully_qualified_name;
#	my $txntype;
#	if(  $mtd =~ m/::encode_(\d.*)/g   ) {
#		$txntype = $1;
#		$hash->{ $txntype }->[0] = $method  ;
#	} elsif( $mtd =~ m/::decode_(\d.*)/g ) {
#		$txntype = $1;
#		$hash->{ $txntype }->[1] = $method ;
#	}
#    } 
#    return $hash;
#}
#sub register_cb {
#    my ( $self , $dptype ,$txnType , $cb ) =  @_;
#    if ( exists $self->txntypes->{ $txnType } ) {
#         confess "have exist $txnType in dispatch tables";
#         return undef;		
#    }
#    if( $dptype =~ /decode/ )  {
#    	$self->txntypes->{ $txnType }->[1] =  sub{ $cb } ;
#    } else {
#    	$self->txntypes->{ $txnType }->[0] =  sub{ $cb } ;
#    }
#}

sub disptach {
    my ( $self , $dptype , $txnType, $data ) =  @_;
    unless ( exists $self->pluginroom->plugins->{ $txnType } ) {
        confess "not exist $txnType in plugins tables";
        return undef;		
    }
    my $pluginname = $self->pluginroom->plugins->{ $txnType };
    apply_all_roles( $self, $pluginname );
    my $buf = $self->encode( $data );
    
    #say '####', $txnType,'###',$data;
    #say '>>>>>>', length( $self->package );
    #return undef unless( $self->comm( $buf ) ) ;
    unless( $self->comm( $buf ) ) {
	say '>>>>>> ',  'No recive a package';	
	return undef;
    } 
    #say '>>>>>>',  $self->package;
    return  $self->decode;
    
    #return  $self->package;
    #my $buf = $self->txntypes->{ $txnType }->[0]->execute( $self, $data );
    #return $self->txntypes->{ $txnType }->[1]->( $self );
}

sub setting {
    my ( $self , $ip , $port ) =  @_;
    $self->server_ip( $ip );
    $self->port( $port );
}


1;
