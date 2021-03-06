#!/usr/bin/perl
use lib '/home/bbs/bin/';
use LocalVars;
use strict;

my($prefix, $id, %inform, $tmp);

foreach $prefix ( 'a'..'z', 'A'..'Z' ){
    opendir DIR, "$BBSHOME/home/$prefix";
    foreach $id ( readdir(DIR) ){
	next if( $id =~ /\./ );
	if( $id =~ /[^a-zA-Z0-9]/ ){
	    `mv '$BBSHOME/home/$prefix/$id/' $BBSHOME/tmp/`;
	    next;
	}
	print "importing $id\n";
	open FH, "$BBSHOME/home/$prefix/$id/alohaed";
	while( <FH> ){
	    $tmp = substr($_, 0, 13);
	    $tmp =~ s/ //g;
	    push @{$inform{$tmp}}, $id;
	}
	close FH;
    }
    closedir DIR;
}

foreach( keys %inform ){
    print "updating $_\n";
    open FH, ">$BBSHOME/home/".substr($_, 0, 1)."/$_/aloha";
    print FH "$_ #1\n"	foreach( @{$inform{$_}} );
    close FH;
}
