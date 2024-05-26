# ubuntu-eol-upgrader
This simple bash script fixes sources.list on EOL Ubuntu releases, then uses apt-get to updates packages the system. RUN AS SU! **THIS DOES NOT UPGRADE DISTRO, ONLY UPDATES THE PACKAGES TO LATEST SUPPORTED VERSION ON OFFICIAL EOL UBUNTU REPOS**

**NOTE: 14.04+ LTS releases don't need this script, you can use main Ubuntu repos just fine on those.**

How does it work? It simply follows https://help.ubuntu.com/community/EOLUpgrades to fix sources.list.
