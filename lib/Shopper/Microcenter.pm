package Shopper::Microcenter;

use base Shopper;
use Moo;
use Mojo::UserAgent;
use Mojo::DOM;
use Data::Dumper;

my $SITE = 'Microcenter';
my $URL = 'http://www.microcenter.com/search/search_results.aspx?Ntt=';

has id => (
    is => 'ro',
    default => sub { $SITE }
);

has base_url => (
    is => 'ro',
    default => sub { $URL }
);

# only care about parsing first page of search results.
# if we have to go passed first page, we need better search params
sub check_results {
    my ($self, $data) = @_;
    my $res = {};
    my $dom = $data->res->dom;

    my $result_check = $dom->at('div#content')->find('h1')->text;
    if ($result_check =~ /Search Results/) {
        # got results
        my $results = $self->parse($dom);
        # for my $result (@$results) {
        #     print $result->find('a')->attr('href'), "\n";
        #     # my $sku = $result->find('div.details')->find('p.sku')->text;
        #     # print "SKU: $sku\n";
        # }
    }
    elsif ($result_check =~ /You search didn/) {
        # no results
    }
    else {
        # found distinct match - getting redirect
    }
}

sub parse {
    my ($self, $dom) = @_;
    my $data = [];

    # get array of <li>s that define each result item
    my @li;
    $dom->find('article#productGrid > ul > li:not(.break)')->each(
        sub {
            push @li, $_;
        }
    );

    # parse each li to hash ref
    for my $li (@li) {
        my $hash = {
            sku => $self->sku($li),
            # description => $self->description($li),
            # price => $self->price($li),
            # stock => $self->stock($li),
            # image_href => $self->image_href($li),
            # item_href => $self->item_href($li),
        };
        push @{$data}, $hash;
        # $li->find('div.details')->each(
        # $li->each(
        # sub {
        #     # print STDERR $_->text, "\n";
        #     my $hash = {
        #         sku => $self->sku($_),
        #         description => $self->description($_),
        #         price => $self->price($_),
        #         stock => $self->stock($_),
        #         image_href => $self->image_href($_),
        #         item_href => $self->item_href($_),
        #     };
        #     push @{$data}, $hash;
        # })
    }
    print "TOT: ", scalar @li, "\n";
    print STDERR Dumper $data;
    return $data;
}

sub sku {
    my ($self, $dom) = @_;
    my $sku = $dom->at('div.details > p.sku')->text;
    $sku =~ s/SKU:\s+//;
    return $sku;
}

sub description {
    my ($self, $dom) = @_;
}

sub stock {
    my ($self, $dom) = @_;

}

sub price {
    my ($self, $dom) = @_;

}

sub image_href {
    my ($self, $dom) = @_;

}

sub item_href {
    my ($self, $dom) = @_;

}

sub pagination {
    my ($self, $dom) = @_;
}

1;