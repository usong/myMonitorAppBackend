package Util::DbTxnProcess; 

use Moose;
use Data::Dump qw/dump/;
use POSIX qw(strftime); 
sub insert_node_and_sysinfo {

	my ( $self , $nodeindex , $nodesrow ,  $hdrowarray ,  $schema ) = @_;

	#dump( $nodesrow );
	#dump( strftime( "%Y%m%d%H%M%S", localtime(time) ) );
	eval {	
		$schema->txn_begin();
		#insert nodes table 

		my $node = $schema->resultset('Node');
		$node->create({
		     'node_index' 	 => $nodesrow->{'node_index'},
		     'monitor_ip'  	 => $nodesrow->{'server_ip'} ,
		     'monitor_port'      => $nodesrow->{'port'},
		     'alias'             => $nodesrow->{'hostname'},
		     'inserted_times'    => strftime( "%Y%m%d%H%M%S", localtime(time) ),
		     'running_status'    => $nodesrow->{'running_status'},
		     'server_type'       => $nodesrow->{'server_type'}
		});
		#insert sysinfo
		
		my $sysinfo = $schema->resultset('NodeSystemInfo');
		$sysinfo->create({
		     'node_index' 	 => $nodesrow->{'node_index'},
		     'cpu_num'  	 => $nodesrow->{'cpunum'} ,
		     'cpu_process_info'  => $nodesrow->{'cputype'},
		     'opsys_info'        => $nodesrow->{'opsys_info'},
		     'mm_size'    	 => $nodesrow->{'mmsize'},
		     'mm_free_size'      => $nodesrow->{'mmfreesize'},
		     'hd_size'           => $nodesrow->{'hdsize'},
		     'hd_free_size'      => $nodesrow->{'hdfreesize'}
		});
		#$sysinfo->create({
		#'node_index' 	 => $sysinforow->{'node_index'},
		#	     'cpu_num'  	 => $sysinforow->{'cpunum'} ,
		#	     'cpu_process_info'  => $sysinforow->{'cputype'},
		#	     'opsys_info'        => $sysinforow->{'opsys_info'},
		#	     'mm_size'    	 => $sysinforow->{'mmsize'},
		#	     'mm_free_size'      => $sysinforow->{'mmfreesize'},
		#	     'hd_size'           => $sysinforow->{'hdsize'},
		#	     'hd_free_size'      => $sysinforow->{'hdfreesize'}
		#	});
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
				'inserted_times' => strftime( "%Y%m%d%H%M%S", localtime(time) ) ,
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

sub insert_backup_path {

	my ( $self ,$node_index, $filehandle , $schema ) = @_;
	eval {	
		$schema->txn_begin();
		#insert nodes table 
		my $ix = 1;
		while( <$filehandle> ) {
			my $backup = $schema->resultset('NodeBackupInfo');
			$backup->create({
			     'node_index' 	 => $node_index,
			     'backup_no'         => $ix++,
			     'backup_servers'  	 => '0',
			     'backup_time'  	 => '0',
			     'backup_prename'  	 => '0',
			     'backup_dir'  	 => $_,
			     'backup_interval'   => '0',
			     'ftp_username'      => '0',
			     'ftp_passwd'        => '0',
			     'ftp_ip'       	 => '0',
			     'ftp_path'        	 => '0',
			     'del_interval'      => '0',
			     'inserted_times'    => strftime( "%Y%m%d%H%M%S", localtime(time) ),
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
