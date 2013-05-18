use utf8;
package Util::Schema::ResultSet::NodeSystemInfo;

use Moose; 
extends qw/DBIx::Class::ResultSet DBIx::Class::Schema  DBIx::Class::Storage/;

sub get_node_systeminfo {
	my ( $self  ,$nodeindex ) = @_;

	my $node = $self->search({
		node_index => $nodeindex ,
	})->first;
	return $node;
}

