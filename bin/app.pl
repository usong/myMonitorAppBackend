#!/usr/bin/env perl
use Dancer;
use Monitor::App;
use Util::Basic;
use 5.010;
use Data::Dump qw( dump );
#use Util::ServerTypeTool;
#my $obj = Util::ServerTypeTool->new;
#$obj->get_svrtype_hash( 7 ) ;
#my @type = grep { $obj->types->{ $_ }->{ 'has_types' } eq 1  } 1..6 ;
#map { say $_." " } @type;

dance;
