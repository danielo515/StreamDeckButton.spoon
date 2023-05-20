#!/bin/bash

# Check that the second file is provided and exists
if [ $# -ne 1 ] || [ ! -f "$1" ]; then
  echo "Usage: $0 <file>"
  exit 1
fi

# Read the contents of the first file into a variable
file1="$(dirname $0)/reference.hx"
content1=$(cat "$file1")

# Read the contents of the second file into a variable
file2="$1"
content2=$(cat "$file2")

# Interpolate the contents of the files into a multi-line string
result="You are an expert Haxe programmer. You are going to generate externs for Haxe for the provided hammerspoon module.
First I will provide you a reference of how the generated externs shold look like. This are externs generated for the hs.httpserver module:
$content1
Here are the API definitions of the hammerspoon module I want you to generate externs for. This module is named $(basename $file2):
$content2
"

# Copy the result to the system clipboard
if command -v pbcopy >/dev/null 2>&1; then
  # macOS
  echo -n "$result" | pbcopy
else
  # Linux
  echo -n "$result" | xclip -selection clipboard
fi

echo "Result copied to clipboard"
