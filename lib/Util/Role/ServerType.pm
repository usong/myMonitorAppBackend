use utf8;
package Util::Role::ServerType;
use Moose::Role;
use Encode;
use constant PROCSS_TYPE  => 1;
use constant MM_TYPE      => 2;
use constant HD_TYPE      => 3;
use constant BACKUP_TYPE  => 4;
use constant DB_TYPE  	  => 5;
use constant TXN_TYPE     => 6;

my $idx = 1;
has $_ => ( is => 'ro'  , default => $idx++ ) 
	foreach ( qw/PROCSS_TYPE MM_TYPE HD_TYPE BACKUP_TYPE DB_TYPE TXN_TYPE/);

has 'types_desc' => ( is => 'rw'  , lazy_build => 1 ); 
sub _build_types_desc {
    return [ qw/进程监控 内存监控 磁盘监控 备份监控 数据库监控 业务监控/ ];
}

has 'type_ix' => ( is => 'rw'  , lazy_build => 1 ); 

sub _build_type_ix {
	return  [ PROCSS_TYPE, MM_TYPE, HD_TYPE, BACKUP_TYPE, DB_TYPE, TXN_TYPE ];
}

has 'types' => ( is => 'rw'  , isa => 'HashRef' , lazy_build => 1 );
##{
##    '1' => { 'type' => 'x' ,'desc' => 'y' ,'has_types' => '1' or '0'
##    '1' => { 'type' => 'x' ,'desc' => 'y' ,'has_types' => '1' or '0'
##}
sub _build_types {
    my $self  =  shift; 
    my $len   =  scalar @{  $self->type_ix } - 1  ;
    my $hash = {};
    foreach ( 0..$len ) {
    	$hash->{ $self->type_ix->[ $_ ] }->{ 'type' }  = $self->type_ix->[ $_ ];
	#$hash->{ $self->type_ix->[ $_ ] }->{ 'desc' }  = Encode::encode('UTF-8', $self->types_desc->[ $_ ] );
	$hash->{ $self->type_ix->[ $_ ] }->{ 'desc' }  = $self->types_desc->[ $_ ] ;
   	$hash->{ $self->type_ix->[ $_ ] }->{ 'has_types' }  = 0;
    }
    return $hash;
}


sub set_types_function {
    my ( $self , $type , @callfuncs ) =  @_; 
    
    confess "this is $type not support."
   	 if ( grep { $_ ne $type } $self->meta->get_all_attributes );
    confess "not found $type in function tables."
    		unless exists $self->types->{ $type } ;
    $self->types->{ $type }{ 'decode_caller' }  = $callfuncs[0] || sub { print "no defined.\n" } ;
    $self->types->{ $type }{ 'encode_caller' }  = $callfuncs[1] || sub { print "no defined.\n" } ;
    $self->types->{ $type }{ 'has_types' }      = 0;
}


1;
