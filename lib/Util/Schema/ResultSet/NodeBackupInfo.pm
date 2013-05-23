use utf8;
package Util::Schema::ResultSet::NodeBackupInfo;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;

sub get_node_backinfo_row {
	my ( $self  , $nodeindex ) = @_;

	my $backinforow = $self->search({
		node_index => $nodeindex ,
	});
	return $backinforow->count;
}
