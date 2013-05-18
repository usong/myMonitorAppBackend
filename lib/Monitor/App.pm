package Monitor::App;
use Dancer ':syntax';
use Dancer::Plugin::Ajax;
use Util::Basic;
use Util::Tools;
use File::Spec ;
use Data::Dump qw(dump);
use Encode;
use Util::ServerTypeTool;
use Util::TxnFlow;
use utf8;
our $VERSION = '0.1';

set 'views'  => path( Util::Basic->proot, 'templates' );
set 'layout'  => path( Util::Basic->proot, 'templates' );
set 'public' => path( Util::Basic->proot, 'public' );
set serializer => 'JSON';

hook before_template_render => sub {
    my $tokens = shift;
    $tokens->{public_resource}   =  request->uri_base ;# /* uri_base */
    $tokens->{webroot}   =  uri_for('/');  #/* node_information */
    $tokens->{node_view}   =  uri_for('/node_view');  #/* node_information */
    $tokens->{node_cfgview}   =  uri_for('/node_svrcfgview'); # /* node_confg view */
    $tokens->{node_cfgokview}   =  uri_for('/node_svrcfgokview'); # /* node_confg view */
    $tokens->{hd_paramcfg_url}   =  uri_for('/hd_paramcfg');#  /* hd_param */
    $tokens->{mm_paramcfg_url}   =  uri_for('/mm_paramcfg');#  /* mm_param */
    $tokens->{process_paramcfg_url}   =  uri_for('/process_paramcfg');  #/* process_param */
    $tokens->{backup_paramcfg_url}   =  uri_for('/backup_paramcfg');  #/* backup_param */
    $tokens->{param_hdconfig_url}   =  uri_for('/param_hdconfigok');#  /* hd_param config ok */
    $tokens->{param_processconfig_url}   =  uri_for('/param_processconfigok');#  /* process_param config ok */
    $tokens->{node_addconfig_url}   =  uri_for('/node_addprocess');#  /* process_param config ok */
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


any '/test' => sub {


=pod
	my $config = Util::Basic->pconfig->{ 'MonitroServer' };
	my $dp = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );

	my $data_1001 = 
	{
		'node_index' 	 => 123456,
		'server_ip'  	 => '10.0.1.171' ,
		'port'           => 9000,
		'inserted_time'  => 0,
		'running_status' => 0,
		'server_type'    => 0,
		'txntype'        => 1001,
		'hostname'       => '555',
	
	};
	my $result_1001 = $dp->disptach( undef, 1001, $data_1001 ); #1001  create a monitor server host

	unless( $result_1001 ) {
		dump( $result_1001);
		dump( 'failed!' );
		return ( '999999' , 'comminication failed' );
	}

	if( $result_1001->{ 'response_code' } ne '000000' ) {
		return ( $result_1001->{ 'response_code' } , $result_1001->{ 'response_msg' } );
	} 


	my $data_1005 = 
	{
		'node_index' 	 => 123456,
		'cpunum'  	 => 0 ,
		'cputype'        => 0,
		'opsys_info'     => 0,
		'mmsize'         => 0,
		'mmfreesize'     => 0,
		'hdsize'         => 0,
		'hdfreesize'     => 0,
		'txntype'        => 1005,
	
	};
	my $result_1005 = $dp->disptach( undef, 1005, $data_1005 ); #1005  create a monitor server host

	unless( $result_1005 ) {
		dump( 'failed!' );
		return ( '999999' , 'comminication failed' );
	}
	
	if( $result_1005->{ 'response_code' } ne '000000' ) {
		return ( $result_1005->{ 'response_code' } , $result_1005->{ 'response_msg' } );
	} else {
		#dump( $result_1005 );
		#return ( '000000' ,'here....3');

	}
=cut
	#my $config = Util::Basic->pconfig->{ 'MonitroServer' };
	##my $dp = new Util::MessageDispatch;
	#$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	#my $data = 
	#	{
	#		'node_index' 	 => '1',
	#		'server_ip'  	 => '1',
	#		'port'           => '1',
	#		'inserted_time'    => 0,
	#		'running_status' => 0,
	#		'server_type'    => 64,
	#		'txntype'        => 1001,
	#		'hostname'       => 'ttttt',

	#	};

	#my $buf = $dp->disptach( undef, 1001, $data );
	#dump( $buf );
	#my $tmp = $dp->disptach( undef, 1005, $data );
	#dump( $tmp );
	#
	#return  $buf;
};

