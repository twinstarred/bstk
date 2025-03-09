# bstk
 Useful BlueStacks tools and scripts, mainly focused on Air (Silicon) \
 You can clone the repository or curl the script (it's more comfortable to clone the repo) \
 Most scripts are not properly functional when using ```curl {} | {bash, sh}```, so don't do that.

# Rooting BlueStacks Air with SuperSU
## Using vulnerability (Recommended)
```sh air/root/ssu/xroot_vul.sh``` \
or \
```curl https://raw.githubusercontent.com/twinstarred/bstk/main/air/root/ssu/xroot_vul.sh > xroot_vul.sh && sh xroot_vul.sh```

There is a bug where the script will be in DOS format instead of Unix. To fix this, run ```dos2unix``` on the script \
(```dos2unix xroot_vul.sh```)

## Rootless (probably won't work)
```sh air/root/ssu/xroot.sh``` \
or \
```curl https://raw.githubusercontent.com/twinstarred/bstk/main/air/root/ssu/xroot.sh > xroot.sh && sh xroot.sh```
