## balena usb-mount

This is an experimental project as part of https://github.com/balena-os/balena-supervisor/pull/1993.

https://github.com/balena-os/balena-supervisor/pull/1993 proposes adding a bind-mounted folder to the host when applying a certain label. This folder can then be used - in theory - for mounting USB drives that can be accessed from multiple containers simultaneously. This repo is a containerised build of the required UDEV process so that USB mounting could be managed by a block rather than entrypoints and installs added in to users applications, and remove the requirement of adding privileged flags to core components of a build.