get '/node_add' => sub {
	template 'node_add.tt2',
	{
     		'check_value'         =>  0 ,
		'check_tip'           =>  undef,
  	};
};

post '/node_addprocess' => sub {
	dump( params);
	my $failed = 0;
	my $tip ;
	if(  params->{nodeip} eq ""  ||   params->{nodealias} eq ""   ||   params->{nodeport} eq ""  ) {
	   	$failed = 1;
		$tip    = "提示:\n未填写完整信息,请确认完善节点资料!",
	
	} else {
		my $schema = Util::Basic->schema;
		my $nodeip =  params->{ nodeip } ;
		dump( $nodeip );
		my $node = $schema->resultset('Node')->get_noderow_throughip( $nodeip );
		dump( 'count is '.$node );
    		if( $node ne 0 ) {
			$failed  = 1;
			$tip    = "提示:\n该节点已被添加,请输入新节点信息!",
		} else {
		    	# comm to server and get server information from monitor server
			my $obj = new Util::TxnFlow ;
			my $nodeidx = time();
			my ( $rlt , $msg ) = $obj->add_node_and_initialinfo( $nodeidx ,params->{nodeip} , params->{nodeport} , params->{nodealias} , $schema );
			if( $rlt ne '000000' ) {
				return ($rlt ,$msg ); #forward error pages 
			
			}
			redirect '/node_view/1368867046';
		
		
		}
	}
	if( $failed ) {
		template 'node_add.tt2',
		{
				'check_value'         =>  $failed ,
				'check_tip'           =>  $tip ,
		};

	}
	template 'node_info.tt2',
	{
			'node_info'           =>  [ 'monitor_ip' , '127.0.0.1' , 'monitor_port' , '80' ],
			'node_index'          =>  121212,
	};
};




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
		#generate node_index
		#search have exist the node_index
		# timestamp as nodeindex
		my $nodeidx = time();
		#my $dp = new Util::MessageDispatch;
		##send 1001 create a new host monitor server
		#my $data = 
		#{
		#	'node_index' 	 => $nodeidx, 'server_ip'      => $serverip,  'port'           => $port,
		#	'inserted_time'  => 0,        'running_status' => 0,          'server_type'    => 64,
		#	'txntype'        => 1001,     'hostname'       => 'ttttt',
		#};
		#$dp->setting(  Util::Basic->pconfig->{'server_ip'} , Util::Basic->pconfig->{'port'} );
		#unless( $dp->disptach( undef, 1001 , $data ) ) {

		#	return 'error msg to client';
		#}
		#my $data = 
		#{
		#	'node_index' 	 => $nodeidx,
		#	'server_ip'  	 => $serverip,
		#	'port'           => $port,
		#	'insert_time'    => undef,
		#	'running_status' => undef,
		#	'server_type'    => undef,
		#}
		#my $dp = new Util::MessageDispatch;
		#$dp->disptach( undef, 1001 , $data );
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
		my $hostinfo = $schema->resultset('NodeSystemInfo')->search({
    			node_index => $nodeindex ,
  		});

   		template 'node_info.tt2',
		{
     			'node_info'           =>  $node->first ,
     			'host_info'           =>  $hostinfo->first ,
			'node_index'          =>  $nodeindex,
  		};	
	}
};

