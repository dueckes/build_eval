** 0.0.11 **

New:
* `TravisPro` build status is unknown when login attempt fails

** 0.0.10 **

New:
* `Travis` and `TravisPro` build status is unknown when Travis SDK call fails

** 0.0.9 **

Fix:
* `Travis` and `TravisPro` build status is that of last finished build

** 0.0.8 **

Fix:
* Addressed `TravisPro` race condition by logging-in immediately before evaluating build status

** 0.0.7 **

Fix:
* `Travis` API use: Switched to `recent_builds.first` as `last_build` appears to yield false positives.

** 0.0.6 **

Breaking:
* `:TravisOrg` and `:TravisCom` renamed to `:TravisPro` and `Travis` respectively

** 0.0.5 **

New:
* `:TravisCom` support

Breaking:
* `:TravisCI` renamed to `:TravisOrg`

** 0.0.4 **

New:
* Jenkins support
* ssl verify mode is configurable per server

** 0.0.3 **

Breaking:
* Failure and Error status symbols mirror Blinky

** 0.0.2 **

New:
* `:TravisCI` open source project support
* Error status support
* Composite monitors

** 0.0.1 **

New:
* TeamCity with basic authentication support
