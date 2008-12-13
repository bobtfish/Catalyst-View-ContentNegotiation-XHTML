package Catalyst::View::TT::XHTML;
use strict;
use warnings;
use HTTP::Negotiate qw(choose);
use Class::C3;
use base qw/Catalyst::View::TT/;

our $VERSION = '1.002';

our $variants = [
    [qw| xhtml 1.000 application/xhtml+xml |],
    [qw| html  0.001 text/html             |],
];

sub process {
    my $self = shift;
    my ($c) = @_;
    my $return = $self->next::method(@_);
   
    if ($c->request->header('Accept') && $c->response->headers->{'content-type'} =~ m|text/html|) {
        my $var = choose($variants, $c->request->headers);
        if ($var eq 'xhtml') {
            $c->response->headers->{'content-type'} =~ s|text/html|application/xhtml+xml|;
        }
    }
    return $return;
}

1;

__END__

=head1 NAME

Catalyst::View::TT::XHTML - A sub-class of the standard TT view which
serves application/xhtml+xml content if the browser accepts it.

=head1 SYNOPSIS

    package MyApp::View::XHTML;
    use strict;
    use warnings;
    use base qw/Catalyst::View::TT::XHTML MyApp::View::TT/;
    
    1;
    
=head1 DESCRIPTION

This is a very simple sub-class of L<Catalyst::View::TT>, which sets
the response C<Content-Type> to be C<application/xhtml+xml> if the
user's browser sends an C<Accept> header indicating that it is willing
to process that MIME type.

Changing the C<Content-Type> causes browsers to interpret the page as
strict XHTML, meaning that the markup must be well formed.

This is useful when you're developing your application, as you know that
all pages you view are rendered strictly, so any markup errors will show
up at once.

=head1 METHODS

=head2 process

Overrides the standard process method, delegating to L<Catalyst::View::TT>
to render the template, and then changing the response C<Content-Type> if
appropriate (from the requests C<Accept> header).

=head1 BUGS

There should be a more elegant way to inherit the config of your normal 
TT view.

Configuration (as loaded by L<Catalyst::Plugin::ConfigLoader>) for the TT 
view is not used.

No helper to generate the view file needed (just copy the code in the 
SYNOPSIS).

=head1 AUTHOR

Tomas Doran C<< <bobtfish@bobtfish.net> >>

=head1 CONTRIBUTORS

=over

=item David Dorward - test patches

=back

=head1 COPYRIGHT

This module itself is copyright (c) 2008 Tomas Doran and is licensed under the same terms as Perl itself.

=cut
