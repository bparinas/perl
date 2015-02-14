#!/usr/bin/perl -w
use strict;

my @passwds = `cat /etc/shadow`;
foreach(@passwds) {
	print if(m/^root:/);
}
exit;
