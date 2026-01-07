action=$1
icon1=$2
icon2=$3
mode=$(makoctl mode)


if [ "$mode" == "default" ]; then
    # Sets mode if default is enabled
    if [ "$action" == "toggle" ]; then makoctl mode -s dnd > /dev/null 2>&1; fi
    if [ "$action" == "icon" ]; then echo "{ \"text\": \"$icon1\", \"class\": \"default\" }"; fi
elif [ "$mode" == "dnd" ]; then
    # Sets mode if dnd is enabled
    if [ "$action" == "toggle" ]; then makoctl mode -s default > /dev/null 2>&1; fi
    if [ "$action" == "icon" ]; then echo "{ \"text\": \"$icon2\", \"class\": \"dnd\" }"; fi
else
    # Resets mode if it was broken through other means
    makoctl mode -s default
    if [ "$action" == "icon" ]; then echo "{ \"text\": \"$icon1\", \"class\": \"default\" }"; fi
fi
