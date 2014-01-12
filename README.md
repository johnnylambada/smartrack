
Smartrack
=========

Sometimes you just want to build an app that statically bundles all of your microsoft documents so they can be read offline from within the app itself. This Cordova project lets  you do that.

To use it, you'll have to download the Android SDK and Cordova, and these instructions will show you how to do just that.

The Procedure
-------------
Generally, the procedure for building this app goes as follows (details for each step is in a section below):

1. Use git to clone the smarttrack repository
1. Validate the macosx environment
1. Download and extract the Android SDK
1. Download and extract Cordova
1. Point the www directory to the correct source
1. Make sure the javascript is correct
1. Build and test the app

Use git to clone the smarttrack repository
------------------------------------------
This repository is housed in github. Use git to clone it to your local machine.

```bash
mkdir -p ~/Projects/itp/ # You can put this wherever you like
git clone https://github.com/johnnylambada/smartrack.git
cd smartrack
pwd # This is the home directory for your project
```

Validate the macosx environment
-------------------------------
The OSX environment may require some additional tools. Generally these can be obtained using [homebrew](http://brew.sh/).

```bash
cd ~/Projects/itp/smarttrack
source scripts/envsetup.sh
validate
```

If phase 0 passes, then you're ready to move on to downloading the Android SDK.

Download and set up the Android SDK
-----------------------------------
We're going to download a private copy of the Android SDK. If you already have a copy of the SDK, feel free to use it instead.

```bash
cd ~/Projects/itp/smarttrack
source scripts/envsetup.sh
download-android-sdk
```


Important commands
==================
cordova create app com.sigseg.hbhsfb2013 HBHSFootball2013
cordova platform add ios
cordova platform add android
cordova plugin add https://git-wip-us.apache.org/repos/asf/cordova-plugin-console.git

