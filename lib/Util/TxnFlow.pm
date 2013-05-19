package Util::TxnFlow;

use Moose;
use Util::Basic;
use Util::MessageDispatch;
use Util::DbTxnProcess;
use Data::Dump qw/dump/;

sub add_node_and_initialinfo {

	my ( $self , $nodeindex,  $ip , $port ,$alias , $schema ) = @_;
	my $config = Util::Basic->pconfig->{ 'MonitroServer' };
    	my $dp     = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	
	my $data_1001 = 
	{
		'node_index' 	 => $nodeindex,
		'server_ip'  	 => $ip ,
		'port'           => $port,
		'inserted_time'  => 0,
		'running_status' => 0,
		'server_type'    => 0,
		'txntype'        => 1001,
		'hostname'       => Encode::encode('UTF-8', $alias),
	
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
	#......continue........
	$dp = undef;
	########################################################################
	#1007 get host info
	########################################################################
	$dp     = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	my $data_1005 = 
	{
		'node_index' 	 => $nodeindex,
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
		dump( 'failed,here...here!' );
		return ( '999999' , 'comminication failed' );
	}
	
	if( $result_1005->{ 'response_code' } ne '000000' ) {
		return ( $result_1005->{ 'response_code' } , $result_1005->{ 'response_msg' } );
	} else {
		#dump( $result_1005 );
		#return ( '000000' ,'here....3');
		#insert into nodes node_system_info 
		my $obj = new Util::DbTxnProcess;	
		dump( $result_1001 );
		dump( $result_1005 );
		if( $obj->insert_node_and_sysinfo( $result_1001, $result_1005 , $schema  ) ) {
			return ( '888888' , '1001_1005_database process failed' );
		}
		return ( $result_1005->{ 'response_code' } , $result_1005->{ 'response_msg' } );

	}
}

sub add_nodesvrtype {
	my ( $self , $nodeindex ,$svrtype ) = @_;
	my $schema = Util::Basic->schema;
	my $config = Util::Basic->pconfig->{ 'MonitroServer' };
    	my $dp     = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );

	my $resultset = $schema->resultset('Node') ;

	my $node = $resultset->search({ node_index => $nodeindex  })->first;	

	my $data_1003 = 
	{
		'node_index' 	 => $nodeindex,
		'server_ip'  	 => $node->monitor_ip ,
		'port'           => $node->monitor_port ,
		'inserted_time'  => 0,
		'running_status' => 0,
		'server_type'    => $svrtype,
		'txntype'        => 1003,
		'hostname'       => $node->alias,
	};
	my $result_1003 = $dp->disptach( undef, 1003, $data_1003 ); #1001  create a monitor server host

	unless( $result_1003 ) {
		return ( '999999' , 'comminication failed' );
	}
	if( $result_1003->{ 'response_code' } ne '000000' ) {
		return ( $result_1003->{ 'response_code' } , $result_1003->{ 'response_msg' } );
	}else {
		if( $resultset->update_nodeservertype( $schema , $nodeindex , $svrtype ) )
	       	{ 
			return ( '888888' , '1003_database process failed' );
		}
		return ( $result_1003->{ 'response_code' } , $result_1003->{ 'response_msg' } );
	}	

}	


1;
