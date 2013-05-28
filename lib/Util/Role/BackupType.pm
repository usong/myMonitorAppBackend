use utf8;
package Util::Role::BackupType;
use Moose::Role;
use Encode;
use constant COMPRESS_TYPE  => 1;
use constant FTP_TYPE       => 2;
use constant UNLINK_TYPE    => 3;

my $idx = 1;
has $_ => ( is => 'ro'  , default => $idx++ ) 
	foreach ( qw/COMPRESS_TYPE FTP_TYPE UNLINK_TYPE/);

has 'types_desc' => ( is => 'rw'  , lazy_build => 1 ); 
sub _build_types_desc {
    return [ qw/备份压缩 备份上传 备份删除/ ];
}

has 'type_ix' => ( is => 'rw'  , lazy_build => 1 ); 

sub _build_type_ix {
	return  [ COMPRESS_TYPE, FTP_TYPE, UNLINK_TYPE  ];
}

has 'types' => ( is => 'rw'  , isa => 'HashRef' , lazy_build => 1 );

sub _build_types {
    my $self  =  shift; 
    my $len   =  scalar @{  $self->type_ix } - 1  ;
    my $hash = {};
    foreach ( 0..$len ) {
    	$hash->{ $self->type_ix->[ $_ ] }->{ 'type' }  = $self->type_ix->[ $_ ];
	$hash->{ $self->type_ix->[ $_ ] }->{ 'desc' }  = $self->types_desc->[ $_ ] ;
   	$hash->{ $self->type_ix->[ $_ ] }->{ 'has_types' }  = 0;
    }
    return $hash;
}

1;
