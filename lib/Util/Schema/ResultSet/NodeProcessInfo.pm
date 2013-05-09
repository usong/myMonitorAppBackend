use utf8;
package Util::Schema::ResultSet::NodeProcessInfo;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;

sub update_process_setnums {
	my ( $self , $schema ,$nodeindex, $nodeprocess ) = @_;
	#update or insert process_setnums
	eval {	
		$schema->txn_begin();
		for my $process ( keys %{ $nodeprocess } ) {
			my $processsets = $self->search({
				node_index => $nodeindex ,
				process_no => $process   ,
			});
			$processsets->update( { 'process_setnum' => $nodeprocess->{ $process }  } );
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
	my ( $self , $schema ,$nodeindex, $nodehds ) = @_;
	#insert process_info
        return 0;
}

