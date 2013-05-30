use utf8; 
package Util::BackupTypeTool;
use Moose;
with 'Util::Role::BackupType';
use Data::Dump qw/dump/;
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

sub get_hassvrtype_hash {
	my $self = shift;
	$self->types;
}


sub getvalue_from_typestring {
	my $self = shift;
	my $str  = shift;
	my $value = 0;
	return  undef unless ( length( $str ) == $self->size );
	my $size = $self->size - 1 ;
	foreach ( 0..$self->size-1 ) {
		$value += $self->types->{ $self->type_ix->[ $_ ] }->{ 'value' }  #important : through type_ix which is array , get tyes keys
			if( unpack( "x$_ A1" , $str ) == '1' );
    	}
	return $value;
}

sub getstring_from_typevalue {
	my $self   = shift;
	my $value  = shift;
	my $string = "";
	$self->get_svrtype_hash( $value );
	foreach ( 1..$self->size  ) {
		if( $self->types->{ $_ }->{ 'has_types' }  ) {
			$string = $string . '1';
		}
		else {
    			$string = $string . '0';
		}
	}
	return $string;
}

1;
