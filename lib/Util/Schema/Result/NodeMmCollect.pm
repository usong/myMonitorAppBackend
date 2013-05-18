use utf8;
package Util::Schema::Result::NodeMmCollect;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeMmCollect

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_MM_COLLECT>

=cut

__PACKAGE__->table("NODE_MM_COLLECT");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 mm_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 mm_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 mm_free

  data_type: 'varchar2'
  is_nullable: 1
  size: 6

=head2 swap_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 swap_used

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 swap_free

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "mm_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "mm_used",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "mm_free",
  { data_type => "varchar2", is_nullable => 1, size => 6 },
  "swap_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "swap_used",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "swap_free",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-18 16:26:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:vRkE6wE/Esp54+QqY8eMCg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
