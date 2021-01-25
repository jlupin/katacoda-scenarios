#!/bin/bash

(console | filter.sh) 2> >(grep -Ev WARNING 1>&2)
