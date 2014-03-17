package Shopper;

use lib '.';
use Moo;
use Module::Pluggable search_path => 'Shopper', instantiate => 'new';
use Data::Dumper;

sub get_sites {
    my ($self, $sites) = @_;
    my @sites;
    # add filter to include only sites passed in
    for my $site ($self->plugins) {
        push @sites, $site;
    }
    return @sites;
}

1;