package Catalyst::View::ContentNegotiation::XHTML;

use Moose::Role;
use MooseX::Types::Moose qw/Num Str ArrayRef/;
use MooseX::Types::Structured qw/Tuple/;
use HTTP::Negotiate qw/choose/;

use namespace::clean -except => 'meta';

# Remember to bump $VERSION in View::TT::XHTML also.
our $VERSION = '1.100';

has variants => (
    is      => 'ro',
    isa     => ArrayRef[Tuple[Str, Num, Str]],
    lazy    => 1,
    builder => '_build_variants',
);

sub _build_variants {
    return [
        [qw| xhtml 1.000 application/xhtml+xml |],
        [qw| html  0.900 text/html             |],
    ];
}

after process => sub {
    my ($self, $c) = @_;
    if ($c->request->header('Accept') && $c->response->headers->{'content-type'} =~ m|text/html|) {
        $self->pragmatic_accept($c);
        my $var = choose($self->variants, $c->request->headers);
        if ($var eq 'xhtml') {
            $c->response->headers->{'content-type'} =~ s|text/html|application/xhtml+xml|;
        }
    }
};

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

Catalyst::View::ContentNegotiation::XHTML - A Moose Role to apply to
Catalyst views adjusts the response Content-Type header to 
application/xhtml+xml content if the browser accepts it.

=head1 SYNOPSIS

    package Catalyst::View::TT;

    use Moose;
    use namespace::clean -except => 'meta';

    extends qw/Catalyst::View::TT/;
    with qw/Catalyst::View::ContentNegotiation::XHTML/;

    1;

=head1 DESCRIPTION

This is a very simple Role which uses a method modifier to run after the
C<process> method, and sets the response C<Content-Type> to be 
C<application/xhtml+xml> if the users browser sends an C<Accept> header 
indicating that it is willing to process that MIME type.

Changing the C<Content-Type> causes browsers to interpret the page as
XML, meaning that the markup must be well formed.

This is useful when you're developing your application, as you know that
all pages you view are parsed as XML, so any errors caused by your markup
not being well-formed will show up at once.

=head1 METHOD MODIFIERS

=head2 after process

Changes the response C<Content-Type> if appropriate (from the requests C<Accept> header).

=head1 METHODS

=head2 pragmatic_accept

Some browsers (such as Internet Explorer) have a nasty way of sending
Accept */* and this claiming to support XHTML just as well as HTML.
Saving to a file on disk or opening with another application does
count as accepting, but it really should have a lower q value then
text/html. This sub takes a pragmatic approach and corrects this mistake
by modifying the Accept header before passing it to content negotiation.

=head1 ATTRIBUTES

=head2 variants

Returns an array ref of 3 part arrays, comprising name, priority, output 
mime-type, which is used for the content negotiation algorithm.

=head1 PRIVATE METHODS

=head2 _build_variants

Returns the default variant attribute contents.

=head1 SEE ALSO

=over

=item L<Catalyst::View::TT::XHTML> - Trivial Catalyst TT view using this role.

=item L<http://www.w3.org/Protocols/rfc2616/rfc2616-sec12.html> - Content negotiation RFC.

=back

=head1 BUGS

Will only work with Views which implement a process method.

Should be split into a base ContentNegotiation role which is consumed by ContentNegotiation::XHTML.

=head1 AUTHOR

Tomas Doran (t0m) C<< <bobtfish@bobtfish.net> >>

=head1 CONTRIBUTORS

=over

=item David Dorward - test patches and */* pragmatism. 

=item Florian Ragwitz (rafl) C<< <rafl@debian.org> >> - Conversion into a Moose Role

=back

=head1 COPYRIGHT

This module itself is copyright (c) 2008 Tomas Doran and is licensed under the same terms as Perl itself.

=cut
