#!/bin/bash

total_attempts=0
declare -a numbers
row_count=2
column_count=3
element_count=$((row_count * column_count - 1))
space="s"
for ((i = 1; i <= element_count; ++i)); do
    numbers+=("$i")
done
numbers+=($space)
numbers=($(shuf -e "${numbers[@]}"))

function show_board() {
    border_layer="+"
    medium_layer="|"
    layer=""
    for ((i = 0; i < column_count - 1; ++i)); do
        layer+="-----"
    done
    layer+="----"
    border_layer="$border_layer$layer+"
    medium_layer="$medium_layer$layer|"
    counter=1
    echo "${border_layer}"
    for ((i = 0; i < row_count; ++i)); do
        row="|"
        for ((j = 0; j < column_count; ++j)); do
            current=${numbers[i * column_count + j]}
            current_string="${current}"
            if [[ "$current" -eq "$space" ]]; then
                current_string="  "
            elif [[ $current -lt "10" ]]; then
                current_string+=" "
            fi
            row+=" $current_string |"
        done
        echo "${row}"
        if [[ i -ne $((row_count - 1)) ]]; then
            echo "${medium_layer}"
        fi
    done
    echo "${border_layer}"
}

function get_index_of_puzzle() {
    for i in "${!numbers[@]}"; do
        [[ "${numbers[$i]}" = "$1" ]] && break
    done
    echo $i
}

function move_puzzle() {
    index=$(get_index_of_puzzle $space)
    space_row=$(((index / column_count) + 1))
    space_column=$(((index % column_count) + 1))
    available_indexes=()
    available_puzzles=()
    if [[ "$space_row" -lt $((row_count)) ]]; then
        available_indexes+=("$((index + column_count))")
    fi
    if [[ "$space_row" -gt 1 ]]; then
        available_indexes+=("$((index - column_count))")
    fi
    if [[ "$space_column" -lt $((column_count)) ]]; then
        available_indexes+=("$((index + 1))")
    fi
    if [[ "$space_column" -gt 1 ]]; then
        available_indexes+=("$((index - 1))")
    fi
    for i in "${available_indexes[@]}"; do
        available_puzzles+=("$((numbers[$i]))")
    done
    puzzle=$1
    puzzle_index=$(get_index_of_puzzle $puzzle)
    if [[ ! "${available_indexes[*]} " =~ "$puzzle_index" ]]; then
        echo "Неверный ход!"
        echo "Невозможно костяшку $puzzle передвинуть на пустую ячейку."
        echo "Можно выбрать: ${available_puzzles[@]}"
    else
        buf="${numbers[$index]}"
        numbers[$index]=${numbers[$puzzle_index]}
        numbers[$puzzle_index]=$buf
    fi
}

function is_win() {
    for ((i = 1; i < row_count * column_count; ++i)); do
        if [[ "$i" != "${numbers[i - 1]}" ]]; then
            return 1
        fi
    done
    return 0
}

while [ true ]; do
    echo "Ход № $((total_attempts + 1))"
    show_board
    read -p "Ваш ход (q - выход): " user_input
    case "$user_input" in
    q)
        echo "Игра окончена. Всего доброго!"
        exit 0
        ;;
    *)
        move_puzzle $user_input
        ;;
    esac
    ((total_attempts++))
    if is_win; then
        echo "Вы собрали головоломку за $total_attempts ходов"
        show_board
        exit 0
    fi
done
