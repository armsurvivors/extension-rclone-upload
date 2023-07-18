# rclone-upload

an ABF extension to upload images to remote storage via rclone

## concepts
has a concept of "local" target and "publish" targets

### local
local will push the uncompressed image _aka the `.img` file_ to a specified location.  My example use case is it uploaded to my local NAS via smb

### publish
Publish will push `.xz` `.sha` `.txt` artifacts to a specified location.   By default it also publishes all of these files in a folder matching the full final `${version}` name of the build

### rclone version

by default it just installs the `rclone` in the build instance/container's apt repo..  If you need an newer version (ex: need the one with SMB support) use the `RCLONE_INSTALL_LATEST="yes"` flag to skip apt and install the package directly.

## installation

copy or shallow clone this into `userpatches/extensions/rclone-upload`

## configuration

### rclone

the rclone configuration file must be located inside the `userpatches/extensions/rclone-upload/config` folder.  

you can generate a config file via `rclone --config userpatches/extensions/rclone-upload/config/rclone.conf` and follow the prompt or borrow from the `rclone.conf.example` file.  

you my also use seperate conf files and specify them via config variables:

```
RCLONE_LOCAL_CONFIG_NAME
RCLONE_PUBLISH_CONFIG_NAME
```

### Add to build configuration

#### required variables

for local

```
RCLONE_LOCAL_TARGET
```

for publish
```
RCLONE_PUBLISH_TARGET
RCLONE_PUBLISH=yes
```

#### example configuration

```bash
declare -g RCLONE_INSTALL_LATEST="yes"   # needed for SMB support when using jammy base
declare -g RCLONE_LOCAL_CONFIG_NAME="rclone-nas.conf" 
declare -g RCLONE_LOCAL_TARGET="nas:mirror/armbianImages"
declare -g RCLONE_PUBLISH_CONFIG_NAME="rclone-s3.conf"  # both of these could be in same config
declare -g RCLONE_PUBLISH_TARGET="objectstore:mybucket/myprefix"

declare -g RCLONE_PUBLISH=yes   # you might just want to set this flag as an argument during ./compile.sh 

enable_extension rclone-upload

```
