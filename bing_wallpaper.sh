#! /bin/bash

# set path
PATH=/usr/bin:/bin

user=$(whoami)

# set DBUS_SESSION_BUS_ADDRESS
fl=$(find /proc -maxdepth 2 -user $user -name environ -print -quit)

while [ -z $(grep -z DBUS_SESSION_BUS_ADDRESS "$fl" | cut -d= -f2- | tr -d '\000' ) ]
do
  fl=$(find /proc -maxdepth 2 -user $user -name environ -newer "$fl" -print -quit)
done

export DBUS_SESSION_BUS_ADDRESS=$(grep -z DBUS_SESSION_BUS_ADDRESS "$fl" | cut -d= -f2-)

# call bing api for image url
image_url=$(curl -X GET "http://www.bing.com/HPImageArchive.aspx?format=js&idx=0&n=1&mkt=en-US" -H "accept:application/json" | jq '.images[0].url')
image_url=$(echo $image_url | cut -d'"' -f 2)
image_url="https://bing.com${image_url}"

# set as wallpaper
gsettings set org.gnome.desktop.background picture-uri "$image_url"
