#!/usr/bin/perl

use strict;
use warnings;

# 检查命令行参数
die "Usage: $0 <target_directory> <output_file>\n" unless @ARGV == 2;

# 目标目录和输出文件
my $target_dir = $ARGV[0]; # 从命令行读取目标目录
my $output_file = $ARGV[1];

# 打开目标目录
opendir(my $dir, $target_dir) or die "Cannot open directory: $!";

# 读取目录内容
while (my $file = readdir($dir)) {
    # 匹配 iperfs{num} 文件
    if ($file =~ /iperfs(\d+)/) {
        my $num = $1; # 提取数字部分
        my $log_path = "$target_dir/persist/$num/var/log/iperf.log";

        # 如果日志文件存在，读取并追加到输出文件
        if (-e $log_path) {
            open(my $log_file, '<', $log_path) or die "Cannot open file: $!";
            open(my $out_file, '>>', $output_file) or die "Cannot open file: $!";

            while (my $line = <$log_file>) {
                print $out_file $line;
            }

            close($log_file);
            close($out_file);
        }
    }
}

closedir($dir);

