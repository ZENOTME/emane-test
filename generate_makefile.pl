#!/usr/bin/perl

use strict;
use warnings;

sub generate_makefile {
    my ($dir, $number) = @_;

    open(my $fh, '<', "$dir/Makefile.template") or die "Cannot open Makefile.template: $!";
    open(my $out_file, '>', "$dir/Makefile") or die "Cannot open Makefile";
    
    while (my $line = <$fh>) {
        $line =~ s/\{(.+?)\{\$\}(.+?)\}/
            join(' ', map { "$1$_$2" } 1..$number)
        /gex;

        $line =~ s/\{@\}/$number/g;
            
        print $out_file $line;
    }


    close($fh);
    close($out_file);
}


die "Usage: $0 <target_dir> <number>\n" unless @ARGV == 2;

my $dir = $ARGV[0];
my $number = $ARGV[1];

generate_makefile($dir,$number);
