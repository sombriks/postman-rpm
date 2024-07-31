#!/bin/env sh

# Define variables
export NAME=postman
export VERSION="$(date +'%0Y.%0m%0d.%0H%0M%0S')"
export REALURL=https://dl.pstmn.io/download/latest/linux_64
export RELEASE=1
export ARCH=x86_64

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for required commands
if ! command_exists curl; then
    echo "curl is not installed. Exiting."
    exit 1
fi

if ! command_exists rpmbuild; then
    echo "rpmbuild is not installed. Exiting."
    exit 1
fi

# Initialize rpmbuild directories
echo "Initializing rpmbuild directories"
rpmdev-setuptree

# Clean up old files
rm -rf $HOME/rpmbuild/SOURCES/$NAME-*.tar.gz
rm -rf $HOME/rpmbuild/BUILDROOT/$NAME-*
rm -rf postman-*
rm -rf Postman.tar.gz

# Download latest Postman
if [ ! -f Postman.tar.gz ]; then
    echo "Downloading Postman"
    curl $REALURL > Postman.tar.gz
    if [ $? -ne 0 ]; then 
        echo "Something went wrong with Postman download!"
        exit 1
    fi
fi

# Provide some cosmetics and the LICENSE file
tar cvfz $NAME-$VERSION.tar.gz LICENSE Postman.desktop
mv $NAME-$VERSION.tar.gz $HOME/rpmbuild/SOURCES/

# Generate spec file
echo "Generating $NAME.spec file"

cat << EOF > $HOME/rpmbuild/SPECS/$NAME.spec
Name:           $NAME
Version:        $VERSION
Release:        $RELEASE%{?dist}
Group:          Development/Libraries
Summary:        Postman is an API platform for building and using APIs.

License:        Proprietary (with open source components)
URL:            https://www.postman.com/product/what-is-postman/
Source0:        $NAME-$VERSION.tar.gz

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
tar xvf %{_sourcedir}/$NAME-$VERSION.tar.gz
mkdir -p %{buildroot}/usr/share/applications
cp Postman.desktop %{buildroot}/usr/share/applications/Postman.desktop


%files
%license LICENSE
%{_datadir}/applications/Postman.desktop


%pre
cd /opt
curl $REALURL > $NAME-$VERSION.tar.gz
tar xvf $NAME-$VERSION.tar.gz
chown root:root -R /opt/Postman


%postun
cd /opt
rm -rf Postman $NAME-$VERSION.tar.gz


%changelog
* Wed Jul 31 2024 Leonardo Silveira <sombriks@gmail.com>
- believe or not i still need to do this

* Sat Nov 18 2023 Leonardo Silveira <sombriks@gmail.com>
- tooling for create an RPM package

EOF

# package it

echo "building the package"

rpmbuild -bb $HOME/rpmbuild/SPECS/$NAME.spec
cp $HOME/rpmbuild/RPMS/$ARCH/$NAME-$VERSION-$RELEASE.*.$ARCH.rpm .

echo "PACKAGE_NAME=$NAME-$VERSION-$RELEASE.*.$ARCH.rpm" >> $GITHUB_OUTPUT
echo "Package done"
