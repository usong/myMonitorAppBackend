#!/usr/bin/env perl
use Dancer;
use Monitor::App;
use Util::Basic;
use 5.010;
use Data::Dump qw( dump );
#my $obj = Util::Basic->new;
#
#my $schema = $obj->schema;
#
#foreach ( 1..10 ) {
#	my $find_rs = $schema->resultset('Host')->search(undef , 
#		{
#			page => $_,
#			rows => 1,
#		}
#	);
#	my @array = $find_rs->all();
#	map {say $_->ip } @array;
#}
dance;
