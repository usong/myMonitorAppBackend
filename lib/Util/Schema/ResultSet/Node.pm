use utf8;
package Util::Schema::ResultSet::Node;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;


sub get_nodeservertype {
	my ( $self  ,$nodeindex ) = @_;

	my $node = $self->search({
		node_index => $nodeindex ,
	})->first;
	return $node->server_type;

}
sub update_servertype {
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
