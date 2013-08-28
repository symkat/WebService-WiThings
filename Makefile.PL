#!/usr/bin/perl
use warnings;
use strict;
use inc::Module::Install;

name            'WebService-WiThings';
all_from        'lib/WebService/WiThings.pm';
license         'perl';

requires        'LWP::Authen::OAuth'    => '1.01';
requires        'Module::Load'          => '0';
requires        'Scalar::Util'          => '0';
requires        'URI::Encode'           => '0';
requires        'Try::Tiny'             => '0';
requires        'Moo'                   => '0';

WriteAll;
