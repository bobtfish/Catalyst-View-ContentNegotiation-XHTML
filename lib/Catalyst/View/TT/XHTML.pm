package Catalyst::View::TT::XHTML;
use strict;
use warnings;
use HTTP::Negotiate qw(choose);
use MRO::Compat;
use base qw/Catalyst::View::TT/;

our $VERSION = '1.004';

our $variants = [
    [qw| xhtml 1.000 application/xhtml+xml |],
    [qw| html  0.900 text/html             |],
];

sub process {
    my $self = shift;
    my ($c) = @_;
    my $return = $self->next::method(@_);
    if ($c->request->header('Accept') && $c->response->headers->{'content-type'} =~ m|text/html|) {
        $self->pragmatic_accept($c);
        my $var = choose($variants, $c->request->headers);
        if ($var eq 'xhtml') {
            $c->response->headers->{'content-type'} =~ s|text/html|application/xhtml+xml|;
        }
    }
    return $return;
}

sub pragmatic_accept {
    my ($self, $c) = @_;
    my $accept = $c->request->header('Accept');
    if ($accept =~ m|text/html|) {
        $accept =~ s!\*/\*\s*([,]+|$)!*/*;q=0.5$1!;
    } else {
        $accept =~ s!\*/\*\s*([,]+|$)!text/html,*/*;q=0.5$1!;
    }
    $c->request->header('Accept' => $accept);
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
XML, meaning that the markup must be well formed.

This is useful when you're developing your application, as you know that
all pages you view are parsed as XML, so any errors caused by your markup
not being well-formed will show up at once.

=head1 METHODS

=head2 process

Overrides the standard process method, delegating to L<Catalyst::View::TT>
to render the template, and then changing the response C<Content-Type> if
appropriate (from the requests C<Accept> header).

=head2 pragmatic_accept

Some browsers (such as Internet Explorer) have a nasty way of sending
Accept */* and this claiming to support XHTML just as well as HTML.
Saving to a file on disk or opening with another application does
count as accepting, but it really should have a lower q value then
text/html. This sub takes a pragmatic approach and corrects this mistake
by modifying the Accept header before passing it to content negotiation.

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

=item David Dorward - test patches and */* pragmatism. 

=back

=head1 COPYRIGHT

This module itself is copyright (c) 2008 Tomas Doran and is licensed under the same terms as Perl itself.

=cut
