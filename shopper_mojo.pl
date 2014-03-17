#!/usr/bin/env perl
use Mojolicious::Lite;
use lib './lib';
use Shopper;
use Data::Dumper;

app->config(hypnotoad => {listen => ['http://*:8080']});
app->secrets('whatthehellisthis');

# Documentation browser under "/perldoc"
plugin 'PODRenderer';

get '/' => sub {
    my $self = shift;
    $self->render('index');
};

get '/search' => sub {
    my $self = shift;
    my $str = $self->param('str');

    # search sites
    my %results;
    if($str) {
        my $shopper = new Shopper;
        my @sites = $shopper->get_sites();
        # $self->app->log->debug("hello");
        for my $site (@sites) {
            $results{$site->id} = $site->shop($str);
        }

    }
    print STDERR Dumper \%results;
    $self->render(text => "Searching for $str");

};

app->start;








__DATA__

@@ index.html.ep
% layout 'default';
% title 'Welcome Shopper';
Shopper site

@@ layouts/default.html.ep
<!DOCTYPE html>
<html>
  <head><title><%= title %></title></head>
  <body><%= content %>
<form action='/search'>
<input type='text' name='str'>
</form>
  </body>
</html>
