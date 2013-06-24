package Util::Role::MonitorSvrSerial::1003;

use Moose::Role;
use 5.010;
with 'Util::Role::Message';
use Data::Dump qw/dump/;
use FindBin;

sub get_Head_Format { 
	my $self = shift; 
	return "A2 A4 A4 A6 A4 A24"; 
}
sub get_Body_Format { 
	my $self = shift; 
	return "A32 A15 A6 A64 A14 A2 A2 A6 A64 A32 A12 A12 A12 A12" 
}

#############################
#send to server package begin 
#############################
sub pre_headpack {
    my ( $self, $data ) = @_;
    #check data value
    my $head_hash = {
	'version' => '01',
	'txnType' => $data->{ 'txntype' },
	'record_amount' => '0001',
	'response_code' => '000000',
	'record_length' => '0071',
 	'response_msg'  => '0',
    };
    $self->MsgHead(
	    pack(   $self->get_Head_Format , 
	    	    $head_hash->{'version'},
		    $head_hash->{'txnType'}, 
		    $head_hash->{'record_amount'}, 
		    $head_hash->{'response_code'}, 
		    $head_hash->{'record_length'}, 
		    $head_hash->{'response_msg'}, 
	      )
    );
}

sub pre_bodypack {
    my ( $self, $data ) = @_;
    #check data value
    my $body_hash = {
	#'node_index'          => '0' x ( 32 - length ( $data->{ 'node_index' } ) ) . $data->{ 'node_index' } ,
	'node_index'          => $data->{ 'node_index' },
	'server_ip'           => $data->{ 'server_ip' },
	'port'                => '0' x ( 6 - length ( $data->{ 'port' } ) ) . $data->{ 'port' },
	'hostname'            => $data->{ 'hostname' },
	'inserted_time'       => $data->{ 'inserted_time' },
	'running_status'      => $data->{ 'running_status' },
	'server_type'         => $data->{ 'server_type' },
	'cpunum'              => $data->{ 'cpunum' },
	'cputype'             => $data->{ 'cputype' },
	'opsys_info'          => $data->{ 'opsys_info' },
	'mmsize'              => $data->{ 'mmsize' },
	'mmfreesize'          => $data->{ 'mmfreesize' },
	'hdsize'              => $data->{ 'hdsize' },
	'hdfreesize'          => $data->{ 'hdfreesize' },
    };
    say '1003', $self->get_Body_Format; 
    $self->MsgBody(
	    pack(   $self->get_Body_Format , 
	    	    $body_hash->{'node_index'},
		    $body_hash->{'server_ip'}, 
		    $body_hash->{'port'}, 
		    $body_hash->{'hostname' },
		    $body_hash->{'inserted_time'}, 
		    $body_hash->{'running_status'}, 
		    $body_hash->{'server_type'}, 
		    $body_hash->{'cpunum'}, 
		    $body_hash->{'cputype'}, 
		    $body_hash->{'opsys_info' },
		    $body_hash->{'mmsize'}, 
		    $body_hash->{'mmfreesize'}, 
		    $body_hash->{'hdsize'}, 
		    $body_hash->{'hdfreesize'},
	      )
    );
}
#############################
#recv from server package begin 
#############################

sub pre_headunpack {
    my ( $self, $data ) = @_;
    my $head_hash = {};
    ( $head_hash->{'version'},
      $head_hash->{'txnType'}, 
      $head_hash->{'record_amount'}, 
      $head_hash->{'response_code'}, 
      $head_hash->{'record_length'}, 
      $head_hash->{'response_msg'}, 
    ) = unpack(  $self->get_Head_Format  , $data  );
    return $head_hash;
}

sub pre_bodyunpack {
    my ( $self, $data ) = @_;
    my $body_hash = {};
    ( $body_hash->{'node_index'},
      $body_hash->{'server_ip'}, 
      $body_hash->{'port'}, 
      $body_hash->{'hostname'}, 
      $body_hash->{'inserted_time'}, 
      $body_hash->{'running_status'}, 
      $body_hash->{'server_type'}, 
      $body_hash->{'cpunum'}, 
      $body_hash->{'cputype'}, 
      $body_hash->{'opsys_info'}, 
      $body_hash->{'mmsize'}, 
      $body_hash->{'mmfreesize'}, 
      $body_hash->{'hdsize'}, 
      $body_hash->{'hdfreesize'}, 
    ) = unpack( 'x44 '.$self->get_Body_Format , $data );
    return $body_hash;
}

############################################
#callback funcition from outside moose class 
############################################
sub encode {
    my ( $self, $dthash ) = @_;
    dump( $dthash );
    #            --------44-------- =====================
    #$buf = pack('A2 A4 A4 A6 A4 A24 A32 A16 A6 A14 A2 A2' , values %$data );
    if( $self->check_msgvalid( $dthash ) ) { return undef };
    $self->pre_bodypack( $dthash  );
    $self->pre_headpack( $dthash );
    return $self->datadump;
}

sub decode {
    my $self = shift;
    say 'I am decode_1003';
    return undef unless  $self->package ;
    if( length( $self->package ) != 329 ) { return undef; }
    my $hdhash   = $self->pre_bodyunpack( $self->package );
    my $bodyhash = $self->pre_headunpack( $self->package );
    dump( $hdhash );
    #my %hash = ( %$hdhash, %$bodyhash ) ;
    foreach my $item ( keys %$bodyhash ) {  $hdhash->{ $item } = $bodyhash->{ $item } };
    return  $hdhash ;
}

sub check_msgvalid {
    my ( $self ,$data ) = @_;
   
    unless( exists $data->{ 'node_index' } &&  
	    exists $data->{ 'server_ip' } &&
            exists $data->{ 'port' } &&
            exists $data->{ 'inserted_time' } &&
            exists $data->{ 'running_status' } &&
            exists $data->{ 'server_type' }   &&
            exists $data->{ 'txntype' }    &&
	    exists $data->{ 'hostname' }  &&
	    exists $data->{ 'cpunum' } && 
	    exists $data->{ 'cputype' } && 
	    exists $data->{ 'opsys_info' } && 
	    exists $data->{ 'mmsize' } && 
	    exists $data->{ 'mmfreesize' } && 
	    exists $data->{ 'hdsize' } && 
	    exists $data->{ 'hdfreesize' }  
    ) {

            confess "msg invaild ,checking the datagram!" ;
            return 1;
    }
    return 0;
}
sub test {
    my $self = shift;
    dump('i am 1003');
}

1;
