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
    	#my @artists = (['1','192.168.1.2','22','清算','null'],['2','192.168.1.2','22','公交二级','null']);   
    	#$schema->populate('Node', [
    	# 	[qw/node_index monitor_ip monitor_port alias inserted_times/],
    	# 	@artists,
    	#]);
    	my $job_rs = $schema->resultset('Node')->search( undef, {
        	order_by => 'inserted_times DESC',
        	rows => 8,
        	page => 1,
   	});
   	template 'nodes.tt2',
	{
     	    'nodes'           => [ $job_rs->all ] ,
  	};
    
};

#any['get','post'] => '/get_value' => sub {
options '/node_getinfo' => sub {
		header('Access-Control-Allow-Origin' => '*,');
		header('Access-Control-Allow-Methods'=>'POST, GET, OPTIONS');
		header('Access-Control-Allow-Headers'=>'origin, X-Requested-With, content-type, accept');
};
any['get','post'] => '/node_getinfo' => sub {
	
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
get '/node_view/:nodeid' => sub {
	if ( params->{nodeid} =~ m/[#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeid =  params->{nodeid} ;
    		my $node = $schema->resultset('Node')->search({
    			node_index => $nodeid ,
  		});

   		template 'nodeinfo.tt2',
		{
     		    'node_info'           =>  $node->first() ,
  		};	
	}
};
true;


