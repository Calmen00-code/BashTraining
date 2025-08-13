#!/bin/bash

NUMS="${#}"
while [[ "${#}" -ge 1 ]]; do
    echo "NUMS${#}"
    shift +n
done
