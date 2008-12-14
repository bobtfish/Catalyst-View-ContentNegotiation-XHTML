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

if (-e 'inc/.author') {
  build_requires 'Test::Pod' => 1.14;
  build_requires 'Test::Pod::Coverage' => 1.04;

  if ($^O eq 'darwin') {
      my $osx_ver = `/usr/bin/sw_vers -productVersion`;
      chomp $osx_ver;

      # TAR on 10.4 wants COPY_EXTENDED_ATTRIBUTES_DISABLE
      # On 10.5 (Leopard) it wants COPYFILE_DISABLE
      my $attr = $osx_ver eq '10.5' ? 'COPYFILE_DISABLE' : 'COPY_EXTENDED_ATTRIBUTES_DISABLE';

      makemaker_args(dist => { PREOP => qq{\@if [ "\$\$$attr" != "true" ]; then}.
                                        qq{ echo "You must set the ENV variable $attr to true,"; }.
                                        ' echo "to avoid getting resource forks in your dist."; exit 255; fi' });
  }
}

WriteAll();
