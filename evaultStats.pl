#!/usr/bin/perl
#author: parinab@ph.ibm.com
#created: 06/07/2016

use lib "./Softlayer/API/";
use Softlayer::API::SOAP;
use Data::Dumper;
use Number::Bytes::Human qw(format_bytes);
use strict;

my $api_user = "setme";
my $api_key = "setme";
my $ev_client = SoftLayer::API::SOAP->new('SoftLayer_Account', undef, $api_user, $api_key);
my $objectMask = 'mask(SoftLayer_Network_Storage_Backup_Evault_Version6) [
                   totalBytesUsed,
                   backupJobDetails,
                   restoreJobDetails,
                   agentStatuses
                 ]';
$ev_client->setObjectMask($objectMask);
my $ev_ret = $ev_client->getEvaultNetworkStorage();
printf("%-33s %-23s %-27s %-15s %-23s %-22s\n", 'Device', 'Backup Status', 'Last Backup', 'Capacity (GB)', 'Total Size Used (GB)', 'Notes');
print "===============================================================================================================================================\n";
foreach my $i (@{$ev_ret->result}) {
  my $serverId = $i->{hostId};
  my $hw_client = SoftLayer::API::SOAP->new('SoftLayer_Account', undef, $api_user, $api_key);
  my $hw_ret = $hw_client->getHardware();
  foreach my $j (@{$hw_ret->result}) {
   if ($j->{id} eq $serverId) {
    my $device = $j->{fullyQualifiedDomainName};
    my $status = $i->{agentStatuses}[0]->{status};
    my $last = $i->{agentStatuses}[0]->{lastBackup};
    my $cap = $i->{capacityGb};
    my $total = format_bytes($i->{totalBytesUsed});
    my $notes = $j->{notes};
    printf("%-33s %-23s %-27s %-15s %-23s %-22s\n", $device, $status, $last, $cap, $total, $notes);
   }
  }
}
