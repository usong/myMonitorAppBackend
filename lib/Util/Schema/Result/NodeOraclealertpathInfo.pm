use utf8;
package Util::Schema::Result::NodeOraclealertpathInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeOraclealertpathInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_ORACLEALERTPATH_INFO>

=cut

__PACKAGE__->table("NODE_ORACLEALERTPATH_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 logpath

  data_type: 'varchar2'
  is_nullable: 1
  size: 256

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "logpath",
  { data_type => "varchar2", is_nullable => 1, size => 256 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-06-24 16:17:24
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:dVItqUCvM843TRXXFiGu+g


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
