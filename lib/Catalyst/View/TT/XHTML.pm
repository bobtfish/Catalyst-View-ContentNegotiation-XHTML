package Catalyst::View::TT::XHTML;

use Moose;
use namespace::clean -except => 'meta';

extends qw/Catalyst::View::TT/;
with qw/Catalyst::View::ContentNegotiation::XHTML/;

our $VERSION = '1.100';
   
1;

__END__

=head1 NAME

Catalyst::View::TT::XHTML - A sub-class of the standard TT view which
serves application/xhtml+xml content if the browser accepts it.

=head1 SYNOPSIS

    package MyApp::View::XHTML;
    use strict;
    use warnings;
    use base qw/Catalyst::View::TT::XHTML/;

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

=head1 NOTE 

This module is a very simple demonstration of a consumer of the 
L<Catalyst::View::ContentNegotiation::XHTML> role. 

If your needs are not trivial, then it is recommended that you consume
that role yourself.

=head1 AUTHOR

Tomas Doran (t0m) C<< <bobtfish@bobtfish.net> >>

=head1 COPYRIGHT

This module itself is copyright (c) 2008 Tomas Doran and is licensed under the same terms as Perl itself.

=cut
