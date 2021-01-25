#!/bin/bash

console 2> >(grep -Ev WARNING 1>&2)
