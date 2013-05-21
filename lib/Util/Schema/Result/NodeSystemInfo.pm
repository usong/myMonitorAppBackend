use utf8;
package Util::Schema::Result::NodeSystemInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeSystemInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_SYSTEM_INFO>

=cut

__PACKAGE__->table("NODE_SYSTEM_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 0
  size: 32

=head2 cpu_num

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [6,0]

=head2 cpu_process_info

  data_type: 'varchar2'
  is_nullable: 1
  size: 64

=head2 opsys_info

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 mm_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 mm_free_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 hd_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 hd_free_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 0, size => 32 },
  "cpu_num",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [6, 0],
  },
  "cpu_process_info",
  { data_type => "varchar2", is_nullable => 1, size => 64 },
  "opsys_info",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "mm_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "mm_free_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "hd_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "hd_free_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
);

=head1 PRIMARY KEY

=over 4

=item * L</node_index>

=back

=cut

__PACKAGE__->set_primary_key("node_index");
#__PACKAGE__->belongs_to( NODE=>'Util::Schema::Result::Node','node_index' );

# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-19 19:46:54
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:GrKtV9pm0Ra0OKk8plkwmQ


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
