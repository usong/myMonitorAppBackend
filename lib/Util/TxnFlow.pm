package Util::TxnFlow;

use Moose;
use Util::Basic;
use Util::MessageDispatch;

sub add_node_and_initialinfo {

	my ( $self , $ip , $port ,$alias ) = @_;
	my $config = Util::Basic->pconfig->{ 'MonitroServer' };
    	my $dp = new Util::MessageDispatch;
	$dp->setting(  $config->{'server_ip'} , $config->{'port'} );
	my $nodeidx = time();
	my $data_1001 = 
	{
		'node_index' 	 => $nodeidx,
		'server_ip'  	 => $ip ,
		'port'           => $port,
		'inserted_time'  => 0,
		'running_status' => 0,
		'server_type'    => 0,
		'txntype'        => 1001,
		'hostname'       => $alias,
	
	};
	my $buf_1001 = $dp->disptach( undef, 1001, $data_1001 ); #1001  create a monitor server host
	unless( $buf_1001 ) {
		return undef ;
	}
	return  $buf_1001; #hash 1001

        my $data_1007 = 
	{
		'node_index' 	 => $nodeidx,
		'Cpunum'  	 => 0 ,
		'Cputype'        => 0,
		'Opsys_info'     => 0,
		'Mmsize'         => 0,
		'mmfreesize'     => 0,
		'hdsize'         => 0,
		'hdfreesize'     => 0,
		'txntype'        => 1007,
	
	};
	my $buf_1007 = $dp->disptach( undef, 1007, $data_1007 ); #1007  create a monitor server host
	unless( $buf_1007 ) {
		return undef ;
	}
	return  $buf_1001; #hash 1001


}

1;
