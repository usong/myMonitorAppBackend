use utf8;
package Util::Schema::Result::Node;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::Node

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODES>

=cut

__PACKAGE__->table("NODES");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 0
  size: 32

=head2 monitor_ip

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

=head2 monitor_port

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [6,0]

=head2 alias

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=head2 running_status

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [2,0]

=head2 server_type

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [2,0]

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 0, size => 32 },
  "monitor_ip",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
  "monitor_port",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [6, 0],
  },
  "alias",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
  "running_status",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [2, 0],
  },
  "server_type",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [2, 0],
  },
);

=head1 PRIMARY KEY

=over 4

=item * L</node_index>

=back

=cut

__PACKAGE__->set_primary_key("node_index");
__PACKAGE__->belongs_to( SYSINFO=>'Util::Schema::Result::NodeSystemInfo','node_index' );

# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-27 17:36:26
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:D+lbWsSIPu5CsgAc2Fseaw


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
