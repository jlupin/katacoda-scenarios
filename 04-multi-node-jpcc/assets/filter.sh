#!/bin/bash

FILTER=1
while IFS= read -n 1 CHAR
do
  if [ $FILTER -eq 1 ] && [ "$CHAR" == "Y" ]; then
    FILTER=0
  fi
  if [ $FILTER -eq 0 ]; then
    if [ "x$CHAR" == "x" ]; then
      printf "\n"
    else
      printf "%c" "$CHAR"
    fi
  fi
done
