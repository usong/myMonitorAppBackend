package Util::MessagePlugin;


use Moose;
use Util::Basic;
use Moose::Util qw( apply_all_roles );
use FindBin qw($Bin $Script);
use File::Find;
use 5.010;
use Data::Dump qw/dump/;


has 'plugpath'  => ( is => 'rw' , isa => 'Str' , lazy_build => 1 ); 
sub _build_plugpath {
    my $self = shift;
    my $libbasepath = "$Bin/../lib/";
    my $config = Util::Basic->pconfig;
    my $path = $libbasepath.$config->{ 'PluginPath' }->{ 'path' };
    confess 'not found plugin moudle directory!'
    	unless( -d $path );
    return $path;
}

has 'plugins'   => ( is => 'rw' , isa => 'HashRef' , lazy_build => 1 ); 
sub _build_plugins {
    my $self = shift;	
    my $hash = {};
    my $config = Util::Basic->pconfig;
    my $pkgpath = $config->{ 'PluginPath' }->{ 'path' };
    find( sub {
		if( $_  =~ /(\d+).pm/g ) {
		      my $txntype = $1;
		      $pkgpath =~ s/\//::/g;
		      $hash->{ $txntype } = $pkgpath.'::'.$txntype;
		}
          },
          $self->plugpath
    );
    dump( $hash );
    return $hash;
}


1;

