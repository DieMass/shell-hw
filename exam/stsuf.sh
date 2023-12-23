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

declare -A suffix_count

mapfile -t files < <(find "$path" -type f)
for file in "${files[@]}"; do
    filename=$(basename "$file")
    suffix=$(basename "$filename" | awk -F. '{print $NF}')
    if [[ "$filename" == "$suffix" ]]; then
        ((suffix_count["no_suffix"]++))
    else
        ((suffix_count[.$suffix]++))
    fi
done

result=$(for k in "${!suffix_count[@]}"; do
    echo "$k: ${suffix_count["$k"]}\n"
done |
    sort -rn -k2)
echo -e ${result/no_suffix/no suffix}
