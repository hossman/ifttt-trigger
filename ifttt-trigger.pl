#!/usr/bin/env perl

# Copyright 2016 Chris Hostetter
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

##################################################

# https://github.com/hossman/ifttt-trigger
#
# uses the ifttt Maker channel to trigger an event with some optional input
#   https://ifttt.com/maker
#
# If the HTTP request to fire the ifttt event fails for any reason, the original event input will be 
# written to STDOUT, and the script will die with the details of the HTTP error.
#
# this should (in theory) allow you to chain this script with something else as a fall back (ie: notify-send)
# so you can still get *some* notification, while also accessing the full details of the error.

use strict;
use warnings;
use LWP::UserAgent;
use JSON::XS qw(encode_json);

if (@ARGV < 2 or 5 < @ARGV) {
    die "Usage: $0 secret_key event [value1 [value2 [value3]]]\n";
}
 
my $key = shift;
my $event = shift;
my %json_payload;
my $var = 1;
for my $value (@ARGV) {
    $json_payload{"value$var"} = $value;
    $var++;
}

my $ua = new LWP::UserAgent();
my $req = HTTP::Request->new( 'POST', "https://maker.ifttt.com/trigger/$event/with/key/$key" );
$req->header( 'Content-Type' => 'application/json' );
$req->content( encode_json(\%json_payload) );
my $rsp = $ua->request( $req );

unless ($rsp->is_success) {
    print STDOUT @ARGV;
    die $rsp->as_string;
}
