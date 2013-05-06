use utf8;
package Util::Schema::Result::NodeScheduling;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeScheduling

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_SCHEDULING>

=cut

__PACKAGE__->table("NODE_SCHEDULING");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 monitor_ip

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

=head2 server_type

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [2,0]

=head2 interval_time

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [8,0]

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "monitor_ip",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
  "server_type",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [2, 0],
  },
  "interval_time",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [8, 0],
  },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-03 22:37:07
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:oQJXPgNTU6+eNB8DolYysg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
