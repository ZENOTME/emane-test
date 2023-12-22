#!/usr/bin/perl

use strict;
use warnings;

my $number = $ARGV[0];

my @iperf;
my @node;

for (my $i = 1; $i <= $number; $i += 2) {
    my $server_id = $i;
    my $client_id = $i + 1;

    my $server_node = "node-$server_id";
    my $client_node = "node-$client_id";

    my $server_ip = "10.100.0.$server_id";
    my $client_ip = "10.100.0.$client_id";

    push @iperf, "$client_node->$server_node";
    push @node, "$client_node=\"$client_ip\"";
    push @node, "$server_node=\"$server_ip\"";
}

my $iperf_output = join(",",map { "\"$_\"" } @iperf);
my $node_output = join("\n",@node);
my $output = "
duration=180
iperf=[$iperf_output]
[node]
$node_output
";

print $output;
