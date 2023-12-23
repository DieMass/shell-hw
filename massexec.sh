#!/bin/bash

dirpath=$(pwd)
mask="*"
number=$(nproc)

while [[ $# -gt 0 ]]; do
    case $1 in
    --path)
        dirpath="$2"
        shift 2
        ;;
    --mask)
        mask="$2"
        shift 2
        ;;
    --number)
        number="$2"
        shift 2
        ;;
    *)
        command="$1"
        shift
        ;;
    esac
done

if [ ! -d "$dirpath" ]; then
    echo "Каталог \"$dirpath\" должен существоать"
    exit 1
fi
if [ -z "$command" ]; then
    echo "Файл команды command должен существовать"
    exit 1
fi
if [ ${#mask} -eq 0 ]; then
    echo "Длина строки mask должна быть больше нуля"
    exit 1
fi
if ! [[ "$number" =~ ^[0-9]+$ ]]; then
    echo "Number должно быть целое число больше нуля"
    exit 1
fi

files=($dirpath/$mask)
files_count=${#files[@]}
file_index=0
pids=()
run_proc_count=0

while [ $file_index -lt $files_count ] || [ $run_proc_count -gt 0 ]; do
    i=0
    count=${#pids[@]}
#    проверяем, не завершились ли текущие процессы
    while [ $i -lt $count ]; do
        pid="${pids[$i]}"
        echo "CPU №$i run ${pids[$i]} process"
        if ! kill -0 "$pid" 2>/dev/null; then
            unset pids[$i]
            ((run_proc_count--))
        fi
        ((i++))
    done
#    запускаем новые процессы, если есть свободные ресурсы/задачи
    while [ "$run_proc_count" -lt "$number" ] && [ $file_index -lt "$files_count" ]; do
        if [ -f "${files[$file_index]}" ]; then
            "$command" "${files[$file_index]}" &
            pids+=($!)
            ((run_proc_count++))
            ((file_index++))
        fi
    done
    wait
done
