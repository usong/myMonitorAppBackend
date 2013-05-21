package Util::DbTxnProcess; 

use Moose;
use Data::Dump qw/dump/;
sub insert_node_and_sysinfo {

	my ( $self , $nodeindex , $nodesrow , $sysinforow  , $hdrowarray ,  $schema ) = @_;


	eval {	
		$schema->txn_begin();
		#insert nodes table 
                my $node = $schema->resultset('Node');
		$node->create({
		     'node_index' 	 => $nodesrow->{'node_index'},
		     'monitor_ip'  	 => $nodesrow->{'server_ip'} ,
		     'monitor_port'      => $nodesrow->{'port'},
		     'alias'             => $nodesrow->{'hostname'},
		     'inserted_times'    => $nodesrow->{'inserted_time'},
		     'running_status'    => $nodesrow->{'running_status'},
		     'server_type'       => $nodesrow->{'server_type'}
		});
		#insert sysinfo
		my $sysinfo = $schema->resultset('NodeSystemInfo');
		$sysinfo->create({
		     'node_index' 	 => $sysinforow->{'node_index'},
		     'cpu_num'  	 => $sysinforow->{'cpunum'} ,
		     'cpu_process_info'  => $sysinforow->{'cputype'},
		     'opsys_info'        => $sysinforow->{'opsys_info'},
		     'mm_size'    	 => $sysinforow->{'mmsize'},
		     'mm_free_size'      => $sysinforow->{'mmfreesize'},
		     'hd_size'           => $sysinforow->{'hdsize'},
		     'hd_free_size'      => $sysinforow->{'hdfreesize'}
		});
		#insert hdinfo
		my $hdinfo = $schema->resultset('NodeHdInfo');
		foreach my $hd (  @{ $hdrowarray->{'rows'} }  ) {
		     	$hdinfo->create( { 
				'node_index'     => $nodeindex,
				'hd_no'          => $hd->{'hd_no'}  ,
				'hd_no_size'     => $hd->{'hd_no_size'}  ,
				'hd_used_size'   => $hd->{'hd_used_size'}  ,
				'hd_free_size'   => $hd->{'hd_free_size'}  ,
				'hd_threhold'    => $hd->{'hd_threhold'}  ,
				'hd_usepercent'  => $hd->{'hd_usepercent'}  ,
				'inserted_times' => $hd->{'inserted_times'}  ,
			});
        	}
            
	};
	if( $@ ) { 
		print "Failed Manutiplate Database UpData or Insert,\n" ;
		$schema->txn_rollback();
		return 1;
	} 
	$schema->txn_commit();
	return 0;
}


1;
