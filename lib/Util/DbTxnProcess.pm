package Util::DbTxnProcess; 

use Moose;
use Data::Dump qw/dump/;
use POSIX qw(strftime); 
use Util::BackupTypeTool;
use Encode;

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
		     'alias'             => Encode::encode( 'gb2312' , Encode::decode( 'UTF-8',$nodesrow->{'hostname'} ) ),
		     #'alias'             => $nodesrow->{'hostname'} ,
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

	my ( $self ,$node_index , $content, $schema ) = @_;
	eval {	
		$schema->txn_begin();
		#insert nodes table 
		my $ix = 1;
		my $backup = $schema->resultset('NodeBackupInfo');
		my $typeset = $backup->search({
			node_index => $node_index ,
		});	
		$typeset->delete;
		$content = Encode::decode("gb2312",$content);
		dump( $content );
		my @lines = split( "\r\n" , $content );
		for my $line ( @lines ) {
			my $backup = $schema->resultset('NodeBackupInfo');
			$line = Encode::encode( 'gb2312' ,  $line  );
			$backup->create({
			     'node_index' 	 => $node_index,
			     'backup_no'         => $ix++,
			     'backup_servers'  	 => '0',
			     'backup_time'  	 => '00:00',
			     'backup_prename'  	 => '/',
			     'backup_dir'  	 =>  $line ,
			     'backup_interval'   => '0',
			     'ftp_username'      => '',
			     'ftp_passwd'        => '',
			     'ftp_ip'       	 => '',
			     'ftp_path'        	 => '/',
			     'del_interval'      => '0',
			     'inserted_times'    => strftime( "%Y%m%d%H%M%S", localtime(time) ),
			});
		}
		#while( <$filehandle> ) {
		#	my $backup = $schema->resultset('NodeBackupInfo');
		#	$_ =~ s/\r?\n//g;
		#	$_ =~ s/\x{FEFF}//ig;
		#	$backup->create({
		#	     'node_index' 	 => $node_index,
		#	     'backup_no'         => $ix++,
		#	     'backup_servers'  	 => '0',
		#	     'backup_time'  	 => '00:00',
		#	     'backup_prename'  	 => '/',
		#	     'backup_dir'  	 => $_,
		#	     'backup_interval'   => '0',
		#	     'ftp_username'      => '',
		#	     'ftp_passwd'        => '',
		#	     'ftp_ip'       	 => '',
		#	     'ftp_path'        	 => '/',
		#	     'del_interval'      => '0',
		#	     'inserted_times'    => strftime( "%Y%m%d%H%M%S", localtime(time) ),
		#	});
		#}
	};
	if( $@ ) { 
		print "Failed Manutiplate Database UpData or Insert,\n" ;
		$schema->txn_rollback();
		return 1;
	} 
	$schema->txn_commit();
	return 0;
}



sub update_backuppara_path {

	my ( $self ,$node_index, $data , $schema ) = @_;
	eval {	
		$schema->txn_begin();
		#insert nodes table 
		my $backup = $schema->resultset('NodeBackupInfo');
		for my $row ( @{ $data->{'row'} } ) {
			my $obj = new Util::BackupTypeTool;
			$row->[6] = $obj->getvalue_from_typestring( $row->[6] );
			my $typeset = $backup->search({
				node_index => $node_index ,
				backup_no  => $row->[0]  ,
			});
			
			my $time = $data->{"backuptime"};
			$time =~ s/:/-/g;
			$typeset->update( { 
					'backup_time' 	  => $time , 
					'backup_interval' => $row->[4]  , 
					'del_interval' 	  => $row->[5]  , 
					'ftp_path' 	  => $row->[3]  ,
					'backup_prename'  => $row->[2]  ,
					'ftp_username' 	  => $data->{"ftpuser"}  , 
					'ftp_passwd' 	  => $data->{"ftppwd"}  , 
					'ftp_ip' 	  => $data->{"ftpip"}  , 
					'ftp_port' 	  => $data->{"ftpport"}  , 
					'backup_servers'  => $row->[6]  , 
			} );
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




sub insert_process_info {

	my ( $self ,$node_index, $filehandle , $schema ) = @_;
	eval {	
		$schema->txn_begin();
		#insert nodes table 
		my $ix = 1;
		my $process = $schema->resultset('NodeProcessInfo');
		my $typeset = $process->search({
			node_index => $node_index ,
		});	
		$typeset->delete;
		while( <$filehandle> ) {
			$_ =~ s/\r?\n//g;
			$_ =~ s/\x{FEFF}//ig;
			$process->create({
			     'node_index' 	 => $node_index,
			     'process_no'        => $_,
			     'process_desc'  	 => '0',
			     'process_status'  	 => '0',
			     'process_runnum'  	 => '0',
			     'process_setnum'  	 => '0',
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


sub insert_alertpath_info {

	my ( $self ,$node_index, $filehandle , $schema ) = @_;
	eval {	
		$schema->txn_begin();
		#insert nodes table 
		my $ix = 1;
		my $process = $schema->resultset('NodeOraclealertpathInfo');
		my $typeset = $process->search({
			node_index => $node_index ,
		});	
		$typeset->delete;
		while( <$filehandle> ) {
			$_ =~ s/\r?\n//g;
			$_ =~ s/\x{FEFF}//ig;
			$process->create({
			     'node_index' 	 => $node_index,
			     'logpath'           => $_,
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


sub insert_busdata {
	my ( $self ,$node_index , $data, $schema ) = @_;
	eval {	
		$schema->txn_begin();
		my $ix = 1;
		my $busdata = $schema->resultset('NodeBustxndataInfo');
		my $typeset = $busdata->search({
			node_index => $node_index ,
		});	
		$typeset->delete;
		for my $row ( @{ $data->{'row'} } ) {
			$busdata->create({
			     'node_index' 	 => $node_index,
			     'busdata_set'       => $row->[1],
			     'busdata_time'  	 => $row->[0],
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
