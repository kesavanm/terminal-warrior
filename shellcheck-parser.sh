#!/bin/bash

# Check if the log file is provided
if [ -z "$1" ]; then
        echo "Usage: $0 <log_file>"
        exit 1
fi

# Initialize associative arrays to store counts and descriptions
declare -A info_counts
declare -A warning_counts
declare -A error_counts
declare -A style_counts
declare -A descriptions
i=0
# Read the log file line by line
while IFS= read -r line; do
  # Remove escape sequences
  clean_line=$(echo "$line" | sed 's/\x1b\[[0-9;]*m//g')
  
  # Check if the line contains SCXXXX code
  if [[ $clean_line =~ SC[0-9]{4} ]]; then
    # Extract the SCXXXX code
    code=$(echo "$clean_line" | grep -o 'SC[0-9]\{4\}')

    # Extract the type (info or warning)
    if [[ $clean_line =~ \(info\) ]]; then
      type="info"
    elif [[ $clean_line =~ \(warning\) ]]; then
      type="warning"
    elif [[ $clean_line =~ \(error\) ]]; then
      type="error"
    elif [[ $clean_line =~ \(style\) ]]; then
        type="style"
    else
      type=""
      continue
    fi

    # Extract the description using awk    # trim description
    description=$(echo "$clean_line" | awk -F': ' '{print $2}')
    description=$(echo $description | sed -e 's/^[[:space:]]*//')
    descriptions[$code]="$description"

    # Increment the count based on the type
    if [[ $type == "info" ]]; then
      ((info_counts[$code]++))
    elif [[ $type == "warning" ]]; then
      ((warning_counts[$code]++))
    elif [[ $type == "error" ]]; then
      ((error_counts[$code]++))
    elif [[ $type == "style" ]]; then
        ((style_counts[$code]++))
    fi
  fi
        ((i++))
done < $1

# dump counts in tabular format
declare -A types=(
           [info]="$(tput setaf 4) [info   ] $(tput sgr0)"
        [warning]="$(tput setaf 3) [warning] $(tput sgr0)"
          [error]="$(tput setaf 1) [error  ] $(tput sgr0)"
          [style]="$(tput setaf 6) [style  ] $(tput sgr0)"
);
total_observations=0
headers=("SNo" "Type" "Code" "Occurrences" "Description")
printf "\033[1;44m%-3s | %-11s | %-10s | %-9s | %-s\033[0m\n" "${headers[@]}"  
ij=1
for type in "${!types[@]}"; do
  declare -n counts="${type}_counts"
  for code in "${!counts[@]}"; do
    printf "%-3d | %-16s | %-10s | %-11d | %s\n" "$ij" "${types[$type]:- }" "$code" "${counts[$code]}" "${descriptions[$code]:- }"
    ((ij++))
        total_observations=$((total_observations+${counts[$code]}))
  done
done

echo 
echo "$(tput setaf 3)$(tput bold)Total Observations: $total_observations$(tput sgr0)"

#EOF
