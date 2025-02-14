#!/usr/bin/perl
# 
# Copyright 2022 Centreon (http://www.centreon.com/)
#
# Centreon is a full-fledged industry-strength solution that meets
# the needs in IT infrastructure and application monitoring for
# service performance.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

use strict;
use warnings;

my $plugins = [];
for (my $i = 0; $i < scalar(@ARGV); $i++) {
    if ($ARGV[$i] =~ /^centreon-plugin-([A-Za-z\-_0-9]+)$/) {
        push @$plugins, '"' . $ARGV[$i] . '"';
    }
}

if (scalar(@$plugins) <= 0) {
    print "nothing to install\n";
    exit(0);
}

my $command = 'yum -y install ' . join(' ', @$plugins) . ' 2>&1';
my $output = `$command`;
if ($? == -1) {
    print "failed to execute: $!\n";
    exit(1);
} elsif ($? & 127) {
    printf "child died with signal %d, %s coredump\n",
        ($? & 127), ($? & 128) ? 'with' : 'without';
    exit(1);
}

my $exit = $? >> 8;
print "succeeded command (code: $exit): " . $output;
exit(0);
