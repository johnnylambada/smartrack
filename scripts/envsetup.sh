function hmm() {
cat <<EOF
Invoke ". scripts/envsetup.sh" from your shell to add the following 
functions to your environment:
EOF
    sort $(gettop)/.hmm |awk -F @ '{printf "%-30s %s\n",$1,$2}'
}

function gettop
{
    local TOPFILE=scripts/envsetup.sh
    if [ -n "$TOP" -a -f "$TOP/$TOPFILE" ] ; then
        echo $TOP
    else
        if [ -f $TOPFILE ] ; then
            # The following circumlocution (repeated below as well) ensures
            # that we record the true directory name and not one that is
            # faked up with symlink names.
            PWD= /bin/pwd
        else
            # We redirect cd to /dev/null in case it's aliased to
            # a command that prints something as a side-effect
            # (like pushd)
            local HERE=$PWD
            T=
            while [ \( ! \( -f $TOPFILE \) \) -a \( $PWD != "/" \) ]; do
                cd .. > /dev/null
                T=`PWD= /bin/pwd`
            done
            cd $HERE > /dev/null
            if [ -f "$T/$TOPFILE" ]; then
                echo $T
            fi
        fi
    fi
}
T=$(gettop)
rm -f $T/.hmm $T/.hmmv
echo "gettop@display the top directory" >> $T/.hmm

function croot()
{
    T=$(gettop)
    if [ "$T" ]; then
        cd $(gettop)
    else
        echo "Couldn't locate the top of the tree.  Try setting TOP."
    fi
}
echo "croot@Change back to the top dir" >> $T/.hmm

function jsgrep()
{
        find . -name .repo -prune -o -name .git -prune -o -type f -name "*\.js" -not -name "*.min.*" -print0 | xargs -0 grep --color -n "$@"
}
echo 'jsgrep@Grep through all javascript code' >> $T/.hmm

function www()
{
  cd $(gettop)/app/www
}
echo 'www@Change to the www directory' >> $T/.hmm

function st-android-package
{
	local name=$(gettop)/app/platforms/android/bin/OilersFootball-release.apk
	if [ -e $name ]; then
		echo $name
		return 0
	else
		echo >&2 "doesn't exist: "$name
		return 1
	fi
}
echo 'st-android-package@display the filename of the apk for this app' >> $T/.hmm

function st-android-install
{
	local apk=$(st-android-package) && 
	adb install -r $apk
}
echo 'st-android-install@Install the apk for this app' >> $T/.hmm

function st-android-uninstall
{
	local apk=$(st-android-package) && 
	apk=$(aapt dump badging $(st-android-package) | sed -ne "/package: name/s/^package: name='\([^']*\)'.*/\1/p" 2>/dev/null) &&
	echo $apk &&
	adb uninstall $apk
}
echo 'st-android-uninstall@remove the apk for this app' >> $T/.hmm

function st-android-start
{
	local apk=$(st-android-package) && 
	local run=$(aapt dump badging $apk | awk "/^package:/{gsub(/^[^']*'/,\"\");gsub(/'.*/,\"\");package=\$1;}/^launchable-activity:/{gsub(/^[^']*'/,\"\");gsub(/'.*/,\"\");activity=\$1;}END{print package\"/\"activity}") && 
	adb shell am start -n $run
}
echo 'st-android-start@Start the app on the device' >> $T/.hmm

st-www-prepare ()
{
    local min=".min"
    case $1 in
        -nomin) unset min;;
    esac
    (
    local JQ=1.10.2
    local JQM=1.3.2
    local INCLUDE=app/www/include
    cd $(gettop)
    rm -rf $INCLUDE
    mkdir -p $INCLUDE $INCLUDE/images
    cp lib/jquery-$JQ/jquery-$JQ$min.js $INCLUDE/jquery.js
    cp lib/jquery.mobile-$JQM/jquery.mobile-$JQM$min.js $INCLUDE/jquery.mobile.js
    cp lib/jquery.mobile-$JQM/jquery.mobile-$JQM$min.css $INCLUDE/jquery.mobile.css
    cp lib/jquery.mobile-$JQM/images/* $INCLUDE/images
    )
}
echo 'st-www-prepare [-nomin]@Prepare the www directory. -nomin to use unminimized libs' >> $T/.hmm

st-android-prepare ()
{
  (
  cd $(gettop)
  local PROJ=app/platforms/android
  local RES=$PROJ/res
  local WWW=$PROJ/assets/www
  local MANIFEST=$PROJ/AndroidManifest.xml
  local CONFIG=$WWW/config.xml
  for x in drawable drawable-ldpi drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi ; do
    rm -f $RES/$x/icon.png $RES/$x/ic_launcher.png
    mkdir -p $RES/$x
  done
  cp art/icons/icon-048.png $RES/drawable-ldpi/icon.png
  cp art/icons/icon-072.png $RES/drawable-hdpi/icon.png
  cp art/icons/icon-096.png $RES/drawable-xhdpi/icon.png
  cp art/icons/icon-144.png $RES/drawable-xxhdpi/icon.png

  # android needs a special style
  cp art/styles/android.css $WWW/device.css

  # only allow portrait
  grep -q android:screenOrientation $MANIFEST || 
    gsed -i -e 's/<activity /<activity android:screenOrientation="portrait" /' $MANIFEST

  # update the version code
  local versionCode=$(sed -n '/versionCode/s/.*versionCode[^"]*"\([0-9]*\).*/\1/p' $CONFIG)
  gsed -i -e 's/versionCode="[0-9]*"/versionCode="'$versionCode'"/' $MANIFEST

  # set up the ant.keystore
  cat <<EOF > $PROJ/ant.properties
key.store=../../../keystore
key.alias=android
key.store.password=keystore
key.alias.password=keystore
EOF

  )
}
echo 'st-android-prepare@Prepare the android project' >> $T/.hmm

st-android-build ()
{
    (
    st-android-prepare
    cd $(gettop)/app/platforms/android
    time ant clean release
    )
}
echo 'st-android-build@Build for Android' >> $T/.hmm

unset T f
