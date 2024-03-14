#!/bin/bash

handle_input() {
    case "$1" in
        "exit")
            echo "Exiting..."
            exit 0
            ;;
        "help")
            echo "Server supports the following commands:"
            echo "exit - Terminate the connection"
            echo "help - Display this help message"
            echo "CountryWithLanguage <language> - Get the country with the provided language"
            echo "IpToCity <IP> - Get the city name based on the provided IP"
            ;;
        "CountryWithLanguage "*)
            LANGUAGE=$(echo "$1" | cut -d' ' -f2-)
            RESPONSE=$(curl -s "https://restcountries.com/v3.1/lang/$LANGUAGE")
            COUNTRIES=$(echo "$RESPONSE" | jq -r '.[].name.common')
            echo "Countries with language $LANGUAGE:"
            echo "$COUNTRIES"
            ;;
        "IpToCity "*)
            IP=$(echo "$1" | cut -d' ' -f2)
            if [[ ! "$IP" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
                echo "Invalid IP format."
                return
            fi
            RESPONSE=$(curl -s "https://ipapi.co/$IP/json/")
            CITY=$(echo "$RESPONSE" | jq -r '.city')
            if [ "$CITY" != "null" ]; then
                echo "City for IP $IP: $CITY"
            else
                echo "Incorrect IP or could not determine city."
            fi
            ;;
        *)
            echo "Command not recognized. Type 'help' for a list of supported commands."
            ;;
    esac
}

echo "Server is running..."

IFS=$'\n'

while read -r IN_LINE; do
    LINE=$(echo "${IN_LINE}" | tr -d '\r')

    handle_input "$LINE"
done
