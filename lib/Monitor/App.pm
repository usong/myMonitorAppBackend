package Monitor::App;
use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Util::Basic;
use File::Spec ;
use Data::Dump qw(dump);
use Encode;
use utf8;
our $VERSION = '0.1';

set 'views'  => path( Util::Basic->proot, 'templates' );
set 'layout'  => path( Util::Basic->proot, 'templates' );
set 'public' => path( Util::Basic->proot, 'public' );
set serializer => 'JSON';

hook before_template_render => sub {
    my $tokens = shift;
	$tokens->{public_resource} =  request->uri_base ;
};

any '/' => sub {
    	
    my $schema = Util::Basic->schema;
    my $job_rs = $schema->resultset('Nodes')->search( undef, {
        order_by => 'inserted_times DESC',
        rows => 6,
        page => 1,
    });
    var nodes  => [$job_rs->all];
    var nodes_pager => $job_rs->pager;
    my $freelance_rs = $schema->resultset('Freelance')->search( undef, {
        order_by => 'inserted_at DESC',
        rows => 6,
        page => 1,
    });
    var freelances => [$freelance_rs->all];
    var freelances_pager => $freelance_rs->pager;

    template 'index.tt2';

    template 'nodes.tt2';
};

#any['get','post'] => '/get_value' => sub {
options '/get_value' => sub {
		header('Access-Control-Allow-Origin' => '*,');
		header('Access-Control-Allow-Methods'=>'POST, GET, OPTIONS');
		header('Access-Control-Allow-Headers'=>'origin, X-Requested-With, content-type, accept');
};
any['get','post'] => '/get_value' => sub {
	
	if ( request->request_method =~ /^options$/i ) {
	    header('Access-Control-Allow-Origin' => '*,');
		headers('Access-Control-Allow-Methods'=>'POST, GET, OPTIONS');
		headers('Access-Control-Allow-Headers'=>'origin, X-Requested-With, content-type, accept');
	} else {
		my $json = JSON->new->utf8;
	    my $json_text1 = param "XForms:Model";
        $json_text1 = Encode::encode('UTF-8', $json_text1);
		my $hash = $json->decode( $json_text1 ); 
		header('Access-Control-Allow-Origin' => '*,');
		header('Access-Control-Allow-Methods'=>'POST, GET, OPTIONS');
		header('Access-Control-Allow-Headers'=>'origin, X-Requested-With, content-type, accept');
		return $hash->{'ip'};
	}
};
true;


