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
    $tokens->{public_resource}   =  request->uri_base ; /* uri_base */
    $tokens->{node_view}   =  uri_for('/node_view');  /* node_information */
    $tokens->{node_cfgview}   =  uri_for('/node_cfgview');  /* node_confg view */
    $tokens->{hd_paramcfg_url}   =  uri_for('/hd_paramcfg');  /* hd_param */
    $tokens->{mm_paramcfg_url}   =  uri_for('/mm_paramcfg');  /* mm_param */
    $tokens->{process_paramcfg_url}   =  uri_for('/process_paramcfg');  /* process_param */
    $tokens->{backup_paramcfg_url}   =  uri_for('/backup_paramcfg');  /* backup_param */
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
get '/node_view/:node_index' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex =  params->{node_index} ;
    		my $node = $schema->resultset('Node')->search({
    			node_index => $nodeindex ,
  		});
			

   		template 'nodeinfo.tt2',
		{
     		'node_info'           =>  $node->first ,
			'node_index'          =>  $nodeindex,
  		};	
	}
};

get '/node_cfgview/:node_index' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex =  params->{node_index} ;
        	my $node = $schema->resultset('Node')->search({
    			node_index => $nodeindex ,
  		})->first;

   		template 'nodeinfo.tt2',
		{
     			'node_servertypes'     =>  get_svrtype( $node->server_type ), /* monitor subsrv type */
			'node_index'          =>  $nodeindex,
  		};	
	}
};

true;


