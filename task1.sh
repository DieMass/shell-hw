#!/bin/bash

total_attempts=0
correct_attempts=0
declare -a last_numbers

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

while true; do
    secret_number=$((RANDOM % 10))

    echo "Step $((total_attempts + 1))"
    read -p "Please enter number from 0 to 9 (q - quit): " user_input

    case "$user_input" in
    [0-9]) ;;
    q)
        echo "Game over. Goodbye!"
        exit 0
        ;;
    *)
        echo "Input error! Please enter number from 0 to 9"
        continue
        ;;
    esac
    ((total_attempts++))
    result=-1

    if [ "$user_input" -eq "$secret_number" ]; then
        echo "Hit! My number:  $secret_number"
        result="${GREEN}${user_input}${RESET}"
        ((correct_attempts++))
    else
        echo "Miss! My number:  $secret_number"
        result="${RED}${user_input}${RESET}"
    fi

    last_numbers+=(${result})

    correct_percent=$((correct_attempts * 100 / total_attempts))
    echo "Hits: $correct_percent% Miss: $((100 - correct_percent))%"
    if [ ${#last_numbers[@]} -gt 10 ]; then
        echo -e "Numbers: ${last_numbers[@]: -10}"
    else
        echo -e "Numbers: ${last_numbers[@]}"
    fi
    echo
done
