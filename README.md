# Postman rpm script

Script to proper download postman for linux. use at your own risk

## Requirements

- rpm dev tools
- open ssl
- curl

## Using the script

Simply run:

```bash
sh make-package.sh
```

It will generate a rpm package to get latest postman .tar.gz file and wrap it
for you. that's it.

## Why?

Postman got too big, too heavy, rpm package creation simply fails.

Anyways, [Flatpak postman](https://flathub.org/pt-BR/apps/com.getpostman.Postman)
should be enough, but there is a bug at the moment.

## Further reading

- <https://www.redhat.com/sysadmin/create-rpm-package>
- <https://github.com/postmanlabs/postman-app-support/issues/12330>
- <https://www.baeldung.com/linux/date-command>
- <https://benjamintoll.com/2023/07/06/on-creating-rpm-packages/>
- <https://rpm-packaging-guide.github.io/>
- <https://stackoverflow.com/questions/48337127/can-the-source0-in-a-rpm-spec-be-a-git-repo>
- <https://www.cyberciti.biz/faq/howto-list-installed-rpm-package/>
