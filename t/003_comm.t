use strict;
use warnings;

use FindBin qw($Bin);
use lib "$Bin/../lib";
use Util::MessageDispatch;
use 5.010;
#txntype
my $dp = new Util::MessageDispatch;


my $nodeidx  = time();
my $serverip = '10.0.1.171';
my $port = 9000;

$dp->setting(  '127.0.0.1' , 8888 );
my $data = 
		{
			'node_index' 	 => $nodeidx,
			'server_ip'  	 => $serverip,
			'port'           => $port,
			'inserted_time'    => 0,
			'running_status' => 0,
			'server_type'    => 64,
			'txntype'        => 1001,
			'hostname'       => 'ttttt',

		};

my $buf = $dp->disptach( undef, 1001, $data );
say 'recive = '. $buf;


