use utf8;
package Util::Schema::Result::NodeEvent;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeEvent

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_EVENT>

=cut

__PACKAGE__->table("NODE_EVENT");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 event_type

  data_type: 'varchar2'
  is_nullable: 1
  size: 5

=head2 event_time

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=head2 event_priority

  data_type: 'varchar2'
  is_nullable: 1
  size: 4

=head2 event_desc

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "event_type",
  { data_type => "varchar2", is_nullable => 1, size => 5 },
  "event_time",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
  "event_priority",
  { data_type => "varchar2", is_nullable => 1, size => 4 },
  "event_desc",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-29 15:11:05
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:m7wmPMysaG+thd4Icf4/oQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
