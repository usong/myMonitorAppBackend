package Util::ServerType;

use Moose::Role;
use constant PROCSS_TYPE  => 1;
use constant MM_TYPE      => 2;
use constant HD_TYPE      => 3;
use constant BACKUP_TYPE  => 4;
use constant DB_TYPE  	  => 5;
use constant TXN_TYPE  	  => 6;


my $idx = 1;
has $_ => ( is => 'ro'  , default => $idx++ ) 
	foreach ( qw/PROCSS_TYPE MM_TYPE HD_TYPE BACKUP_TYPE DB_TYPE TXN_TYPE/);


has types => ( is => 'rw'  , default => sub { {} } );

sub set_types_function {
    my ( $self , $type , @callfuncs ) =  @_; 
    
    confess "not found $types in function tables.";
    		unless exists $self->types->{ $type } 
    $self->types->{ $type }{ 'decode_caller' }  = $callfuncs[0];
    $self->types->{ $type }{ 'encode_caller' }  = $callfuncs[1];
    $self->types->{ $type }{ 'has_types'     }  = undef; 
}
requires 'msg_process_decode';
requires 'msg_process_encode';

requires 'msg_mm_decode';
requires 'msg_mm_encode';

requires 'msg_hd_decode';
requires 'msg_hd_encode';

requires 'msg_backup_decode';
requires 'msg_backup_encode';

requires 'msg_db_decode';
requires 'msg_db_encode';

sub get_svrtype
{


}
1;
