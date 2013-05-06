package Util::MonitorSvrSerial;

use Moose;

with 'Util::Message';

sub check_msgvalid {
    my ( $self, $data ) = shift;
    confess 'msghead  invaild ,checking the datagram '  
    	unless ( exists $data->{ 'TxnType' } &&  
		 exists $data->{ 'Version' } &&
		 exists $data->{ 'Record_amount' } &&
		 exists $data->{ 'Response_code' } &&
		 exists $data->{ 'Record_length' } 
	       )

     confess 'msgbody  invaild ,checking the datagram '  
    	unless ( exists $data->{ 'Node_index' } &&  
		 exists $data->{ 'Ip' } &&
		 exists $data->{ 'Port' } &&
		 exists $data->{ 'Inserted_time' } &&
		 exists $data->{ 'Running_status' } &&
		 exists $data->{ 'Server_type' }
	       )
}

sub 1001_pack {
    my ( $self, $data ) = shift;
    $self->check_msgvalid( $data );	

    my $buf = undef;
    $buf = pack('A4 A2 A4 A6 A4 A32 A16 A6 A14 A2 A2' , values %$data );
    $sele->MsgHead( unpack( 'A20' , $buf   );
    $sele->MsgBody( unpack( 'x20 A*' , $buf );
}
sub 1001_unpack {
    my $self = shift;
}

1;
