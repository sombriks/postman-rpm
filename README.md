# Postman rpm script

Script to proper package postman for linux. use at your own risk

## Requirements

- rpm dev tools
- open ssl
- curl

## Using the script

Simply run:

```bash
sh make-package.sh
```

It will get latest postman .tar.gz file and wrap it for you. that's it.

## Why?

Why not?

Anyways, Flatpak postman should be enough, but there is a nasty bug at the
moment.

## Further reading

- <https://www.redhat.com/sysadmin/create-rpm-package>
- <https://github.com/postmanlabs/postman-app-support/issues/12330>
- <https://www.baeldung.com/linux/date-command>
- <https://benjamintoll.com/2023/07/06/on-creating-rpm-packages/>
- <https://rpm-packaging-guide.github.io/>
- <https://stackoverflow.com/questions/48337127/can-the-source0-in-a-rpm-spec-be-a-git-repo>
