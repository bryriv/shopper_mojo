package Shopper;

use lib '.';
use Moo;
use Module::Pluggable search_path => 'Shopper', instantiate => 'new';
use Mojo::UserAgent;
use URI::Encode qw(uri_encode);

use Data::Dumper;

sub shop {
    my ($self, $str) = @_;
    my $url = $self->build_url($str);
    my $ua = Mojo::UserAgent->new;
    my $tx = $ua->get($url);
    return $self->check_results($tx);
}

sub build_url {
    my ($self, $str) = @_;
    return $self->base_url . uri_encode($str);
}

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