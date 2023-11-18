#!/bin/env sh

# some checks and variables

curl --version
if [ $? -ne 0 ] ; then exit 1 ; fi
rpmbuild --version
if [ $? -ne 0 ] ; then exit 1 ; fi

export NAME=postman
export VERSION="$(date +'%0Y.%0m%0d.%0H%0M%0S')"
export REALURL=https://dl.pstmn.io/download/latest/linux_64
export FAKEURL=https://dl.pstmn.io/download/latest/$NAME-$VERSION.tar.gz
export RELEASE=1
export SUMMARY="Postman is an API platform for building and using APIs."

# prepare directories

echo "intialize rpmbuild directories" 
rpmbuild
rm -rf $HOME/rpmbuild/SOURCES/$NAME-*.tar.gz
rm -rf Postman.tar.gz

# download latest postman

echo "download postman"
curl $REALURL > Postman.tar.gz
if [ $? -ne 0 ] ; then echo "something wrong with postman download!"; exit 1 ; fi

# we need to add the LICENSE file and rename the directory

echo "Adding a LICENSE file"
tar xvf Postman.tar.gz
cp LICENSE Postman
mv Postman $NAME-$VERSION
tar cvf $HOME/rpmbuild/SOURCES/$NAME-$VERSION.tar.gz $NAME-$VERSION

# set up the spec file

echo "Generating $NAME.spec file"
cat << EOF > $HOME/rpmbuild/SPECS/$NAME.spec
Name:           $NAME
Version:        $VERSION
Release:        $RELEASE%{?dist}
Summary:        $SUMMARY

License:        Proprietary (with open source components)
URL:            https://www.postman.com/product/what-is-postman/
Source0:        $FAKEURL

BuildRequires:  gzip tar
Requires:       openssl

%description
What is Postman?
Postman is an API platform for building and using APIs. Postman simplifies each step of the API lifecycle and streamlines collaboration so you can create better APIs—faster.
API repository
Easily store, catalog, and collaborate around all your API artifacts on one central platform. Postman can store and manage API specifications, documentation, workflow recipes, test cases and results, metrics, and everything else related to APIs.
Tools
The Postman platform includes a comprehensive set of tools that help accelerate the API lifecycle—from design, testing, documentation, and mocking to the sharing and discoverability of your APIs.

%prep


%build


%install
install -m 0755 -d %{name} %{buildroot}/opt

%files
%license LICENSE



%changelog
* Sat Nov 18 2023 Leonardo Silveira <sombriks@gmail.com>
- tooling for create an RPM package

EOF

# package it

echo "buyilding the package"
rpmbuild -bb $HOME/rpmbuild/SPECS/$NAME.spec