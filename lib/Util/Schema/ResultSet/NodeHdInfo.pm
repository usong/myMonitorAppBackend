use utf8;
package Util::Schema::ResultSet::NodeHdInfo;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;

sub get_node_hdinfo {
	my ( $self  ,$nodeindex ) = @_;

	my $node = $self->search({
		node_index => $nodeindex ,
	});
	return $node->count;
}


sub update_hd_threhold {
	my ( $self , $schema ,$nodeindex, $nodehds ) = @_;
	#update or insert node_hd_info
	
	eval {	
		$schema->txn_begin();
		for my $hd ( keys %{ $nodehds } ) {
			my $hdinfosets = $self->search({
				node_index => $nodeindex ,
				hd_no      => $hd        ,
			});
			$hdinfosets->update( { 'hd_threhold' => $nodehds->{ $hd }  } );
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

sub insert_hd_info {
	my ( $self , $schema ,$nodeindex, $nodehds ) = @_;
	#insert node_hd_info
	eval {	
		$schema->txn_begin();
		for my $hd (  @$nodehds  ) {
		     	$self->create( { 
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
