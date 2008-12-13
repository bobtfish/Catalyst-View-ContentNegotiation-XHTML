use inc::Module::Install;

name 'Catalyst-View-TT-XHTML';
all_from 'lib/Catalyst/View/TT/XHTML.pm';

requires 'Catalyst::Runtime';
requires 'Catalyst::View::TT';
requires 'HTTP::Negotiate';
requires 'MRO::Compat';

build_requires 'Catalyst::Action::RenderView';
build_requires 'Test::WWW::Mechanize::Catalyst';
build_requires 'Test::More';

resources repository => 'http://dev.catalyst.perl.org/repos/Catalyst/Catalyst-View-TT-XHTML';

WriteAll();
