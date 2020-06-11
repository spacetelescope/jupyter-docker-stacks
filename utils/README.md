# Image Building Utility Scripts

These scripts automate common Docker tasks based on a vars.sh file
which defines basic account and  image properties.

## Setup and vars.sh

Every project needs a vars.sh file which records details needed for the build,
push, run, pull, and login Docker tasks.

If a project has no vars.sh file,  clone one from another project and
customize it as needed.

A convenient way to use `vars.sh` is to symlink the `vars.sh` from a
specific project to the root directory.

## Commands

Each of the commands is designed to operate from the root directory
relative to a vars.sh symlink also in the root directory.

Here's an example workflow:

```
# From git repo root directory ...

ln -s jwst-cal/vars.sh  .

utils/build
... lots of Docker output

utils/run
... do browser based testing

utils/login
... login to the configured Docker registry

utils/push
... upload to the registry configured in vars.sh

utils/pull
... download the image from the registry

utils/run
... run the image and do browser based testing

```
