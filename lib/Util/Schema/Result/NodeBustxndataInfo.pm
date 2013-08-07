use utf8;
package Util::Schema::Result::NodeBustxndataInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeBustxndataInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_BUSTXNDATA_INFO>

=cut

__PACKAGE__->table("NODE_BUSTXNDATA_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 busdata_set

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 busdata_time

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "busdata_set",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "busdata_time",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-08-07 16:27:36
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:L4s2+pa4yCU3BbQ39AU4Ig


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
