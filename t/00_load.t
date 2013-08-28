#!/usr/bin/perl
use warnings;
use strict;
use Test::More;
use File::Find;

find( 
    sub {
        return unless $_ =~ /\.pm$/;
        my $module = $File::Find::name;
        $module =~ s/\.pm$//;
        $module =~ s/lib\///;
        $module =~ s/\//::/g;
        use_ok( $module );
    }, "lib"
);

done_testing;