get '/node_svrcfgview/:node_index' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex =  params->{node_index} ;
		
		my $resultset = $schema->resultset('Node');
		my $node = $resultset->search({
    			node_index => $nodeindex ,
  		})->first;
		my $servertype = $resultset->get_nodeservertype( $nodeindex );
  		
		my $obj = Util::ServerTypeTool->new;	
		my $servertypehash = $obj->get_svrtype_hash( $servertype );

		my $typenums =  $obj->get_hassvrtype_nums ;
		my $tmp = $servertypehash;
   		template 'node_svrtypecfg.tt2',
		{
			'node_servertypes'    =>  $servertypehash,# /* monitor subsrv type */
			'node_index'          =>  $nodeindex,
			'type_nums'           =>  $typenums,
			'node'                =>  $node ,
			
  		};	
	}
};

post '/node_svrcfgokview' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex = params->{ node_index } ;
		my @types =  params->{ types } ;
		my @selected_items =  params->{ selected_items } ;
	        my %selected_tp_hash = Util::Tools->Array_Merge( @types , @selected_items );
		my $value = Util::Tools->GetBitValue( %selected_tp_hash );
		dump( $nodeindex  );
		dump( @types  );
		dump( @selected_items  );
		dump( %selected_tp_hash );
		dump( $value );
		my $result = 0;	
	
		my $resultset = $schema->resultset('Node') ;
		if( $resultset->update_nodeservertype( $schema ,'1' , $value ) ) { $result = 1 ; }

		template 'node_svrtypecfgok.tt2',
		{
		    	'db_result'    =>  $result ,
		};	 
	}

};



#process running nums setting
get '/process_paramcfg/:node_index' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex =  params->{node_index} ;
		my $node = $schema->resultset('Node')->search({
    			node_index => $nodeindex ,
  		})->first;
	        #process config information
        	my @node_processset = $schema->resultset('NodeProcessInfo')->search({
    			node_index => $nodeindex ,
  		})->all;
	        if(  scalar( @node_processset )  ){
			template 'node_processcfg.tt2',
			{
			 	'node_process'            =>  \@node_processset,
			 	'node'                    =>  $node ,
			};	 
		} else {
		        #initial config 
		        forward "404.html" ;
	        }
	}
};

#process_config ok
post '/param_processconfigok' => sub {
	if ( params->{node_index} =~ m/[~\^@\#&!\$\+_ ].*/g ) {
		forward "404.html" ;
	}
	else {
		my $schema = Util::Basic->schema;
		my $nodeindex = params->{ node_index } ;
		my $buf = undef;
		my @process_items =  params->{ process_items } ;
		my @process_setnums =  params->{ process_setnums } ;
		my $result = 0;	
		#merge hd_no => threhold 
		my %process_hash = Util::Tools->Array_Merge( @process_items , @process_setnums );
		my $resultset = $schema->resultset('NodeProcessInfo') ;
		if( $resultset->update_process_setnums( $schema ,$nodeindex, \%process_hash ) ) { $result = 1 ; }

		template 'node_processcfgok.tt2',
		{
		    	'db_result'    =>  $result ,
		};	 
	}

};

#hard_drive threhold setting
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
	        if(  scalar(@node_hdinfoset)  ){
		    template 'node_hdcfg.tt2',
		    {
		    	'node_hds'            =>  \@node_hdinfoset,
		    	'node'                =>  $node ,
		    };	 
		 } else {
		    # #initial config 
		    forward "404.html" ;
	         }
	}
};

#hd_config ok
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
		my %hd_hash = Util::Tools->Array_Merge( @hd_no_items , @threhold_items );

		my $resultset = $schema->resultset('NodeHdInfo') ;
		if( $resultset->update_hd_threhold( $schema ,$nodeindex, \%hd_hash ) ) { $result = 1 ; }

		template 'node_hdcfgok.tt2',
		{
		    	'db_result'    =>  $result ,
		};	 
	}

};

true;


