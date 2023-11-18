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
rpmdev-setuptree
rm -rf $HOME/rpmbuild/SOURCES/$NAME-*.tar.gz
rm -rf postman-*

# download latest postman

ls Postman.tar.gz
if [ $? -ne 0 ]
then
  echo "download postman"
  curl $REALURL > Postman.tar.gz
  if [ $? -ne 0 ] ; then echo "something wrong with postman download!"; exit 1 ; fi
fi

# we need to add the LICENSE file and rename the directory

echo "Adding a LICENSE file"
tar xf Postman.tar.gz
cp LICENSE Postman
mv Postman $NAME-$VERSION
tar cf $HOME/rpmbuild/SOURCES/$NAME-$VERSION.tar.gz $NAME-$VERSION LICENSE

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


%build
tar xvf $HOME/rpmbuild/SOURCES/$NAME-$VERSION.tar.gz


%install
mkdir -p %{buildroot}/opt/$NAME
mkdir -p %{buildroot}/usr/share/licenses/$NAME
cp -R $HOME/rpmbuild/BUILD/$NAME-$VERSION/app %{buildroot}/opt/$NAME/app
cp $HOME/rpmbuild/BUILD/$NAME-$VERSION/LICENSE %{buildroot}/usr/share/licenses/$NAME/LICENSE
install -m 0755 $HOME/rpmbuild/BUILD/$NAME-$VERSION/Postman %{buildroot}/opt/$NAME/Postman


%files
%license LICENSE


%changelog
* Sat Nov 18 2023 Leonardo Silveira <sombriks@gmail.com>
- tooling for create an RPM package

EOF

# package it

echo "building the package"
rpmbuild -bb $HOME/rpmbuild/SPECS/$NAME.spec
