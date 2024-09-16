#!/bin/bash
# A simple GLaDOS voice clip generator using the glados.c-net.org api
# by PolyCat

nullMsgCheck () {
    if [[ -z $1 ]]; then
        echo -e "\033[31mERROR: Null string. No message defined\033[0m"
        exit 0
    fi
}

if [[ $1 == "-h" || -z $1 ]]; then
    echo -e "\e[32mGLaDOS TTS Wrapper:\e[0m"
    echo "A simple GLaDOS voice clip generator"
    echo ""

    echo -e "\e[32mCommands:\e[0m"
    echo "-h, --help                           Shows the help page"
    echo "-p <message>, --play <message>       Will play a message of your choosing"
    echo "-d <message> --download <message>    Will download an audio file with a message of your choosing"
    echo ""

# Option to just play the audio
elif [[ $1 == "-p" || $1 == "--play" ]]; then
    nullMsgCheck $2
    curl -L --retry 30 --get --fail \
    --data-urlencode "text=$2" \
    "https://glados.c-net.org/generate" | aplay

# Option to download the audio to a `.wav` file
elif [[ $1 == "-d" || $1 == "--download" ]]; then
    nullMsgCheck $2
    curl -L --retry 30 --get --fail \
    --data-urlencode "text=$2" \
    -o "glados-$2.wav" \
    "https://glados.c-net.org/generate"

else
    echo -e "\033[31mERROR: Unexpected argument\033[0m \e[38;5;94m'$1'\e[0m \033[31mfound\033[0m"
fi
