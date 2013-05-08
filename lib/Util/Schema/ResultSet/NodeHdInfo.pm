use utf8;
package Util::Schema::ResultSet::NodeHdInfo;

use Moose; 
extends qw/DBIx::Class::ResultSet  DBIx::Class::Storage/;

sub insert_or_update {
	my ( $self ,$nodeindex, $nodehds ) = @_;
	#update or insert node_hd_info
	
	try {
	    #$self->txn_do ( sub {
	        for my $hd ( keys %{ $nodehds } ) {
	        	my $hdinfosets = $self->search({
	        		node_index => $nodeindex ,
	        		hd_no      => $hd        ,
	        	});
	        	#exist be update ,not be insert
	        	if(  $hdinfosets->first  ) {
	        		$hdinfosets->update( { 'hd_threhold' => $nodehds->{ $hd }  } );
	        	    
	        	} else {
	        	     	$hdinfosets->create( { 
					'hd_no'       => $hd  ,
					'hd_no_size'  => $hd  ,#$nodehds->{ $hd }->{ 'hd_no_size'  } ,
					'hd_threhold' => $hd  ,#$nodehds->{ $hd }->{ 'hd_threhold' } ,
				});
	                }
                }
		#});
        } catch {
            my $error = shift;
            print '=>>>>>>>>>>>>>>>>>',$error,"\n";
	    confess "Terrible! Database Manutiplate has be Failed!"
	    if ( $error =~ /Rollback failed/);          # Rollback failed
	        #$self->txn_rollback();
        } finally  {
            if (@_) {
		 print '=>>>>>>>>>>>>>>>>>>>>>>>>>>>>2',"\n";
     		 print "The try block died with: @_\n";
   	    } else {
     		 print '=>>>>>>>>>>>>>>>>>>>>>>>>>>>>3',"\n";
    	    }
	}
        return 0;
}
