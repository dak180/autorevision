Name:           autorevision
Version:        1.10a
Release:        2%{?dist}
Summary:        A shell script for extracting revision information.

License:       dak180
URL:           https://github.com/Autorevision/autorevision
Source0:       %{name}-%{version}.tar.gz

BuildRequires: asciidoc
BuildRequires: coreutils
BuildRequires: gnupg2


%description
A shell script for extracting revision information useful
in release/build scripting from repositories.

Supported repository types include `git`, `hg`, `bzr`, and `svn`. The
record can be emitted in a ready-to-use form for `C`, `C++`, `Java`,
`bash`, `Python`, `Perl`, `lua`, `php`, `ini` and others.

Emitted information includes the ID of the most recent commit, its
branch, its date, and several other useful pieces of meta-information.

There is support for reading and writing a cache file so autorevision
will remain useful during a build from an unpacked distribution
tarball.

See the [manual page](http://www.catb.org/esr/autorevision/autorevision.html),
included in the distribution, for invocation details.

You can check out examples of the different output that autorevision
can produce in (https://github.com/Autorevision/autorevision/tree/master/examples).



# These are the locations of the app-specific files.
#
%define app        autorevision
%define _prefix    /usr
%define bindir     %{_prefix}/bin
%define sharedir   %{_prefix}/share
%define docdir	   %{sharedir}/doc
%define mandir	   %{sharedir}/man/man1


%prep
%setup -q

%build

%install
mkdir -p $RPM_BUILD_ROOT%{bindir}
mkdir -p $RPM_BUILD_ROOT%{docdir}/%{app}-%{version}
mkdir -p $RPM_BUILD_ROOT%{mandir}

cp %{app} $RPM_BUILD_ROOT%{bindir}/%{app}
cp contribs/gitrepos-revision.sh $RPM_BUILD_ROOT%{bindir}/gitrepos-revision
cp contribs/vcs-wc-modified.sh   $RPM_BUILD_ROOT%{bindir}/vcs-wc-modified
cp -r AUTHORS.txt %{app}.html contribs CONTRIBUTING.html \
      COPYING.html examples NEWS README.html \
      $RPM_BUILD_ROOT%{docdir}/%{app}-%{version}
gzip --no-name < %{app}.1 > $RPM_BUILD_ROOT%{mandir}/%{app}.1.gz


%clean
rm -rf $RPM_BUILD_ROOT


%files
%defattr(-,root,root,-)
%{bindir}/%{app}
%{bindir}/gitrepos-revision
%{bindir}/vcs-wc-modified
%{docdir}/%{app}-%{version}/*
%{mandir}/%{app}.1.gz


%changelog
* Wed Jan 21 2015 Dennis Biringer <dbiringer@integrity-apps.com> - 1.10a-2
- Added shell utilities in contribs.

* Wed Jan 21 2015 Dennis Biringer <dbiringer@integrity-apps.com> - 1.10a-1
- Initial RPM for PDS extended autorevision.

