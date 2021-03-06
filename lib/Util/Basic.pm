package Util::Basic;

use MooseX::Singleton;
use namespace::autoclean;
use File::Spec ;
use Cwd qw( abs_path );
use 5.010;
#whole appliation root path
has 'proot' => ( is => 'ro', isa => 'Str', lazy_build => 1 );
sub _build_proot {
	my (  undef ,$root ) = File::Spec->splitpath( __FILE__ );	
   	return abs_path( File::Spec->catdir( $root , '..' , '..' ) );	
}

#application config file path
use YAML qw( LoadFile Dump );
has 'pconfig' => ( is => 'ro' , isa => 'HashRef' ,  lazy_build => 1 );
sub _build_pconfig {
	my $self = shift;	
	my $config = File::Spec->catdir( $self->proot , 'conf' , 'monitor.yml' );
	confess "conf/monitor.yml not exist!"
		if( ! -e $config );
    	LoadFile( $config ); 
}

#db path
has 'pdb' => ( is => 'ro' , isa => 'Str' , lazy_build => 1 );
sub _build_pdb {
	my $self = shift;	
	my $config = File::Spec->catdir( $self->proot , 'db' , 'monitor.db' );
	confess "db/monitor.db not exist!"
		if( ! -e $config );
    return $config; 
}

use Util::Schema;
has 'schema' => ( is => 'ro' , lazy_build => 1 );
sub _build_schema {
	my $self = shift;	
   	my $schema = Util::Schema->connect( "dbi:Oracle:host=10.0.1.91;sid=devdb", "sysmonitor", "sysmonitor", { AutoCommit => 1 }, '' );
	return $schema;
}

1;

