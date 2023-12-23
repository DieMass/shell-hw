#!/bin/bash

script_end_flag=SCRIPT_ENDED
archive_end_flag=ARCHIVE_ENDED

while getopts "d:n:" option; do
    case "${option}" in
    d)
        dir_path="$OPTARG"
        ;;
    n)
        name="$OPTARG"
        ;;
    \?)
        exit 1
        ;;
    :)
        exit 1
        ;;
    esac
done

if [[ -z "$dir_path" || -z "$name" ]]; then
  echo "Use this format: $0 -d dir_path -n name"
  exit 1
fi

cat <<$script_end_flag > "$name"
#!/bin/bash

result_dir="."

while getopts "o:" opt; do
  case \$opt in
    o)
      result_dir="\$OPTARG"
      ;;
    \?)
      exit 1
      ;;
    :)
      exit 1
      ;;
  esac
done

cat <<$archive_end_flag | base64 --decode | tar -xzf - --directory="\$result_dir"
$script_end_flag

archive_name="$name.tar.gz"
tar -czf $archive_name "$dir_path"
cat $archive_name | base64 >> "$name"
echo "$archive_end_flag" >> "$name"
chmod +x "$name"
rm $archive_name
