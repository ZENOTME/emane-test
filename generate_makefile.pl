#!/usr/bin/perl

use strict;
use warnings;

sub generate_makefile {
    my ($dir, $number) = @_;

    open(my $fh, '<', "$dir/Makefile.template") or die "Cannot open Makefile.template: $!";
    open(my $out_file, '>', "$dir/Makefile") or die "Cannot open Makefile";
    
    # generate iperf
    my @iperf_strings = ();
    for (my $i = 1; $i <= $number; $i += 2) {
        push @iperf_strings, "iperfs$i";
        push @iperf_strings, "iperfc" . ($i + 1) . "-$i" if ($i + 1) <= $number;
    }
    print $out_file "GENERATED_IPERF=" . join(' ', @iperf_strings) . "\n";
    
    # expend the {number}
    while (my $line = <$fh>) {
        $line =~ s/\{(.+?)\{\$\}(.+?)\}/
            join(' ', map { "$1$_$2" } 1..$number)
        /gex;
        
        print $out_file $line;
    }


    close($fh);
    close($out_file);
}

die "Usage: $0 <target_dir> <number>\n" unless @ARGV == 2;

my $dir = $ARGV[0];
my $number = $ARGV[1];

generate_makefile($dir,$number)
