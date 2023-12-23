#!/bin/bash

# собираем параметры
while [[ $# -gt 0 ]]; do
    case $1 in
    --path)
        path="$2"
        shift 2
        ;;
    --old_suffix)
        old_suffix="$2"
        shift 2
        ;;
    --new_suffix)
        new_suffix="$2"
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
if [ -z "$old_suffix" ]; then
    echo "Выберите текущий суффикс --old_suffix"
    exit 1
fi
if [[ $old_suffix != "."* || $old_suffix == "."*"."* ]]; then
    echo "Текущий суффикс не является суффиксом (суффикс - это последовательность символов в конце имени файла, которая начинается с символа . (точка) и больше не содержит символов . (точка))"
    exit 1
fi
if [ -z "$new_suffix" ]; then
    echo "Выберите новый суффикс --new_suffix"
    exit 1
fi
if [[ $new_suffix != "."* || $new_suffix == "."*"."* ]]; then
    echo "Новый суффикс не является суффиксом (суффикс - это последовательность символов в конце имени файла, которая начинается с символа . (точка) и больше не содержит символов . (точка))"
    exit 1
fi

# меняем суффиксы файлов
#old_files=($(find "$path" -type f -name "*$old_suffix"))
mapfile -t old_files < <(find "$path" -type f -name "*$old_suffix")
for file in "${old_files[@]}"; do
    filename=$(basename "$file" "$old_suffix")
        if [[ "$filename" != "$old_suffix" ]]; then
            new_file="${file/%$old_suffix/$new_suffix}"
            mv "$file" "$new_file"
            echo "Файл $file переименован в $new_file"
        fi
done
