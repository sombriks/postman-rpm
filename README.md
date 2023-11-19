# [Postman rpm script](https://github.com/sombriks/postman-rpm)

Script to crate a [RPM package](https://rpm.org) and proper download postman
for linux. Use at your own risk.

## Requirements

- rpm dev tools
- open ssl
- curl

## Using the script

Simply run:

```bash
sh make-package.sh
```

An rpm package will appear by the end of the process.

## Why?

Postman got too big, too heavy, rpm package creation simply fails.

So, this package holds a few cosmetics on it, declares proper postman
dependencies and use pre/post RPM scripts

Anyways, [Flatpak postman](https://flathub.org/pt-BR/apps/com.getpostman.Postman)
should be enough, but there is a bug at the moment.

## Tested environments

- Fedora 39 KDE edition

## Known issues

- By double-clicking the rpm file will open Discover properly and install nicely
  but uninstall fails. unsintall with `sudo dnf remove postman`  

## Further reading

- <https://www.redhat.com/sysadmin/create-rpm-package>
- <https://github.com/postmanlabs/postman-app-support/issues/12330>
- <https://www.baeldung.com/linux/date-command>
- <https://benjamintoll.com/2023/07/06/on-creating-rpm-packages/>
- <https://rpm-packaging-guide.github.io/>
- <https://stackoverflow.com/questions/48337127/can-the-source0-in-a-rpm-spec-be-a-git-repo>
- <https://www.cyberciti.biz/faq/howto-list-installed-rpm-package/>
- <https://rpm-software-management.github.io/rpm/manual/spec.html>
- <https://gist.github.com/hauthorn/d1da427b16133776bd8c65db802bc6ad>
- <http://ftp.rpm.org/max-rpm/ch-rpm-anywhere.html>
- <https://docs.fedoraproject.org/en-US/packaging-guidelines/RPMMacros/>
