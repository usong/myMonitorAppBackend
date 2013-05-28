use utf8; 
package Util::BackupTypeTool;
use Moose;
with 'Util::Role::BackupType';

sub get_svrtype_hash {
	my ( $self , $svrtypevalue ) = @_;
	my $pos = 1;
	my $value = 0;
	my %hash = %{ $self->types };
	do {
            if( $svrtypevalue & 0x01) {
	        if( exists $hash{ $pos } ) {
	       	    $hash{ $pos }{ 'has_types' } = 1;
	        } else { print 'overflow defined process !'; exit(0) }
	        $value = $value + 2**($pos-1);
	    }
	} while (  ( $svrtypevalue = $svrtypevalue >> 1 ) && ( $pos++ ) );
	return $self->types;
}

sub get_hassvrtype_nums {
	my $self = shift;
	my @type = grep { $self->types->{ $_ }->{ 'has_types' } eq 1  } 1..3 ;
	return scalar  @type;
}
1;
