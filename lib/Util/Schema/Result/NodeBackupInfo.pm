use utf8;
package Util::Schema::Result::NodeBackupInfo;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeBackupInfo

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_BACKUP_INFO>

=cut

__PACKAGE__->table("NODE_BACKUP_INFO");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 backup_time

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

=head2 backup_ftp

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 backup_param

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 backup_desc

  data_type: 'varchar2'
  is_nullable: 1
  size: 512

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "backup_time",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
  "backup_ftp",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "backup_param",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "backup_desc",
  { data_type => "varchar2", is_nullable => 1, size => 512 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-03 22:37:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Xc3CdeaoPcS5U5dbK1dVRA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
