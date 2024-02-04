#!/bin/bash
# This script generates the automatic labeler for the 3b1b/captions repository.
# In order to add a language to the label pool you need to add it to the languages array and then run the script from the root of the repository.


# Define the regex patterns
pattern1="[0-9]{4}/[^/]+/[^/]+"
pattern2="[0-9]{4}/shorts/[^/]+/[^/]+"
pattern3="[0-9]{4}/blog/[^/]+/[^/]+"

# Use find and grep to search for matching folders
# and keep only the las part of the path
a=$(find . -type d | grep -E "$pattern1" | grep -v "/shorts/" | grep -v "/blog/" | awk -F/ '{print $NF}')
b=$(find . -type d | grep -E "$pattern2" | grep -v "/blog/" | awk -F/ '{print $NF}')
c=$(find . -type d | grep -E "$pattern3" | grep -v "/shorts/" | awk -F/ '{print $NF}')

# Join the two lists
languages=$(cat <(echo "$a") <(echo "$b") <(echo "$c") | sort | uniq)

labeler_file=".github/labeler.yml"

echo "# This file was automatically generated by the labeler.sh script. Do not edit manually." > $labeler_file
echo "" >> $labeler_file

for language in $languages;
do
    # Set the label name, with the first letter capitalized 
    label_name=$(echo "$language" | awk '{print toupper(substr($0, 1, 1)) substr($0, 2)}')

    {
        echo "$label_name:"
        echo "- changed-files:"
        echo "  - any-glob-to-any-file: '**/$language/*'"
        echo ""
    } >> $labeler_file
done
