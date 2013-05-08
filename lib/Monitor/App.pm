package Monitor::App;
use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Util::Basic;
use Util::Tools;
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
    $tokens->{public_resource}   =  request->uri_base ;# /* uri_base */
    $tokens->{node_view}   =  uri_for('/node_view');  #/* node_information */
    $tokens->{node_cfgview}   =  uri_for('/node_cfgview'); # /* node_confg view */
    $tokens->{hd_paramcfg_url}   =  uri_for('/hd_paramcfg');#  /* hd_param */
    $tokens->{mm_paramcfg_url}   =  uri_for('/mm_paramcfg');#  /* mm_param */
    $tokens->{process_paramcfg_url}   =  uri_for('/process_paramcfg');  #/* process_param */
    $tokens->{backup_paramcfg_url}   =  uri_for('/backup_paramcfg');  #/* backup_param */
    $tokens->{param_hdconfig_url}   =  uri_for('/param_hdconfigok');#  /* param config ok */
};

any '/' => sub {
    	my $schema = Util::Basic->schema;
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
			#'node_servertypes'     =>  get_svrtype( $node->server_type ), /* monitor subsrv type */
			'node_index'          =>  $nodeindex,
  		};	
	}
};

get '/hd_paramcfg/:node_index' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex =  params->{node_index} ;
		my $node = $schema->resultset('Node')->search({
    			node_index => $nodeindex ,
  		})->first;
	        #hd config information
        	my @node_hdinfoset = $schema->resultset('NodeHdInfo')->search({
    			node_index => $nodeindex ,
  		});
	        if(  scalar(@node_hdinfoset) > 0 ){
		    template 'node_hdcfg.tt2',
		    {
		    	'node_hds'            =>  \@node_hdinfoset,# /* monitor subsrv type */
		    	'node'                =>  $node ,
			#'test'                =>  $hash ,
		    };	 
		 } else {
		    #send msg to svr
		    #template 'node_hdcfg.tt2',
		    #{
		    #	'node_hds'            =>  $node_hdinfoset, #/* monitor subsrv type */
		    #	'node_index'          =>  $nodeindex,
  		    #};
		    forward "404.html" ;
	         }
	}
};

#config ok
post '/param_hdconfigok' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
        	
		my $schema = Util::Basic->schema;
		my $nodeindex = params->{ node_index } ;
	
		my $buf = undef;
		my @hd_no_items =  params->{ hd_no_items } ;
		my @threhold_items =  params->{ threhold_items } ;
		my $result = 0;	
		#merge hd_no => threhold 
		dump(@hd_no_items);
		dump(@threhold_items );	
		my %hd_hash = Util::Tools->HdInfo_Merge( @hd_no_items , @threhold_items );
		dump( $hd_hash{'a'} );	
		if( $schema->resultset('NodeHdInfo')->insert_or_update( $nodeindex, \%hd_hash ) ) { $result = 1 ; }
		
		#merge array 	
		#map { $buf .= $_.' ' } params->{hd_no_items};
		#map { $buf .= $_.' ' } params->{threhold_item};
		#my $node = $schema->resultset('Node')->search({
    		#	node_index => $nodeindex ,
		#});
		dump( $result );
		template 'node_hdcfgok.tt2',
		{
		    	'db_result'    =>  $result ,
		};	 
	}

};

true;


