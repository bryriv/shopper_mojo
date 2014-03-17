package Shopper::Microcenter;

use Moo;

has id => (
    is => 'rw',
    default => sub {'Microcenter'}
);

sub shop {
    my ($self) = @_;
    return 'getting Microcenter data';
}


1;