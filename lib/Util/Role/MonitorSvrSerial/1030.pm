package Util::Role::MonitorSvrSerial::1030;

use Moose::Role;
use 5.010;
with 'Util::Role::Message';
use Data::Dump qw/dump/;

sub get_Head_Format { 
	my $self = shift; 
	return "A2 A4 A4 A6 A4 A24";
}
sub get_Body_Format { 
	my $self = shift; 
	return "A32 A32 A12 A12 A12 A6 A6 A14";
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
	'record_length' => '0126',
 	'response_msg'  => '0',
    };
    dump($head_hash);
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
	'node_index'          => $data->{ 'node_index' },
	'hd_name'             => $data->{ 'hd_name' },
	'hd_size'             => $data->{ 'hd_size' },
	'hd_used'             => $data->{ 'hd_used' },
	'hd_free'             => $data->{ 'hd_free' },
	'hd_threhold'         => $data->{ 'hd_threhold' },
	'hd_usepercent'       => $data->{ 'hd_usepercent' },
	'insert_time'         => $data->{ 'insert_time' },
    };
    say '1030', $self->get_Body_Format; 
   
    $self->MsgBody(
	    pack(   $self->get_Body_Format , 
	    	    $body_hash->{'node_index'},
		    $body_hash->{'hd_name'}, 
		    $body_hash->{'hd_size'}, 
		    $body_hash->{'hd_used' },
		    $body_hash->{'hd_free'}, 
		    $body_hash->{'hd_threhold'}, 
		    $body_hash->{'hd_usepercent'}, 
		    $body_hash->{'insert_time'}, 
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
    ) = unpack(  $self->get_Head_Format , $data  );
    return $head_hash;
}

sub pre_bodyunpack {
    my ( $self, $data ) = @_;
    my $head_hash = $self->pre_headunpack( $data ); 
    my $body_hash = {};
    
    my $offset = 44 ;
    my $offstr ;
    
    $body_hash->{'rows'} = [];
    for ( 1..$head_hash->{'record_amount'} ) {
	$offstr = 'x'.$offset;
	my ( 
	     $node_index,
      	     $hd_name, 
      	     $hd_size, 
      	     $hd_used, 
      	     $hd_free, 
      	     $hd_threhold, 
      	     $hd_usepercent, 
      	     $insert_time 
    	) = unpack( $offstr .' '. $self->get_Body_Format , $data );
	my $row = { 
		    'nodeindex'      => $node_index, 
		    'hd_no'          => $hd_name, 
		    'hd_no_size'     => $hd_size, 
		    'hd_used_size'   => $hd_used, 
		    'hd_free_size'   => $hd_free,
		    'hd_threhold'    => $hd_threhold, 
		    'hd_usepercent'  => $hd_usepercent, 
		    'inserted_times' => $insert_time 
	};
        push @{ $body_hash->{'rows'} } , $row;
	$offset += int( $head_hash->{'record_length'} );
    }
    foreach my $item ( keys %$body_hash ) {  $head_hash->{ $item } = $body_hash->{ $item } };
    return $head_hash;
}

############################################
#callback funcition from outside moose class 
############################################
sub encode {
    my ( $self, $dthash ) = @_;
    if( $self->check_msgvalid( $dthash ) ) { return undef };
    $self->pre_bodypack( $dthash );
    $self->pre_headpack( $dthash );
    return $self->datadump;
}

sub decode {
    my $self = shift;
    say 'I am decode_1030';
    return undef unless  $self->package ;
    #if( length( $self->package ) != 226 ) { return undef; }
    my $hdhash   = $self->pre_bodyunpack( $self->package );
    #my $bodyhash = $self->pre_headunpack( $self->package );
    #dump( $hdhash );
    return  $hdhash ;
}

sub check_msgvalid {
    my ( $self ,$data ) = @_;
    unless( exists $data->{ 'node_index' } 
    ) {
            confess "msg invaild ,checking the datagram!" ;
            return 1;
    }
    return 0;
}
sub test {
    my $self = shift;
    dump('i am 1030');
}


1;
