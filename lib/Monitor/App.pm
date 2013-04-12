package Monitor::App;
use Dancer ':syntax';
use Util::Basic;
use File::Spec ;
our $VERSION = '0.1';

set 'views'  => path( Util::Basic->proot, 'templates' );
set 'layout'  => path( Util::Basic->proot, 'templates' );
set 'public' => path( Util::Basic->proot, 'public' );

hook before_template_render => sub {
    my $tokens = shift;
	$tokens->{public_resource} =  request->uri_base ;
    #$tokens->{public_resource} = File::Spec->catdir( Util::Basic->proot , 'public' );
};


get '/' => sub {
    template 'nodes.tt2';
};

true;
