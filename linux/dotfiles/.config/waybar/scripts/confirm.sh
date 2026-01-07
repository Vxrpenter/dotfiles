question=$1
command=$2

pkill fuzzel
confirmation=$(echo -e "Yes\nNo" | fuzzel -d --placeholder " $question" --lines 2)
if [ "$confirmation" == "Yes" ]; then
    eval $command
fi
