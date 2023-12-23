#!/bin/bash

# собираем параметры
while [[ $# -gt 0 ]]; do
    case $1 in
    --path)
        path="$2"
        shift 2
        ;;
    *)
        echo "$1"
        shift
        ;;
    esac
done

# проверяем параметры
if [ -z "$path" ]; then
    echo "Укажите каталог --path"
    exit 1
fi
if [ ! -d "$path" ]; then
    echo "Каталог \"$path\" должен существоать"
    exit 1
fi

files=($path/*.txt)
user_name=$(whoami)
# deprecated
current_date=$(date -Idate)
#current_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

for file in "${files[@]}"; do
    sed -i "1i Approved $user_name $current_date" $file
    echo "Файл $file обработан"
done