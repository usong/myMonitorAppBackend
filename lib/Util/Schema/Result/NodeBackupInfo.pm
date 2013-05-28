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

=head2 backup_no

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 backup_servers

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,0]

=head2 backup_time

  data_type: 'varchar2'
  is_nullable: 1
  size: 8

=head2 backup_prename

  data_type: 'varchar2'
  is_nullable: 1
  size: 20

=head2 backup_dir

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 backup_interval

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,0]

=head2 ftp_username

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 ftp_passwd

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 ftp_ip

  data_type: 'varchar2'
  is_nullable: 1
  size: 15

=head2 ftp_path

  data_type: 'varchar2'
  is_nullable: 1
  size: 128

=head2 del_interval

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,0]

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "backup_no",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "backup_servers",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 0],
  },
  "backup_time",
  { data_type => "varchar2", is_nullable => 1, size => 8 },
  "backup_prename",
  { data_type => "varchar2", is_nullable => 1, size => 20 },
  "backup_dir",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "backup_interval",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 0],
  },
  "ftp_username",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "ftp_passwd",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "ftp_ip",
  { data_type => "varchar2", is_nullable => 1, size => 15 },
  "ftp_path",
  { data_type => "varchar2", is_nullable => 1, size => 128 },
  "del_interval",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 0],
  },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-27 17:36:28
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:t1C9DM3jaWK63q6ztqQWsg


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
