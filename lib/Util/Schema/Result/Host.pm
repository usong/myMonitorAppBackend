use utf8;
package Util::Schema::Result::Host;

# Created by DBIx::Class::Schema::Loader
# DO NOT MODIFY THE FIRST PART OF THIS FILE

=head1 NAME

Util::Schema::Result::Host

=cut

use strict;
use warnings;

use base 'DBIx::Class::Core';

=head1 TABLE: C<host>

=cut

__PACKAGE__->table("host");

=head1 ACCESSORS

=head2 remoteport

  data_type: 'numeric'
  is_nullable: 1

=head2 ip

  data_type: 'varchar'
  is_nullable: 1
  size: 15

=cut

__PACKAGE__->add_columns(
  "remoteport",
  { data_type => "numeric", is_nullable => 1 },
  "ip",
  { data_type => "varchar", is_nullable => 1, size => 15 },
);


# Created by DBIx::Class::Schema::Loader v0.07035 @ 2013-03-28 14:32:33
# DO NOT MODIFY THIS OR ANYTHING ABOVE! md5sum:Z91/6lAKsrbRmpogQVkVvA


# You can replace this text with custom code or comments, and it will be preserved on regeneration
1;
