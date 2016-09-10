#!/usr/bin/env perl
use strict;
use warnings;

use lib 'local/lib/perl5/';
use Mojolicious::Lite;
use Mojo::JSON qw(decode_json encode_json);

sub getDataJSON {
  my $section = shift @_;

  my $filename = "data/$section.json";

  my $data;
  open(my $handler, '<', $filename) or die "Error: Couldn't open file '$filename' $!";
  {
    local $/;
    $data = <$handler>;
  }
  close($handler);
  my $hash = decode_json $data;
  return $hash;
}

get '/:section' => [section => qr/(tech|done|impact|lead)/] => sub {
  my $c = shift;

  $c->render(json => getDataJSON $c->param('section'));
};

get '/:section/:index' => [section => qr/(tech|done|impact|lead)/] => sub {
  my $c = shift;

  my $hash = getDataJSON $c->param('section');

  my $index = $c->param('index');

  $c->render(json => $hash->{data}->[$index]);
};

app->start;
