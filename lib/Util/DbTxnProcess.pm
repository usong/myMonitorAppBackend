package Util::DbTxnProcess; 

use Moose;

sub insert_node_and_sysinfo {

	my ( $self , $nodesrow , $sysinforow  , $schema ) = @_;

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
