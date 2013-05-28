use utf8;
package Util::Schema::Result::NodeHdInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeHdInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_HD_INFO>

=cut

__PACKAGE__->table("NODE_HD_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 hd_no

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 hd_no_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 hd_used_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 hd_free_size

  data_type: 'varchar2'
  is_nullable: 1
  size: 12

=head2 hd_threhold

  data_type: 'varchar2'
  is_nullable: 1
  size: 6

=head2 hd_usepercent

  data_type: 'varchar2'
  is_nullable: 1
  size: 6

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "hd_no",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "hd_no_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "hd_used_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "hd_free_size",
  { data_type => "varchar2", is_nullable => 1, size => 12 },
  "hd_threhold",
  { data_type => "varchar2", is_nullable => 1, size => 6 },
  "hd_usepercent",
  { data_type => "varchar2", is_nullable => 1, size => 6 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-27 17:36:29
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:4IDGrD88gJ45932ZJJKCBg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
