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
		'txntype'        => 1001,
		'inserted_time'  => 0,
		'running_status' => 0,
		'server_type'    => 0,
		'hostname'       => Encode::encode('UTF-8', $alias),
		'cpunum'  	 => 0 ,
		'cputype'        => 0,
		'opsys_info'     => 0,
		'mmsize'         => 0,
		'mmfreesize'     => 0,
		'hdsize'         => 0,
		'hdfreesize'     => 0,
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
	$dp = undef;
	#......continue........
	
	########################################################################
	#1005 get host info
	########################################################################
	#$dp     = new Util::MessageDispatch;
	#$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	#my $data_1005 = 
	#{
	#	'node_index' 	 => $nodeindex,
	#	'cpunum'  	 => 0 ,
	#	'cputype'        => 0,
	#	'opsys_info'     => 0,
	#	'mmsize'         => 0,
	#	'mmfreesize'     => 0,
	#	'hdsize'         => 0,
	#	'hdfreesize'     => 0,
	#	'txntype'        => 1005,
	#
	#};
	#my $result_1005 = $dp->disptach( undef, 1005, $data_1005 ); #1005  create a monitor server host

	#unless( $result_1005 ) {
	#	dump( 'failed,here...here!' );
	#	return ( '999999' , 'comminication failed' );
	#}
	#
	#if( $result_1005->{ 'response_code' } ne '000000' ) {
	#	return ( $result_1005->{ 'response_code' } , $result_1005->{ 'response_msg' } );
	#} 
	#
	#$dp = undef;
	########################################################################
	#1030 get nodehd info
	########################################################################
	$dp     = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	my $data_1030 = 
	{
		'node_index' 	 => $nodeindex,
		'hd_name'  	 => '0' ,
		'hd_size'        => '0',
		'hd_used'  	 => 0,
		'hd_free'        => 0,
		'hd_threhold'    => 0,
		'hd_usepercent'  => 0,
		'insert_time'    => 0,
		'txntype'        => 1030,
	};
	my $result_1030 = $dp->disptach( undef, 1030, $data_1030 ); #1030  create a monitor server host
	#dump( $result_1030 );	
	unless( $result_1030 ) {
		dump( $result_1030);
		dump( 'failed!' );
		return ( '999999' , 'comminication failed' );
	}
	if( $result_1030->{ 'response_code' } ne '000000' ) {
		return ( $result_1030->{ 'response_code' } , $result_1030->{ 'response_msg' } );
	}
	else {
		#dump( $result_1001 );
		#dump( $result_1005 );
		#dump( $result_1030 );
		my  $obj = new Util::DbTxnProcess;
		if( $obj->insert_node_and_sysinfo( $nodeindex , $result_1001,  $result_1030 , $schema  ) ) {
			return ( '888888' , '1001_1005_1030_database process failed' );
		}
		return ( $result_1030->{ 'response_code' } , $result_1030->{ 'response_msg' } );
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

sub add_backuppath {
	my ( $self , $nodeindex , $filehandle  ) = @_;
	my  $schema = Util::Basic->schema;
	my  $obj = new Util::DbTxnProcess;
	if( $obj->insert_backup_path( $nodeindex , $filehandle,   $schema  ) ) {
		return ( '888888' , '1001_1005_1030_database process failed' );
	}
	return ( '000000' , 'succesfully!' );
}	




1;
