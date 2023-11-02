#!/bin/bash
mkdir $2;
cp -r $1/* $2/;
for f in $2/*; do mv -f -n "$f" "${f//[ ()]/_}"; done;
