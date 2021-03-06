use utf8;
package Util::Schema::ResultSet::Node;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;

sub get_noderow_throughip {
	my ( $self  ,$ip ) = @_;

	my $node = $self->search({
		monitor_ip => $ip ,
	});
	return $node->count;

}

sub get_nodeservertype {
	my ( $self  ,$nodeindex ) = @_;

	my $node = $self->search({
		node_index => $nodeindex ,
	})->first;
	return $node->server_type;

}
sub update_nodeservertype {
	my ( $self , $schema ,$nodeindex, $svrtypevalue ) = @_;
	eval {	
		$schema->txn_begin();
		my $typeset = $self->search({
			node_index => $nodeindex ,
		});
		$typeset->update( { 'server_type' => $svrtypevalue  } );
	};
	if( $@ ) { 
		print "Failed Manutiplate Database UpData or Insert,\n" ;
		$schema->txn_rollback();
		return 1;
	} 
        $schema->txn_commit();
        return 0;
}

sub insert_noderow {
	my ( $self , $row , $schema ) = @_;
	#insert node_hd_info
	eval {	
		$schema->txn_begin();
	
		$self->create({
		     'node_index' 	 => $row->{'node_index'},
		     'monitor_ip'  	 => $row->{'server_ip'} ,
		     'monitor_port'      => $row->{'port'},
		     'alias'             => $row->{'hostname'},
		     'inserted_times'    => $row->{'inserted_time'},
		     'running_status'    => $row->{'running_status'},
		     'server_type'       => $row->{'server_type'}
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

sub insert_servertype {
	my ( $self , $schema ,$nodeindex, $nodehds ) = @_;
	#insert node_hd_info
	eval {	
		$schema->txn_begin();
		for my $hd ( keys %{ $nodehds } ) {
			my $hdinfosets = $self->search({
				node_index => $nodeindex ,
				hd_no      => $hd        ,
			});
		     	$hdinfosets->create( { 
				'hd_no'       => $hd  ,
				'hd_no_size'  => $hd  ,#$nodehds->{ $hd }->{ 'hd_no_size'  } ,
				'hd_threhold' => $hd  ,#$nodehds->{ $hd }->{ 'hd_threhold' } ,
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

