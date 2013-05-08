use utf8;
package Util::Schema::Result::NodeProcessInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeProcessInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_PROCESS_INFO>

=cut

__PACKAGE__->table("NODE_PROCESS_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 process_no

  data_type: 'varchar2'
  is_nullable: 1
  size: 60

=head2 process_status

  data_type: 'varchar2'
  is_nullable: 1
  size: 5

=head2 process_runnum

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [3,0]

=head2 process_setnum

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [3,0]

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "process_no",
  { data_type => "varchar2", is_nullable => 1, size => 60 },
  "process_status",
  { data_type => "varchar2", is_nullable => 1, size => 5 },
  "process_runnum",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [3, 0],
  },
  "process_setnum",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [3, 0],
  },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-07 10:05:46
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:OoRjSb/edBPUQJaoo1b8Nw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
