#!/bin/sh -

echo "Username: $1"
echo "Password: $2"
echo "SiteUrl: $3"
echo "Filter: $4"
echo "PackageName: $5"

if [ "$#" != "5" ]; then
	echo "Invalid Args"
    echo "Total $#, Expected 5;"
    echo "Username, Password, SiteUrl, Filter, PackageName"
    	exit 1
else
	echo "Args Success"
fi

PACKAGE_NAME="content-builder-$5"
echo $PACKAGE_NAME
PACKAGE_GROUP="my_packages"
echo $PACKAGE_GROUP

LOCAL_ADMIN_USERNAME="admin"
LOCAL_ADMIN_PASSWORD="admin"
LOCAL_SITE_URL="http://localhost:4502"

# delete exsting file
echo "Deleting existing file"
rm -f $PACKAGE_NAME.zip

# create package
echo "Creating package on remote instance"
curl -k -u $1:$2 -X POST $3/crx/packmgr/service/.json/etc/packages/$PACKAGE_GROUP/$PACKAGE_NAME?cmd=create \
-d packageName=$PACKAGE_NAME \
-d groupName=$PACKAGE_GROUP

# add filters
echo "Adding filter to package on remote instance"
curl -k -u $1:$2 POST $3/etc/packages/$PACKAGE_GROUP/$PACKAGE_NAME.zip/jcr:content/vlt:definition/filter/f2.rw.html \
-F"root= $4" \
-Frules="[exclude:/content/dam/hyundai/au/en/models]"

# build package
echo "Building package"
curl -k -u $1:$2 -X POST $3/crx/packmgr/service/.json/etc/packages/$PACKAGE_GROUP/$PACKAGE_NAME.zip?cmd=build

# download package
echo "Downloading package"
curl -k -u $1:$2 $3/etc/packages/$PACKAGE_GROUP/$PACKAGE_NAME.zip > $PACKAGE_NAME.zip

# clean up remote instance
echo "Cleaning package from remote instance"
curl -k -u $1:$2 -F cmd=delete $3/crx/packmgr/service/.json/etc/packages/$PACKAGE_GROUP/$PACKAGE_NAME.zip

# install local
echo "Upload and install to local instance"
curl -u $LOCAL_ADMIN_USERNAME:$LOCAL_ADMIN_PASSWORD -F file=@"$PACKAGE_NAME.zip" -F name="$PACKAGE_NAME.zip" -F force=true -F install=true $LOCAL_SITE_URL/crx/packmgr/service.jsp

# clean up existing file
echo "Cleaning local package"
rm -f $PACKAGE_NAME.zip
