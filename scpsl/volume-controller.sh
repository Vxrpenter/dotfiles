export process=false
export runningValue

function title() {
  echo " ▗▄▄▖ ▗▄▄▖▗▄▄▖  ▗▄▄▖▗▖       ▗▖  ▗▖ ▗▄▖ ▗▖   ▗▖ ▗▖▗▖  ▗▖▗▄▄▄▖     ▗▄▄▖ ▗▄▖ ▗▖  ▗▖▗▄▄▄▖▗▄▄▖  ▗▄▖ ▗▖   ▗▖   ▗▄▄▄▖▗▄▄▖ "
  echo "▐▌   ▐▌   ▐▌ ▐▌▐▌   ▐▌       ▐▌  ▐▌▐▌ ▐▌▐▌   ▐▌ ▐▌▐▛▚▞▜▌▐▌       ▐▌   ▐▌ ▐▌▐▛▚▖▐▌  █  ▐▌ ▐▌▐▌ ▐▌▐▌   ▐▌   ▐▌   ▐▌ ▐▌"
  echo " ▝▀▚▖▐▌   ▐▛▀▘  ▝▀▚▖▐▌       ▐▌  ▐▌▐▌ ▐▌▐▌   ▐▌ ▐▌▐▌  ▐▌▐▛▀▀▘    ▐▌   ▐▌ ▐▌▐▌ ▝▜▌  █  ▐▛▀▚▖▐▌ ▐▌▐▌   ▐▌   ▐▛▀▀▘▐▛▀▚▖"
  echo "▗▄▄▞▘▝▚▄▄▖▐▌   ▗▄▄▞▘▐▙▄▄▖     ▝▚▞▘ ▝▚▄▞▘▐▙▄▄▖▝▚▄▞▘▐▌  ▐▌▐▙▄▄▖    ▝▚▄▄▖▝▚▄▞▘▐▌  ▐▌  █  ▐▌ ▐▌▝▚▄▞▘▐▙▄▄▖▐▙▄▄▖▐▙▄▄▖▐▌ ▐▌"
  echo "Copyright (c) 2025 Vxrpenter"
  echo ""
  echo "This program only changes your microphones volume when 'SCPSL.exe' is running. If you want to exit just press, STRG + C"

}

function checkProcess() {
  ! pgrep -f SCPSL.exe &> /dev/null ; runningValue=$?

  if [ runningValue == 1 ]; then
    process = true
  fi
}

title
checkProcess
while [ process ]
do
    checkProcess
    amixer set Capture 100% > /dev/null 2>&1
    sleep 0.5
done
