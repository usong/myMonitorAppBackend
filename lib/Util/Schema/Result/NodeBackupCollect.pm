use utf8;
package Util::Schema::Result::NodeBackupCollect;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::NodeBackupCollect

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<NODE_BACKUP_COLLECT>

=cut

__PACKAGE__->table("NODE_BACKUP_COLLECT");

=head1 ACCESSORS

=head2 node_index

  data_type: 'varchar2'
  is_nullable: 1
  size: 32

=head2 backupexec_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=head2 backup_servers

  data_type: 'numeric'
  is_nullable: 1
  original: {data_type => "number"}
  size: [4,0]

=head2 backup_resultdesc

  data_type: 'varchar2'
  is_nullable: 1
  size: 1024

=head2 inserted_times

  data_type: 'varchar2'
  is_nullable: 1
  size: 14

=cut

__PACKAGE__->add_columns(
  "node_index",
  { data_type => "varchar2", is_nullable => 1, size => 32 },
  "backupexec_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
  "backup_servers",
  {
    data_type => "numeric",
    is_nullable => 1,
    original => { data_type => "number" },
    size => [4, 0],
  },
  "backup_resultdesc",
  { data_type => "varchar2", is_nullable => 1, size => 1024 },
  "inserted_times",
  { data_type => "varchar2", is_nullable => 1, size => 14 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-05-29 15:11:04
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:R2iyWmsTSoJYp1Sx7mbMYA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
